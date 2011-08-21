//::///////////////////////////////////////////////
//:: Reach to the Blaze
//:: nx_s2_reachblaze.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////
//:: Repurposed from Body of the Sun

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_reachtothebl();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	float fDuration = RoundsToSeconds(5); // Fixed to 5 rounds.

	
	//string sSelf = ObjectToString(oCaster) + IntToString(GetSpellId());
	//object oSelf = GetNearestObjectByTag(sSelf);
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, TRUE  );
	effect eAOE = EffectAreaOfEffect(AOE_MOB_REACH_TO_THE_BLAZE, "", "", "", sAOETag);
	effect eVis = EffectVisualEffect(VFX_SPELL_DUR_BODY_SUN);
	
	//Link effects
	effect eLink = EffectLinkEffects(eAOE, eVis);
	
	//Destroy the object if it already exists before creating a new one
	
	//if (GetIsObjectValid(oSelf))
	//{
	//	DestroyObject(oSelf);
	//}
	
	//Determine duration
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	//Generate the object
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	
	HkPostCast(oCaster);
}