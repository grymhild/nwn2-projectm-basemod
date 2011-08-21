//::///////////////////////////////////////////////
//:: Scintillating Sphere
//:: X2_S0_ScntSphere
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A scintillating sphere is a burst of electricity
// that detonates with a low roar and inflicts 1d6
// points of damage per caster level (maximum of 10d6)
// to all creatures within the area. Unattended objects
// also take damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25 , 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_scintillatin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SCINTILLATING_SPHERE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower( oCaster, 10 ); // OldGetCasterLevel(oCaster);
	int iDamage;
	float fDelay;
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_LIGHTNING, SC_SHAPE_AOE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eVis = EffectVisualEffect(iHitEffect);
	effect eDam;
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget);


	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
			if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
				if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
					//Roll damage for each target
					iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
					//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
					//Set the damage effect
					eDam = HkEffectDamage(iDamage, iDamageType);
					if(iDamage > 0)
					{
							// Apply effects to the currently selected target.
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							//This visual effect is applied to the target object not the location as above.  This visual effect
							//represents the flame that erupts on the target not on the ground.
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}
			}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	HkPostCast(oCaster);
}

