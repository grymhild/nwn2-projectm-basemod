/** @file
* @brief Include File for Dex Random Monsters
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

//#include "_SCUtility"
//#include "nw_i0_plot"

void SendMsgToSeed(string sMsg)
{
   object oSeed = GetLocalObject(GetModule(), "IAMSEED");
   if (oSeed!=OBJECT_INVALID) {
      SendMessageToPC(oSeed, sMsg);
   } else {
      SendMessageToAllDMs(sMsg);
   }
}

void voidStoreCampaignObject(string sDB, string sKey, object oMinion) {
   SDB_LogMsg("RESAVEDROW", "sDB=" + sDB + "  sKey=" + sKey + " sTag=" + GetTag(oMinion), oMinion);
   StoreCampaignObject(sDB, sKey, oMinion); // SAVE THE NEW VERSION
}

void ClearInv(object oCopy) {
   TakeGoldFromCreature(GetGold(oCopy), oCopy, TRUE);
   SetLootable(oCopy, FALSE);
   object oItem = GetFirstItemInInventory(oCopy);
   while (GetIsObjectValid(oItem)) {
      SetPlotFlag(oItem, FALSE);
      DestroyObject(oItem); 
      oItem = GetNextItemInInventory(oCopy);
   }
   int i;
   for (i = 0; i < NUM_INVENTORY_SLOTS; i++) {
      oItem = GetItemInSlot(i, oCopy);
      if (GetIsObjectValid(oItem)) {
         SetDroppableFlag(oItem, FALSE);
         SetPickpocketableFlag(oCopy, FALSE);
      }
   }
}

string SkinMergeIP(object oOld, object oNew, itemproperty ipProperty) {
   int iPropType = GetItemPropertyType(ipProperty);
   //if (iPropType==ITEM_PROPERTY_AC_BONUS) return ""; // SKIP AC
   int iSubType=GetItemPropertySubType(ipProperty);
   int iBonus = GetItemPropertyCostTableValue(ipProperty);
   int iParam1 = GetItemPropertyParam1Value(ipProperty);
   CSLSafeAddItemProperty(oNew, ipProperty, 0.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   return CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1);
}

void SkinMergeItem(object oMinion, object oNew, object oOld) {
   SetDroppableFlag(oNew, FALSE);
   SetPickpocketableFlag(oNew, FALSE);
   if (!GetIsObjectValid(oOld)) return;
   itemproperty ipProperty = GetFirstItemProperty(oOld);
   string sProps = "";
   while (GetIsItemPropertyValid(ipProperty)) {
      sProps += SkinMergeIP(oOld, oNew, ipProperty) + ", ";
      ipProperty = GetNextItemProperty(oOld);
   }
   if (sProps!="") {
      sProps = GetStringLeft(sProps, GetStringLength(sProps)-2);
   }
   AssignCommand(oMinion, ActionUnequipItem(oOld));
   DestroyObject(oOld);
}

object GetRandomMonster(object oLocator, string sDB, int iLevel, string sWhere="1=1", string sOrderBy="rm_added", string sFirstName="", string sArmor="", string sHelm="", string sShield="") {
   string sLevel = IntToString(iLevel);
   string sSQL = "select rm_rmid, rm_plid, rm_moid from randommonster where " + sWhere + " and rm_level = " + IntToString(iLevel) + " order by " + sOrderBy + ">(8+rm_level/2) desc, rm_dlspawn limit 1";
   if (iLevel<0) {
      iLevel = 0-iLevel;
      sSQL = "select rm_rmid, rm_plid, rm_moid, rm_level from randommonster where rm_rmid = " + IntToString(iLevel);
      sLevel = "";
   }
   CSLNWNX_SQLExecDirect(sSQL);
   if (!CSLNWNX_SQLFetch()) return OBJECT_INVALID;
   string sRMID = CSLNWNX_SQLGetData(1);
   string sKey = "PLID_" + CSLNWNX_SQLGetData(2);
   string sMOID = CSLNWNX_SQLGetData(3);
   if (sLevel=="") sLevel = CSLNWNX_SQLGetData(4);
   string sTag = sKey + "_" + sLevel;
   if (sDB=="") sDB = "PCLVL" + sLevel;
   else sDB = sDB + sLevel;

   object oMinion = GetObjectByTag(sTag);
   if (oMinion!=OBJECT_INVALID) {
      ClearInv(oMinion);
      return oMinion; // ALREADY EXISTS, NO SPAWN NEEDED
   }
   string sDBName = "";
   string sDMMOID = "";
   sSQL = "select mo_name, mo_moid from monster where mo_resref=" + CSLInQs(sTag);
   CSLNWNX_SQLExecDirect(sSQL);
   if (CSLNWNX_SQLFetch()) {
      sDBName = CSLNWNX_SQLGetData(1);
      sDMMOID = CSLNWNX_SQLGetData(2);
   }
   if (sMOID=="0" && sDMMOID!="") sDMMOID = ", rm_moid=" + sDMMOID;
   else sDMMOID = "";
   
   if (sFirstName=="") {
      if (sDBName!="") sFirstName = sDBName;
      else  sFirstName = RandomName();
   }   
   
   oMinion = RetrieveCampaignObject(sDB, sKey, GetLocation(oLocator));
   if (oMinion==OBJECT_INVALID) {
      SDB_LogMsg("BADDROW", "sDB=" + sDB + "  sKey=" + sKey);
      sSQL = "update randommonster set rm_dlspawn=now()" + sDMMOID + " where rm_rmid = " + sRMID;
      CSLNWNX_SQLExecDirect(sSQL);
      return CreateObject(OBJECT_TYPE_CREATURE, "drowtroll", GetLocation(oLocator), FALSE);
   }
   
   sSQL = "update randommonster set rm_dlspawn=now(), rm_spawned=rm_spawned+1" + sDMMOID + " where rm_rmid = " + sRMID;
   CSLNWNX_SQLExecDirect(sSQL);

//   SetCreatureScriptsToSet(oMinion, SCRIPTSET_NPC_DEFAULT);
   SetFirstName(oMinion, sFirstName);
   SetLastName(oMinion, "");
   
   object oOldArmor  = GetItemInSlot(INVENTORY_SLOT_CHEST, oMinion);
   object oOldShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMinion);
   object oOldHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oMinion);
   object oArmor;
   object oShield;
   object oHelm;
   int nArmor = GetArmorRank(oOldArmor);
   int nShield = GetBaseItemType(oOldShield);

   ClearInv(oMinion);
   
   if (GetTag(oMinion)!=sTag || CSLHasItemByTag(oMinion, "townstone")) {
      CopyObject(oMinion, GetLocation(oLocator), OBJECT_INVALID, sTag);
      DestroyObject(oMinion); 
      oMinion = GetObjectByTag(sTag);
      if (oMinion!=OBJECT_INVALID) {
         ClearInv(oMinion);
         AssignCommand(GetModule(), DelayCommand(1.1, voidStoreCampaignObject(sDB, sKey, oMinion))); // SAVE THE NEW VERSION
      }      
   }

   string sResRef = sArmor;
   if (sResRef=="") { // NONE SENT TO SCRIPT, PICK ONE NOW
      if (nArmor==ARMOR_RANK_LIGHT) {  
         nArmor = d3();
         if      (nArmor==1) sResRef = CSLPickOne("nw_aarcl009", "nw_cloth027", "nw_cloth015", "nw_cloth021", "nw_cloth007", "n2_pca_duelist", "nw_cloth014", "nw_cloth002", "nw_cloth008");
         else if (nArmor==2) sResRef = CSLPickOne("nw_aarcl001", "nw_armor_druid", "nw_armor_rogue", "nw_armor_warlock", "nw_cloth004", "nx1_base_spiritshaman");
         else if (nArmor==3) sResRef = CSLPickOne("nw_aarcl002", "nw_aarcl008", "nw_armor_barb", "nw_cloth001");
      } else if (nArmor==ARMOR_RANK_MEDIUM) {  
         nArmor = d2();
         if      (nArmor==1) sResRef = CSLPickOne("nw_aarcl012", "nw_aarcl003", "nw_armor_paladin", "nw_armor_fighter", "mwa_ltcs_drk_3");
         else if (nArmor==2) sResRef = CSLPickOne("nw_aarcl010", "nw_aarcl004", "mwa_ltcs_mth_4", "mwa_mdsm_mth_4");
      } else if (nArmor==ARMOR_RANK_HEAVY) {  
         nArmor = d3();
         if      (nArmor==1) sResRef = CSLPickOne("nw_aarcl011", "mwa_mdbp_mth_4", "mwa_mdsm_ada_4");
         else if (nArmor==2) sResRef = CSLPickOne("nw_aarcl006", "mwa_hvbm_mth_3", "mwa_mdbp_ada_4");
         else if (nArmor==3) sResRef = CSLPickOne("nw_aarcl007", "mwa_hvhp_mth_4", "mwa_hvbm_ada_3");
      } else { // ASSUME CLOTHES
         sResRef = CSLPickOne("nw_cloth017", "x2_cloth008", "nw_cloth012", "nw_cloth026", "nw_cloth023", "nw_cloth029", "nw_cloth005");
      }
   }
//   AssignCommand(oMinion, ClearAllActions());
   if (sResRef!="") {
      oArmor = CreateItemOnObject(sResRef, oMinion, 1, "ARMOR_" + sTag);
      SkinMergeItem(oMinion, oArmor, oOldArmor);
      AssignCommand(GetModule(), DelayCommand(0.0, AssignCommand(oMinion, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST))));   
   }
   sResRef = "";
   if (CSLGetIsAShield(nShield)) sResRef = sShield;
   if (sResRef=="") {
       if (nShield==BASE_ITEM_TOWERSHIELD && d2()==1) nShield=BASE_ITEM_LARGESHIELD;
       if (nShield==BASE_ITEM_LARGESHIELD && d3()==1) nShield=BASE_ITEM_SMALLSHIELD;
       if      (nShield==BASE_ITEM_SMALLSHIELD) sResRef = CSLPickOne("nw_ashlw001", "mwa_shlt_ada_4", "mwa_shlt_drk_3", "mwa_shlt_dsk_3", "mwa_shlt_mth_4");
       else if (nShield==BASE_ITEM_LARGESHIELD) sResRef = CSLPickOne("nw_ashto001", "mwa_shhv_ada_4", "mwa_shhv_drk_3", "mwa_shhv_dsk_3", "mwa_shhv_mth_4");
       else if (nShield==BASE_ITEM_TOWERSHIELD) sResRef = CSLPickOne("nw_ashto001", "mwa_shtw_ada_4", "mwa_shtw_drk_3", "mwa_shtw_dsk_3", "mwa_shtw_mth_4");
   }
   if (sResRef!="") {
      oShield = CreateItemOnObject(sResRef, oMinion, 1, "SHIELD_" + sTag);
      SkinMergeItem(oMinion, oShield, oOldShield);
      AssignCommand(GetModule(), DelayCommand(0.0, AssignCommand(oMinion, ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND))));
   }
   sResRef = sHelm;
   if (sResRef=="") sResRef = CSLPickOne("custom_helm_cloth" + IntToString(Random(20)), "custom_helm_cloth" + IntToString(Random(20)), "custom_helm_leather" + IntToString(Random(4)), "custom_helm_halfplate" + IntToString(Random(9)), "custom_helm_fullplate" + IntToString(Random(7)));
   oHelm = CreateItemOnObject(sResRef, oMinion, 1, "HELM_" + sTag);
   SkinMergeItem(oMinion, oHelm, oOldHelm);
   AssignCommand(GetModule(), DelayCommand(0.0, AssignCommand(oMinion, ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD))));
   
   oArmor = GetItemPossessedBy(oMinion, "ARMOR_" + sTag);
   oHelm   = GetItemPossessedBy(oMinion, "HELM_" + sTag);
   oShield = GetItemPossessedBy(oMinion, "SHIELD_" + sTag);
   SendMsgToSeed("<color=gold>RCO Has Name = " + GetName(oMinion) + " and Tag = " + GetTag(oMinion) +
      " armor=" + GetName(oArmor) +    
      " helm=" + GetName(oHelm) +    
      " shield=" + GetName(oShield));
 
   ForceRest(oMinion);
   SetLocalInt(oMinion, "DONTDROP", TRUE);
   sMOID = SDB_GetMOID(oMinion);
   return oMinion;
}