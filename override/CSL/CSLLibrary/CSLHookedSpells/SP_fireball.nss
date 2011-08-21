//::///////////////////////////////////////////////
//:: Fireball
//:: NW_S0_Fireball
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A fireball is a burst of flame that detonates with
// a low roar and inflicts 1d6 points of damage per
// caster level (maximum of 10d6) to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: AidanScanlan, On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: May 25, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Environment"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FIREBALL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_ELEMENTAL;
	if ( GetSpellId() == SPELL_SHADES_FIREBALL )
	{
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	/*
	else if ( GetSpellId() == SPELLABILITY_ACCELERATING_FIREBALL )
	{
		iSpellSchool = SPELL_SCHOOL_EVOCATION;
		iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	}
	else if ( GetSpellId() == SPELL_INFINITE_RANGE_FIREBALL )
	{
		iSpellSchool = SPELL_SCHOOL_EVOCATION;
		iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	}
	*/
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	
	int iSpellPower = HkGetSpellPower( oCaster, 10 ); // OldGetCasterLevel(oCaster);
	// int nDam = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);
	
	int iDamage;
	float fDelay;
	
	/* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
	 */
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	int iShapeEffect = HkGetShapeEffect( VFX_FNF_FIREBALL, SC_SHAPE_AOEEXPLODE, oCaster, fRadius  ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_IMP_FLAME_M );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	int iDC = HkGetSpellSaveDC();
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	
	effect eDam;
	//Get the spell target location as opposed to the spell target.
	
	//Limit Caster level for the purposes of damage
	//if (iSpellPower > 10)
	//{
	//    iSpellPower = 10;
	//}
	
	//Apply the fireball explosion at the location captured above.
	location lTarget = HkGetSpellTargetLocation();
	effect eExplode = EffectVisualEffect(iShapeEffect);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		
		if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			CSLEnviroBurningStart( 10, oTarget );
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( iDC, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//if((GetSpellId() == SPELL_SHADES_FIREBALL) || GetSpellId() == iSpellId)
			//{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
				if (!HkResistSpell(oCaster, oTarget, fDelay))
				{
					iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);

					//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
					
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
					//iDamage = HkGetReflexAdjustedDamage(iDamage, oTarget, iDC, iSaveType);
					//Set the damage effect
					eDam = HkEffectDamage(iDamage, iDamageType);
					if(iDamage > 0)
					{
						// Apply effects to the currently selected target.
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						//This visual effect is applied to the target object not the location as above.  This visual effect
						//represents the flame that erupts on the target not on the ground.
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iHitEffect), oTarget));
					}
				}
				CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
			//}
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
	}
	
	HkPostCast(oCaster);
}
