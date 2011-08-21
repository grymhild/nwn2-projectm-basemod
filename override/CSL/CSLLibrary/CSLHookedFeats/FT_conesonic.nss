//::///////////////////////////////////////////////
//:: Cone: Sonic
//:: NW_S1_ConeSonic
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A cone of damage eminated from the monster.  Does
	a set amount of damage based upon the creatures HD
	and can be halved with a Reflex Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iHD = GetHitDice(OBJECT_SELF);
	int iDamage;
	int nLoop = iHD / 3;
	int iDC = 10 + (iHD/2);
	float fDelay;
	if(nLoop == 0)
	{
			nLoop = 1;
	}
	//Calculate the damage
	for (nLoop; nLoop > 0; nLoop--)
	{
			iDamage = iDamage + d6(2);
	}
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget;
	effect eCone;
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);

	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	//Get first target in spell area
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_CONE_SONIC, TRUE ));
				//Determine effect delay
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, DAMAGE_TYPE_SONIC);
				//Set damage effect
				eCone = EffectDamage(iDamage, DAMAGE_TYPE_SONIC);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				if(iDamage > 0)
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
	}
}

