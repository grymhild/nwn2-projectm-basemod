//::///////////////////////////////////////////////
//:: Clairaudience / Clairvoyance
//:: NW_S0_ClairAdVo.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants the target creature a bonus of +10 to spot and listen checks
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_clraudclrvoy();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
	int iClass = CLASS_TYPE_NONE;
	if ( iSpellId == SPELL_ASN_Clairaudience_and_Clairvoyance )
	{
		int iClass = CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_SCRYING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iDuration = HkGetSpellDuration( oCaster) ; // OldGetCasterLevel(oCaster);
	//iDuration += GetLevelByClass(CLASS_TYPE_ASSASSIN);
	//iDuration += GetLevelByClass(CLASS_TYPE_AVENGER);
	
	object oTarget = HkGetSpellTarget();
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_CLAIRAUD);
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, 10));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LISTEN, 10));
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( iDuration ));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	CSLUnstackSpellEffects(oTarget, iSpellId);
	eLink = SetEffectSpellId(eLink, iSpellId);
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, iSpellId);
	
	
	HkPostCast(oCaster);	
}

