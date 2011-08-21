//::///////////////////////////////////////////////
//:: Freezing Sphere
//:: SOZ UPDATE BTM
//:: X2_S2_FreezingSphere
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Created by Reeron on 3-18-08
//
// A freezing sphere is a burst of cold that detonates
// and inflicts 1d6 points of damage per
// caster level (maximum of 15d6) to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FREEZING_SPHERE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	
		
	
    int iCasterLevel = GetCasterLevel(oCaster);
    int iSpellPower = HkGetSpellPower( oCaster, 15 );
    
    int iDamage;
    float fDelay;
    int nWe = 0; // Used for Water Elemental damage application. If nWe==1 apply d8 damage dice.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = HkGetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    
    	
	
	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_ICE, SC_SHAPE_AOE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId ));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/10;
            if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                iDamage = d6(iCasterLevel);
                int nApp= GetAppearanceType(oTarget);
                
                if ( CSLGetElementalType( oTarget ) == SCRACE_ELEMENTALTYPE_WATER )
                {               
                    iDamage = HkApplyMetamagicVariableMods(d8(iSpellPower), 8 * iSpellPower);
                }
                else
                {
                	iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
                }
                
                
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
                //Set the damage effect
                eDam = HkEffectDamage(iDamage, iDamageType);
                if(iDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the cold that erupts on the target not on the ground.
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    
    HkPostCast(oCaster);
}

