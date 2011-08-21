//::///////////////////////////////////////////////
//:: Hell Hound Fire Breath
//:: NW_S1_HndBreath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A cone of fire eminates from the hound.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2001
//:://////////////////////////////////////////////
//:: Updated By: Andrew Nobbs
//:: Updated On: FEb 26, 2003
//:: Note: Changed the faction check to GetIsEnemy
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iHD = GetHitDice(OBJECT_SELF);
	int iDamage = d4(1)+1;
	float fDelay;
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget;
	effect eCone;
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
			if(GetIsEnemy(oTarget))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HELL_HOUND_FIREBREATH, TRUE ));
				//Determine effect delay
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				//Set damage effect
				eCone = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
				if(iDamage > 0)
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
	}
}