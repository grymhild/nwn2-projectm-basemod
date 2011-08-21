//::///////////////////////////////////////////////
//:: [Shadow Daze]
//:: [x0_S2_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Shadow dancer.
//:: Will save or be dazed for 5 rounds.
//:: Can only daze humanoid-type creatures
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 23, 2002
//:://////////////////////////////////////////////
//:: Update Pass By:
//:: March 2003: Removed humanoid and level checks to
//:: make this a more powerful daze
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	effect eDaze = EffectDazed();
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	effect eLink = EffectLinkEffects(eMind, eDaze);
	//eLink = EffectLinkEffects(eLink, eDur);

	//effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
	int iDuration = 5;
	int nRacial = GetRacialType(oTarget);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 475));
	
	//int nDC = 10 + GetAbilityModifier(ABILITY_DEXTERITY) + GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
	// nDC = 
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Make SR check
		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
				//Make Will Save to negate effect
				if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
				{
					//Apply VFX Impact and daze effect
					HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
	}
}