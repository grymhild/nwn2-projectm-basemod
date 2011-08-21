//::///////////////////////////////////////////////
//:: Elemental Shield
//:: cmi_s2_elemshield
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: May 13, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
//#include "_SCInclude_Class"

void main()
{	
	// testing things DISABLED
	//return;
	// end testing
	
	//scSpellMetaData = SCMeta_FT_elemarchshie();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = ELEM_ARCHER_ELEM_SHIELD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes =98688;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDamageType = 0;	
	int iLevel = GetLevelByClass(CLASS_ELEM_ARCHER, OBJECT_SELF);
		
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	
	if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_AIR))
	{
		iDamageType = DAMAGE_TYPE_ELECTRICAL;
	}
	else if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_EARTH))
	{
		iDamageType = DAMAGE_TYPE_ACID;
	}
	else if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_FIRE))
	{
		iDamageType = DAMAGE_TYPE_FIRE;
	}
	else if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_WATER))
	{
		iDamageType = DAMAGE_TYPE_COLD;
	}
		
	int iDuration = GetAbilityModifier(ABILITY_CONSTITUTION);
	if (iDuration < 0)
	{
		iDuration = 0;
	}
	iDuration += iLevel;
	
	int iBonus = iLevel/2;
	if (iLevel == 5)
	{
		iBonus = 3;
	}
		
	if (GetHasFeat(FEAT_ELEM_ARCHER_IMP_ELEM_SHIELD))
	{
		iBonus = iLevel;
		iDuration = iDuration * 2;
	}
		
	effect eDS = EffectDamageShield(iBonus, DAMAGE_BONUS_1d4, iDamageType);
	effect eAC = EffectACIncrease(iBonus);
    effect eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
	effect eLink = EffectLinkEffects(eAC, eDS);	
	eLink = EffectLinkEffects(eDur, eLink);	
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, iSpellId);
		
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS), iSpellId ));
	
	HkPostCast(oCaster);
}