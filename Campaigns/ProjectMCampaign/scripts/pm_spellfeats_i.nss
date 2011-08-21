#include "hcr2_debug_i"

void AdjustSkinSkillModifier(object oSkin, int nSkillID, int nBonus)
{
	int nCurrModifierValue = 0;
	itemproperty ip = GetFirstItemProperty(oSkin);
	while (GetIsItemPropertyValid(ip))
	{
		int nType = GetItemPropertyType(ip);				
		if (nType == ITEM_PROPERTY_SKILL_BONUS)
		{
			int nSubType = GetItemPropertySubType(ip);			
			if (nSubType == nSkillID)
			{
				nCurrModifierValue = GetItemPropertyCostTableValue(ip);
				break;
			}
		}
		if (nType == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)
		{
			int nSubType = GetItemPropertySubType(ip);			
			if (nSubType == nSkillID)
			{
				nCurrModifierValue = GetItemPropertyCostTableValue(ip) * -1;
				break;
			}
		}
		ip = GetNextItemProperty(oSkin);
	}
	RemoveItemProperty(oSkin, ip); 
	nCurrModifierValue += nBonus;
	if (nCurrModifierValue > 0)
		ip = ItemPropertySkillBonus(nSkillID, nCurrModifierValue);
	else if (nCurrModifierValue < 0)
		ip = ItemPropertyDecreaseSkill(nSkillID, nCurrModifierValue * -1); //<-- wants a postive value
	if (GetIsItemPropertyValid(ip))
		AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
}

void AddFeatSkillBonusToSkin(string sFeat, int nSkillID, int nBonus, int nRemoveFeatID = -1)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);

	if (!GetIsObjectValid(oSkin))
		h2_LogMessage(H2_LOG_ERROR, sFeat + " needs a player skin to work properly.");
	else
	{			
		if (!GetLocalInt(oSkin, sFeat))
		{
			AdjustSkinSkillModifier(oSkin, nSkillID, nBonus);
			SetLocalInt(oSkin, sFeat, nBonus);
			if (nRemoveFeatID > -1)
				FeatRemove(oChar, nRemoveFeatID);
		}
	}
}

void AddImprovedStatBonus(string sFeat, int nAbility, int nBonus)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);

	if (!GetIsObjectValid(oSkin))
		h2_LogMessage(H2_LOG_ERROR, sFeat + " needs a player skin to work properly.");
	else
	{
		if (!GetLocalInt(oSkin, sFeat))
		{
			SetLocalInt(oSkin, sFeat, nBonus);
			int nCurrScore = GetAbilityScore(oChar, nAbility, TRUE);
			nCurrScore += nBonus;
			SetBaseAbilityScore(oChar, nAbility, nCurrScore);
		}
	}
}