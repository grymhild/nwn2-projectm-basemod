//::///////////////////////////////////////////////
//:: Sacred Defense
//:: cmi_s2_sacreddef
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Nov 7, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_dssacreddefe();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIVSEEK_SACRED_DEFENSE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	
	int nBoost = 0;
	

	
	int iLevel = GetLevelByClass(CLASS_DIVINE_SEEKER);
		
	if (iLevel > 3)
		nBoost = 2;
	else
		nBoost = 1;
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBoost);
	eSave = SetEffectSpellId(eSave,iSpellId);
	eSave = SupernaturalEffect(eSave);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, OBJECT_SELF, HkApplyDurationCategory(2, SC_DURCATEGORY_DAYS) );
	
	HkPostCast(oCaster);
}