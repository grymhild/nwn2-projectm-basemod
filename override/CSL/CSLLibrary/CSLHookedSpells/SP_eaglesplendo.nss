//::///////////////////////////////////////////////
//:: Eagles Splendor
//:: NW_S0_EagleSpl
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Raises targets Chr by 4
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_eaglesplendo();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EAGLES_SPLENDOR;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_BG_Eagle_Splendor )
	{
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	else if ( GetSpellId() == SPELLABILITY_EAGLE_SPLENDOR )
	{
		iClass = CLASS_TYPE_NONE;
	}
	int iSpellLevel = 2;
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
	
		
	
	int iDuration = HkGetSpellDuration( oCaster ); // OldGetCasterLevel(oCaster);
	//iDuration += GetLevelByClass(CLASS_TYPE_BLACKGUARD);
	
	object oTarget = HkGetSpellTarget();
	int nModify = 4;
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_EAGLES_SPLENDOR, FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods( DURATION_TYPE_TEMPORARY );
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_EAGLE_SPLENDOR);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CHARISMA, nModify));
	// BABA YAGA DURATION EDIT
	//if (CSLStringStartsWith(GetTag(oCaster),"BABA_")) fDuration = HoursToSeconds(24);
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_EAGLES_SPLENDOR );
	
	HkPostCast(oCaster);
}

