//::///////////////////////////////////////////////
//:: Fireburst
//:: NW_S0_Fireburst
//:://////////////////////////////////////////////
/*
	Burst of Fire from caster damaging everyone within
	5 feet.  Does 1d8/lvl (max 5d8) to everyone in
	range except for the caster.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_fireburst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FIREBURST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster, 5);
	location lTarget = HkGetSpellTargetLocation();
	int iDamage;
	float fDelay;
	int iDC = HkGetSpellSaveDC();
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_FIRE, SC_SHAPE_AOE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget );


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	while (GetIsObjectValid(oTarget)) 
	{
		if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			CSLEnviroBurningStart( 10, oTarget );
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( iDC, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster)
		{
			fDelay = CSLRandomBetweenFloat(0.15, 0.35);
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				iDamage = HkApplyMetamagicVariableMods(d8(iSpellPower), iSpellPower * 8);
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType );
				//iDamage = HkGetReflexAdjustedDamage(iDamage, oTarget, iDC, iSaveType );
				if (iDamage)
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, iDamageType ), oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( iHitEffect ), oTarget));
				}
			}
			CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	}
	
	HkPostCast(oCaster);
}