/** @file
* @brief Include File for Magic Stones, a magical upgrade system for Dex
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_CSLCore_Nwnx"
#include "seed_db_inc"
#include "_CSLCore_Items"
#include "_SCInclude_UnlimitedAmmo"

object oWorkContainer = GetObjectByTag("BABAYAGA");    // SOME NPC WHO CAN HOLD THE TEMP ITEMS

string StoneGetID(object oStone)
{
   string sID = GetStringRight(GetFirstName(oStone), 5);
   if (StringToInt(sID)>0) return sID;
   return "0";
}

void StoneOnAcquired(object oPC, object oItem) // ONLY THE FIRST PC WHO PICKS UP STONE AFTER CREATION
{
   string sStoneID = StoneGetID(oItem);
   if (sStoneID=="0") return;
   if (GetLocalInt(oItem, "UNOWNED")) // STONE HAS JUST BEEN ACQUIRED THE FIRST TIME, SAVE THE NEW OWNER
   {
      DeleteLocalInt(oItem, "UNOWNED");
      string sSQL = "update stonetracker set st_plid=" + GetLocalString(oPC, "SDB_PLID") + " where st_stid=" + sStoneID;
      CSLNWNX_SQLExecDirect(sSQL);
   }
}

void StoneUsed(object oStone, object oPC, object oTarget)
{
   string sStoneID = StoneGetID(oStone);
   string sPLID = GetLocalString(oPC, "SDB_PLID");
   string sSQL = "update stonetracker set st_used=now(), st_usedplid=" + sPLID + " where st_stid=" + sStoneID;
   CSLNWNX_SQLExecDirect(sSQL);
   WriteTimestampedLogEntry("Stone Used by " + GetName(oPC) + ": " + GetTag(oStone) + "/" + GetName(oStone) + " used on " + GetTag(oTarget) + "/" + GetName(oTarget));
   DestroyObject(oStone); // DESTORY IT NOW
}

int StoneIsValid(object oStone)
{
   if (GetIsSinglePlayer()) return TRUE;
   string sStoneID = StoneGetID(oStone);
   if (sStoneID!="0") {
      CSLNWNX_SQLExecDirect("select st_usedplid from stonetracker where st_stid=" + sStoneID);
      if (CSLNWNX_SQLFetch()!=CSLSQL_ERROR) {
         return (CSLNWNX_SQLGetData(1)=="0"); // EXISTS IN DB, RETURN TRUE IF USED_PLID IS 0
      }
   }
   return FALSE; // INVALID # OR NOT IN DB
}

string StoneGetNextID(object oCreateOn, string sName)
{
   string sToken;
   string sPLID = "0";
   if (GetIsPC(oCreateOn)) sPLID = GetLocalString(oCreateOn, "SDB_PLID");
   string sSQL = "insert into stonetracker (st_name, st_plid) values ("+ CSLDelimList(CSLInQs(sName), sPLID) + ")";
   CSLNWNX_SQLExecDirect(sSQL);
   sSQL = "select last_insert_id() from stonetracker limit 1";
   CSLNWNX_SQLExecDirect(sSQL);
   if (CSLNWNX_SQLFetch()!=CSLSQL_ERROR)
   {
      sToken = GetStringRight("00000" + CSLNWNX_SQLGetData(1), 5);
      WriteTimestampedLogEntry("Generated Stone #" + sToken + " " + sName);
   }
   else
   {
      WriteTimestampedLogEntry("No database! Token not fetched.");
      sToken = "00000";
   }
   return sToken;
}

object StoneCreate(object oCreateOn, string sResRef, string sName, string sTag)
{
   object oItem = CreateItemOnObject(sResRef, oCreateOn, 1, sTag);
   string sStoneID = StoneGetNextID(oCreateOn, sName);
   SetFirstName(oItem, sName + " #" + sStoneID);
   SetLocalInt(oItem, "UNOWNED", TRUE); // SAVE IT AS A LOCAL STRING SO WE CAN USE IT WHEN PICKED UP FIRST TIME
   return oItem;
}

int StonePowerFailed(object oPC, string sMsg)
{
   FloatingTextStringOnCreature("pffftt!", oPC, TRUE);
   ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_IMP_DOOM), oPC);
   SendMessageToPC(oPC, sMsg);
   return FALSE; // CHANGE THIS TO TRUE TO DESTROY ITEM EVEN IF POWER FAILS
}

void StoneDelayTransferPower(object oPC, object oTarget, object oNew, object oStone, itemproperty ipAdd, int nVisual, string sMsg)
{
   int iNewLevel = CSLGetItemLevel(GetGoldPieceValue(oNew));
   DestroyObject(oNew);
   if (iNewLevel > GetHitDice(oPC))
   {
      StonePowerFailed(oPC, "The Item would be too powerful for you with this enchantment. (level " + IntToString(iNewLevel) + ")");
      return;
   }
   if (iNewLevel > SMS_ITEM_LEVEL_MAX)
   {
      StonePowerFailed(oPC, "The Item would be too powerful for this world with this enchantment. (level " + IntToString(iNewLevel) + ")");
      return;
   }
   AssignCommand(oPC, ActionUnequipItem(oTarget));
   CSLSafeAddItemProperty(oTarget, ipAdd, 0.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   FloatingTextStringOnCreature(sMsg, oPC, TRUE);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisual), oPC);
   SendMessageToPC(oPC,"Item is now level "+IntToString(iNewLevel));
   StoneUsed(oStone, oPC, oTarget);
   SDB_UpdatePlayerStatus(oPC); // SAVE THE CHARACTER TO HARDDISK TO PREVENT LOG DUPPING
}

int StoneTransferPower(object oPC, object oTarget, itemproperty ipAdd, int nVisual, string sMsg)
{
   object oNew = CopyItem(oTarget, oWorkContainer);
   CSLSafeAddItemProperty(oNew, ipAdd, 0.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   object oStone = GetItemActivated();
   DelayCommand(0.1f,StoneDelayTransferPower(oPC, oTarget, oNew, oStone, ipAdd, nVisual, sMsg));
   return TRUE;
}

int IsValidSkillItem(int nBase)
{
   return nBase==BASE_ITEM_AMULET || nBase==BASE_ITEM_ARMOR || nBase==BASE_ITEM_BOOTS;
}

int StoneNextSkill(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   int nBase = ItemProps.ItemBase;
   if (!IsValidSkillItem(nBase))
   {
      return StonePowerFailed(oPC, "This magic may only be used on amulets, armor and boots.");
   }
   int nSkill = ItemProps.SkillCurrent;
   if (nSkill==0) return StonePowerFailed(oPC, "This magic may only be used on items with existing Skill Bonuses.");
   string sSkill = CSLSkillTypeToString(ItemProps.SkullType);
   if (nSkill>=4) return StonePowerFailed(oPC, "This item has +" + IntToString(nSkill) + " " + sSkill + " cannot be enchanted any further.");
   nSkill++;
   return StoneTransferPower(oPC, oTarget, ItemPropertySkillBonus(ItemProps.SkullType, nSkill), nVisual, sSkill + " enchanted to +" + IntToString(nSkill));
}

int StoneAddAmmo(object oPC, object oTarget)
{
   int nAmmoType = StringToInt(Get2DAString("baseitems", "AmmunitionType", GetBaseItemType(oTarget)));
   if (nAmmoType!=1 && nAmmoType!=2 && nAmmoType!=3) return StonePowerFailed(oPC, "This magic may only be used on ranged weapons.");
   if (CSLGetItemPropertyExists(oTarget, ITEM_PROPERTY_UNLIMITED_AMMUNITION)) {
      return StonePowerFailed(oPC, "This item has unlimited ammo and cannot be enchanted any further.");
   }
   string sName = GetName(GetItemActivated());
   int nVisual = VFX_IMP_LIGHTNING_S;
   int nElement = IP_CONST_UNLIMITEDAMMO_BASIC;
   StoneTransferPower(oPC, oTarget, ItemPropertyUnlimitedAmmo(nElement), nVisual, "Your weapon now has unlimited 1d4 Elemental ammo");
   DelayCommand(1.0, SCUnlimAmmo_SetULAFlag(oTarget));
   return TRUE;
}

int StoneAddDR10(object oPC, object oTarget)
{
   int iIPConstDamageType = -1;
   int nBonusPower = 0;
   itemproperty ipLoop=GetFirstItemProperty(oTarget);
   while (GetIsItemPropertyValid(ipLoop)) {
      if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_DAMAGE_RESISTANCE) {
         iIPConstDamageType = GetItemPropertySubType(ipLoop);
         nBonusPower = GetItemPropertyCostTableValue(ipLoop);
      }
      ipLoop=GetNextItemProperty(oTarget);
   }
   if (iIPConstDamageType==-1) return StonePowerFailed(oPC, "This magic may only be used on armor that has 5/- bludgeoning, piercing, or slashing damage resistance.");
   string sDamageType = CSLIPDamagetypeToString(iIPConstDamageType);
   if (nBonusPower!=IP_CONST_DAMAGERESIST_5) return StonePowerFailed(oPC, "This armor already has enough " + sDamageType + " damage resistance.");
   return StoneTransferPower(oPC, oTarget, ItemPropertyDamageResistance(iIPConstDamageType, IP_CONST_DAMAGERESIST_10), VFX_INVOCATION_DRAINING_HIT, sDamageType+" damage resistance increased to 10/-");
}

int StoneNextRegeneration(object oPC, object oTarget, int nVisual)
{
   if (GetBaseItemType(oTarget)!=SMS_REGEN_MAIN_ITEM) return StonePowerFailed(oPC, "This magic may only be used on " + SMS_REGEN_MAIN_ITEM_STRING);
   int nBonusPower = CSLGetItemPropertyBonus(oTarget, ITEM_PROPERTY_REGENERATION);
   if (nBonusPower >= SMS_REGEN_MAIN_ITEM_MAX) return StonePowerFailed(oPC, "This item has +" + IntToString(nBonusPower) + " regeneration and cannot be enchanted any further.");
   nBonusPower++;
   StoneTransferPower(oPC, oTarget, ItemPropertyRegeneration(nBonusPower), nVisual, "Regeneration enchanted to +"+IntToString(nBonusPower));
   return TRUE;
}

int GetNextSR(int nSR)
{
   if (nSR==SMS_SPELL_RESISTANCE_MAX) return SMS_SPELL_RESISTANCE_MAX; // AT MAX!
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_10) return IP_CONST_SPELLRESISTANCEBONUS_12;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_12) return IP_CONST_SPELLRESISTANCEBONUS_14;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_14) return IP_CONST_SPELLRESISTANCEBONUS_16;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_16) return IP_CONST_SPELLRESISTANCEBONUS_18;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_18) return IP_CONST_SPELLRESISTANCEBONUS_20;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_20) return IP_CONST_SPELLRESISTANCEBONUS_22;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_22) return IP_CONST_SPELLRESISTANCEBONUS_24;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_24) return IP_CONST_SPELLRESISTANCEBONUS_26;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_26) return IP_CONST_SPELLRESISTANCEBONUS_28;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_28) return IP_CONST_SPELLRESISTANCEBONUS_30;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_30) return IP_CONST_SPELLRESISTANCEBONUS_32;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_32) return IP_CONST_SPELLRESISTANCEBONUS_32; // AT MAX!
   return IP_CONST_SPELLRESISTANCEBONUS_10;
}

int StoneNextSpellResistance(object oPC, object oTarget, int nVisual)
{
   if (GetBaseItemType(oTarget)!=SMS_SPELL_RESISTANCE_MAIN_ITEM) return StonePowerFailed(oPC, "This magic can only be used on " + SMS_SPELL_RESISTANCE_MAIN_ITEM_STRING);
   itemproperty ipLoop=GetFirstItemProperty(oTarget);
   int nBonusPower = -1;
   while (GetIsItemPropertyValid(ipLoop) && nBonusPower<0) {
      if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_SPELL_RESISTANCE) nBonusPower = GetItemPropertyCostTableValue(ipLoop);
      ipLoop=GetNextItemProperty(oTarget);
   }
   if (nBonusPower==SMS_SPELL_RESISTANCE_MAX) return StonePowerFailed(oPC, "This item has " + CSLSpellResistanceToString(nBonusPower) + " spell resistance and cannot be enchanted any further.");
   nBonusPower = GetNextSR(nBonusPower);
   return StoneTransferPower(oPC, oTarget, ItemPropertyBonusSpellResistance(nBonusPower), nVisual, "Spell Resistance enchanted to "+CSLSpellResistanceToString(nBonusPower));
}

int StoneNextVampRegen(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   if (!ItemProps.WeaponMelee) return StonePowerFailed(oPC, "This magic may only be used on melee weapons.");
   int nBonusPower = ItemProps.WeaponVampRegenCurrent;
   if (nBonusPower>=ItemProps.WeaponVampRegenMax) return StonePowerFailed(oPC, "This weapon has +" + IntToString(nBonusPower) + " Vampiric Regeneration and cannot be enchanted any further.");
   nBonusPower++;
   return StoneTransferPower(oPC, oTarget, ItemPropertyVampiricRegeneration(nBonusPower), nVisual, "Vampiric Regeneration enchanted to +"+IntToString(nBonusPower));
}

int StoneAddHaste(object oPC, object oTarget, int nVisual)
{
   if (!CSLIsValidProp(SHOW_HASTE)) return StonePowerFailed(oPC, "This magic can only be used on boots.");
   if (CSLIsUsedProp(SHOW_HASTE)) return StonePowerFailed(oPC, "This item cannot get any quicker with this magic.");
   return StoneTransferPower(oPC, oTarget, ItemPropertyHaste(), nVisual, "ndale!");
}

int StoneAddKeen(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   if (!CSLIsValidProp(SHOW_KEEN)) return StonePowerFailed(oPC, "This magic may only be used on melee weapons.");
   if (CSLIsUsedProp(SHOW_KEEN)) return StonePowerFailed(oPC, "This weapon cannot get any sharper.");
   return StoneTransferPower(oPC, oTarget, ItemPropertyKeen(), nVisual, "Weapon sharped to a keen edge.");
}

int StoneNextAC(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   int nBaseType = GetBaseItemType(oTarget);
   if (nBaseType!=BASE_ITEM_AMULET && nBaseType!=BASE_ITEM_ARMOR) return StonePowerFailed(oPC, "This magic may only be used on amulets and armor.");
   int nAC = ItemProps.ACCurrent;
   if (nAC>=SMS_AC_MAX_ARMORAMULET) return StonePowerFailed(oPC, "This item has +" + IntToString(nAC) + " AC cannot be enchanted any further.");
   nAC++;
   return StoneTransferPower(oPC, oTarget, ItemPropertyACBonus(nAC), nVisual, "AC enchanted to +"+IntToString(nAC));
}

int StoneNextAB(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   if (!CSLIsValidProp(SHOW_AB)) return StonePowerFailed(oPC, "This magic may only be used on weapons and monk gloves.");
   itemproperty ipNew;
   int nBonusType = ItemProps.WeaponABEB;
   int nBonusPower = ItemProps.WeaponABCurrent;
   if (nBonusPower>=5) return StonePowerFailed(oPC, "This weapon is +" + IntToString(nBonusPower) + " and cannot be enchanted any further.");
   nBonusPower++;
   if (nBonusType==ITEM_PROPERTY_ENHANCEMENT_BONUS) ipNew = ItemPropertyEnhancementBonus(nBonusPower);
   else ipNew = ItemPropertyAttackBonus(nBonusPower);
   return StoneTransferPower(oPC, oTarget, ipNew, nVisual, "Weapon attack enchanted to +"+IntToString(nBonusPower));
}

int StoneNextMighty(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   if (!CSLIsValidProp(SHOW_MIGHTY)) return StonePowerFailed(oPC, "This magic may only be used on ranged weapons.");
   int nBonusPower = ItemProps.WeaponMightyCurrent;
   if (nBonusPower >= ItemProps.WeaponMightyMax) return StonePowerFailed(oPC, "This weapon has Mighty +" + IntToString(nBonusPower) + " and cannot be enchanted any further.");
   nBonusPower++;
   return StoneTransferPower(oPC, oTarget, ItemPropertyMaxRangeStrengthMod(nBonusPower), nVisual, "Mighty enchanted to +"+IntToString(nBonusPower));
}

int StoneNextAbility(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   int nBaseType = GetBaseItemType(oTarget);
   if (!CSLIsValidProp(SHOW_ABILITY)) return StonePowerFailed(oPC, "This magic may only be used on amulets, armor and boots.");
   int nAbility = ItemProps.AbilityCurrent;
   if (nAbility==0) return StonePowerFailed(oPC, "This magic may only be used on items with existing Ability Bonuses.");
   string sAbility = CSLAbilityIPToString(ItemProps.AbilityType, TRUE);
   if (nAbility>=6) return StonePowerFailed(oPC, "This item has +" + IntToString(nAbility) + " " + sAbility + " cannot be enchanted any further.");
   nAbility++;
   return StoneTransferPower(oPC, oTarget, ItemPropertyAbilityBonus(ItemProps.AbilityType, nAbility), nVisual, sAbility + " enchanted to +" + IntToString(nAbility));
}

int StoneNextDamageBonus(int nDamageBonus)
{
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6) return -1; // AT MAX!
   // REPLACE INVALID TYPES WITH SIMILIAR VALID TYPE
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_3   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_4   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8 ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_5   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d10;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_6   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_7   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_8   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d8;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_9   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d8;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_10  ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d10;
   // ROTATE UP TO THE NEXT AMOUNT
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d4)  return IP_CONST_DAMAGEBONUS_1d6;   // 6
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d6)  return IP_CONST_DAMAGEBONUS_2d4;   // 8
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d4)  return IP_CONST_DAMAGEBONUS_1d10;  // 10
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d10) return IP_CONST_DAMAGEBONUS_2d6;   // 12
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6)  return IP_CONST_DAMAGEBONUS_2d8;   // 16
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d8)  return IP_CONST_DAMAGEBONUS_3d6;   // 18
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d6)  return IP_CONST_DAMAGEBONUS_2d10;  // 20
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d10) return IP_CONST_DAMAGEBONUS_2d12;  // 24
   return IP_CONST_DAMAGEBONUS_1d4;
}

int StoneNextMassCrit(object oPC, object oTarget, int nVisual)
{
   CSLLoadItemProps(oTarget);
   if (!CSLIsValidProp(SHOW_MASSCRITS)) return StonePowerFailed(oPC, "This magic may only be used on weapons.");
   int nBonusPower = CSLDamageBonusValue(ItemProps.WeaponMassCritCurrent);
   if (nBonusPower>=ItemProps.WeaponMassCritMax) return StonePowerFailed(oPC, "This weapon has " + CSLDamageBonusToString(ItemProps.WeaponMassCritCurrent) + " massive critical damage and cannot be enchanted any further.");
   nBonusPower = StoneNextDamageBonus(ItemProps.WeaponMassCritCurrent);
   return StoneTransferPower(oPC, oTarget, ItemPropertyMassiveCritical(nBonusPower), nVisual, "Massive Critical damage enchanted to "+CSLDamageBonusToString(nBonusPower));
}

int ULA_IncreaseDamageBonus(object oPC, object oItem, int iIPConstDamageType)
{
   if (!GetLocalInt(oItem, "ULA_DAMAMT_" + IntToString(iIPConstDamageType))) SetLocalInt(oItem, "ULA_DAMAMT_" + IntToString(iIPConstDamageType), 1);
   int nBonusCurrent = SCUnlimAmmo_GetDamageAmount(oItem, iIPConstDamageType);
   int nBonusNext = SCUnlimAmmo_NextDamageBonus(nBonusCurrent);
   string sType = CSLIPDamagetypeToString(iIPConstDamageType);
   string sBonus;
   if (nBonusNext==-1)
   {
      FloatingTextStringOnCreature("pffftt!", oPC, TRUE);
      ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_IMP_DOOM), oPC);
      SendMessageToPC(oPC, "This weapon already has unlimited " + CSLDamageBonusToString(nBonusCurrent) + " " + sType + " damage and cannot be increased any further.");
      return FALSE; // CHANGE THIS TO TRUE TO DESTROY ITEM EVEN IF POWER FAILS
   }
   SCUnlimAmmo_AddDamageBit(oItem, SCUnlimAmmo_DamageType2Bit(iIPConstDamageType));
   SCUnlimAmmo_SetDamageAmount(oItem, iIPConstDamageType, nBonusNext);
   SendMessageToPC(oPC, "This weapon now has unlimited " + CSLDamageBonusToString(nBonusNext) + " " + sType + " ammo.");
   SendMessageToPC(oPC, SCUnlimAmmo_ShowTypes(oItem));
   
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(CSLGetHitEffectByDamageType( CSLGetDamageTypeByIPConstDamageType( iIPConstDamageType ) ) ), oPC);
   StoneUsed(GetItemActivated(), oPC, oItem);
   SDB_UpdatePlayerStatus(oPC); // SAVE THE CHARACTER TO HARDDISK TO PREVENT LOG DUPPING
   
   return TRUE;
}

int StoneNextDamage(object oPC, object oTarget, int iIPConstDamageType)
{
   SCUnlimAmmo_SetULAFlag(oTarget);
   if (SCUnlimAmmo_IsValidWeapon(oTarget))
   {
      return ULA_IncreaseDamageBonus(oPC, oTarget, iIPConstDamageType);
   }
   CSLLoadItemProps(oTarget);
   if (!ItemProps.WeaponDamageMax) return StonePowerFailed(oPC, "This magic may only be used on unlimited ammo, melee weapons and monk gloves.");
   string sCurOfMax = IntToString(ItemProps.WeaponDamageCurrent) + " of " + IntToString(ItemProps.WeaponDamageMax);
   if (ItemProps.WeaponDamageCurrent>=ItemProps.WeaponDamageMax) return StonePowerFailed(oPC, "This weapon does " + sCurOfMax + " total bonus damage and cannot be enchanted any further.");
   int nBonusCurrent = CSLGetItemPropertyBonus(oTarget, ITEM_PROPERTY_DAMAGE_BONUS, iIPConstDamageType);
   if (ItemProps.WeaponModsCount>=3 && !nBonusCurrent) return StonePowerFailed(oPC, "This weapon has 3 damage bonuses and cannot be enchanted any further.");
   int nBonusNext = StoneNextDamageBonus(nBonusCurrent);
   int nBonusNew = ItemProps.WeaponDamageCurrent + CSLDamageBonusValue(nBonusNext) - CSLDamageBonusValue(nBonusCurrent);
   string sType = CSLIPDamagetypeToString(iIPConstDamageType);
   if (nBonusNext==-1) return StonePowerFailed(oPC, "This weapon has " + CSLDamageBonusToString(nBonusCurrent) + " " + sType + " damage and this type cannot be enchanted any further.");
   if (nBonusNew>ItemProps.WeaponDamageMax) {
      if (!nBonusCurrent) return StonePowerFailed(oPC, "This weapon does " + sCurOfMax + " total bonus damage and cannot add another 1d4 type without exceeding the max.");
      return StonePowerFailed(oPC, "This weapon does " + sCurOfMax + " total bonus damage and cannot be enchanted any further.");
   }
   SendMessageToPC(oPC, "This weapon currently does " + IntToString(ItemProps.WeaponDamageCurrent) + " of " + IntToString(ItemProps.WeaponDamageMax) + " total bonus damage and will increased to " + IntToString(nBonusNew) + ".");
   return StoneTransferPower(oPC, oTarget, ItemPropertyDamageBonus(iIPConstDamageType, nBonusNext), CSLGetHitEffectByDamageType( CSLGetDamageTypeByIPConstDamageType( iIPConstDamageType ) ), sType+" damage increased to "+CSLDamageBonusToString(nBonusNext));
}

void StoneOnUsed(object oPC, object oTarget, object oItem)
{
   string sWhich = GetTag(oItem);
   if (!StoneIsValid(oItem)) // INVALID STONE, PURGE IT
   {
      SDB_LogMsg("STONEERROR", "Invalid Stone used " + GetName(oItem), oPC);
      StonePowerFailed(oPC, "Sorry, this stone appears to be invalid.");
      DestroyObject(oItem); // DELETE THE BOGUS STONE

   }
   else if (!CSLItemGetIsEquipable(oTarget))
   {
      StonePowerFailed(oPC, "Only equipable items may be enchanted.");

   }
   else if (sWhich == "SMS_SKILL")
   {
      StoneNextSkill(oPC, oTarget, VFX_IMP_RAISE_DEAD);
   }
   else if (sWhich == "SMS_MASSCRIT")
   {
      StoneNextMassCrit(oPC, oTarget, VFX_IMP_RAISE_DEAD);
   }
   else if (sWhich == "SMS_REGEN")
   {
      StoneNextRegeneration(oPC, oTarget, VFX_IMP_RAISE_DEAD);
   }
   else if (sWhich == "SMS_AMMO")
   {
      StoneAddAmmo(oPC, oTarget);
   }
   else if (sWhich == "SMS_DR10")
   {
      StoneAddDR10(oPC, oTarget);
   }
   else if (sWhich == "SMS_SR")
   {
      StoneNextSpellResistance(oPC, oTarget, VFX_IMP_MAGBLUE);
   }
   else if (sWhich == "SMS_VAMPREGEN")
   {
      StoneNextVampRegen(oPC, oTarget, VFX_IMP_MAGBLUE);
   }
   else if (sWhich == "SMS_ATTACK")
   {
      StoneNextAB(oPC, oTarget, VFX_FNF_HOWL_MIND);
   }
   else if (sWhich == "SMS_KEEN")
   {
      StoneAddKeen(oPC, oTarget, VFX_FNF_MYSTICAL_EXPLOSION);
   }
   else if (sWhich == "SMS_AC")
   {
      StoneNextAC(oPC, oTarget, VFX_IMP_GLOBE_USE);
   }
   else if (sWhich == "SMS_HASTE")
   {
      StoneAddHaste(oPC, oTarget, VFX_IMP_HASTE);
   }
   else if (sWhich == "SMS_MIGHTY")
   {
      StoneNextMighty(oPC, oTarget, VFX_FNF_GAS_EXPLOSION_MIND);
   }
   else if (sWhich == "SMS_ABILITY")
   {
      StoneNextAbility(oPC, oTarget, VFX_FNF_NATURES_BALANCE);
   }
   else if (sWhich == "SMS_DAMAGE_ACID")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_ACID);
   }
   else if (sWhich == "SMS_DAMAGE_BLUDGEONING")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_BLUDGEONING);
   }
   else if (sWhich == "SMS_DAMAGE_COLD")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_COLD);
   }
   else if (sWhich == "SMS_DAMAGE_DIVINE")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_DIVINE);
   }
   else if (sWhich == "SMS_DAMAGE_ELECTRICAL" || sWhich == "SMS_DAMAGE_ELECTRIC")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_ELECTRICAL);
   }
   else if (sWhich == "SMS_DAMAGE_FIRE")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_FIRE);
   }
   else if (sWhich == "SMS_DAMAGE_MAGICAL")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_MAGICAL);
   }
   else if (sWhich == "SMS_DAMAGE_NEGATIVE")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_NEGATIVE);
   }
   else if (sWhich == "SMS_DAMAGE_PIERCING")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_PIERCING);
   }
   else if (sWhich == "SMS_DAMAGE_POSITIVE")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_POSITIVE);
   }
   else if (sWhich == "SMS_DAMAGE_SLASHING")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_SLASHING);
   }
   else if (sWhich == "SMS_DAMAGE_SONIC")
   {
      StoneNextDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_SONIC);
   }
   else
   {
      StonePowerFailed(oPC, "Unknown Magic Stone: " + sWhich);
   }
}