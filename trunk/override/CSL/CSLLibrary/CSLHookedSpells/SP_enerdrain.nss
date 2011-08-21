//::///////////////////////////////////////////////
//:: Energy Drain
//:: NW_S0_EneDrain.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target loses 2d4 levels.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"





////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_enerdrain();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENERGY_DRAIN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDamage;
	object oTarget = HkGetSpellTarget();

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ENERGY_DRAIN));
		effect eBeam = EffectBeam( VFX_BEAM_NECROMANCY, oCaster, BODY_NODE_HAND);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7);
		int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS)
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				int nDrain = HkApplyMetamagicVariableMods(d4(2), 8);
				nDrain = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDrain, SC_TOUCH_RANGED );
				
				int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
				SCApplyDeadlyAbilityLevelEffect( nDrain, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster, iSneakDamage );
				
				//effect eDrain = SupernaturalEffect(EffectNegativeLevel(nDrain));
				effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_DRAIN);
				
				// apply damage
				
				//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
	}
	
	HkPostCast(oCaster);
}

