//::///////////////////////////////////////////////
//:: Greater Mindblast 10m radius
//:: x2_s1_mblast10
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A psionic wave originating from the creature
	in a 10m foot radius around the creature

	Creatures can save vs the mindblast at a
	-4 modifier or be stunned for 1d3 rounds

	if the creature is already stunned, the
	mind blast does 1d3+casterlevel points of
	damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July 30, 2003
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	//Declare major variables
	object oTarget;
	int iLevel = GetHitDice(OBJECT_SELF);
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	eVis = EffectLinkEffects(EffectVisualEffect(VFX_FNF_LOS_NORMAL_20),eVis);
	effect eVisStun = EffectVisualEffect(VFX_IMP_DOMINATE_S);

	int iDuration;
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	eDur = EffectLinkEffects(EffectStunned(),eDur);

	int iSaveDC = 10 +(GetHitDice(OBJECT_SELF)/2) +  GetAbilityModifier(ABILITY_WISDOM,OBJECT_SELF);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

	//Determine enemies in the radius around the bard
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 15.0f, GetLocation(OBJECT_SELF),TRUE,OBJECT_TYPE_CREATURE);
	int iDamage = GetHitDice(OBJECT_SELF);
	effect eDam = EffectDamage(iDamage,DAMAGE_TYPE_POSITIVE);
	while (GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				if (GetHasSpellEffect(GetSpellId(),oTarget))
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);
					//iDamage = GetHitDice(OBJECT_SELF);
					DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				}
				else
				{
					iDuration = d3();
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE ));
					//Make SR and Will saves
					if (WillSave(oTarget, iSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF)==0)
					{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisStun, oTarget);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
					}
			}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 15.0f, GetLocation(OBJECT_SELF),TRUE,OBJECT_TYPE_CREATURE);
	}
	//Apply bonus and VFX effects to bard.
}