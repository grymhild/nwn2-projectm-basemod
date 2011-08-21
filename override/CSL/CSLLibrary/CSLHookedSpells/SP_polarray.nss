//::///////////////////////////////////////////////
//:: Polar Ray
//:: [nw_s0_polarray.nss]
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	If the caster succeeds at a ranged touch attack
	the target takes 1d6 cold damage/caster level
	(max 25d6).
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



//#include "seed_db_inc"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POLAR_RAY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	///int iDamageType = DAMAGE_TYPE_COLD;	
	//if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD))
	//{
	//	iDamageType = DAMAGE_TYPE_MAGICAL;
	//}

	
	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_ICE, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);

	object oTarget    = HkGetSpellTarget();
	int iTouch     = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
	iSpellPower = CSLGetMin(25, iSpellPower);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_POLAR_RAY));
		if (iTouch!=TOUCH_ATTACK_RESULT_MISS)
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				int nDam = d6(iSpellPower);
				nDam = HkApplyMetamagicVariableMods(nDam, 6 * iSpellPower);
				nDam = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDam, SC_TOUCHSPELL_RAY);
				effect eDam = HkEffectDamage(nDam, iDamageType);
				effect eVis = EffectVisualEffect(iHitEffect);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}
	effect eRay = EffectBeam(iShapeEffect, oCaster, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
	
	HkPostCast(oCaster);
}