//::///////////////////////////////////////////////
//:: Owl's Wisdom
//:: NW_S0_OwlWis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Raises targets Wis by 4
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_owlswisdom();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_OWLS_WISDOM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	object oTarget = HkGetSpellTarget();
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	int iDuration = HkGetSpellDuration( oCaster );
	int nModify = 4;
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_OWLS_WISDOM, FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_OWL_WISDOM);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_WISDOM, nModify));
	// BABA YAGA DURATION EDIT
	//if (CSLStringStartsWith(GetTag(oCaster),"BABA_")) fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

