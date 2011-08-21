//:://////////////////////////////////////////////////////////////////////////
//:: Imbue Item
//:: nx_s2_imbue_item
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/28/2007
//:: Copyright (c) 2007 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This is the spell script called when you use the Warlock feat Imbue Item;
	it is intended to replace the need for spell prereqs for item creation.
	
	And indeed it shall! Muhahaha!
*/
// ChazM 3/14/07

const int SPELL_IMBUE_ITEM = 1081;

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_imbueitem();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes =98689;
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
	

	object oTarget = HkGetSpellTarget();


	// SpeakString("I am the spell script stub for nx_s2_imbue_item called when you use the Imbue Item feat.");
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMBUE_ITEM, FALSE));
	
	
	HkPostCast(oCaster);	
}