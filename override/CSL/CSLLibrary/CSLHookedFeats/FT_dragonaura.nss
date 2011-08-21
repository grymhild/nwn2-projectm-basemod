//::///////////////////////////////////////////////
//:: Dragon Aura of Fear
//:: NW_S1_AuraDrag.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura of the creature the player
	must make a will save or be struck with fear because
	of the creatures presence.

	GZ, OCT 2003
	Since Druids and Shifter's can now use this as well,
	make their version last level /4 rounds

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 17, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;

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
	float fDuration = HkApplyDurationCategory(4, SC_DURCATEGORY_DAYS);
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );

	effect eAOE = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "", "", "", sAOETag );
	eAOE = ExtraordinaryEffect( eAOE );
	eAOE = SetEffectSpellId(eAOE, SPELLABILITY_DRAGON_FEAR);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, fDuration );

	HkPostCast(oCaster);
}