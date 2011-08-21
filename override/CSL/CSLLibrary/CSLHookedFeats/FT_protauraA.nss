//::///////////////////////////////////////////////
//:: Protective Aura
//:: NW_S2_ProtAuraA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Grants a bonus to saves and AC to allies within
	the spell radius.

	On Enter script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/17/2006
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_FT_protaura(); //SPELLABILITY_PROTECTIVE_AURA;
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
	
	//SpeakString("nw_s2_protauraA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	int    iLevel  = GetLevelByClass(CLASS_NWNINE_WARDER, oCaster);

	// Default to +2 saves, +1 AC.
	int nSaveBonus = 2;
	int nACBonus   = 1;

	// If you're level 4 or higher NW9, grant +3 saves, +2 AC.
	if (iLevel >=4)
	{
		//SpeakString("nw_s2_protauraA.nss: On Enter: caster has more than 4 levels of NW9");
		nSaveBonus = 3;
		nACBonus   = 2;
	}

	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_protauraA.nss: On Enter: target is not the same as the creator");

		//Faction Check
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			//SpeakString("nw_s2_protauraA.nss: On Enter: target is friend");

			effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus);
			effect eAC   = EffectACIncrease(nACBonus, AC_DEFLECTION_BONUS);
		
			effect eLink = EffectLinkEffects(eSave, eAC);
			eLink        = SupernaturalEffect(eLink);
	
			SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABILITY_PROTECTIVE_AURA, FALSE));
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
		}
	}
}