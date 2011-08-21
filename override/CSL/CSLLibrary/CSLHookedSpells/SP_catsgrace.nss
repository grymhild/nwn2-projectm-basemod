//::///////////////////////////////////////////////
//:: Cat's Grace
//:: NW_S0_CatGrace
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The transmuted creature becomes more graceful,
// agile, and coordinated. The spell grants an
// enhancement  bonus to Dexterity of 4
// points, adding the usual benefits to AC,
// Reflex saves, Dexterity-based skills, etc.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_catsgrace();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CATS_GRACE;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_Cats_Grace )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

		
	
	int iCasterLevel = HkGetSpellDuration( oCaster ); // OldGetCasterLevel(oCaster);
	
	//iCasterLevel += GetLevelByClass(CLASS_TYPE_ASSASSIN);	
	//iCasterLevel += GetLevelByClass(CLASS_TYPE_AVENGER);
	
	object oTarget = HkGetSpellTarget();
	int nModify = 4;
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CATS_GRACE, FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( iCasterLevel));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_CAT_GRACE);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, nModify));
	eLink = SetEffectSpellId(eLink, SPELL_CATS_GRACE);
	// BABA YAGA DURATION EDIT
	//if (CSLStringStartsWith(GetTag(oCaster),"BABA_")) fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_CATS_GRACE );
	
	HkPostCast(oCaster);
}

