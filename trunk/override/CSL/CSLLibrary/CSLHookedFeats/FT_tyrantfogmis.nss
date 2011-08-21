//::///////////////////////////////////////////////
//:: Tyrant Fog Zombie Mist
//:: NW_S1_TyrantFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creatures entering the area around the zombie
	must save or take 1 point of Constitution
	damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	//scSpellMetaData = SCMeta_FT_tyrantfogmis();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes =123012;
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
	
	effect eAOE = EffectAreaOfEffect(AOE_MOB_TYRANT_FOG, "", "", "", sAOETag);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, fDuration );
	
	HkPostCast(oCaster);
}