//::///////////////////////////////////////////////
//:: Pulse: Cold
//:: NW_S1_PulsCold
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

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iDamage;
	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
	effect eHowl;
	float fDelay;
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + iHD;
	effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_COLD);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		if(oTarget != OBJECT_SELF)
		{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_COLD, TRUE ));
					//Roll the damage
					iDamage = d6(GetHitDice(OBJECT_SELF));
					//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, SAVING_THROW_TYPE_COLD);
					//Determine effect delay
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					eHowl = EffectDamage(iDamage, DAMAGE_TYPE_COLD);
					if(iDamage > 0)
					{
							//Apply the VFX impact and effects
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}