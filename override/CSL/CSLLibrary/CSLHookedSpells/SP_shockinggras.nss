//::///////////////////////////////////////////////
//:: [Shocking Grasp]
//:: [NW_S0_ShkngGrsp.nss]
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_shockinggras();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHOCKING_GRASP;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int iTouch = CSLTouchAttackMelee(oTarget);
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_SHOCKING_GRASP, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	if (iTouch != TOUCH_ATTACK_RESULT_MISS)
	{
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) )
		{
			SignalEvent( oTarget, EventSpellCastAt(oCaster, GetSpellId()) );
			if ( !HkResistSpell(oCaster, oTarget) )
			{
				int iSpellPower = HkGetSpellPower(oCaster, 5);
				int iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), iSpellPower * 6);
				iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDamage, SC_TOUCHSPELL_MELEE);
				effect eDam = HkEffectDamage(iDamage, iDamageType);
				DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iHitEffect), oTarget);
			}
		}
	}
	effect eRay = EffectBeam(iShapeEffect, oCaster, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
	
	HkPostCast(oCaster);
}

