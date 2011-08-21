//::///////////////////////////////////////////////
//:: Citadel Training
//:: cmi_s2_cittrain
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 26, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_cwsuperdefen();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_CHAMPWILD_SUPERIOR_DEFENSE;
	int iClass = CLASS_CHAMPION_WILD;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iAttributes = 0;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	//if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	//{
	//	return;
	//}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	
	
	int nBoost = GetLevelByClass(CLASS_CHAMPION_WILD);
	nBoost = nBoost / 3;
	
	effect eAC = EffectACIncrease(nBoost);
	eAC = SetEffectSpellId(eAC,iSpellId);
	eAC = SupernaturalEffect(eAC);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, OBJECT_SELF, 0.0f, iSpellId ));
	
	//HkPostCast(oCaster);
	
}      

