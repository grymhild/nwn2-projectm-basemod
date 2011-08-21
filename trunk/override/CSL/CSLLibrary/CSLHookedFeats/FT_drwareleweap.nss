//::///////////////////////////////////////////////
//:: Dragon Warrior, Elemental Weapon
//:: cmi_s2_drgwrwpn
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: August 12, 2008
//:://////////////////////////////////////////////
//#include "nwn2_inc_spells"
//#include "cmi_ginc_chars"
//#include "cmi_ginc_spells"
//#include "_CSLCore_Items"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	
	object oCaster = OBJECT_SELF;
	int nSpellId = SPELLABILITY_DRGWRR_ELEMENTAL_WEAPON;

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, nSpellId );
	
	int nDragonDis = GetLocalInt(oCaster, "DragonDisciple");
	if (nDragonDis == 0)
	{
		SetupDragonDis();
		nDragonDis = GetLocalInt(oCaster, "DragonDisciple");
	}

	int nDamageType = DAMAGE_TYPE_FIRE;
	int nItemVisual = ITEM_VISUAL_FIRE;
	int nLevel = GetLevelByClass(CLASS_DRAGON_WARRIOR, oCaster);
	int nDamageBonus = DAMAGE_BONUS_1d6;
	if (nLevel > 8)
	{
		nDamageBonus = DAMAGE_BONUS_2d6;
	}
	
	if (nDragonDis == 2)
	{
		nDamageType = DAMAGE_TYPE_ACID;
		nItemVisual = ITEM_VISUAL_ACID;
	}
	else if (nDragonDis == 3)
	{
		nDamageType = DAMAGE_TYPE_ELECTRICAL;
		nItemVisual = ITEM_VISUAL_ELECTRICAL;
	}
	else if (nDragonDis == 4)
	{
		nDamageType = DAMAGE_TYPE_COLD;
		nItemVisual = ITEM_VISUAL_COLD;
	}


	float fDuration = HoursToSeconds(nLevel);

	effect eLink = EffectDamageIncrease(nDamageBonus, nDamageType);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
	eLink = EffectLinkEffects(eDur, eLink);
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpellId);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration, nSpellId ));
}