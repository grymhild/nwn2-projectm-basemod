//::///////////////////////////////////////////////
//:: Howl: Stun
//:: NW_S1_HowlStun
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A howl emanates from the creature which affects
	all within 10ft unless they make a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////

#include "_HkSpell" 
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_IMP_STUN);
	effect eHowl = EffectStunned();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDur2 = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_MIND);

	effect eLink = EffectLinkEffects(eHowl, eDur);
	eLink = EffectLinkEffects(eLink, eDur2);
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + (iHD/4);
	int iDuration = 1 + (iHD/4);
	float fDelay;
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
				fDelay = GetDistanceToObject(oTarget)/10;
				iDuration = HkGetScaledDuration(iDuration , oTarget);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HOWL_STUN));

				//Make a saving throw check
				if(!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
}