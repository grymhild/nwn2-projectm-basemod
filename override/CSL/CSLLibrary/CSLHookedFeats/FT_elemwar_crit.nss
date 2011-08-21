//::///////////////////////////////////////////////
//:: Critical Sense + Expert Tumbling
//:: cmi_s2_critsense
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: March 23, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	// testing things DISABLED
	//return;
	// end testing
	
	
	//scSpellMetaData = SCMeta_FT_elemwar_crit();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_WHDERV_CRITSENSE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
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
	

	
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
		
	
	int nWhDerv = GetLevelByClass(CLASS_WHIRLING_DERVISH);
	effect eCritSense;
	
	if (nWhDerv > 9) // Crit Sense +2 and Expert Tumbling
	{
		effect eAB = EffectAttackIncrease(2);
		effect eAC = EffectACIncrease(1);
		eCritSense = EffectLinkEffects(eAB,eAC);
	}
	else if (nWhDerv > 4) // Expert Tumbling
	{
		effect eAB = EffectAttackIncrease(1);
		effect eAC = EffectACIncrease(1);
		eCritSense = EffectLinkEffects(eAB,eAC);	
	}
	else // Crit Sense +1 
	{
		eCritSense = EffectAttackIncrease(1);	
	}
	
	eCritSense = SetEffectSpellId(eCritSense,iSpellId);
	eCritSense = SupernaturalEffect(eCritSense);
	
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eCritSense, oCaster);
	
	//HkPostCast(oCaster);
}