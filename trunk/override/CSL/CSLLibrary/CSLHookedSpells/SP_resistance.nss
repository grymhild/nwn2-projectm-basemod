//::///////////////////////////////////////////////
//:: Resistance
//:: NW_S0_Resis
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: This spell gives the recipiant a +1 bonus to
//:: all saves.  It lasts for 1 Turn.
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/12/01
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: Aug 7, 2001


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_resistance();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RESISTANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_RESISTANCE );

	int iBonus = 1; //Saving throw bonus to be applied
	float fDuration = TurnsToSeconds(2); // Turns
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_RESISTANCE, SPELL_NIGHTSHIELD);
	if (GetHasSpellEffect(SPELL_SUPERIOR_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_GREATER_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_CONVICTION, oTarget) )
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESISTANCE, FALSE));

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

