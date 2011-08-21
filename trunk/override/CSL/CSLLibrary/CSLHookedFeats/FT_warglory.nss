//::///////////////////////////////////////////////
//:: War Glory
//:: NW_S2_WarGlory.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Grants a bonus to hit to allies and penalties
	to saves for enemies.
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
	//scSpellMetaData = SCMeta_FT_warglory();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_WAR_GLORY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL;
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
	
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
	// Strip any Protective Auras first
	//SCRemoveSpellEffects(SPELLABILITY_WAR_GLORY, OBJECT_SELF, oTarget);
	// Strip any Auras first
	CSLRemoveAuraById( oTarget, iSpellId );
	
	//Create an instance of the AOE Object using the Apply Effect function
	// AFW-OEI 09/21/2006: Only apply effects if you don't already have them.
	// The SCRemoveSpellEffects brute-force call was causing problems with effect icons.
	if (!GetHasSpellEffect(iSpellId, oTarget))
	{
		effect eAOE = EffectAreaOfEffect(AOE_PER_WAR_GLORY, "", "", "", sAOETag);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
		eAOE = ExtraordinaryEffect(eAOE);
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget);
	}
	
	HkPostCast(oCaster);
}