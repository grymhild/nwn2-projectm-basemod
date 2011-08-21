//::///////////////////////////////////////////////
//:: Frenzy
//:: NW_S1_Frenzy
//:://////////////////////////////////////////////
/*
	Similar to Barbarian Rage
	Gives +6 Str, -4 AC, extra attack at highest
	Base Attack Bonus (BAB), doesn't stack with Haste/etc.,
	receives 2 points of non-lethal dmg a round.
	Lasts 3+ Con Mod rounds.
	Greater Frenzy starts at level 8.
*/

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY;
	object oCaster = OBJECT_SELF;
	if (!GetHasFeatEffect(FEAT_FRENZY_1))
	{

		int iLevel = GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER);
		int nIncrease = GetHasFeat(FEAT_GREATER_FRENZY, oCaster, TRUE) ? 10 : 6;
		int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);
		if (GetHasFeat(FEAT_EXTEND_RAGE)) nCon += 5;

		PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
		
		int nDamage = 6;
		if (GetLevelByClass(CLASS_TYPE_BARBARIAN) > 0)
		{
			nDamage = 2;
		}
			
		effect eLink = EffectVisualEffect(VFX_DUR_SPELL_RAGE);
		eLink = EffectLinkEffects(eLink, EffectACDecrease(4, AC_DODGE_BONUS));
		eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease));
		eLink = EffectLinkEffects(eLink, EffectDamageOverTime(nDamage, 6.0f, DAMAGE_TYPE_ALL));
		//eLink = EffectLinkEffects(eLink, EffectModifyAttacks(1));

		SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
		
		if (nCon > 0)
		{
			float fDuration = 2.0 + RoundsToSeconds(nCon);
			
			if (!CSLGetHasEffectType( oCaster, EFFECT_TYPE_HASTE ) )
			{
				eLink = EffectLinkEffects(eLink, EffectModifyAttacks(1));
			}
			eLink = ExtraordinaryEffect(eLink);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
			
			effect eDeathless;

			int nHasDeathless = 0;
			
			if (GetHasFeat(FEAT_DEATHLESS_FRENZY))
			{
				nHasDeathless = TRUE;
				eDeathless = EffectImmunity(IMMUNITY_TYPE_DEATH);
				eDeathless = EffectLinkEffects(eDeathless, EffectDamageResistance(DAMAGE_TYPE_NEGATIVE,9999,0));
				eDeathless = EffectLinkEffects(eDeathless, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
				eDeathless = EffectLinkEffects(eDeathless, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
				
				eDeathless = ExtraordinaryEffect(eDeathless);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathless, oCaster, fDuration);
			}
			// Start the fatigue logic half a second before the frenzy ends
			if (iLevel < 10)
			{
				//CSLApplyFatigue(oCaster, 30.0f, 0.6f );
				DelayCommand(fDuration-0.5f, CSLApplyFatigue(oCaster, RoundsToSeconds(5), 0.6f) );	// Fatigue duration fixed to 5 rounds
			}
			
			if (GetHasFeat(FEAT_SHARED_FURY, OBJECT_SELF))
			{
				object oMyPet = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);	
				if (GetIsObjectValid(oMyPet))
				{
            		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMyPet, fDuration));	
					if (nHasDeathless)
            		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathless, oMyPet, fDuration));									
				}
			}
			
			
		}
	}
}