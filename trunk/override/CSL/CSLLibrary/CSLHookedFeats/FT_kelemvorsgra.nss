//::///////////////////////////////////////////////
//:: Kelemvor's Grace
//:: NW_S2_KelemGraceA.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Doomguide ability. Grants +4 bonus on saves
	vs. death effects to all allies within 10'. The
	doomguide herself gains an immunity to death that's
	implemented in the code.
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 05/28/2008
//:: Rewrote On: 10/15/2008 by Justin Reynard (JWR-OEI)
//:: Persistent Aura's are handled differently now.
//:://////////////////////////////////////////////
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	//SpeakString("Firing Aura");
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();

	// Strip any Auras first
	CSLRemoveAuraById( oTarget, SPELLABILITY_KELEMVORS_GRACE );

	effect eAOE = EffectAreaOfEffect(AOE_PER_KELEMVORS_GRACE);
	eAOE = SupernaturalEffect(eAOE);
	//Create an instance of the AOE Object using the Apply Effect function
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_KELEMVORS_GRACE, FALSE));
	DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget) );
	
	HkPostCast(oCaster);
}