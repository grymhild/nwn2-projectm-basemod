//::///////////////////////////////////////////////
//:: Greater Fireburst
//:: NW_S0_GrFirbrst
//:://////////////////////////////////////////////
/*
	Burst of Fire from caster damaging everyone within
	5 feet.  Does 1d8/lvl (max 5d8) to everyone in
	range except for the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
// MDiekmann 7/25/07 - Modified to pass GetSpellId() for CastAtEvent.


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_grtfireburst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_FIREBURST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower( oCaster, 15 ); // OldGetCasterLevel(oCaster);
	int iDC = HkGetSpellSaveDC();
	int iDamage;
	float fDelay;
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_FIRE, SC_SHAPE_AOE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	effect eVis = EffectVisualEffect(iHitEffect);
	effect eDam;
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
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
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
		{
			fDelay = CSLRandomBetweenFloat(0.15, 0.35);
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE ));
			if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
				//Roll damage for each target
				iDamage = HkApplyMetamagicVariableMods(d8(iSpellPower), iSpellPower * 8);

				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
				if ( iDamage > 0 )
				{
						//Set the damage effect
						eDam = HkEffectDamage(iDamage, iDamageType);
						// Apply effects to the currently selected target.
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						//This visual effect is applied to the target object not the location as above.  This visual effect
						//represents the impact that erupts on the target not on the ground.
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	HkPostCast(oCaster);
}

