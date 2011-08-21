//::///////////////////////////////////////////////
//:: Animalistic Power
//:: nx2_s0_animalistic_power.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Animalistic Power
	Transmutation
	Level: Cleric 2, Druid 2, duskblade 2, ranger 2, sorceror/wizard 2
	Components: V, S
	Range: Touch
	Target: Creature touched
	Duration 1 minute/level
	
	You imbue the subject with an aspect of the natural world.
	The subject gains a +2 bonus to Strength, Dexterity, and Constitution.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ANIMALISTIC_POWER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	// Spell Duration
	float fDuration = TurnsToSeconds( HkGetSpellDuration( oCaster ) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	// Effects
	effect eStrength = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eDexterity = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
	effect eConstitution = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
	effect eVisual = EffectVisualEffect(VFX_DUR_SPELL_ANIMALISTIC_POWER);
	effect eLink = EffectLinkEffects(eStrength, eDexterity);
	eLink =  EffectLinkEffects(eLink, eConstitution);
	eLink =  EffectLinkEffects(eLink, eVisual);
	
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
		// check to see if ally
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			// apply linked effect to target
			HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
			CSLConstitutionBugCheck( oTarget );
		}
		
	}
	
	
	HkPostCast(oCaster);
}

