//#include "prc_alterations"
//#include "prc_inc_spells"
//#include "x2_inc_spellhook"

int GetIsValidAnimate(object oTarget);
int GetWeaponAnimateSize(object oTarget);
void AddArmourHardness(object oHide, object oArmour, object oAnimate);
void AddWeaponHardness(object oHide, object oWeapon, object oAnimate);

const int SIZE_SMALL = 1;
const int SIZE_MEDIUM = 2;

const int ERROR_CODE_5_AGAIN = 1;

int GetWeaponAnimateSize(object oTarget)
{
	int iBaseItemType = GetBaseItemType(oTarget);
	switch (iBaseItemType)
	{
		case BASE_ITEM_BASTARDSWORD:
		case BASE_ITEM_DIREMACE:
		case BASE_ITEM_TWOBLADEDSWORD:
		case BASE_ITEM_DOUBLEAXE:
		case BASE_ITEM_HEAVYFLAIL:
		case BASE_ITEM_GREATAXE:
		case BASE_ITEM_GREATSWORD:
		case BASE_ITEM_HALBERD:
		case BASE_ITEM_SCYTHE:
			return SIZE_MEDIUM;
			break;
		case BASE_ITEM_DWARVENWARAXE:
		case BASE_ITEM_BATTLEAXE:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_KAMA:
		case BASE_ITEM_KATANA:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_LIGHTFLAIL:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_LONGSWORD:
		case BASE_ITEM_MORNINGSTAR:
		case BASE_ITEM_QUARTERSTAFF:
		case BASE_ITEM_RAPIER:
		case BASE_ITEM_SCIMITAR:
		case BASE_ITEM_SHORTSPEAR:
		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_WARHAMMER:
		case BASE_ITEM_WHIP:
			return SIZE_SMALL;
			break;
	}
	return SIZE_SMALL;
}

int GetIsValidAnimate(object oTarget)
{
	int iBaseItemType = GetBaseItemType(oTarget);
	itemproperty ipMagicWeapon = GetFirstItemProperty(oTarget);
	if (GetIsItemPropertyValid(ipMagicWeapon))
	{
		if (iBaseItemType == BASE_ITEM_WHIP)
		{
			ipMagicWeapon = GetNextItemProperty(oTarget);
			if (GetIsItemPropertyValid(ipMagicWeapon))
			{
				return FALSE;
			}
			else
			{
				ipMagicWeapon = GetFirstItemProperty(oTarget);
				if (GetItemPropertyType(ipMagicWeapon) == ITEM_PROPERTY_BONUS_FEAT)
				{
				if (GetItemPropertySubType(ipMagicWeapon) != 37)
					return FALSE;

				}
				else
				{
				return FALSE;
				}
			}
		}
		else
		{
			return FALSE;
		}
	}

	switch (iBaseItemType)
	{
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_BASTARDSWORD:
		case BASE_ITEM_BATTLEAXE:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_DIREMACE:
		case BASE_ITEM_DOUBLEAXE:
		case BASE_ITEM_DWARVENWARAXE:
		case BASE_ITEM_GREATAXE:
		case BASE_ITEM_GREATSWORD:
		case BASE_ITEM_HALBERD:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_HEAVYFLAIL:
		case BASE_ITEM_KAMA:
		case BASE_ITEM_KATANA:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_LIGHTFLAIL:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_LONGSWORD:
		case BASE_ITEM_MORNINGSTAR:
		case BASE_ITEM_QUARTERSTAFF:
		case BASE_ITEM_RAPIER:
		case BASE_ITEM_SCIMITAR:
		case BASE_ITEM_SCYTHE:
		case BASE_ITEM_SHORTSPEAR:
		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_TWOBLADEDSWORD:
		case BASE_ITEM_WARHAMMER:
		case BASE_ITEM_WHIP:
			return TRUE;
			break;
		default:
			return FALSE;
			break;
	}
	return FALSE;
}


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ANIMATE_OBJECT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	if (GetIsValidAnimate(oTarget))
	{
		object oAnimate;
		location lTarget;
		effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
		if (GetItemPossessor(oTarget) == OBJECT_INVALID)
		{
			lTarget = GetLocation(oTarget);
		}
		else
		{
			lTarget = GetLocation(GetItemPossessor(oTarget));
		}
		if (GetBaseItemType(oTarget) == BASE_ITEM_ARMOR)
		{
			//SendMessageToPC(OBJECT_SELF, "is armour");
			int iArmourClass = GetItemACValue(oTarget);
			if (iArmourClass>4)
			{
				oAnimate = CreateObject(OBJECT_TYPE_CREATURE, "anim_armour_5_8", lTarget, FALSE, "PRC_Spell_Animated_Object");
				//SendMessageToPC(OBJECT_SELF, "5-8");
			}
			else if (iArmourClass>0)
			{
				oAnimate = CreateObject(OBJECT_TYPE_CREATURE, "anim_armour_1_4", lTarget, FALSE, "PRC_Spell_Animated_Object");
				//SendMessageToPC(OBJECT_SELF, "1-4");
			}
			else
			{
				oAnimate = CreateObject(OBJECT_TYPE_CREATURE, "anim_armour_0", lTarget, FALSE, "PRC_Spell_Animated_Object");
				//SendMessageToPC(OBJECT_SELF, "0");
			}
			if (iArmourClass>0)
			{
				//remove armour from the animated object (armour should not get armour from itself)
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACDecrease(iArmourClass,AC_ARMOUR_ENCHANTMENT_BONUS),oAnimate);
			}
			object oNewTarget = CopyObject(oTarget, GetLocation(oAnimate),oAnimate);
			DestroyObject(oTarget,1.0);
			AssignCommand(oAnimate, ActionEquipItem(oNewTarget,INVENTORY_SLOT_CHEST));
			//SendMessageToPC(OBJECT_SELF, "done armour");
		}
		else
		{
			if (GetWeaponAnimateSize(oTarget) == SIZE_SMALL)
			{
				oAnimate = CreateObject(OBJECT_TYPE_CREATURE, "anim_weapon_smal", lTarget, FALSE, "PRC_Spell_Animated_Object");
			}
			else
			{
				oAnimate = CreateObject(OBJECT_TYPE_CREATURE, "anim_weapon_larg", lTarget, FALSE, "PRC_Spell_Animated_Object");
			}
			object oNewTarget = CopyObject(oTarget, GetLocation(oAnimate),oAnimate);
			DestroyObject(oTarget,1.0);
			AssignCommand(oAnimate, ActionEquipItem(oNewTarget,INVENTORY_SLOT_RIGHTHAND));
		}
		if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
			SetLocalInt(oAnimate,"Rounds",(HkGetCasterLevel(oCaster)*2));
		else
			SetLocalInt(oAnimate,"Rounds",HkGetCasterLevel(oCaster));
		effect eDom = SupernaturalEffect(EffectCutsceneDominated());
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oAnimate, 4.0);
		DelayCommand(0.0, AssignCommand(oAnimate, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 2.0)));
		DelayCommand(3.5, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDom, oAnimate));
	}
	else
	{
		SendMessageToPC(OBJECT_SELF, "Invalide target");
		SendMessageToPC(OBJECT_SELF, "Target must be armour/clothing/melee weapon");
		SendMessageToPC(OBJECT_SELF, "Target cannot be magical");
	}
}



