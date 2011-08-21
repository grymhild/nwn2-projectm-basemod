//::///////////////////////////////////////////////
//:: Hezrou Stench
//:: NW_S1_HezStench.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	A hezrous skin produces a foul-smelling,
	toxic liquid whenever it fights. Any living creature
	(except other demons) within 10 feet must succeed on a DC 24 Fortitude
	save or be nauseated for as long as it remains within the affected area
	and for 1d4 rounds afterward. Creatures that successfully save are
	sickened for as long as they remain in the area. A creature that
	successfully saves cannot be affected again by the same hezrous
	stench for 24 hours. A delay poison or neutralize poison spell removes
	either condition from one creature. Creatures that have immunity to poison
	are unaffected, and creatures resistant to poison receive their
	normal bonus on their saving throws. The save DC is Constitution-based.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 24, 2006
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	//scSpellMetaData = SCMeta_FT_hezroustench();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
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
	effect eAOE = EffectAreaOfEffect( AOE_MOB_HEZROU_STENCH, "", "", "", sAOETag);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF );
	
	HkPostCast(oCaster);
}