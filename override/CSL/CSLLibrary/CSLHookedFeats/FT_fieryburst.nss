//::///////////////////////////////////////////////
//:: Fiery Burst
//:: cmi_s2_fieryburst
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 12, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"


void main()
{	
	//scSpellMetaData = SCMeta_FT_fieryburst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nDamageDice = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_FIRE, oCaster );
	if (nDamageDice == -1)
	{
		SendMessageToPC(oCaster,"You do not have any valid spells left that can trigger this ability.");
		return;
	}
		
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_FIRE, SC_SHAPE_AOE ); 
	int iHitEffect = HkGetHitEffect( VFX_IMP_FLAME_S );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	int iDC = GetReserveSpellSaveDC(nDamageDice, oCaster);
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	float fDelay;
	int iDamage;
	effect eDam;
	effect eVis = EffectVisualEffect(iHitEffect);
	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	location lTarget = HkGetSpellTargetLocation();
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			CSLEnviroBurningStart( iDC, oTarget );
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( iDC, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
    	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt( oCaster, iSpellId ) );
			//Get the distance between the explosion and the target to calculate delay
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			
			//Roll damage for each target
			iDamage = SCGetReserveFeatDamage( nDamageDice, 6);

			
			//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget,iDC, iSaveType);
			//Set the damage effect
			eDam = EffectDamage(iDamage, iDamageType);
			if(iDamage > 0)
			{
				// Apply effects to the currently selected target.
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				//This visual effect is applied to the target object not the location as above.  This visual effect
				//represents the flame that erupts on the target not on the ground.
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
			CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
    }	
	HkPostCast(oCaster);
}