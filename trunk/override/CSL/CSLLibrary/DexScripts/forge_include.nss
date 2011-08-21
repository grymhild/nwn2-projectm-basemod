//********************************************************************************

//Feed me an Item object-variable with a PropertyTypeID and PropertySubTypeID and I'll go look for it in the item object and return the corresponding itemproperty object if it is found.
itemproperty FindItemProperty(object oItem, int PropertyType, int PropertySubType)
{
	itemproperty FoundItemProperty;
	int Match=0;
	
	FoundItemProperty=GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(FoundItemProperty)==TRUE && Match==0)
	{
		if (GetItemPropertyType(FoundItemProperty)==PropertyType)
		{
			if (GetItemPropertySubType(FoundItemProperty)==PropertySubType)
			{
				Match=1;
			}
			else if (PropertyType==1 || PropertyType==6 || PropertyType==10 || PropertyType==11 || PropertyType==12 || PropertyType==21 || PropertyType==26 || PropertyType>31 && PropertyType<40 || PropertyType==43 || PropertyType==45 || PropertyType==47 || PropertyType==51 || PropertyType>52 && PropertyType<57 || PropertyType>59 && PropertyType<68 || PropertyType>70 && PropertyType<82 || PropertyType==83 || PropertyType==84)
			{
				Match=1;
			}
		}
		SendMessageToPC(GetFirstPC(), "Type=" + IntToString(PropertyType) + " SubType=" + IntToString(PropertySubType) + " cType=" + IntToString(GetItemPropertyType(FoundItemProperty)) + " cSubType=" + IntToString(GetItemPropertySubType(FoundItemProperty)) + " Match=" + IntToString(Match));
		if (Match==0) FoundItemProperty=GetNextItemProperty(oItem);
	}
	return FoundItemProperty;
}

//********************************************************************************

