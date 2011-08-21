//::///////////////////////////////////////////////
//:: Aura of Courage
//:: NW_S2_CourageA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Paladin ability.  Grants +4 morale bonus on saves
	vs. fear effects to all allies within 10'.  The
	paladin herself gains an immunity to fear that's
	implemented in the code.

	On Enter script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_FT_auracourage(); //SPELLABILITY_AURA_OF_COURAGE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//SpeakString("nw_s2_courageaA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();

	// Default to +4 saves vs. fear.
	int nSaveBonus = 4;

	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_courageaA.nss: On Enter: target is not the same as the creator");

		//Faction Check
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			//SpeakString("nw_s2_courageaA.nss: On Enter: target is friend");

			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus, SAVING_THROW_TYPE_FEAR);
			eSave        = SupernaturalEffect(eSave);
	
			SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABILITY_AURA_OF_COURAGE, FALSE));
			HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oTarget, 0.0f, SPELLABILITY_AURA_OF_COURAGE );
		}
	}
}