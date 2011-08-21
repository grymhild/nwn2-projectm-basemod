//::///////////////////////////////////////////////
//:: Detect_Evil
//:: NW_S2_DetecEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures of Evil Alignment within LOS of
	the Paladin glow for a few seconds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//Declare major variables
	object oTarget;
	int nEvil;
	effect eVis = EffectVisualEffect(VFX_COM_SPECIAL_RED_WHITE);
	
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
			//Check the current target's alignment
			nEvil = GetAlignmentGoodEvil(OBJECT_SELF);
			if(nEvil == ALIGNMENT_EVIL)
			{
				//Apply the VFX
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0);
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
	
}