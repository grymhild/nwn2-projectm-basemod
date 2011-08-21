//::///////////////////////////////////////////////
//:: Body of the Sun
//:: nw_s0_bodysun.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 18, 2006
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_bodysun();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BODY_OF_THE_SUN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster, 10 );
	
	
	//Declare major variables
	//Also prevent stacking
	
	//string sSelf = ObjectToString(oCaster) + IntToString(GetSpellId());
	//object oSelf = GetNearestObjectByTag(sSelf);
	int iAOEUsed = AOE_MOB_BODY_SUN;
	if (CSLGetHasEffectType( oCaster, EFFECT_TYPE_POLYMORPH))
	{
		iAOEUsed = VFX_MOB_BODY_SUN_WILDSHAPE;		
	}	
	
	float fDuration = RoundsToSeconds(HkGetSpellDuration(oCaster));
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, TRUE  );
	
	effect eAOE = EffectAreaOfEffect( iAOEUsed, "", "", "", sAOETag);
	effect eVis = EffectVisualEffect( VFX_SPELL_DUR_BODY_SUN );
	
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
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, fDuration);
	
	HkPostCast(oCaster);
}

