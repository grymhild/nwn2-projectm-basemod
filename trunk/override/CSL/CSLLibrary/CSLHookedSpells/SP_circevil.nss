//::///////////////////////////////////////////////
//:: Magic Circle Against Evil
//:: NW_S0_CircEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: 6/68/06 - BDF-OEI: updated to use NWN2 VFX

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_circevil();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_GOOD, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration(OBJECT_SELF);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "", "", "", sAOETag);
		//effect eVis = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	//effect eVis = EffectVisualEffect( VFX_DUR_SPELL_EVIL_CIRCLE ); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	//effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_CIRCLE ); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
	//effect eVis2 = EffectVisualEffect(VFX_IMP_GOOD_HELP); // handled by SCCreateProtectionFromAlignmentLink(); see nw_i0_spells.nss

	//effect eLink = EffectLinkEffects(eAOE, eDur);
	//eLink = EffectLinkEffects(eLink, eDur);

	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE));

	//Create an instance of the AOE Object using the Apply Effect function
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
	HkApplyEffectToObject(iDurType, eAOE, oTarget, fDuration );
	HkPostCast(oCaster);
}

