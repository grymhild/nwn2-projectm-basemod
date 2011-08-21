//::///////////////////////////////////////////////
//:: Warpriest Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2006 Obsidain Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Gives the targeted creature one extra partial
	action per round.

	Warpriest's spell-like ability to caste Haste.
	Main difference is that it uses the Warpriest
	level for variable effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////
//:: AFW-OEI 04/24/2007: Modify to work for Favored Souls, too.
//:: RPGplayer1 03/20/2008: Will affect allies if used on caster (RADIUS_SIZE_LARGE)

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Transmutation"

#include "_SCInclude_Group"

void main()
{
	//scSpellMetaData = SCMeta_FT_wphaste();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	object oTarget = HkGetSpellTarget();
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();
	/*
	if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
	{
			//SCRemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oTarget, SPELL_EXPEDITIOUS_RETREAT );
	}

	if (GetHasSpellEffect(647, oTarget) == TRUE)
	{
			//SCRemoveSpellEffects(647, OBJECT_SELF, oTarget);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oTarget, 647 );
	}

	if (GetHasSpellEffect(SPELL_MASS_HASTE, oTarget) == TRUE)
	{
		//SCRemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, oTarget);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oTarget, SPELL_MASS_HASTE );
	}
	*/
	
	int iCasterLevel = 0;
	if (iSpellId == SPELLABILITY_WARPRIEST_HASTE)
	{
		iCasterLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST); // AFW-OEI 05/20/2006: main difference from Haste
	}
	else if (iSpellId == SPELLABILITY_FAVORED_SOUL_HASTE)
	{
		iCasterLevel = GetLevelByClass(CLASS_TYPE_FAVORED_SOUL);
	}
	int iDuration = CSLGetMax( iCasterLevel, HkGetSpellDuration(oCaster));
	
	float fDuration = RoundsToSeconds(iCasterLevel);

	//Check for metamagic extension
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	
	// NPC Caster...
	int nNumTargets = iCasterLevel;
	object oOrigTgt = oTarget;

	// First, affect Caster...
	if ( GetIsObjectValid(oTarget) )
	{
		//Fire cast spell at event for the specified target
		//SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

		// Create the Effects
		//effect eHaste = EffectHaste();
		//effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
		//effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
		//effect eLink = EffectLinkEffects(eHaste, eDur);

		// Apply effects to the currently selected target.
		//HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
		SCApplyHasteEffect( oTarget, oTarget, SPELL_HASTE, fDuration, DURATION_TYPE_TEMPORARY );
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}


	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget) && (nNumTargets > 0))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			if ( oTarget != oOrigTgt )
			{
					//Fire cast spell at event for the specified target
					//SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));

					// Create the Effects
					//effect eHaste = EffectHaste();
					//effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
					//effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
					//effect eLink = EffectLinkEffects(eHaste, eDur);

					// Apply effects to the currently selected target.
					//HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
					SCApplyHasteEffect( oTarget, oCaster, SPELL_HASTE, fDuration, DURATION_TYPE_TEMPORARY );
					
					nNumTargets--;
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}

		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		
	}
	HkPostCast(oCaster);
}