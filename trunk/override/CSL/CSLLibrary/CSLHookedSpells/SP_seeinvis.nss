//::///////////////////////////////////////////////
//:: See Invisibility
//:: NW_S0_SeeInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Allows the mage to see creatures that are
	invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_seeinvis();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SEE_INVISIBILITY;
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
	



	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SEE_INVISIBILITY );
	effect eSight = EffectSeeInvisible();
	effect eLink = EffectLinkEffects(eDur, eSight);
	//eLink = EffectLinkEffects(eLink, eDur);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SEE_INVISIBILITY, FALSE));

	float fDuration = TurnsToSeconds(HkGetSpellDuration(OBJECT_SELF));

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	CSLRemovePermanencySpells(oTarget);

	//Apply the VFX impact and effects
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_SEE_INVISIBILITY );
	HkPostCast(oCaster);
}

