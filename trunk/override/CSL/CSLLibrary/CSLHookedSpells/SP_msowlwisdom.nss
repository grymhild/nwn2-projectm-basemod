//::///////////////////////////////////////////////
//:: Owl's Wisdom, Mass
//:: NX_s0_msowlwis.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
Owl's Wisdom, Mass
Transmutation
Level: Cleric 6, Druid 6, Sorceror/wizard 6
Range: Close
Targets: One creature/level withint a 30 ft. radius of target

The transmuted creatures becomes wiser, gaining a +4 bonus to their Wisdom.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.05.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_msowlwisdom();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_OWL_WISDOM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	//Declare major variables
	location lTarget = HkGetSpellTargetLocation();
	effect eBuff;
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_OWL_WISDOM ); //replace this with proper vfx later
	
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);


	float fDuration = TurnsToSeconds( HkGetSpellDuration( OBJECT_SELF ) );
	
	//Set the buff effect
	eBuff = EffectAbilityIncrease(ABILITY_WISDOM, 4);
	eBuff = EffectLinkEffects( eBuff, eVis );

	//Check for metamagic
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);

	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1026, FALSE));

			//Apply the bonus effect and VFX impact
			HkApplyEffectToObject(iDurType, eBuff, oTarget, fDuration);
		}
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

