/** @file
* @brief Include File for Dex Unlimited Ammo System
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_CSLCore_Math"
#include "_CSLCore_Items"
#include "_CSLCore_Magic"
#include "_CSLCore_Visuals"

const int SCUNLIMAMMO_ALLOW_ACID         = BIT1;    //            1;
const int SCUNLIMAMMO_ALLOW_COLD         = BIT2;    //            2;
const int SCUNLIMAMMO_ALLOW_DIVINE       = BIT3;    //            4;
const int SCUNLIMAMMO_ALLOW_ELECTRICAL   = BIT4;    //            8;
const int SCUNLIMAMMO_ALLOW_FIRE         = BIT5;    //           16;
const int SCUNLIMAMMO_ALLOW_MAGICAL      = BIT6;    //           32;
const int SCUNLIMAMMO_ALLOW_NEGATIVE     = BIT7;    //           64;
const int SCUNLIMAMMO_ALLOW_POSITIVE     = BIT8;    //          128;
const int SCUNLIMAMMO_ALLOW_SONIC        = BIT9;    //          256;
const int SCUNLIMAMMO_ALLOW_BLUDGEONING  = BIT10;   //          512;
const int SCUNLIMAMMO_ALLOW_PIERCING     = BIT11;   //         1024;
const int SCUNLIMAMMO_ALLOW_SLASHING     = BIT12;   //         2048;

int SCUnlimAmmo_Bit2DamageType(int nDamageBit)
{
   if (nDamageBit==SCUNLIMAMMO_ALLOW_ACID       ) return IP_CONST_DAMAGETYPE_ACID       ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_COLD       ) return IP_CONST_DAMAGETYPE_COLD       ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_DIVINE     ) return IP_CONST_DAMAGETYPE_DIVINE     ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_ELECTRICAL ) return IP_CONST_DAMAGETYPE_ELECTRICAL ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_FIRE       ) return IP_CONST_DAMAGETYPE_FIRE       ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_MAGICAL    ) return IP_CONST_DAMAGETYPE_MAGICAL    ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_NEGATIVE   ) return IP_CONST_DAMAGETYPE_NEGATIVE   ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_POSITIVE   ) return IP_CONST_DAMAGETYPE_POSITIVE   ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_SONIC      ) return IP_CONST_DAMAGETYPE_SONIC      ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_BLUDGEONING) return IP_CONST_DAMAGETYPE_BLUDGEONING;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_PIERCING   ) return IP_CONST_DAMAGETYPE_PIERCING   ;
   if (nDamageBit==SCUNLIMAMMO_ALLOW_SLASHING   ) return IP_CONST_DAMAGETYPE_SLASHING   ;
   return IP_CONST_DAMAGETYPE_FIRE;
}

int SCUnlimAmmo_DamageType2Bit(int nType)
{
   if (nType==IP_CONST_DAMAGETYPE_ACID       ) return SCUNLIMAMMO_ALLOW_ACID       ;
   if (nType==IP_CONST_DAMAGETYPE_COLD       ) return SCUNLIMAMMO_ALLOW_COLD       ;
   if (nType==IP_CONST_DAMAGETYPE_DIVINE     ) return SCUNLIMAMMO_ALLOW_DIVINE     ;
   if (nType==IP_CONST_DAMAGETYPE_ELECTRICAL ) return SCUNLIMAMMO_ALLOW_ELECTRICAL ;
   if (nType==IP_CONST_DAMAGETYPE_FIRE       ) return SCUNLIMAMMO_ALLOW_FIRE       ;
   if (nType==IP_CONST_DAMAGETYPE_MAGICAL    ) return SCUNLIMAMMO_ALLOW_MAGICAL    ;
   if (nType==IP_CONST_DAMAGETYPE_NEGATIVE   ) return SCUNLIMAMMO_ALLOW_NEGATIVE   ;
   if (nType==IP_CONST_DAMAGETYPE_POSITIVE   ) return SCUNLIMAMMO_ALLOW_POSITIVE   ;
   if (nType==IP_CONST_DAMAGETYPE_SONIC      ) return SCUNLIMAMMO_ALLOW_SONIC      ;
   if (nType==IP_CONST_DAMAGETYPE_BLUDGEONING) return SCUNLIMAMMO_ALLOW_BLUDGEONING;
   if (nType==IP_CONST_DAMAGETYPE_PIERCING   ) return SCUNLIMAMMO_ALLOW_PIERCING   ;
   if (nType==IP_CONST_DAMAGETYPE_SLASHING   ) return SCUNLIMAMMO_ALLOW_SLASHING   ;
   return SCUNLIMAMMO_ALLOW_FIRE;
}   

void SCUnlimAmmo_SetULAFlag(object oItem)
{
   if (GetLocalInt(oItem, "ULA")) return;
   if (!CSLGetItemPropertyExists(oItem, ITEM_PROPERTY_UNLIMITED_AMMUNITION)) return;
   if (!CSLGetItemPropertyExists(oItem, ITEM_PROPERTY_CAST_SPELL, IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY))
   {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE), oItem);      
   }   
   SetLocalInt(oItem, "ULA", TRUE);
   CSLDefineLocalInt(oItem, "ULA_DAMTYPES", SCUNLIMAMMO_ALLOW_FIRE | SCUNLIMAMMO_ALLOW_COLD | SCUNLIMAMMO_ALLOW_ELECTRICAL | SCUNLIMAMMO_ALLOW_ACID);
}

int SCUnlimAmmo_IsValidWeapon(object oItem)
{
   if (GetLocalInt(oItem, "ULA")) return TRUE;
   if (!CSLStringStartsWith(GetTag(oItem), "ULA_")) return FALSE;
   int nBaseItem = GetBaseItemType(oItem);
   return (nBaseItem==BASE_ITEM_LONGBOW || nBaseItem==BASE_ITEM_SHORTBOW || nBaseItem==BASE_ITEM_HEAVYCROSSBOW || nBaseItem==BASE_ITEM_LIGHTCROSSBOW || nBaseItem==BASE_ITEM_SLING);
}

int SCUnlimAmmo_GetDamageBits(object oItem)
{
   return CSLDefineLocalInt(oItem, "ULA_DAMTYPES", SCUNLIMAMMO_ALLOW_FIRE | SCUNLIMAMMO_ALLOW_COLD | SCUNLIMAMMO_ALLOW_PIERCING);
}

void SCUnlimAmmo_AddDamageBit(object oItem, int nDamageBit)
{
   SetLocalInt(oItem, "ULA_DAMTYPES", SCUnlimAmmo_GetDamageBits(oItem) | nDamageBit);
}

int SCUnlimAmmo_GetDamageBitCurrent(object oItem)
{
   return CSLDefineLocalInt(oItem, "ULA_DAMCUR", SCUNLIMAMMO_ALLOW_FIRE);
}

void SCUnlimAmmo_SetDamageBitCurrent(object oItem, int nDamageBit)
{
   SetLocalInt(oItem, "ULA_DAMCUR", nDamageBit);
}

int SCUnlimAmmo_GetDamageAmount(object oItem, int iIPConstDamageType)
{   
   return CSLDefineLocalInt(oItem, "ULA_DAMAMT_" + IntToString(iIPConstDamageType), IP_CONST_DAMAGEBONUS_1d4);
}

void SCUnlimAmmo_SetDamageAmount(object oItem, int iIPConstDamageType, int nDamageBonus)
{
   SetLocalInt(oItem, "ULA_DAMAMT_" + IntToString(iIPConstDamageType), nDamageBonus);
}

string SCUnlimAmmo_ShowTypes(object oItem)
{
   int nAllowFlags = SCUnlimAmmo_GetDamageBits(oItem);
   string sMsg = "This weapon has the following unlimited ammo:";
   int nDamageBit = SCUNLIMAMMO_ALLOW_ACID;
   int iIPConstDamageType;
   int iBonus;
   while (nDamageBit <= SCUNLIMAMMO_ALLOW_SLASHING)
   {
      if ( nDamageBit & nAllowFlags) // THIS TYPE IS ALLOWED
	  {
          iIPConstDamageType = SCUnlimAmmo_Bit2DamageType(nDamageBit);
          iBonus = SCUnlimAmmo_GetDamageAmount(oItem, iIPConstDamageType);
          sMsg += "\n" 
		  + CSLDamageBonusToString(iBonus) 
		  + " " + CSLIPDamagetypeToString(iIPConstDamageType);
      }
      nDamageBit *= 2; 
   }
   return sMsg;
}

int SCUnlimAmmo_NextDamageBonus(int nDamageBonus) {
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d6) return -1; // AT MAX!
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

int SCUnlimAmmo_GetDamageType(object oItem, int nRotateNext) { 
   int nDamageBitCurrent = SCUnlimAmmo_GetDamageBitCurrent(oItem);
   int nFoundBit = 0;
   if (nRotateNext) {
      int nAllowFlags = SCUnlimAmmo_GetDamageBits(oItem);
      int nFirst = 0;      
      int nDamageBit = SCUNLIMAMMO_ALLOW_ACID;
      while (nDamageBit <= SCUNLIMAMMO_ALLOW_SLASHING) {
         if (nDamageBit & nAllowFlags) { // THIS TYPE IS ALLOWED
            if (nDamageBit <= nDamageBitCurrent) {
                if (!nFirst) nFirst = nDamageBit; // THIS IS THE FIRST ALLOWABLE DAMAGE, SAVE IT IN CASE WE NEED TO ROTATE BACK TO START FROM THE BOTTOM
            } else {
               nFoundBit = nDamageBit;
               break;
            }   
         }
         nDamageBit *= 2; 
      }
      if (!nFoundBit) nFoundBit = nFirst; // NO MATCH FOUND AFTER CURRENT BIT, ROTATE BACK TO FIRST IN THE LIST
      SCUnlimAmmo_SetDamageBitCurrent(oItem, nFoundBit); // SAVE THE NEW TYPE
   } else {
      nFoundBit = nDamageBitCurrent;
   }
   return SCUnlimAmmo_Bit2DamageType(nFoundBit);
}

void SCUnlimAmmo_SetDamage(object oPC, object oItem, int nRotateNext = FALSE) {
   int iIPConstDamageType = SCUnlimAmmo_GetDamageType(oItem, nRotateNext); // GETS THE IP_ DAMAGETYPE
   int nDamageBonus = SCUnlimAmmo_GetDamageAmount(oItem, iIPConstDamageType);
   SendMessageToPC(oPC, "Ranged damage set to " + CSLDamageBonusToString(nDamageBonus) + " " + CSLIPDamagetypeToString(iIPConstDamageType));
   oItem = CSLGetAmmo(oPC); //GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
   itemproperty ipLoop=GetFirstItemProperty(oItem);
   while (GetIsItemPropertyValid(ipLoop)) { 
      if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_DAMAGE_BONUS) {
         RemoveItemProperty(oItem, ipLoop);
      }
      ipLoop=GetNextItemProperty(oItem);
   }
   int nVisual = CSLGetHitEffectByDamageType( CSLGetDamageTypeByIPConstDamageType( iIPConstDamageType ) );
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisual), oPC);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(iIPConstDamageType, nDamageBonus), oItem);
}

void SCUnlimAmmo_Equip(object oPC, object oItem) {
   if (SCUnlimAmmo_IsValidWeapon(oItem)) {
      SCUnlimAmmo_SetDamage(oPC, oItem);
      SendMessageToPC(oPC, SCUnlimAmmo_ShowTypes(oItem));      
   }   
}

void SCUnlimAmmo_Activate(object oPC, object oItem) {
   if (SCUnlimAmmo_IsValidWeapon(oItem)) SCUnlimAmmo_SetDamage(oPC, oItem, TRUE);
}

void SCUnlimAmmo_AllowAcid(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_ACID);
}
void SCUnlimAmmo_AllowCold(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_COLD);
}
void SCUnlimAmmo_AllowDivine(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_DIVINE);
}
void SCUnlimAmmo_AllowElectrical(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_ELECTRICAL);
}
void SCUnlimAmmo_AllowFire(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_FIRE);
}
void SCUnlimAmmo_AllowMagical(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_MAGICAL);
}
void SCUnlimAmmo_AllowNegative(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_NEGATIVE);
}
void SCUnlimAmmo_AllowPositive(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_POSITIVE);
}
void SCUnlimAmmo_AllowSonic(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_SONIC);
}
void SCUnlimAmmo_AllowBludgeoning(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_BLUDGEONING);
}
void SCUnlimAmmo_AllowPiercing(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_PIERCING);
}
void SCUnlimAmmo_AllowSlashing(object oItem) {
   SCUnlimAmmo_AddDamageBit(oItem, SCUNLIMAMMO_ALLOW_SLASHING);
}