//Feed me a PropertyTypeID, PropertySubTypeID, and property enhancement Value and I'll regurgatate an itemproperty object.  itemprops.2da mined as of NWN 1.03
itemproperty GenerateItemProperty(int PropertyType, int PropertySubType, int ParamValue, int ExtraParamValue1=0)
{
	itemproperty TheItemProperty;

	switch (PropertyType)
	{
		case 0:
			TheItemProperty=ItemPropertyAbilityBonus(PropertySubType, ParamValue);
			break;
		case 1:
			TheItemProperty=ItemPropertyACBonus(ParamValue);
			break;
		case 2:
			TheItemProperty=ItemPropertyACBonusVsAlign(PropertySubType, ParamValue);
			break;
		case 3:
			TheItemProperty=ItemPropertyACBonusVsDmgType(PropertySubType, ParamValue);
			break;
		case 4:
			TheItemProperty=ItemPropertyAbilityBonus(PropertySubType, ParamValue);
			break;
		case 5:
			TheItemProperty=ItemPropertyACBonusVsSAlign(PropertySubType, ParamValue);
			break;
		case 6:
			TheItemProperty=ItemPropertyEnhancementBonus(ParamValue);
			break;
		case 7:
			TheItemProperty=ItemPropertyEnhancementBonusVsAlign(PropertySubType, ParamValue);
			break;
		case 8:
			TheItemProperty=ItemPropertyEnhancementBonusVsRace(PropertySubType, ParamValue);
			break;
		case 9:
			TheItemProperty=ItemPropertyEnhancementBonusVsSAlign(PropertySubType, ParamValue);
			break;
		case 10:
			TheItemProperty=ItemPropertyAttackPenalty(ParamValue);
			break;
		case 11:
			TheItemProperty=ItemPropertyWeightReduction(ParamValue);
			break;
		case 12:
			TheItemProperty=ItemPropertyBonusFeat(ParamValue);
			break;
		case 13:
			TheItemProperty=ItemPropertyBonusLevelSpell(PropertySubType, ParamValue);
			break;
		case 14:
			//TheItemProperty="Boomerang";
			break;
		case 15:
			TheItemProperty=ItemPropertyCastSpell(PropertySubType, ParamValue);
			break;
		case 16:
			TheItemProperty=ItemPropertyDamageBonus(PropertySubType, ParamValue);
			break;
		case 17:
			TheItemProperty=ItemPropertyDamageBonusVsAlign(PropertySubType, ExtraParamValue1, ParamValue);
			break;
		case 18:
			TheItemProperty=ItemPropertyDamageBonusVsRace(PropertySubType, ExtraParamValue1, ParamValue);
			break;
		case 19:
			TheItemProperty=ItemPropertyDamageBonusVsSAlign(PropertySubType, ExtraParamValue1, ParamValue);
			break;
		case 20:
			TheItemProperty=ItemPropertyDamageImmunity(PropertySubType, ParamValue);
			break;
		case 21:
			TheItemProperty=ItemPropertyDamagePenalty(ParamValue);
			break;
		case 22:
			TheItemProperty=ItemPropertyDamageReduction(ParamValue, PropertySubType, 0, ExtraParamValue1);
			break;
		case 23:
			TheItemProperty=ItemPropertyDamageResistance(PropertySubType, ParamValue);
			break;
		case 24:
			TheItemProperty=ItemPropertyDamageVulnerability(PropertySubType, ParamValue);
			break;
		case 25:
			//TheItemProperty="Dancing";
			break;
		case 26:
			TheItemProperty=ItemPropertyDarkvision();
			break;
		case 27:
			TheItemProperty=ItemPropertyDecreaseAbility(PropertySubType, ParamValue);
			break;
		case 28:
			TheItemProperty=ItemPropertyDecreaseAC(PropertySubType, ParamValue);
			break;
		case 29:
			TheItemProperty=ItemPropertyDecreaseSkill(PropertySubType, ParamValue);
			break;
		case 30:
			//TheItemProperty="Double_Stack";
			break;
		case 31:
			//TheItemProperty="Enhanced_Container:_Bonus_Slots";
			break;
		case 32:
			TheItemProperty=ItemPropertyContainerReducedWeight(ParamValue);
			break;
		case 33:
			TheItemProperty=ItemPropertyExtraMeleeDamageType(ParamValue);
			break;
		case 34:
			TheItemProperty=ItemPropertyExtraRangeDamageType(ParamValue);
			break;
		case 35:
			TheItemProperty=ItemPropertyHaste();
			break;
		case 36:
			TheItemProperty=ItemPropertyHolyAvenger();
			break;
		case 37:
			TheItemProperty=ItemPropertyImmunityMisc(ParamValue);
			break;
		case 38:
			TheItemProperty=ItemPropertyImprovedEvasion();
			break;
		case 39:
			TheItemProperty=ItemPropertyBonusSpellResistance(ParamValue);
			break;
		case 40:
			TheItemProperty=ItemPropertyBonusSavingThrowVsX(PropertySubType, ParamValue);
			break;
		case 41:
			TheItemProperty=ItemPropertyBonusSavingThrow(PropertySubType, ParamValue);
			break;
		case 42:
			//TheItemProperty="****";
			break;
		case 43:
			TheItemProperty=ItemPropertyKeen();
			break;
		case 44:
			TheItemProperty=ItemPropertyLight(PropertySubType, ParamValue);
			break;
		case 45:
			TheItemProperty=ItemPropertyMaxRangeStrengthMod(ParamValue);
			break;
		case 46:
			//TheItemProperty="ITEM_PROPERTY_MIND_BLANK";
			break;
		case 47:
			TheItemProperty=ItemPropertyNoDamage();
			break;
		case 48:
			TheItemProperty=ItemPropertyOnHitProps(PropertySubType, ParamValue, ExtraParamValue1);
			break;
		case 49:
			TheItemProperty=ItemPropertyReducedSavingThrow(PropertySubType, ParamValue);
			break;
		case 50:
			TheItemProperty=ItemPropertyReducedSavingThrowVsX(PropertySubType, ParamValue);
			break;
		case 51:
			TheItemProperty=ItemPropertyRegeneration(ParamValue);
			break;
		case 52:
			TheItemProperty=ItemPropertySkillBonus(PropertySubType, ParamValue);
			break;
		case 53:
			TheItemProperty=ItemPropertySpellImmunitySpecific(ParamValue);
			break;
		case 54:
			TheItemProperty=ItemPropertySpellImmunitySchool(ParamValue);
			break;
		case 55:
			TheItemProperty=ItemPropertyThievesTools(ParamValue);
			break;
		case 56:
			TheItemProperty=ItemPropertyAttackBonus(ParamValue);
			break;
		case 57:
			TheItemProperty=ItemPropertyAttackBonusVsAlign(PropertySubType, ParamValue);
			break;
		case 58:
			TheItemProperty=ItemPropertyAttackBonusVsRace(PropertySubType, ParamValue);
			break;
		case 59:
			TheItemProperty=ItemPropertyAttackBonusVsSAlign(PropertySubType, ParamValue);
			break;
		case 60:
			TheItemProperty=ItemPropertyEnhancementPenalty(ParamValue);
			//TheItemProperty="To_Hit_Penalty";
			break;
		case 61:
			TheItemProperty=ItemPropertyUnlimitedAmmo(ParamValue);
			break;
		case 62:
			TheItemProperty=ItemPropertyLimitUseByAlign(ParamValue);
			break;
		case 63:
			TheItemProperty=ItemPropertyLimitUseByClass(ParamValue);
			break;
		case 64:
			TheItemProperty=ItemPropertyLimitUseByRace(ParamValue);
			break;
		case 65:
			TheItemProperty=ItemPropertyLimitUseBySAlign(ParamValue);
			break;
		case 66:
			TheItemProperty=ItemPropertyBonusHitpoints(ParamValue);
			break;
		case 67:
			TheItemProperty=ItemPropertyVampiricRegeneration(ParamValue);
			break;
		case 68:
			//TheItemProperty="Vorpal_Blade";
			break;
		case 69:
			//TheItemProperty="Wounding";
			break;
		case 70:
			TheItemProperty=ItemPropertyTrap(PropertySubType, ParamValue);
			break;
		case 71:
			TheItemProperty=ItemPropertyTrueSeeing();
			break;
		case 72:
			TheItemProperty=ItemPropertyOnMonsterHitProperties(PropertySubType, ParamValue);
			break;
		case 73:
			TheItemProperty=ItemPropertyTurnResistance(ParamValue);
			break;
		case 74:
			TheItemProperty=ItemPropertyMassiveCritical(ParamValue);
			break;
		case 75:
			TheItemProperty=ItemPropertyFreeAction();
			break;
		case 76:
			//TheItemProperty="Poison";
			break;
		case 77:
			TheItemProperty=ItemPropertyMonsterDamage(ParamValue);
			break;
		case 78:
			TheItemProperty=ItemPropertyImmunityToSpellLevel(ParamValue);
			break;
		case 79:
			TheItemProperty=ItemPropertySpecialWalk(ParamValue);
			break;
		case 80:
			TheItemProperty=ItemPropertyHealersKit(ParamValue);
			break;
		case 81:
			TheItemProperty=ItemPropertyWeightIncrease(ParamValue);
			break;
		case 82:
			TheItemProperty=ItemPropertyOnHitCastSpell(PropertySubType, ParamValue);
			break;
		case 83:
			TheItemProperty=ItemPropertyVisualEffect(ParamValue);
			break;
		case 84:
			TheItemProperty=ItemPropertyArcaneSpellFailure(ParamValue);
			break;
		case 85:
			//TheItemProperty="ArrowCatching";
			break;
		case 86:
			//TheItemProperty="Bashing";
			break;
		case 87:
			//TheItemProperty="Animated";
			break;
		case 88:
			//TheItemProperty="Wild";
			break;
		case 89:
			//TheItemProperty="Etherealness";
			break;
	}

	return TheItemProperty;
}

