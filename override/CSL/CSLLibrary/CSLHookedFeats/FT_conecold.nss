//::///////////////////////////////////////////////
//:: Cone: Cold
//:: NW_S1_ConeCold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A cone of damage eminated from the monster.  Does
	a set amount of damage based upon the creatures HD
	and can be halved with a Reflex Save.
*/

#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_FT_conecold();
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oCaster = OBJECT_SELF;
	int iHD = GetHitDice(oCaster);
	int iDamage;
	int iDice = CSLGetMax(1, iHD / 3) * 2;
	int iDC = 10 + (iHD/2);
	float fDelay;
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_WINTER_WOLF_BREATH), oCaster, 2.0);
	effect eDamage;
	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_CONE_COLD, TRUE ));
			fDelay = GetDistanceBetween(oCaster, oTarget)/20;
			iDamage = d6(iDice);
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, SAVING_THROW_TYPE_COLD);
			if (iDamage)
			{
				eDamage = EffectDamage(iDamage, DAMAGE_TYPE_COLD);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			}
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}
}

