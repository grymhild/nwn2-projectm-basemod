//::///////////////////////////////////////////////
//:: Howl: Sonic
//:: NW_S1_HowlSonic
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
	object oCaster = OBJECT_SELF;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
	effect eHowl;
	effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
	int iHD = GetHitDice(OBJECT_SELF);
	int nAmount = iHD/4;
	if(nAmount == 0)
	{
			nAmount = 1;
	}
	int iDC = 10 + nAmount;
	int iDamage;
	float fDelay;
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
				fDelay = GetDistanceToObject(oTarget)/20;
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HOWL_SONIC));
				iDamage = d6(nAmount);
				//Make a saving throw check
				//if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_SONIC, OBJECT_SELF, fDelay))
				//{
				//	iDamage = iDamage / 2;
				//}
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_SONIC, oCaster, SAVING_THROW_RESULT_ROLL, fDelay );
			
				//Set damage effect
				if ( iDamage > 0 )
				{
					eHowl = EffectDamage(iDamage, DAMAGE_TYPE_SONIC);
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
}