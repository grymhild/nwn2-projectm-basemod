//::///////////////////////////////////////////////
//:: True Seeing
//:: NW_S0_TrueSee.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The creature can seen all invisible, sanctuared, or hidden opponents.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_trueseeing();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TRUE_SEEING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	iSpellPower += GetLevelByClass(CLASS_TYPE_RANGER, oTarget) / 2;
	iSpellPower += GetLevelByClass(CLASS_TYPE_ASSASSIN, oTarget);
	iSpellPower += GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oTarget);
	iSpellPower += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oTarget);
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(iSpellPower));
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_TRUE_SEEING);
	int nBoost = CSLGetMin(25, 10 + iSpellPower / 3);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, nBoost));
	eLink = EffectLinkEffects(eLink, EffectUltravision());
	eLink = EffectLinkEffects(eLink, EffectSeeInvisible());
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	CSLUnstackSpellEffects(oTarget, SPELL_TRUE_SEEING);
	
	// ?? this is nonsense
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, SPELL_DARKNESS);
	
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_TRUE_SEEING );
	HkPostCast(oCaster);
}

