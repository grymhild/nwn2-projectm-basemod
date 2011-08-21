//::///////////////////////////////////////////////
//:: Remove Paralysis
//:: NW_S0_RmvParal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Removes the paralysis and hold effects from the
	targeted creature.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_remparalysis();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REMOVE_PARALYSIS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);


	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_CONJURATION);
	int nRemove = 1 + HkGetSpellPower(OBJECT_SELF) / 4;

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), HkGetSpellTargetLocation());
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	while(GetIsObjectValid(oTarget) && nRemove > 0) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF)) {
			if (CSLRemoveEffectByType(oTarget, EFFECT_TYPE_PARALYZE)) {
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_PARALYSIS, FALSE));
				nRemove--;
				DelayCommand(CSLRandomBetweenFloat(), HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}

