//::///////////////////////////////////////////////
//:: Minor Globe of Invulnerability
//:: NW_S0_MinGlobe.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Caster is immune to 3rd levels spells and lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_minglobe();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LESSER_GLOBE_OF_INVULNERABILITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool=SPELL_SCHOOL_ABJURATION;
	int iSpellSubSchool=SPELL_SUBSCHOOL_NONE;
	if ( GetSpellId() == SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE )
	{
		iSpellSchool=SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool=SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = oCaster;
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_GLOBE_INV_LESS);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eSpell = EffectSpellLevelAbsorption(3, 0);
	//Link Effects
	effect eLink = EffectLinkEffects(eVis, eSpell);
	//eLink = EffectLinkEffects(eLink, eDur);
	int iDuration = HkGetSpellDuration(oCaster); // OldGetCasterLevel(OBJECT_SELF);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_LESSER_GLOBE_OF_INVULNERABILITY, FALSE ) );

	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	
	HkPostCast(oCaster);
}

