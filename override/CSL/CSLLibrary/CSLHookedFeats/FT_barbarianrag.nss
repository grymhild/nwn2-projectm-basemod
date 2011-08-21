//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The Str and Con of the Barbarian increases,
	Will Save are +2, AC -2.
	Greater Rage starts at level 15.
	
	
[quote="Rage"]duration 3 + CON Modifier rounds
fatigue applied at end -2 STR/CON, -10% Movement for 5 rounds

[code]CON Mod/2 is added to the DURATION column

LVL   STR/CON  WILL  AC
<8    +4       +2    -2
8     +5       +3    -1
12    +6       +4    -0
16    +7       +5    +0
20    +8       +6    +1
EPIC  +10      +8    +3
[/code][/quote]

[quote="Extended Rage"] Adds +5 Rounds to DURATION[/quote]

[quote="Indomitable Will"] Adds +4 to Will Save vs Mind Spells[/quote]

[quote="Tireless Rage"]Removes Fatigue effect after Raging[/quote]

[quote="Thundering"] Adds the following to the Barbarians Weapons for duration
[code]LVL    MASS CRIT    SONIC
<=19   1d6          1d4
20-24  2d4          1d6
25-29  1d10         2d4
30     2d6          2d6[/code][/quote]

[quote="Terrifying"]gives Fear Aura for duration
Fear DC is (BarbarianLevel + Base' Intimidate Skill + CHA Mod)/2 + 2 Thug + 3 SF Intimidate = (30+33+~5)/2 + 2 + 3 = 39 Max DC

'Base Skill does not include items, feats, or Ability modifiers just raw skill points.

On Save Failure (applied as an extraordinary effect):
If Lvl < Barb Lvl - Effect Paralysis
If Lvl < BarbLvl * 2 - Effect Shaken (-2 ab, -2 Saves)
[/quote]

*/


#include "_HkSpell"
#include "_SCInclude_BarbRage"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;

	object oBarb = OBJECT_SELF;
	
	if (GetHasFeatEffect(FEAT_BARBARIAN_RAGE)) {
		SendMessageToPC(oBarb, "You are already raging!");
		return;
	}
	int iLevel = GetLevelByClass(CLASS_TYPE_BARBARIAN, oBarb);
	int nConMod = GetAbilityModifier(ABILITY_CONSTITUTION, oBarb);
	
	int nIncrease;
	int iSave;
	int nAC;
	
	if (iLevel<8) {
		nIncrease = 4;
		iSave     = 2;
		nAC       = -2;
	} else if (iLevel<12) {
		nIncrease = 5;
		iSave     = 3;
		nAC       = -1;
	} else if (iLevel<16) {
		nIncrease = 6;
		iSave     = 4;
		nAC       = 0;
	} else if (iLevel<20) {
		nIncrease = 7;
		iSave     = 5;
		nAC       = 0;
	} else {
		if (!GetHasFeat(FEAT_EPIC_BARBARIAN_RAGE, oBarb, TRUE)) {
			nIncrease = 8;
			iSave     = 6;
			nAC       = 1;
		} else {
			nIncrease = 10;
			iSave     = 8;
			nAC       = 3;
		}
	}
	int nRageDuration = 3 + nConMod + (nIncrease/2);
	if (GetHasFeat(FEAT_EXTEND_RAGE)) nRageDuration += 5;
	
	float fRageDuration = RoundsToSeconds(nRageDuration);
	// Add Indomitable Will save bonus, if you have it
	if (GetHasFeat(FEAT_INDOMITABLE_WILL, OBJECT_SELF, TRUE))
	{
		effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
		eWill = SetEffectSpellId(eWill, -GetSpellId());
		eWill = ExtraordinaryEffect(eWill);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWill, OBJECT_SELF, fRageDuration);
	}		
		
	if (GetHasFeat(FEAT_BARB_WHIRLWIND_FRENZY))
	{
	        if (nRageDuration > 0)
	        {	
			
				effect eAB = EffectAttackDecrease(2);
				effect eAtks = EffectModifyAttacks(1);
			
				// Put together the positive rage effects
		        effect eStr  = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
		        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nIncrease/2);
		        effect eAC   = EffectACIncrease(nIncrease/2, AC_DODGE_BONUS);
		        effect eDur  = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
				
		        effect eLink = EffectLinkEffects(eStr, eSave);
		        eLink = EffectLinkEffects(eLink, eAC);
		        eLink = EffectLinkEffects(eLink, eDur);
				
				if (!GetHasSpellEffect(SPELL_HASTE,OBJECT_SELF))
				{
					eLink = EffectLinkEffects(eLink, eAB);
					eLink = EffectLinkEffects(eLink, eAtks);
				}					
				
				effect eNaturalAC;
				if (GetHasFeat(FEAT_ICE_TROLL_BERSERKER, OBJECT_SELF, TRUE))
				{
					eNaturalAC = EffectACIncrease(nAC, AC_NATURAL_BONUS);
					eLink = EffectLinkEffects(eLink, eNaturalAC); 
				}
				
		     	eLink = ExtraordinaryEffect(eLink);	 //Make effect extraordinary
		        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
				
				if ( PlayCustomAnimation(oBarb, "sp_warcry", 0) )
				{
					//FloatingTextStringOnCreature( "I HAVE THE WARCRY ANIMATION!", OBJECT_SELF );
				}
				
				SignalEvent(OBJECT_SELF, EventSpellCastAt(oBarb, SPELLABILITY_BARBARIAN_RAGE, FALSE));
	       
	            //Apply the VFX impact and effects
	            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oBarb, fRageDuration);
	            //HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;
	            CSLConstitutionBugCheck( OBJECT_SELF );
				
				if (GetHasFeat(FEAT_SHARED_FURY, OBJECT_SELF))
				{
					object oMyPet = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);	
					if (GetIsObjectValid(oMyPet))
					{
						DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMyPet, fRageDuration));	
	            	}
				}
		        // 2003-07-08, Georg: Rage Epic Feat Handling
		        SCCheckAndApplyEpicRageFeats(nRageDuration);
	
				if (!GetHasFeat(FEAT_TIRELESS_RAGE, oBarb, TRUE))
				{ // Unless you have Tireless Rage, you're going to feel it in the morning
					DelayCommand(fRageDuration - 0.5f, SCEndRageFatigue(oBarb, 5));  // Fatigue duration fixed to 5 rounds
				}				
			}		
		}
		else
		{
			effect eLink = EffectVisualEffect(VFX_DUR_SPELL_RAGE);
			eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease));
			eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease));
			eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, iSave));
			if  (nAC<0)
			{
				eLink = EffectLinkEffects(eLink, EffectACDecrease(nAC, AC_DODGE_BONUS));
			}
			else if (nAC>0)
			{
				eLink = EffectLinkEffects(eLink, EffectACIncrease(nAC, AC_DODGE_BONUS));
			}
			
			if (GetHasFeat(FEAT_ICE_TROLL_BERSERKER, OBJECT_SELF, TRUE))
			{
				eLink = EffectLinkEffects(eLink, EffectACIncrease(nAC, AC_NATURAL_BONUS) ); 
			}
				
			//if (GetHasFeat(FEAT_INDOMITABLE_WILL, oBarb, TRUE)) { // Add Indomitable Will save bonus, if you have it
			//	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS));
			//}
			eLink = ExtraordinaryEffect(eLink);  //Make effect extraordinary
			PlayVoiceChat(CSLPickOneInt(VOICE_CHAT_BATTLECRY1, VOICE_CHAT_BATTLECRY2, VOICE_CHAT_BATTLECRY3, VOICE_CHAT_ATTACK, VOICE_CHAT_THREATEN));
			PlayCustomAnimation(oBarb, "sp_warcry", 0);
			SignalEvent(oBarb, EventSpellCastAt(oBarb, SPELLABILITY_BARBARIAN_RAGE, FALSE));
			float fRageDuration = RoundsToSeconds(nRageDuration);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oBarb, fRageDuration);
			CSLConstitutionBugCheck( oBarb );
			if (GetHasFeat(FEAT_SHARED_FURY, OBJECT_SELF))
			{
				object oMyPet = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);	
				if (GetIsObjectValid(oMyPet))
				{
					DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMyPet, fRageDuration));	
				}
			}
				
			if (GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, oBarb)) 
			{
				SCApplyThunderingRage(oBarb, iLevel, nRageDuration);
			}
			if (GetHasFeat(FEAT_EPIC_TERRIFYING_RAGE, oBarb)) 
			{
				SCApplyTerrifyingRage(oBarb, nRageDuration);
			}
			if (!GetHasFeat(FEAT_TIRELESS_RAGE, oBarb, TRUE))
			{ // Unless you have Tireless Rage, you're going to feel it in the morning
				DelayCommand(fRageDuration - 0.5f, SCEndRageFatigue(oBarb, 5));  // Fatigue duration fixed to 5 rounds
			}
	}
}