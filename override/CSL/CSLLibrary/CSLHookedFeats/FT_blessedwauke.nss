//::///////////////////////////////////////////////
//:: Blessed of Waukeen Halo
//:: nw_s0_waukeen.nss
//:: Copyright (c) 2001 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The Blessed of Waukeen are able to conjure
	a small golden light for five minutes at a time.

*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Aug 31, 2006
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_blessedwauke();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 0;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	

	
	effect eVis = EffectVisualEffect(902);

	int iDuration = 5;
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	
	HkPostCast(oCaster);
}