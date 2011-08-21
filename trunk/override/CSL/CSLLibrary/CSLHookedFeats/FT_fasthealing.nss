//::///////////////////////////////////////////////
//:: Fast Healing I, II
//:: cmi_s2_fastheal
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 17, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_fasthealing();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, SPELLABILITY_Fast_Healing_I, SPELLABILITY_Fast_Healing_II );
		
	
	int nRegen;
	
	if (GetHasFeat(FEAT_FAST_HEALING_II))
		nRegen = 6;
	else
		nRegen = 3;
	 
	effect eRegen = EffectRegenerate(nRegen, 6.0f);
	eRegen = SetEffectSpellId(eRegen,iSpellId);
	eRegen = SupernaturalEffect(eRegen);
	
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, OBJECT_SELF);
	
	HkPostCast(oCaster);	
}