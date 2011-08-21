//::///////////////////////////////////////////////
//:: Protection from Evil
//:: NW_S0_PrEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	When confronted by evil the protected character
	gains +2 AC, +2 to Saves and immunity to all
	mind-affecting spells cast by evil creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_protevil();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PROTECTION_FROM_EVIL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	


	//Declare major variables
	int nAlign = ALIGNMENT_EVIL;
	object oTarget = HkGetSpellTarget();
	float fDuration = HoursToSeconds(HkGetSpellDuration(OBJECT_SELF));

	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_PROT_ALIGN);
	effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
	//Change the effects so that it only applies when the target is evil
	//Try wrapping the sanctuary effect in the Evil wrapper and see if the effect works.

	eAC = VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
	eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
	effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, nAlign);

	effect eLink = EffectLinkEffects(eImmune, eSave);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eDur);

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	CSLRemovePermanencySpells(oTarget);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PROTECTION_FROM_EVIL, FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

