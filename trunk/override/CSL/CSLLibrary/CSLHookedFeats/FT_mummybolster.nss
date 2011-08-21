//::///////////////////////////////////////////////
//:: Bolster Undead
//:: NW_S1_MumUndead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell increases the Turn Resistance of
	all undead around the caster by an amount
	scaled with HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2002
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE;
	int iHD = GetHitDice(OBJECT_SELF);
	iHD = iHD / 4;
	if(iHD == 0)
	{
			iHD = 1;
	}
	effect eTurn = EffectTurnResistanceIncrease(iHD);
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));
	float fDelay;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
			if(GetIsFriend(oTarget))
			{
				fDelay = CSLRandomBetweenFloat();
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MUMMY_BOLSTER_UNDEAD, FALSE));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTurn, oTarget, RoundsToSeconds(10)));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
}