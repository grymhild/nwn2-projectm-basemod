//::///////////////////////////////////////////////
//:: Stormsong - Gust of Wind
//:: cmi_s2_gustwind
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: February 14, 2008
//:: Based On: x0_s0_gustwind.nss
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_ssgustwind();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = STORMSINGER_GUST_OF_WIND;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
    int iCasterLevel = GetStormSongCasterLevel(oCaster);
	
	if (iCasterLevel < 9) //Short circuit
	{
		SendMessageToPC(OBJECT_SELF, "Insufficient Perform skill, you need 9 or more to use this ability.");
		return;
	}
	if (!GetHasFeat(257))
	{
		SpeakString("No uses of the Bard Song ability are available");
		return;
	}
	else
	{
		DecrementRemainingFeatUses(OBJECT_SELF, 257);		
	}
		
    int iDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
   // effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);


	int iDC = 13 + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	iDC += CSLGetDCBonusByLevel(oCaster);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpacLocation = HkGetSpellTargetLocation(); //GetLocation(oCaster);
	
	// void CSLEnviroWindGustEffect( location lStartLocation, location lEndLocation, int iShape = SHAPE_CONE, float fRadius = RADIUS_SIZE_HUGE, int bResistable = FALSE, object oCaster = OBJECT_SELF )

	//CSLEnviroWindGustEffect( lStartLocation, lImpactLoc, SHAPE_CONE, fRadius, TRUE, HkGetSpellSaveDC(), oCaster );
	
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpacLocation);
	
	
	int iObjectType;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lImpacLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		
		iObjectType = GetObjectType(oTarget);
		if ( iObjectType == OBJECT_TYPE_AREA_OF_EFFECT || iObjectType == OBJECT_TYPE_DOOR || iObjectType == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroWindGustEffect( lImpacLocation, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			if( HkResistSpell(oCaster, oTarget) || HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC-CSLGetSizeModifierGrapple(oTarget) ))
			{
				// spell resisted
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE ));
			}
			else
			{
				CSLEnviroWindGustEffect( lImpacLocation, oTarget );
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE ));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lImpacLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
	}
	
	
	/*
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            DestroyObject(oTarget);
        }
        else
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                // * unlocked doors will reverse their open state
                if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
                {
                    if (GetLocked(oTarget) == FALSE)
                    {
                        if (GetIsOpen(oTarget) == FALSE)
                        {
                            AssignCommand(oTarget, ActionOpenDoor(oTarget));
                        }
                        else
                            AssignCommand(oTarget, ActionCloseDoor(oTarget));
                    }
                }
			
                if(!HkResistSpell(OBJECT_SELF, oTarget) && !HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
        	    {

                    effect eKnockdown = EffectKnockdown();
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3));
                    // Apply effects to the currently selected target.
                 //   DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    
                 }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
    }
    */
    HkPostCast(oCaster);
}

