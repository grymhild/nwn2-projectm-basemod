//::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If the caster succeeds at a ranged touch attack
	the target takes 1d4 damage.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 




void main()
{
	//scSpellMetaData = SCMeta_SP_rayfrost();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAY_OF_FROST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	//int iDamageType = DAMAGE_TYPE_COLD;	
	//if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD))
	//{
	//	iDamageType = DAMAGE_TYPE_MAGICAL;
	//}
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	
	
	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	
	int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_RAY_OF_FROST));
		if (iTouch!=TOUCH_ATTACK_RESULT_MISS)
		{
			if(!HkResistSpell(oCaster, oTarget))
			{
				int nDam = HkApplyMetamagicVariableMods(d4(1)+1, 5);
				nDam = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDam, SC_TOUCHSPELL_RAY);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iHitEffect), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, iDamageType ), oTarget);
			}
		}
	}
	effect eRay = EffectBeam(VFX_BEAM_ICE, oCaster, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
	
	HkPostCast(oCaster);
}

