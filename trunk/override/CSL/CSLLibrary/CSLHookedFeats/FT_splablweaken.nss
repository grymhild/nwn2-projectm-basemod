//::///////////////////////////////////////////////
//:: Weaken Spirits
//:: nx_s2_weakenspirits
//:://////////////////////////////////////////////
/*
	A spirit shaman can choose to strip spirits of
	their defenses by using a daily use of her
	chastise spirits ability. When a spirit is
	weakened, it loses its spell resistance, any
	damage reduction, and any miss chance or
	concealment effect it may have. This weakening
	effect lasts for 1 round plus 1 additional round
	for every 3 spirit shaman levels. Spirits that
	make their Will save (DC 10 + shaman level +
	Cha modifier) are unaffected by the weakening
	effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/19/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_FT_splablweaken();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	//int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iImpactSEF =VFXSC_HIT_WEAKENSPIRITS;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	

	//Declare major variables
	int      nShamanLvl = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);
	location lTarget    = HkGetSpellTargetLocation();
	effect   eVis       = EffectVisualEffect(VFX_HIT_WEAKEN_SPIRITS);
	
	int iSaveDC = 10 + nShamanLvl + GetAbilityModifier(ABILITY_CHARISMA);

	float fDelay;
	float fDuration = RoundsToSeconds(1 + nShamanLvl/3);
	//SpeakString("nx_s2_weakenspirits: fDuration = " + FloatToString(fDuration));
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{    //Cycle through the targets within the spell shape until an invalid object is captured.
			if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) &&
				GetIsSpirit(oTarget) &&    // Only targets spirits
				oTarget != oCaster )       // Caster is not affected by the spell.
			{
			if (WillSave(oTarget, iSaveDC) == SAVING_THROW_CHECK_FAILED)
			{
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));           // Fire cast spell at event for the specified target
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;  // Get the distance between the spirit shaman and the target to calculate the delay 
	
				effect eSR = EffectSpellResistanceDecrease(100);
				effect eDR = EffectDamageReductionNegated();
				effect eConceal = EffectConcealmentNegated();
				
				effect eLink = EffectLinkEffects(eSR, eDR);
				eLink = EffectLinkEffects(eLink, eConceal);
				
				// Apply effects to the currently selected target.
					DelayCommand(fDelay, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() ) );
						
					//This visual effect is applied to the target object not the location as above.  This visual effect
					//represents the impact that erupts on the target not on the ground.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
			}
			
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_CHASTISE_SPIRITS);
	
	HkPostCast(oCaster);
}

