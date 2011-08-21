//::///////////////////////////////////////////////
//:: Ghast Stench
//:: NW_S1_ghaststench.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	The stink of death and corruption surrounding
	these creatures is overwhelming. Living creatures
	within 10 feet must succeed on a DC 15 Fortitude
	save or be sickened for 1d6+4 minutes. A creature
	that successfully saves cannot be affected again
	by the same ghasts stench for 24 hours. A delay
	poison or neutralize poison spell removes the effect
	from a sickened creature. Creatures with immunity
	to poison are unaffected, and creatures resistant
	to poison receive their normal bonus on their
	saving throws. The save DC is Charisma-based.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 24, 2006
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_ghaststench();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_RACIAL;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
	//Declare and apply the AOE
	effect eAOE = EffectAreaOfEffect( AOE_MOB_GHAST_STENCH, "", "", "", sAOETag );
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF );
	
	
	HkPostCast(oCaster);
}