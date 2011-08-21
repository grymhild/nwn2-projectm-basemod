//::///////////////////////////////////////////////
//:: Horrid Wilting
//:: NW_S0_HorrWilt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All living creatures (not undead or constructs)
	suffer 1d6 damage per caster level to a maximum
	of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12 , 2001
//:://////////////////////////////////////////////


// (Update JLR - OEI 07/22/05) -- Changed Dmg to 1d6 per lvl
// CGaw - OEI 6/26/06 -- Changed damage cap from 25d6 to 20d6
// AFW-OEI 04/05/2007: Change from RADIUS_SIZE_HUGE (20') to RADIUS_SIZE_COLOSSAL (30')


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_horridwiltin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HORRID_WILTING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_NECROMANCY;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ORGANIC, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	
	int iSpellPower = HkGetSpellPower( oCaster, 20 ); // OldGetCasterLevel(oCaster);

	int iDamage;
	float fDelay;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	effect eDam;
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	int iDC = HkGetSpellSaveDC();
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
			// GZ: Not much fun if the caster is always killing himself
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HORRID_WILTING));
				//Get the distance between the explosion and the target to calculate delay
				//fDelay = CSLRandomBetweenFloat(1.5, 2.5);
				if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
					if( !CSLGetIsConstruct(oTarget) && !CSLGetIsUndead( oTarget ) )
					{
							//Roll damage for each target
							iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
							iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster, SAVING_THROW_RESULT_ROLL );
							
							
							//Set the damage effect
							eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
							// Apply effects to the currently selected target.
							DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
							//This visual effect is applied to the target object not the location as above.  This visual effect
							//represents the flame that erupts on the target not on the ground.
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					}
				}
			}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
	
	HkPostCast(oCaster);
}

