//::///////////////////////////////////////////////
//:: Shroud of Fog (Water Genasi Racial Ability)
//:: nx_s2_shroudfog.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Repurposed from Darkness (nw_s2_darkness).

	Creates a globe of fog around those in the area
	of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_FT_shroudingfog();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE;
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
	
	
	
	location lTarget = HkGetSpellTargetLocation();
	
	int iDuration    = 5; // Fixed to 5 rounds.
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
	
	object oTarget = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_SHROUDING_FOG));
	}
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE      = EffectAreaOfEffect(AOE_PER_SHROUDING_FOG, "", "", "", sAOETag);
	
	//Create an instance of the AOE Object using the Apply Effect function
	DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration ) );
	
	HkPostCast(oCaster);
}

