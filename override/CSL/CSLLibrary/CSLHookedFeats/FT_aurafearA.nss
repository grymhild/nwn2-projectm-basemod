//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
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
//:: Modified By: Constant Gaw - OEI 7/31/06
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_aurafear(); //SPELLABILITY_AURA_FEAR;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_FEAR);
	effect eCess = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	effect eFear = EffectLinkEffects(eDur, EffectFrightened());
	eFear = EffectLinkEffects(eFear, eCess);

	effect eScare = EffectLinkEffects(eDur, eCess);
	eScare = EffectLinkEffects(eScare, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
	eScare = EffectLinkEffects(eScare, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
	eScare = EffectLinkEffects(eScare, EffectAttackDecrease(2, ATTACK_BONUS_MISC));

	int iHD = GetHitDice(oCreator);
	int iDC = 10 + iHD;
	float fDuration = RoundsToSeconds(HkGetScaledDuration(iHD, oTarget));

	if (GetIsEnemy(oTarget, oCreator))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_AURA_FEAR));
		if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
		{
			if ((GetHitDice(oCreator)-GetHitDice(oTarget)>=4) || GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCreator))
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration);
			}
			else
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eScare, oTarget, fDuration);
			}
		}
	}
}