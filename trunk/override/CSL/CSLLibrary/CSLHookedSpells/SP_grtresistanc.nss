//::///////////////////////////////////////////////
//:: Resistance, Greater
//:: NX_s0_grresist.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Resistance, Greater
	Abjuration
	Level: Bard 4, cleric 4, druid 4, sorceror/wizard 4
	Components: V, S
	Range: Touch
	Target: Creatue Touched
	Duration: 24 hours
	Saving Throw: Will negates (harmless)
	Spell Resistance: Yes (harmless)
	
	You grant the subject a +3 bonus on all saves.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills, based on nw_s0_resis (1.12.01 Aidan Scanlan)
//:: Created On: 11.29.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/14/2007: NX1 VFX
//:: AFW-OEI 07/18/2007: Does not stack with Superior Resistance; replaces Resistance.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_grtresistanc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_RESISTANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	



	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eSave;
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_GREATER_RESISTANCE );

	int iBonus = 3; //Saving throw bonus to be applied
	float fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);

	// AFW-OEI 07/18/2007: Does not stack with Superior Resistance; replaces Resistance.
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_NIGHTSHIELD, SPELL_RESISTANCE, SPELL_GREATER_RESISTANCE, SPELL_CONVICTION );
	if (GetHasSpellEffect(SPELL_SUPERIOR_RESISTANCE, oTarget))
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESISTANCE, FALSE));

	//Check for metamagic extend
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Set the bonus save effect
	eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus);
	eSave = EffectLinkEffects( eSave, eVis );

	CSLRemovePermanencySpells(oTarget);

	//Apply the bonus effect and VFX impact
	HkApplyEffectToObject(iDurType, eSave, oTarget, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}

