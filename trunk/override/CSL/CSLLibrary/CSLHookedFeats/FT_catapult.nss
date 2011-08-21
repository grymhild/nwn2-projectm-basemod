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




void main()
{
	//scSpellMetaData = SCMeta_FT_catapult();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
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
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDamage;
	float fDelay;
	
	/* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
	effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL); */
	
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eDebris = EffectNWN2SpecialEffectFile("fx_rockslide.sef");
	effect eDam;
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();
	
	//Apply the fireball explosion at the location captured above.
	/* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);*/

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDebris, lTarget);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
				if(GetSpellId() == 970)
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));
					//Get the distance between the explosion and the target to calculate delay
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
					if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
						{
							//Roll damage for each target
							iDamage = d2(12);

							//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
							iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
							//Set the damage effect
							eDam = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
							if(iDamage > 0)
							{
								// Apply effects to the currently selected target.
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
								//This visual effect is applied to the target object not the location as above.  This visual effect
								//represents the flame that erupts on the target not on the ground.
						DelayCommand(fDelay, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget));
							}
						}
				}
			}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	HkPostCast(oCaster);
}

