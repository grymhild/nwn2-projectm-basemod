//::///////////////////////////////////////////////
//:: Magic Circle Against Good
//:: NW_S0_CircGood.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 18, 2001
//:://////////////////////////////////////////////
//:: 6/68/06 - BDF-OEI: updated to use NWN2 VFX

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_circgood();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAGIC_CIRCLE_AGAINST_GOOD;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_Magic_Circle_against_Good )
	{
		int iClass = CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	//effect eAOE = EffectAreaOfEffect(VFX_MOB_PRC_CIRCEVIL);
	//effect eVis = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	//effect eVis = EffectVisualEffect( VFX_DUR_SPELL_GOOD_CIRCLE ); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	//effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_CIRCLE ); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	//effect eEvil = EffectVisualEffect(VFX_IMP_EVIL_HELP); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	
	//effect eLink = EffectLinkEffects(eAOE, eDur);
	//eLink = EffectLinkEffects(eLink, eDur); // no longer using NWN1 VFX

	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	//iDuration += GetLevelByClass(CLASS_TYPE_ASSASSIN);
	//iDuration += GetLevelByClass(CLASS_TYPE_AVENGER);
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCEVIL, "", "", "", sAOETag);
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));
	//Create an instance of the AOE Object using the Apply Effect function
	HkApplyEffectToObject(iDurType, eAOE, oTarget, fDuration );
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eEvil, oTarget); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	
	HkPostCast(oCaster);
}

