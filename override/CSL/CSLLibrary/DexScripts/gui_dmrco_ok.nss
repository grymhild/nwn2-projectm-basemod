#include "_CSLCore_Player"
#include "_SCInclude_Encounter"

#include "_CSLCore_Combat"

#include "_SCInclude_RandomMonster" 

#include "_SCInclude_AI_Advanced"

//#include "nw_i0_generic" // for determinecombatround function

void SetSpawnIn(object oMinion, int nCondition, int bValid = TRUE)
{
    int nCurrentCond = GetLocalInt(oMinion, "NW_GENERIC_MASTER");
    if (bValid) {
        SetLocalInt(oMinion, "NW_GENERIC_MASTER",  nCurrentCond | nCondition);
    } else {
        SetLocalInt(oMinion, "NW_GENERIC_MASTER", nCurrentCond & ~nCondition);
    }
}

void SetCombatIn(object oMinion, int nCond, int bValid=TRUE)
{
    int nCurrentCond = GetLocalInt(oMinion, "X0_COMBAT_CONDITION");
    if (bValid) {
        SetLocalInt(oMinion, "X0_COMBAT_CONDITION", nCurrentCond | nCond);
    } else {
        SetLocalInt(oMinion, "X0_COMBAT_CONDITION", nCurrentCond & ~nCond);
    }
}

string GetPropDesc(itemproperty ipProperty)
{
   int iPropType = GetItemPropertyType(ipProperty);
   int iSubType=GetItemPropertySubType(ipProperty);
   int iBonus = GetItemPropertyCostTableValue(ipProperty);
   int iParam1 = GetItemPropertyParam1Value(ipProperty);
   return CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1); 
}

void man(string sText)
{
   object oMinion = GetLocalObject(GetModule(), "RANDOMTAG");
   string sTag = GetTag(oMinion);
   object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oMinion);
   SendMsgToSeed(GetName(oMinion) + " has carmor = " + GetName(oItem) ); // SAVE THE NEW VERSION
   object oSkin = GetItemPossessedBy(oMinion, "SKIN_" + sTag);
   AssignCommand(oMinion, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
   itemproperty ipProperty = GetFirstItemProperty(oItem);
   string sProps = "";
   while (GetIsItemPropertyValid(ipProperty)) {
      sProps += GetPropDesc(ipProperty) + ", ";
      ipProperty = GetNextItemProperty(oItem);
   }
   SendMsgToSeed(GetName(oItem) + " has " + sProps); // SAVE THE NEW VERSION
}
    
void main(string sText)
{
   SetLocalObject(GetModule(), "IAMSEED", OBJECT_SELF); 
   int nAppear = -1;   
   if (sText!="") {   
      if (FindSubString(sText, ",")) {  
         nAppear = StringToInt(CSLNth_Shift(sText, ",")); // TAKES THE FIRST VALUE OFF LIST AND RETURNS TRUNCATED LIST
         sText = CSLNth_GetLast(); // FIRST ELEMENT IDENTIFIES ITEM AS AN AMMOBOX
         SendMessageToPC(OBJECT_SELF, "sText:  " + sText + " appear = " + IntToString(nAppear));
      }   
      object oLocator = GetNearestObject(OBJECT_TYPE_WAYPOINT, OBJECT_SELF);
      string sOrder = CSLPickOne("rm_str", "rm_dex", "rm_int", "rm_wis", "rm_cha");
      object oMinion = GetRandomMonster(oLocator, "PCDROW", StringToInt(sText), "1=1", sOrder, "", "drownoblewear", "", "indadushieldlt");
      //oMinion = XPCraft_MakeDrow(oMinion);
      FeatAdd(oMinion, 1075, FALSE);
      if (GetGender(oMinion)==GENDER_MALE)
	  {
         SetSoundSet(oMinion, CSLPickOneInt(363, 364, 365, 366, 465, 466, 467, 468, 469));
      }
	  else
	  {
         SetSoundSet(oMinion, CSLPickOneInt(357, 358, 359, 360, 361, 433, 460, 462, 463, 464));      
      }
        SetSpawnIn(oMinion, CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
        SetSpawnIn(oMinion, CSL_FLAG_AMBIENT_ANIMATIONS);        
        SetSpawnIn(oMinion, CSL_FLAG_STEALTH);
        SetCombatIn(oMinion, CSL_COMBAT_FLAG_AMBUSHER);
      
     // SetLastName(oMinion, "-=DarkPaw=-");
     object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
     AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1, DAMAGE_TYPE_MAGICAL), oMinion));
      DelayCommand(5.0, AssignCommand(oMinion, ClearAllActions(TRUE)));
      DelayCommand(5.1, AssignCommand(oMinion, ActionMoveToObject(oPC, TRUE, 10.0)));
      DelayCommand(5.2, CSLDetermineCombatRound( oMinion, oPC ) );
      if (nAppear>0) {
         SetCreatureAppearanceType(oMinion, nAppear);
     }
      SendMessageToPC(OBJECT_SELF, "Clone:  " + GetName(oMinion) + ", Tag " + GetTag(oMinion) + ", res= " + GetResRef(oMinion) + ", CR = " + FloatToString(CSLGetChallengeRating(oMinion)) + ", HD = " + IntToString(GetHitDice(oMinion))  + " appear = " + IntToString(nAppear));
   }
   CloseGUIScreen(OBJECT_SELF, "SCREEN_STRINGINPUT_MESSAGEBOX"); 
} 