//::///////////////////////////////////////////////
//:: Pulse: Level Drain
//:: NW_S1_PulsLvlDr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A wave of energy emanates from the creature which affects
	all within 10ft.  Damage can be reduced by half for all
	damaging variants.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{
	object oCaster = OBJECT_SELF;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	effect eHowl;
	float fDelay;
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + iHD;
	effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	//Get first target in spell area
	while(GetIsObjectValid(oTarget))
	{
		if(oTarget != OBJECT_SELF)
		{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					fDelay = CSLGetSpellEffectDelay(GetLocation(oCaster), oTarget);
					//Make a saving throw check
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
					{
							//Apply the VFX impact and effects
							//eHowl = EffectNegativeLevel(1);
							//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eHowl, oTarget));
							SCApplyDeadlyAbilityLevelEffect( 1, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster );
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}