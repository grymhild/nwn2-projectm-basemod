/////////////////////////////////////////////////
// Bull's Strength
//-----------------------------------------------
// Created By: Brenon Holmes
// Created On: 10/12/2000
// Description: This script changes someone's strength
// Updated 2003-07-17 to fix stacking issue with blackguard
/////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_bullsstrengt();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BULLS_STRENGTH;
	int iClass = CLASS_TYPE_NONE;
	if (  GetSpellId() == SPELL_BG_BullsStrength ||  GetSpellId() == SPELL_BG_Spellbook_1 )
	{
		iSpellId = SPELL_BG_BullsStrength;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
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
	
		
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ) );
	int nModify = 4;
	
	if (GetSpellId() == SPELLABILITY_BG_BULLS_STRENGTH || GetSpellId()==1716 )
	{
		fDuration = CSLGetMaxf( fDuration, HkApplyDurationCategory(12, SC_DURCATEGORY_HOURS) ); 
		iSpellPower = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
		if (iSpellPower >= 10) nModify = 8;
		else if (iSpellPower >= 6) nModify = 6;
	}
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BULLS_STRENGTH, FALSE));
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_BULL_STRENGTH);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, nModify));
	// BABA YAGA DURATION EDIT
	//if (CSLStringStartsWith(GetTag(oCaster),"BABA_")) fDuration = HoursToSeconds(24);
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

