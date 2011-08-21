//::///////////////////////////////////////////////
//:: Balagarn's Iron Horn
//::
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Create a virbration that shakes creatures off their feet.
// Make a strength check as if caster has strength 20
// against all enemies in area
// Changes it so its not a cone but a radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_ironhorn();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BALAGARNSIRONHORN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_SONIC;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	int iSpellPower = HkGetSpellPower( oCaster, 20 ); // OldGetCasterLevel(oCaster);

	float fDelay;
	float fMaxDelay;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	//effect eExplode = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY); // NWN1 VFX
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC); // NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_BALAGARN_IRON_HORN ); // NWN2 VFX
	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();
	//Limit Caster level for the purposes of damage
	//if (iSpellPower > 20)
	//{
	//    iSpellPower = 20;
	//}
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(d3()));
	//Apply epicenter explosion on caster
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, GetLocation(OBJECT_SELF));
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
			// * spell should not affect the caster
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && (oTarget != oCaster))
		{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 436, TRUE ));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
				if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
					effect eTrip = EffectKnockdown();
					// * DO a strength check vs. Strength 20
					if (d20() + GetAbilityScore(oTarget, ABILITY_STRENGTH) <= 20 + d20() )
					{
							// Apply effects to the currently selected target.
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0f ));
							if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
							{
								CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  6.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
							}
							//This visual effect is applied to the target object not the location as above.  This visual effect
							//represents the flame that erupts on the target not on the ground.
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
					else
							FloatingTextStrRefOnCreature(2750, OBJECT_SELF, FALSE);
				}
			}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect( VFX_DUR_CONE_SONIC );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
	
	HkPostCast(oCaster);
}

