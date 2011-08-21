//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_DragFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura of the creature the player
	must make a will save or be struck with fear because
	of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:: LastUpdated: 24, Oct 2003, GeorgZ
//:: Modified By: Constant Gaw - OEI 7/31/06
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Items"
//#include "nw_i0_plot"

void main()
{
	//scSpellMetaData = SCMeta_FT_dragonfear(); //SPELLABILITY_AURA_FEAR;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();

	if ( CSLDestroyUnownedAOE( oCreator, OBJECT_SELF)) { return; } // make it go away if they are dead
	
	int iHD = GetHitDice(oCreator);
	int nCHRBonus = GetAbilityModifier(ABILITY_CHARISMA, oCreator); //(GetCharisma(oCreator) - 10)/ 2;
	int iDC = 10 + (iHD / 2) + nCHRBonus;
	
	float fDuration = RoundsToSeconds(HkGetScaledDuration(d6(4), oTarget));
	
	if (GetIsEnemy(oTarget, oCreator) )
	{
		if ( !CSLGetHasEffectType( oTarget, SPELLABILITY_DRAGON_FEAR  ) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_AURA_FEAR));
			if ( !HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER ) )
			{
				if ((GetHitDice(oCreator)-GetHitDice(oTarget)>=4) || GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCreator))
				{
					effect eFear = EffectVisualEffect(VFX_DUR_SPELL_FEAR);
					eFear = EffectLinkEffects(eFear, EffectFrightened() );
					eFear = EffectLinkEffects(eFear, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE) );
					eFear = SetEffectSpellId(eFear, SPELLABILITY_DRAGON_FEAR);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration);
				}
				else
				{
					effect eScare = EffectVisualEffect(VFX_DUR_SPELL_FEAR);
					eScare = EffectLinkEffects(eScare, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE) );
					eScare = EffectLinkEffects(eScare, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
					eScare = EffectLinkEffects(eScare, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
					eScare = EffectLinkEffects(eScare, EffectAttackDecrease(2, ATTACK_BONUS_MISC));
					eScare = SetEffectSpellId( eScare, SPELLABILITY_DRAGON_FEAR);
					HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eScare, oTarget, fDuration );
				}
			}
		}
	}
}