//::///////////////////////////////////////////////
//:: Agility Training
//:: cmi_s2_agiltrain
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Nov 7, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/

#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_NIGHTSONGE_AGILITY_TRAINING;
	object oCaster = OBJECT_SELF;
	/*
	
	
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
	
	if (oArmor == OBJECT_INVALID)
	{
		return;
	}
	else if ( GetArmorRank(oArmor) != ARMOR_RANK_LIGHT )
	{
		return;
	}
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );


	effect eSkillBoostHide = EffectSkillIncrease(SKILL_HIDE,2);
	effect eSkillBoostMoveSilent = EffectSkillIncrease(SKILL_MOVE_SILENTLY,2);
	effect eSkillBoostTumble = EffectSkillIncrease(SKILL_TUMBLE,2);
	effect eLink = EffectLinkEffects(eSkillBoostHide,eSkillBoostMoveSilent);
	eLink = EffectLinkEffects(eLink, eSkillBoostTumble);
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(48), iSpellId ));
	
	HkPostCast(oCaster);
}