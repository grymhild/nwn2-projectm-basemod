//::///////////////////////////////////////////////
//:: Immunity to Fire
//:: nx_s2_immunityfire.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (AFW-OEI)
//:: Created On: 09/16/2008
//:://////////////////////////////////////////////
//#include "nwn2_inc_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = 1;
	int iAttributes = -1;
	
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

	// Does not stack with itself
	if (!GetHasSpellEffect(HkGetSpellId(), oTarget))
	{
		effect eImmune = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999,0);
		eImmune = ExtraordinaryEffect(eImmune); // Make it not dispellable.

		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId(), FALSE));

		//Apply the effects
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune, oTarget);
	}
	HkPostCast(oCaster);
}

// -DATA- // int iAttributes =98688;