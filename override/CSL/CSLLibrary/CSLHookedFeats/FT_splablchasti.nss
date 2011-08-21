//::///////////////////////////////////////////////
//:: Chastise Spirits
//:: nx_s2_chastisespirits
//:://////////////////////////////////////////////
/*
	Beginning at 2nd level, a spirit shaman can
	deal 1d4 damage/shaman level to all spirits
	within 30 feet. The affected spirits get a
	Will save (DC 10 + shaman level + Cha modifier)
	for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/13/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_FT_splablchasti();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iImpactSEF = VFXSC_HIT_CHASTISESPIRITS;
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
	int      nShamanLvl = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);
	location lTarget    = HkGetSpellTargetLocation();
	effect   eVis       = EffectVisualEffect(VFX_HIT_CHASTISE_SPIRITS);
	
	int iSaveDC = 10 + nShamanLvl + GetAbilityModifier(ABILITY_CHARISMA);

	int iDamage;
	int nSaveResult;
	float fDelay;
	effect eDam;
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{    //Cycle through the targets within the spell shape until an invalid object is captured. Only spirits and never the caster
			if ( oTarget != oCaster && GetIsSpirit(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) )   // Only targets spirits
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));           // Fire cast spell at event for the specified target
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;  // Get the distance between the spirit shaman and the target to calculate the delay 

				// Will Save for 1/2 damage.
				iDamage = d6(nShamanLvl);
				//nSaveResult = WillSave(oTarget, iSaveDC);
				//if (nSaveResult == SAVING_THROW_CHECK_IMMUNE)
				//{
				//	iDamage = 0;
				//}
				//else if (nSaveResult == SAVING_THROW_CHECK_SUCCEEDED)
				//{
				//	iDamage = iDamage/2;
				//}
				
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iSaveDC, SAVING_THROW_TYPE_ALL, oCaster );
				
			
				if ( iDamage > 0 )
				{
					//Set the damage effect
					eDam = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
					
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					
					//This visual effect is applied to the target object not the location as above.  This visual effect
					//represents the impact that erupts on the target not on the ground.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