//********************************************************************************

/*
melee: 0-5, 8, 9, 10, 13, 18, 22, 28, 37, 38, 40, 41, 42, 47, 50, 51, 53, 55, 60, 111, 114, 116, 119, 120, 124, 126, 140, 141, 142
range: 6,7,8,11, 61
throw: 31, 59, 63

armor: 14, 16, 56, 57
Helm: 17

Ammo: 20, 25, 27
gauntlets: 36
Rod: 44-46

Misc
MiscE 
*/

string GetBaseItemTypeGroup(int ItemType)
{
	string ItemTypeGroup;
	
	if (ItemType>-1 && ItemType<6 || ItemType==8 || ItemType==9 || ItemType==10 || ItemType==13 || ItemType==18 || ItemType==22 || ItemType==28 || ItemType==37 || ItemType==38 || ItemType==40 || ItemType==41 || ItemType==42 || ItemType==47 || ItemType==50 || ItemType==51 || ItemType==53 || ItemType==55 || ItemType==60 || ItemType==111 || ItemType==114 || ItemType==116 || ItemType==119 || ItemType==120 || ItemType==124 || ItemType==126 || ItemType==140 || ItemType==141 || ItemType==142)
	{
		ItemTypeGroup="melee";
	}
	else if (ItemType==6 || ItemType==7 || ItemType==8 || ItemType==11 || ItemType==61)
	{
		ItemTypeGroup="ranged";
	}
	else if (ItemType==-1)
	{
		ItemTypeGroup="misc";
	}
	else if (ItemType==-2)
	{
		ItemTypeGroup="misce";
	}
	else if (ItemType==31 || ItemType==59 || ItemType==63)
	{
		ItemTypeGroup="throw";
	}
	else if (ItemType>43 && ItemType<47)
	{
		ItemTypeGroup="rod";
	}
	else if (ItemType==14 || ItemType==16 || ItemType==56 || ItemType==57)
	{
		ItemTypeGroup="armor";
	}
	else if (ItemType==20 || ItemType==25 || ItemType==27)
	{
		ItemTypeGroup="ammo";
	}
	else
	{
		ItemTypeGroup=="other";
	}		
	
	return ItemTypeGroup;
}

//********************************************************************************