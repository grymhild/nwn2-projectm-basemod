//::///////////////////////////////////////////////
//:: Death Ward
//:: NW_S0_DeaWard.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target creature is protected from the instant
	death effects for the duration of the spell
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 27, 2001

// (Updated JLR - OEI 07/11/05 NWN2 3.5)


// JLR - OEI 08/24/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_deathward();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DEATH_WARD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration( oCaster );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	

	effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
	// JLR - OEI NWN2 3.5 Update: Merged from Negative Energy Protection
	effect eNeg = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 9999, 0);
	effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
	effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
	//effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD); // no longer using NWN1 VFX
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_DEATH_WARD ); // NWN2 VFX
	effect eLink = EffectLinkEffects(eDeath, eDur);
	eLink = EffectLinkEffects(eLink, eNeg);
	eLink = EffectLinkEffects(eLink, eLevel);
	eLink = EffectLinkEffects(eLink, eAbil);


	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_Living_Undeath );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DEATH_WARD, FALSE));

	//Apply VFX impact and death immunity effect
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget); // NWN1 VFX
	
	HkPostCast(oCaster);
}

