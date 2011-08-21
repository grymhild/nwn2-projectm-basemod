//::///////////////////////////////////////////////
//:: Regenerate
//:: NW_S0_Regen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants the selected target 10% of Max HP of
	regeneration every round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_regenerate();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REGENERATE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	object oTarget = HkGetSpellTarget();
	int nRegenAmt = CSLGetMax(5, CSLRoundToNearest(GetMaxHitPoints(oTarget) / 10));
	effect eLink = EffectVisualEffect(VFX_DUR_REGENERATE);
	eLink = EffectLinkEffects(eLink, EffectRegenerate(nRegenAmt, 6.0));

	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(10));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, iSpellId );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), oTarget, 0.0f, iSpellId);
	
	HkPostCast(oCaster);
}

