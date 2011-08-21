//::///////////////////////////////////////////////
//:: Inflame
//:: NW_S2_Inflame
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//::////////////////////////////////////////////// Inflame is a Warpriest ability that grants all
// allies within 30' bonuses to saves vs. fear and
// mind effects for 5 rounds.
//
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_FT_inflame();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST);

	// Determine bonus:
	int nSaveBonus = 2;
	if (iCasterLevel >= 10)
	{
		nSaveBonus = 8;
	}
	else if (iCasterLevel >= 6)
	{
		nSaveBonus = 6;
	}
	else if (iCasterLevel >=4)
	{
		nSaveBonus = 4;
	}
	
	//Get the spell target location as opposed to the spell target.
	location lTarget = GetLocation(oCaster);

	effect eFear = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus, SAVING_THROW_TYPE_FEAR);
	effect eMind = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus, SAVING_THROW_TYPE_MIND_SPELLS);
	effect eDur  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eFear, eMind);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = ExtraordinaryEffect(eLink);

	effect eImpact = EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
	
		//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);

	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_INFLAME, FALSE));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
	
				//Get the distance between the explosion and the target to calculate delay
			}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}