//::///////////////////////////////////////////////
//:: Aura of Despair
//:: NW_S2_AuraDespairA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Blackguard supernatural ability that causes all
	enemies within 10' to take a -2 penalty on all saves.

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
	//scSpellMetaData = SCMeta_FT_auradespair(); //SPELLABLILITY_AURA_OF_DESPAIR;
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
	
	//SpeakString("nw_s2_auradespairA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	
	int nPenalty = 2;
	if ( GetHasFeat(FEAT_EPIC_IMPROVED_AURA_DESPAIR, oCaster) )
	{
		nPenalty = 4;
	}
		
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty );
	eSavePenalty = SupernaturalEffect(eSavePenalty);
	
	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_auradespairA.nss: On Enter: target is not the same as the creator");

		SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABLILITY_AURA_OF_DESPAIR, FALSE));

		//Faction Check
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
				// need to look at aura stripping effect
				
				CSLRemoveEffectSpellIdSingle(SC_REMOVE_ONLYCREATOR, oCaster, oTarget, SPELLABLILITY_AURA_OF_DESPAIR );
	
				HkApplyEffectToObject( DURATION_TYPE_PERMANENT, eSavePenalty, oTarget, 0.0f, SPELLABLILITY_AURA_OF_DESPAIR );
		}
	}
}