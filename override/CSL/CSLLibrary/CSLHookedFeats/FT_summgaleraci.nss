//::///////////////////////////////////////////////
//:: Summon Gale
//:: [nx_s2_summongale.nss]
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Mostly copied from x0_s0_gustwind.  A little
	cleanup & force the spell to be cast as a 5th
	level sorcerer.

	This spell creates a gust of wind in all directions
	around the target. All targets in a medium area will be
	affected:
	- Target must make a For save vs. spell DC or be
		knocked down for 3 rounds
	- if an area of effect object is within the area
		it is dispelled
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_FT_summgaleraci();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SUMMON_GALE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iCasterLevel   = 5; // Force spell to be cast as a 5th level caster.
	
	location lTarget = HkGetSpellTargetLocation(); //Get the spell target location as opposed to the spell target.
	effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	int iDamage;
	float fDelay;
	int iDC = 10 + HkGetSpellLevel(iSpellId) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	
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
				if (GetAreaOfEffectDuration(oTarget) != DURATION_TYPE_PERMANENT) //auras have permanent AOE object
				{
					DestroyObject(oTarget);
				}
			}
			else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			
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
					{
								AssignCommand(oTarget, ActionCloseDoor(oTarget));
					}
					}
				}
				// AFW-OEI 01/11/2007: HkGetSpellSaveDC() works strangely for spell-like abilities, so we're going
				// to just use the innate spell level plus your CHA modifier.  Note that this method will
				// not take penalties/bonuses like negative levels and Spell Focus into account.
				int iDC = 10 + HkGetSpellLevel(SPELLABILITY_SUMMON_GALE) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
				if(!HkResistSpell(OBJECT_SELF, oTarget) && !HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
				{
					effect eKnockdown = EffectKnockdown();
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
	}*/
	
	HkPostCast(oCaster);
}


