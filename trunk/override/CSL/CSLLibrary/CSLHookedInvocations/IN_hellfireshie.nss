//::///////////////////////////////////////////////
//:: Hellfire Shield
//:: NW_S2_hellfireshield.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Hellfire Warlock aura. Hits everyone in melee
	range on heartbeat with a Heallfire Blast in
	exchange for 1 Con per hit.
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 06/20/2008
//:://////////////////////////////////////////////
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "nw_i0_invocatns"


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{	
	//SpeakString("Firing Hellfire Shield");
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_HELLFIRE_SHIELD;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellSchool = SPELL_SCHOOL_ELDRITCH;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	HkPreCast( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//SendMessageToPC( oCaster, "DEBUGGING MESSAGE(JWR-OEI 08.22.08): HellfireShield Start");
		
	//object oTarget = HkGetSpellTarget();

	// Strip any Hellfire Shields first
	CSLRemoveAuraById( oCaster, SPELLABILITY_HELLFIRE_SHIELD );

	effect eAOE = EffectAreaOfEffect(AOE_PER_HELLFIRE_SHIELD);
	//Create an instance of the AOE Object using the Apply Effect function
	SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELLABILITY_HELLFIRE_SHIELD, FALSE));
	DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oCaster, 0.0f, SPELLABILITY_HELLFIRE_SHIELD ) );
	
	HkPostCast(oCaster);
}