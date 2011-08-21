//::///////////////////////////////////////////////
//:: Pox
//:: sp_pox.nss
//:://////////////////////////////////////////////
/*
1d4 Con damage to up to 1 living creature/level in RADIUS_SIZE_SMALL
Fort save negates.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: December 24, 2004
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POX;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	location locTarget = HkGetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	effect eDam;
	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nMax = GetHitDice(OBJECT_SELF);
	int nCount = 0;
	int nDC, nDamage;
	float fDelay;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_SMALL);

	//Declare the spell shape, size and the location. Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, locTarget);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while(oTarget != OBJECT_INVALID && nCount <= nMax)
	{
		// GZ: Not much fun if the caster is always killing himself
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POX));
			//Get a random delay
			fDelay = CSLRandomBetweenFloat(0.5, 1.0);

			//Only living targets
			if( !CSLGetIsConstruct( oTarget )  &&  !CSLGetIsUndead( oTarget ) )
			{
				//We have a valid target, increment counter
				nCount++;

				if(!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
				nDC = HkGetSpellSaveDC(oTarget, OBJECT_SELF);
				//Roll damage for each target and resolve metamagic
				nDamage = HkApplyMetamagicVariableMods(d4(1),4);

				if(/*Fort Save*/ !HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
				{
					//Set the damage effect
					//eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, nDamage, oTarget, DURATION_TYPE_PERMANENT, 0.0f ));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}// end if - fort save
				}// end if - spell resist
			}// end if - is target living
		}// end if - is target non-self and hostile
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, locTarget);
	}// end while - target getting

// Getting rid of the integer used to hold the spells spell school

	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}