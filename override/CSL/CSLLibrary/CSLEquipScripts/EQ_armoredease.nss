//::///////////////////////////////////////////////
//:: Armored Ease
//:: cmi_s2_armoredease
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Nov 7, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"


void main()
{	
	//scSpellMetaData = SCMeta_FT_armoredease();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	
	object oCaster = OBJECT_SELF;
	int iSpellId = DREADCOM_ARMORED_EASE;
	/*
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
	*/

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
		
	
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,oCaster);
	
	if (oArmor == OBJECT_INVALID)
	{	
	//	HkPostCast(oCaster);
		return;
	}
	
	int iBonus = 0;
	if (GetLevelByClass(CLASS_DREAD_COMMANDO) > 3)
	{
		iBonus = 4;
	}
	else
	{
		iBonus = 2; 
	}
		
	effect eSkillBoostHide = EffectSkillIncrease(SKILL_HIDE,iBonus);
	effect eSkillBoostMoveSilent = EffectSkillIncrease(SKILL_MOVE_SILENTLY,iBonus);
	effect eSkillBoostTumble = EffectSkillIncrease(SKILL_TUMBLE,iBonus);
	effect eLink = EffectLinkEffects(eSkillBoostHide,eSkillBoostMoveSilent);
	eLink = EffectLinkEffects(eLink, eSkillBoostTumble);
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(2, SC_DURCATEGORY_DAYS), iSpellId ) );
	
	HkPostCast(oCaster);
}