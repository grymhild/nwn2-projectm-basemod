//::///////////////////////////////////////////////
//:: War Glory
//:: NW_S2_WarGloryA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Grants a bonus to hit to allies and penalties
	to saves for enemies.

	On Enter.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/19/2006
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_FT_warglory(); //SPELLABILITY_WAR_GLORY;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//SpeakString("nw_s2_wargloryA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();

	effect eAttackBonus = EffectAttackIncrease(1);
	eAttackBonus = SupernaturalEffect(eAttackBonus);

	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1);
	eSavePenalty = SupernaturalEffect(eSavePenalty);
	
	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_wargloryA.nss: On Enter: target is not the same as the creator");

		SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABILITY_PROTECTIVE_AURA, FALSE));

		//Faction Check
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			//SpeakString("nw_s2_wargloryA.ns: On Enter: target is friend");
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackBonus, oTarget);
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//SpeakString("nw_s2_wargloryA.ns: On Enter: target is enemy");
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSavePenalty, oTarget);
		}
	}
}