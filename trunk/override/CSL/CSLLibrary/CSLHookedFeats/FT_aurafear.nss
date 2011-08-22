//::///////////////////////////////////////////////
//:: Aura of Fear
//:: NW_S1_AuraFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura of the creature the player
	must make a will save or be struck with fear because
	of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	//scSpellMetaData = SCMeta_FT_aurafear();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	//Set and apply AOE object
	effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR, "", "", "", sAOETag);
	eAOE = SupernaturalEffect( eAOE );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, fDuration );
	
	HkPostCast(oCaster);
}