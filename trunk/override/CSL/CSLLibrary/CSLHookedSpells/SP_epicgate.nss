//::///////////////////////////////////////////////
//:: Epic Gate
//:: nx_s2_epic_gate.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Classes: Bard, Cleric, Druid, Spirit Shaman, Wizard, Sorcerer, Warlock
	Spellcraft Required: 27
	Caster Level: Epic
	Innate Level: Epic
	School: Conjuration
	Descriptor(s):
	Components: Verbal, Somatic
	Range: Medium
	Area of Effect / Target: Point
	Duration: 40 rounds
	Save: None
	Spell Resistance: No

	This spell opens a portal to the Lower Planes and calls forth a balor
	to assail your foes. If the demon is slain, a second one is
	immediately summoned in its place.  The strength of this conjuration
	is such that the devils are bound to your will, and you need not have
	cast Protection from Evil, or any similar spell, to prevent them from
	attacking you.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/11/2007
//:://////////////////////////////////////////////
// EPF 7/13/07 - changed to balor
// AFW-OEI 07/17/2007: NX1 VFX.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"



void main()
{
	//scSpellMetaData = SCMeta_SP_epicgate();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_EPIC_GATE;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	float fDuration = RoundsToSeconds( HkGetBestCasterLevel( OBJECT_SELF ) + 40 ); // Fixed 40 round duration
	
	location lSpellTargetLocation = HkGetSpellTargetLocation();
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_EPIC_GATE);
	effect eVis = EffectVisualEffect(VFX_INVOCATION_BRIMSTONE_DOOM);
	/*
	string sBlueprint = "c_summ_balor";
	if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
		sBlueprint = "cmi_summ_egategood";	
	else
	if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL)
		sBlueprint = "cmi_summ_egateneut";
			
    effect eSummon = EffectSwarm(FALSE,sBlueprint,sBlueprint);
	*/
	effect eSummon = EffectSwarm(FALSE, "c_summ_balor", "c_summ_balor");

	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDur, lSpellTargetLocation, 5.0);
	DelayCommand(3.0, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lSpellTargetLocation));
	DelayCommand(3.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, fDuration));
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	
	HkPostCast(oCaster);
}

