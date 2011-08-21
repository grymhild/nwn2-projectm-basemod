//::///////////////////////////////////////////////
//:: Bear's Endurance, Mass
//:: NX_s0_msbearend.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
Bear's Endurance, Mass
Transmutation
Level: Cleric 6, Druid 6, Sorceror/wizard 6
Range: Close
Targets: One creature/level withint a 30 ft. radius of target

The affected creatures gain greater vitality and stamina.  The spell grants the subjects a +4 bonus to Constitution.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_msbearendura();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_BEAR_ENDURANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF;
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
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nModify = 4;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_BEAR_ENDURANCE);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, nModify));
	location lTarget = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BEARS_ENDURANCE, FALSE));
			if (!CSLCheckNonStackingSpell(oTarget, SPELL_GREATER_BEARS_ENDURANCE, "Greater Bear's Endurance") && 
				!CSLCheckNonStackingSpell(oTarget, SPELL_Chasing_Perfection, "Chasing Perfection") 
			)
			{
				CSLUnstackSpellEffects(oTarget, SPELL_MASS_BEAR_ENDURANCE);
				CSLUnstackSpellEffects(oTarget, SPELL_BEARS_ENDURANCE, "Bear's Endurance");
				HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
				
				CSLConstitutionBugCheck( oTarget );
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

