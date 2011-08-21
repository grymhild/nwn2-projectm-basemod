#include "_CSLCore_Items"
#include "_CSLCore_Messages"

//#include "dmfi_inc_conv"
#include "seed_db_inc"
#include "_CSLCore_Items"
#include "_SCInclude_faction"
#include "_CSLCore_Items"
#include "_CSLCore_ObjectArray"
#include "_SCInclude_DynamConvos"

// PERSIST VARIABLE STRINGS
const string CRAFTER_LIST        = "CRAFTER_LIST";
const string CRAFTER_CONFIRM     = "CRAFTER_CONFIRM";
  
// PAGES
const int PAGE_MENU_MAIN             =  1;
const int PAGE_SHOW_MESSAGE          =  2;
const int PAGE_CONFIRM_ACTION        =  3;
const int PAGE_MENU_ABILITY          =  4;
const int PAGE_MENU_AC               =  5;
const int PAGE_MENU_ACESSORIES       =  6;
const int PAGE_MENU_AMMO             =  7;
const int PAGE_MENU_ARMOR            =  8;
const int PAGE_MENU_AXES             =  9;
const int PAGE_MENU_BLADED           = 10;
const int PAGE_MENU_BLUNTS           = 11;
const int PAGE_MENU_BONUSDC          = 12;
const int PAGE_MENU_BONUSDICE        = 13;
const int PAGE_MENU_BONUSPLUS        = 14;
const int PAGE_MENU_BONUSSLOT        = 15;
const int PAGE_MENU_DAMAGE           = 16;
const int PAGE_MENU_DOUBLESIDED      = 17;
const int PAGE_MENU_ENCHANTMENTS     = 18;
const int PAGE_MENU_EXOTIC           = 19;
const int PAGE_MENU_ONHIT            = 21;
const int PAGE_MENU_POLEARMS         = 22;
const int PAGE_MENU_PROPERTIES       = 23;
const int PAGE_MENU_RANGED           = 24;
const int PAGE_MENU_SAVEBIG3         = 25;
const int PAGE_MENU_SAVEVS           = 26;
const int PAGE_MENU_SHIELD           = 27;
const int PAGE_MENU_SKILLS           = 28;
const int PAGE_MENU_SPELLCLASS       = 29;
const int PAGE_MENU_WEAPONS          = 30;
const int PAGE_MENU_EQUIPPED         = 31;
const int PAGE_MENU_REMOVE           = 32;
const int PAGE_MENU_LIGHT            = 33;
const int PAGE_MENU_VISUALEFFECT     = 34;
const int PAGE_MENU_SET_BOXES        = 35;
const int PAGE_MENU_DAMAGERESIST     = 36;
const int PAGE_MENU_BONUSRESIST      = 37;
const int PAGE_MENU_RANGED_NORMAL    = 38;
const int PAGE_MENU_RANGED_UNLIMITED = 39;
const int PAGE_MENU_DAMAGEIMMUNITY   = 40;
const int PAGE_MENU_BONUSIMMUNITY    = 41;
const int PAGE_MENU_DAMAGEREDUCT     = 42;
const int PAGE_MENU_BONUSREDUCT      = 43;

const int ACTION_CONFIRM          = 101;
const int ACTION_CANCEL           = 102;
const int ACTION_END_CONVO        = 103;
const int ACTION_SELECT_BONUS     = 104;
const int ACTION_SELECT_PROPTYPE  = 105;
const int ACTION_SELECT_SUBTYPE   = 106;
const int ACTION_BUY_ITEM         = 107;
const int ACTION_START_ITEM       = 108;
const int ACTION_START_ITEM50     = 109;
const int ACTION_START_ITEM99     = 110;
const int ACTION_COPY_ITEM        = 111;
const int ACTION_REMOVE_PROP      = 112;
const int ACTION_EXAMINE_ITEM     = 113;
const int ACTION_SET_BOXES        = 114;
const int ACTION_OPEN_STORE       = 115;

const int CRAFT_ARMOR             = BIT1;
const int CRAFT_MAGIC             = BIT2;
const int CRAFT_MELEE             = BIT3;
const int CRAFT_RANGED            = BIT4;

const int TEXT_COLOR = COLOR_BLUE;


void   AddNewProperty();
void   BuildPage(int nPage);
int    CanRemove(int iProp);
void   CleanUp();
void   DeleteWorkingItem();
string DisabledText(string sText);
void   DoConfirmAction();
void   DoShowMessage();
string FlagTooHigh(string sText, int iFlag);
int    GetCurrentPage();
int    GetBackPage();
int    GetBonus();
int    GetBoxCount();
int    GetConfirmedAction();
object GetCopiedItem();
int    GetIsCopyingItem();
int    GetMaxBonus();
int    GetNextPage();
int    GetPageOptionSelected(string sList = CRAFTER_LIST);
int    GetPageOptionSelectedInt(string sList = CRAFTER_LIST);
object GetPageOptionSelectedObject(string sList = CRAFTER_LIST);
string GetPageOptionSelectedString(string sList = CRAFTER_LIST);
int    GetPropType();
int    GetSubType();
object GetWorkingItem();
void   HandleSelection();
string HeaderMsg();
void   Init();
void   CSLLoadItemProps(object oItem);
int    MaxSpellSlot(int iClass);
void   SetCurrentPage(int nPage);
void   SetBackPage(int nPage);
void   SetBonus(int iBonus);
void   SetBoxCount(int iStack);
void   SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No");
void   SetCopiedItem(object oItem);
void   SetMaxBonus(int nMaxBonus, int nSuper=0);
void   SetNextPage(int nPage);
void   SetPrompt(string sText);
void   CSLSetProp(int iPropNum, int PropType, int PropSubType, int PropBonus, string PropDesc);
void   SetPropType(int nPropType);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO);
void   SetSubType(int nSubType);
object SetWorkingItem(string sResRef, int iStack = 1);
int    ShowOption(int iType);
void   ShowPropSelection(int iShow, string sText, int iAction, int iProp);

object oPC = CSLGetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST
object oCrafter = OBJECT_SELF;
//int MAX_LEVEL = GetLocalInt(oCrafter, "CRAFTER_MAX_LEVEL");
int iActivePropCount = 0;

int GetMaxLevel(object oPC, int bCheckHD = TRUE)
{
   if (SDB_GetPCSuper(oPC)) return 30;
   int nMax = GetLocalInt(oCrafter, "CRAFTER_MAX_LEVEL");
   if (!bCheckHD) return nMax;
   return CSLGetMin(nMax, GetHitDice(oPC));
}


void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = CRAFTER_LIST)
{
   int nCurrent = CSLDataArray_PushString(oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) );
   CSLDataArray_SetInt(oPC, sList, nCurrent, nSelectionValue );
   CSLDataArray_SetInt(oPC, sList + "_SUB", nCurrent, nSubValue );
   //CSLDataArray_SetInt(oPC, sList, CSLDataArray_PushString( oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) ), nSelectionValue );
   //CSLDataArray_PushInt(oPC, CRAFTER_LIST + "_SUB", nSubValue);
}

void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = CRAFTER_LIST)
{
	int nCurrent = CSLDataArray_PushString(oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) );
	CSLDataArray_SetInt(oPC, sList, nCurrent, nSelectionValue );
	CSLDataArray_SetString(oPC, sList + "_SUB", nCurrent, sSubValue );
}

void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = CRAFTER_LIST)
{
   int nCurrent = CSLDataArray_PushString(oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) );
   CSLDataArray_SetInt(oPC, sList, nCurrent, nSelectionValue );
   CSLDataArray_SetObject(oPC, sList + "_SUB", nCurrent, oSubValue );
   //CSLDataArray_SetInt( oPC, sList, CSLDataArray_PushString( oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) ), nSelectionValue );
   //CSLDataArray_PushObject( oPC, CRAFTER_LIST+"_SUB", oSubValue);
}

void SetPrompt(string sText)
{
   CSLSetDlgPrompt(CSLColorText(sText, TEXT_COLOR));
}

string DisabledText(string sText)
{
   return CSLColorText(sText, COLOR_GREY);
}

int GetPageOptionSelected(string sList = CRAFTER_LIST)
{
   return CSLDataArray_GetInt( oPC, sList, CSLGetDlgSelection() );
}

int GetPageOptionSelectedInt(string sList = CRAFTER_LIST)
{
   return CSLDataArray_GetInt( oPC, sList + "_SUB", CSLGetDlgSelection() );
}

string GetPageOptionSelectedString(string sList = CRAFTER_LIST)
{
   return CSLDataArray_GetString(oPC, sList + "_SUB", CSLGetDlgSelection());
}

object GetPageOptionSelectedObject(string sList = CRAFTER_LIST)
{
   return CSLDataArray_GetObject( oPC, sList + "_SUB", CSLGetDlgSelection() );
}

int GetCurrentPage()
{
   return GetLocalInt(oPC, CRAFTER_LIST + "_CURPAGE");
}
void SetCurrentPage(int nPage)
{
   SetLocalInt(oPC, CRAFTER_LIST + "_CURPAGE", nPage);
}

int GetNextPage()
{
   return GetLocalInt(oPC, CRAFTER_LIST + "_NEXTPAGE");
}

void SetNextPage(int nPage)
{
   SetLocalInt(oPC, CRAFTER_LIST + "_NEXTPAGE", nPage);
}

int GetBackPage()
{
   return GetLocalInt(oPC, CRAFTER_LIST + "_BACK");
}

void SetBackPage(int nPage)
{
   SetLocalInt(oPC, CRAFTER_LIST + "_BACK", nPage);
}

void SetMaxBonus(int nMaxBonus, int nSuper=0)
{
   if (nSuper && SDB_GetPCSuper(oPC)) nMaxBonus = nSuper;
   SetLocalInt(oPC, CRAFTER_LIST+"_MAXBONUS", nMaxBonus);
}

int GetMaxBonus()
{
   return GetLocalInt(oPC, CRAFTER_LIST+"_MAXBONUS");
}

void SetPropType(int nPropType)
{
   SetLocalInt(oPC, CRAFTER_LIST+"_PROPTYPE", nPropType);
}

int GetPropType()
{
   return GetLocalInt(oPC, CRAFTER_LIST+"_PROPTYPE");
}

void SetSubType(int nSubType)
{
   SetLocalInt(oPC, CRAFTER_LIST+"_SUBTYPE", nSubType);
}

int GetSubType() {
   return GetLocalInt(oPC, CRAFTER_LIST+"_SUBTYPE");
}

void SetBonus(int iBonus) {
   SetLocalInt(oPC, CRAFTER_LIST+"_BONUS", iBonus);
}

int GetBonus() {
   return GetLocalInt(oPC, CRAFTER_LIST+"_BONUS");
}

void SetBoxCount(int iStack) {
   SetLocalInt(oPC, CRAFTER_LIST+"_BOXCOUNT", iStack);
}

int GetBoxCount()
{
   return GetLocalInt(oPC, CRAFTER_LIST+"_BOXCOUNT");
}

object GetWorkingItem() {
    return GetLocalObject(oPC, CRAFTER_LIST+"_ITEM");
}

object SetWorkingItem(string sResRef, int iStack = 1) {
   object oItem = CreateItemOnObject(sResRef, oCrafter, iStack);
   SetDroppableFlag(oItem, FALSE);
   SetLocalInt(oItem, "CRAFTING", TRUE);
   SetIdentified(oItem, TRUE);
   SetLocalObject(oPC, CRAFTER_LIST+"_ITEM", oItem);
   SetDescription(oItem, "Seed z-Crafter 2.0");
   return oItem;
}

void DeleteWorkingItem() {
    object oItem = GetWorkingItem();
    if (oItem!=OBJECT_INVALID && GetObjectType( oItem ) == OBJECT_TYPE_ITEM )
    {
       DestroyObject(oItem);
       SetLocalObject(oPC, CRAFTER_LIST+"_ITEM", OBJECT_INVALID);
    }
}

object GetCopiedItem() {
    return GetLocalObject(oPC, CRAFTER_LIST+"_COPY");
}

int GetIsCopyingItem() {
    return GetLocalInt(oPC, CRAFTER_LIST+"_COPY");
}

void SetCopiedItem(object oItem) {
    SetLocalObject(oPC, CRAFTER_LIST+"_COPY", oItem);
    SetLocalInt(oPC, CRAFTER_LIST+"_COPY", (oItem!=OBJECT_INVALID));
}

void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO) {
   SetLocalString(oPC, CRAFTER_CONFIRM, sPrompt);
   SetLocalInt(oPC, CRAFTER_CONFIRM, nOkAction);
   SetNextPage(PAGE_SHOW_MESSAGE);
}

void DoShowMessage() {
   SetPrompt(GetLocalString(oPC, CRAFTER_CONFIRM));
   int nOkAction = GetLocalInt(oPC, CRAFTER_CONFIRM);
   if (nOkAction!=ACTION_END_CONVO) AddMenuSelectionInt("Ok", nOkAction); // DON'T SHOW OK IF WE ARE ENDING CONVO, DEFAULT "END" WILL HANDLE IT
}

void SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No") {
   SetLocalString(oPC, CRAFTER_CONFIRM, sPrompt);
   SetLocalInt(oPC, CRAFTER_CONFIRM + "_Y", nActionConfirm);
   SetLocalInt(oPC, CRAFTER_CONFIRM + "_N", nActionCancel);
   SetLocalString(oPC, CRAFTER_CONFIRM + "_Y", sConfirm);
   SetLocalString(oPC, CRAFTER_CONFIRM + "_N", sCancel);
   SetNextPage(PAGE_CONFIRM_ACTION);
}

void DoConfirmAction() {
   SetPrompt(GetLocalString(oPC, CRAFTER_CONFIRM));
   AddMenuSelectionInt(GetLocalString(oPC, CRAFTER_CONFIRM + "_Y"), ACTION_CONFIRM, GetLocalInt(oPC, CRAFTER_CONFIRM+"_Y"));
   AddMenuSelectionInt(GetLocalString(oPC, CRAFTER_CONFIRM + "_N"), GetLocalInt(oPC, CRAFTER_CONFIRM+"_N"));
}

int GetConfirmedAction() {
   return GetLocalInt(oPC, CRAFTER_CONFIRM);
}


string GetFactionResRef(string sResRef) {
   int nFAID = StringToInt(SDB_GetFAID(oPC));
   if (!nFAID) return sResRef; // NOT FACTIONED JUST RETURN THE ORIGINAL
   string sPreFix = "";
   if      (nFAID==1) sPreFix = "legion_";
   else if (nFAID==2) sPreFix = "order_";
   else if (nFAID==3) sPreFix = "truebal_";
   else if (nFAID==4) sPreFix = "triad_";
   else if (nFAID==5) sPreFix = "pkr_";

   if (sResRef=="nw_aarcl011") return sPreFix + "banded"      ;
   if (sResRef=="nw_aarcl010") return sPreFix + "breastplate" ;
   if (sResRef=="nw_aarcl004") return sPreFix + "chain"       ;
   if (sResRef=="nw_aarcl012") return sPreFix + "chainshirt"  ;
   if (sResRef=="arcanerobe")  return sPreFix + "cloth"       ;
   if (sResRef=="nw_aarcl007") return sPreFix + "fullplate"   ;
   if (sResRef=="nw_aarcl006") return sPreFix + "halfplate"   ;
   if (sResRef=="nw_ashlw001") return sPreFix + "heavyshield" ;
   if (sResRef=="nw_aarcl008") return sPreFix + "hide"        ;
   if (sResRef=="nw_aarcl001") return sPreFix + "leather"     ;
   if (sResRef=="nw_ashsw001") return sPreFix + "lightshield" ;
   if (sResRef=="nw_aarcl009") return sPreFix + "padded"      ;
   if (sResRef=="nw_aarcl003") return sPreFix + "scale"       ;
   if (sResRef=="nw_aarcl002") return sPreFix + "studded"     ;
   if (sResRef=="nw_ashto001") return sPreFix + "towershield" ;

   return sResRef;
}

void ShowPropSelection(int iShow, string sText, int iAction, int iProp)
{
   if ( ItemProps.ValidProps & iShow ) // VALID PROPERTY FOR THIS ITEM
   {
      if (ItemProps.UsedProps & iShow) // ALREADY HAS THIS PROPERTY, SHOW AS DISABLED
	  {
         sText = DisabledText(sText);
         iAction = PAGE_MENU_ENCHANTMENTS;
      }
	  else
	  {
         iActivePropCount++;
      }
      AddMenuSelectionInt(sText, iAction, iProp);
   }
}

int ShowOption(int iType) {
   if (SDB_GetPCSuper(oPC)) return TRUE;
   return GetLocalInt(oCrafter, "CRAFTER_TYPE") & iType;
}

int CanRemove(int iProp) {
   if (iProp==ITEM_PROPERTY_DECREASED_SAVING_THROWS) return FALSE;
   if (iProp==ITEM_PROPERTY_UNLIMITED_AMMUNITION) return FALSE;
   if (iProp==ITEM_PROPERTY_CAST_SPELL) return FALSE;
   return TRUE;
}

int MaxSpellSlot(int iClass) {
   switch (iClass) {
      case IP_CONST_CLASS_BARD   : return 6;
      case IP_CONST_CLASS_PALADIN: return 4;
      case IP_CONST_CLASS_RANGER : return 4;
   }
   return 9;
}

string FlagTooHigh(string sText, int iFlag) {
   return (iFlag) ? CSLColorText(sText, COLOR_YELLOW) + CSLColorText(" > Max!", COLOR_RED): sText;
}

string HeaderMsg() {
   object oCopy = GetCopiedItem();
   object oItem = GetWorkingItem();
   int iCost = ItemProps.ItemCost;
   int iBox = GetBoxCount();
   int iTrade = 0;
   if (oCopy!=OBJECT_INVALID && GetObjectType( oCopy )==OBJECT_TYPE_ITEM ) iTrade = GetGoldPieceValue(oCopy);
   iCost = CSLGetMax(0, iCost - iTrade);
   int iLevelTooHigh = ItemProps.ItemLevel > GetMaxLevel(oPC);
   int iCostTooHigh = (iCost > GetGold(oPC));
   string sMsg;
   sMsg = "   Crafting:  " + ItemProps.ItemType + "\n";
   if ( GetItemStackSize(oItem)>1) sMsg +="  Quantity:  " + IntToString(iBox) + CSLAddS(" box", iBox, "es")+ " (" + IntToString(GetItemStackSize(GetWorkingItem()) * iBox) + " " +  ItemProps.ItemType + "s)\n";
   sMsg += "Level/Cost:  " + FlagTooHigh(IntToString(ItemProps.ItemLevel),iLevelTooHigh) + " / " + FlagTooHigh(IntToString(ItemProps.ItemCost) + " gold", iCostTooHigh) + "\n";
   if (oCopy!=OBJECT_INVALID && GetObjectType( oCopy )==OBJECT_TYPE_ITEM )
   {
      sMsg += "     Trade In:  " + IntToString(iTrade) + " gold" + "\n";
   }
   sMsg += " Properties:  " + ItemProps.PropList + "\n";
   sMsg += "\n";
   return sMsg;
}

void AddNewProperty() {
   object oItem = GetWorkingItem();
   itemproperty ipNew = CSLCreateItemProperty(GetPropType(), GetSubType(), GetBonus());
   CSLSafeAddItemProperty(oItem, ipNew);
   //if (GetPropType()==ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC && GetSubType()==IP_CONST_SAVEBASETYPE_FORTITUDE) {
     // if (GetBonus() > 2) CSLSafeAddItemProperty(oItem, ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_DEATH, GetBonus()-2));
     // else
   //CSLRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS, DURATION_TYPE_PERMANENT, IP_CONST_SAVEVS_DEATH);
   //}
}

void Init() {
   DeleteWorkingItem();
   SetCopiedItem(OBJECT_INVALID);
   SetNextPage(PAGE_MENU_MAIN);
}

void HandleSelection() {
   object oItem = GetWorkingItem();
   int iSelection = CSLGetDlgSelection(); // THE NUMBER OF THE OPTION SELECTED
   int iOptionSelected = GetPageOptionSelected(); // THE ACTION/PAGE ASSOCIATED WITH THE OPTION
   int iOptionSubSelected = GetPageOptionSelectedInt(); // THE SUB VALUE ASSOCIATED WITH THE OPTION
   string sOptionSubSelected = GetPageOptionSelectedString(); // THE SUB STRING ASSOCIATED WITH THE OPTION
   string sText;
   int iPropCnt;
   int iPropSeq;
   int iConfirmed;
   int iPropType;
   int iSubType;
   int iBonus;
   int iRemains;
   int iCopyCost = 0;
   object oCopy;
   int iGotMsg = 0;
   itemproperty ipProperty;
   SetBackPage(PAGE_MENU_MAIN);
   int iStack = 1;
   
   object oWorkingItem;
   
   switch (iOptionSelected)
   {
      // ********************************
      // HANDLE SIMPLE PAGE TURNING FIRST
      // ********************************
      case PAGE_MENU_MAIN             :
      case PAGE_SHOW_MESSAGE          :
      case PAGE_CONFIRM_ACTION        :
      case PAGE_MENU_ABILITY          :
      case PAGE_MENU_AC               :
      case PAGE_MENU_ACESSORIES       :
      case PAGE_MENU_AMMO             :
      case PAGE_MENU_ARMOR            :
      case PAGE_MENU_AXES             :
      case PAGE_MENU_BLADED           :
      case PAGE_MENU_BLUNTS           :
      case PAGE_MENU_BONUSDC          :
      case PAGE_MENU_BONUSDICE        :
      case PAGE_MENU_BONUSPLUS        :
      case PAGE_MENU_BONUSRESIST      :
      case PAGE_MENU_BONUSREDUCT      :
      case PAGE_MENU_BONUSIMMUNITY    :
      case PAGE_MENU_BONUSSLOT        :
      case PAGE_MENU_DAMAGE           :
      case PAGE_MENU_DOUBLESIDED      :
      case PAGE_MENU_ENCHANTMENTS     :
      case PAGE_MENU_EQUIPPED         :
      case PAGE_MENU_EXOTIC           :
      case PAGE_MENU_LIGHT            :
      case PAGE_MENU_ONHIT            :
      case PAGE_MENU_POLEARMS         :
      case PAGE_MENU_PROPERTIES       :
      case PAGE_MENU_RANGED           :
      case PAGE_MENU_REMOVE           :
      case PAGE_MENU_SAVEBIG3         :
      case PAGE_MENU_SAVEVS           :
      case PAGE_MENU_SHIELD           :
      case PAGE_MENU_SKILLS           :
      case PAGE_MENU_SPELLCLASS       :
      case PAGE_MENU_VISUALEFFECT     :
      case PAGE_MENU_WEAPONS          :
      case PAGE_MENU_SET_BOXES        :
      case PAGE_MENU_RANGED_NORMAL    :
      case PAGE_MENU_RANGED_UNLIMITED :

         if (GetNextPage()==iOptionSelected) PlaySound("vs_favhen4m_no");
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;

      // ************************
      // HANDLE PAGE ACTIONS NEXT
      // ************************
      case ACTION_END_CONVO:
         CSLEndDlg();
         return;

	case ACTION_EXAMINE_ITEM:
		oWorkingItem = GetWorkingItem();
		if (oWorkingItem!=OBJECT_INVALID && GetObjectType( oWorkingItem )==OBJECT_TYPE_ITEM )
		{
			//AssignCommand(oPC, ActionExamine( oWorkingItem ) );
			CSLExamine( oItem, oWorkingItem );
		}
		return;
		
	case ACTION_OPEN_STORE:
         OpenStore(GetObjectByTag(sOptionSubSelected), oPC);
         //OpenStore(GetNearestObjectByTag(GetLocalString(oCrafter, "STORE")), oPC);
         CSLEndDlg();
         return;

      case ACTION_START_ITEM:
      case ACTION_START_ITEM50:
      case ACTION_START_ITEM99:
         if (iOptionSelected==ACTION_START_ITEM50) iStack = 500;
         else if (iOptionSelected==ACTION_START_ITEM99) iStack = 99;
         else iStack = 1;
         SetBoxCount(1);
         SetNextPage(PAGE_MENU_PROPERTIES);
         if (SetWorkingItem(sOptionSubSelected, iStack)==OBJECT_INVALID) SetNextPage(PAGE_MENU_PROPERTIES); // ITEM CREATE FAILED FOR SOME REASON
         return;

      case ACTION_SELECT_PROPTYPE:
         SetPropType(iOptionSubSelected);
         switch (iOptionSubSelected) {
            // PROPS WITH NEITHER SUBTYPE OR BONUS POWER - DONE AFTER SELECTING
            //case G:
            case ITEM_PROPERTY_KEEN:
            case ITEM_PROPERTY_DARKVISION:
               AddNewProperty();
               return;

            // PROPS WITH NO SUBTYPES, JUST A BONUS POWER - SEND TO BONUS SELECTION
            case ITEM_PROPERTY_AC_BONUS:               
               SetMaxBonus(SMS_AC_MAX, 5);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_ATTACK_BONUS:
            case ITEM_PROPERTY_ENHANCEMENT_BONUS:
               SetMaxBonus(SMS_AB_MAX, 5);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_MIGHTY:
               SetMaxBonus(SMS_MIGHTY_MAX, 8);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_REGENERATION:
               SetMaxBonus(SMS_REGEN_MAIN_ITEM_MAX, 3);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
               SetMaxBonus(SMS_VAMP_REGEN_MAX, 4);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_MASSIVE_CRITICALS:
               SetNextPage(PAGE_MENU_BONUSDICE);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;

            // PROPS WITH SUBTYPES - SEND TO SUBTYPE SCREEN
            case ITEM_PROPERTY_ABILITY_BONUS:
               SetMaxBonus(SMS_ABILITY_MAX, 6);
               SetNextPage(PAGE_MENU_ABILITY);
               SetBackPage(PAGE_MENU_ABILITY);
               return;
            case ITEM_PROPERTY_DAMAGE_BONUS:
               SetNextPage(PAGE_MENU_DAMAGE);
               SetBackPage(PAGE_MENU_DAMAGE);
               return;
            case ITEM_PROPERTY_DAMAGE_RESISTANCE:
               SetNextPage(PAGE_MENU_DAMAGERESIST);
               SetBackPage(PAGE_MENU_DAMAGERESIST);
               return;
            case ITEM_PROPERTY_DAMAGE_REDUCTION:
               SetNextPage(PAGE_MENU_DAMAGEREDUCT);
               SetBackPage(PAGE_MENU_DAMAGEREDUCT);
               return;
            case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
               SetNextPage(PAGE_MENU_DAMAGEIMMUNITY);
               SetBackPage(PAGE_MENU_DAMAGEIMMUNITY);
               return;
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
               SetNextPage(PAGE_MENU_ONHIT);
               SetBackPage(PAGE_MENU_ONHIT);
               return;
            case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
               SetMaxBonus(SMS_SAVE_BIG3_MAIN_ITEM_MAX, 3);
               SetNextPage(PAGE_MENU_SAVEBIG3);
               SetBackPage(PAGE_MENU_SAVEBIG3);
               return;
            case ITEM_PROPERTY_SAVING_THROW_BONUS:
               SetMaxBonus(SMS_SAVE_VS_MAIN_ITEM_MAX, 3);
               SetNextPage(PAGE_MENU_SAVEVS);
               SetBackPage(PAGE_MENU_SAVEVS);
               return;
            case ITEM_PROPERTY_SKILL_BONUS:
               SetMaxBonus(SMS_SKILL_MAX, 2);
               SetNextPage(PAGE_MENU_SKILLS);
               SetBackPage(PAGE_MENU_SKILLS);
               return;
            case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
               SetNextPage(PAGE_MENU_SPELLCLASS);
               SetBackPage(PAGE_MENU_SPELLCLASS);
               return;
            case ITEM_PROPERTY_LIGHT:
               SetNextPage(PAGE_MENU_LIGHT);
               SetBackPage(PAGE_MENU_LIGHT);
               return;
            case ITEM_PROPERTY_VISUALEFFECT:
               SetNextPage(PAGE_MENU_VISUALEFFECT);
               SetBackPage(PAGE_MENU_VISUALEFFECT);
               return;
         }

      case ACTION_SELECT_SUBTYPE:
         SetSubType(iOptionSubSelected);
       SetBackPage(GetCurrentPage());
         switch (GetPropType()) {
            // PROPS WITH BONUS TYPES AS PLUS
            case ITEM_PROPERTY_ABILITY_BONUS:
            case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            case ITEM_PROPERTY_SAVING_THROW_BONUS:
            case ITEM_PROPERTY_SKILL_BONUS:
               SetNextPage(PAGE_MENU_BONUSPLUS);
               return;
            // PROPS WITH BONUS TYPES AS SPECIAL (ie DICE, DC)
            case ITEM_PROPERTY_DAMAGE_BONUS:
               SetNextPage(PAGE_MENU_BONUSDICE);
               return;
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
               SetNextPage(PAGE_MENU_BONUSDC);
               return;
            case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
               SetNextPage(PAGE_MENU_BONUSSLOT);
               return;
            case ITEM_PROPERTY_DAMAGE_RESISTANCE:
               SetNextPage(PAGE_MENU_BONUSRESIST);
               return;
            case ITEM_PROPERTY_DAMAGE_REDUCTION:
               SetNextPage(PAGE_MENU_BONUSREDUCT);
               return;
            case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
               SetNextPage(PAGE_MENU_BONUSIMMUNITY);
               return;

         }
         return;

      case ACTION_SELECT_BONUS:
         SetBonus(iOptionSubSelected);
         AddNewProperty();
         SetNextPage(PAGE_MENU_ENCHANTMENTS);
         return;

      case ACTION_COPY_ITEM:
		oItem = CopyItem(GetPageOptionSelectedObject(), oCrafter);
		SetLocalInt(oItem, "CRAFTING", TRUE);
		if (GetBaseItemType(oItem)==BASE_ITEM_ARROW || GetBaseItemType(oItem)==BASE_ITEM_BULLET || GetBaseItemType(oItem)==BASE_ITEM_BOLT) iStack = 99;
		else if (GetBaseItemType(oItem)==BASE_ITEM_DART || GetBaseItemType(oItem)==BASE_ITEM_SHURIKEN || GetBaseItemType(oItem)==BASE_ITEM_THROWINGAXE) iStack = 500;
		else iStack = 1;
		SetLocalObject(oPC, CRAFTER_LIST+"_ITEM", oItem); // SET WORKING OBJECT
		SetCopiedItem(GetPageOptionSelectedObject());
		SetNextPage(PAGE_MENU_PROPERTIES);
		SetBackPage(PAGE_MENU_EQUIPPED);
		return;

      case ACTION_REMOVE_PROP:
         ipProperty =  GetFirstItemProperty(oItem);
         sText = "All Properties ";
         ItemProps.PropList = "None";
         while (GetIsItemPropertyValid(ipProperty)) {
            iPropCnt++;
            iPropSeq++;
            iPropType = GetItemPropertyType(ipProperty);
            iSubType = GetItemPropertySubType(ipProperty);
            iBonus = GetItemPropertyCostTableValue(ipProperty);
            int iParam1 = GetItemPropertyParam1Value(ipProperty);
            if (CanRemove(iPropType) && (iPropSeq==iOptionSubSelected || iOptionSubSelected==0)) {
               RemoveItemProperty(oItem, ipProperty);
               iPropCnt--;
               if (iOptionSubSelected!=0) {
                  sText = CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1);
                  if (iPropType==ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC && GetSubType()==IP_CONST_SAVEBASETYPE_FORTITUDE) {
                     CSLRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS, DURATION_TYPE_PERMANENT, IP_CONST_SAVEVS_DEATH);
                     iPropCnt--;
                  }
                  //break;
               }
            } else {
               CSLSetProp(iPropSeq, iPropType, iSubType, iBonus, CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1));
            }
            ipProperty = GetNextItemProperty(oItem);
         }
         //sText = "Removed " + sText+ "\n\n" + "Properties:   " + ItemProps.PropList + "\n\n";
         //SetShowMessage(sText, PAGE_MENU_PROPERTIES);
         if (iPropCnt<=0 || iOptionSubSelected==0) SetCopiedItem(OBJECT_INVALID); // REMOVED ALL PROPERTIES, DON'T NEED TO SELL ITEM
       SetNextPage(PAGE_MENU_PROPERTIES);
         return;

      case ACTION_BUY_ITEM:
         CSLLoadItemProps(oItem);
         if (GetItemStackSize(oItem)>1) ItemProps.ItemCost = ItemProps.ItemCost * GetBoxCount(); // IF AMMO SHOW EXTENDED PRICE
         if (ItemProps.ItemLevel > GetMaxLevel(oPC))
		 {
            SetShowMessage("This item is beyond my capabilities. Try removing some properties...", PAGE_MENU_REMOVE);
            return;
         }
         iCopyCost = 0;
         oCopy = GetCopiedItem();
         if (oCopy!=OBJECT_INVALID && GetObjectType( oCopy )==OBJECT_TYPE_ITEM && GetItemPossessor(oCopy)==oPC)
		 {
            iCopyCost = GetGoldPieceValue(oCopy);
         }
		 else // CAN'T FIND COPY ITEM
		 { 
            if (GetIsCopyingItem() && GetItemStackSize(oItem)==1) // WERE WE DOING A COPY? IF SO, RESTART
			{ 
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(50, DAMAGE_TYPE_MAGICAL), oPC);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
               TakeGoldFromCreature(ItemProps.ItemCost, oPC, TRUE);
               string sMsg = "cannot find copied " + GetName(oItem) + " in inventory. Value=" + IntToString(GetGoldPieceValue(oItem));
               SDB_LogMsg("CRAFTNOCOPY", sMsg, oPC);
               SetShowMessage("Your slight of hand has not gone unnoticed. You anger me when you try to steal...", PAGE_MENU_MAIN);
               return;
            }
         }
         ItemProps.ItemCost -= iCopyCost;
         if (GetGold(oPC) < ItemProps.ItemCost) {
            SetShowMessage("You cannot afford the item. Try removing some properties...", PAGE_MENU_REMOVE);
            return;
         }
         sText = GetTag(oItem); // SAVE THE TAG OF THE ITEM
         iStack = GetBoxCount(); // HOW MANY BOXES
         if (GetItemStackSize(oItem)>1 && iStack>1)
		 { // MORE THAN ONE STACK, CREATE AN AMMO BOX INSTEAD
            string sDesc = "Creates one stack of " + IntToString(GetItemStackSize(oItem)) + " " + ItemProps.ItemType + " per charge with the following properties:\n\n" + ItemProps.PropList;
            sText = "AB" + ItemProps.PropTag; // SET THE AMMO BOX TAG
            DeleteWorkingItem(); // DELETE THE WORK ITEM
            oItem = SetWorkingItem("ammobox"); // SAVE THE AMMO BOX AS THE WORKING ITEM SO IT IS CREATE INSTEAD OF AMMO BELOW
            SetFirstName(oItem, "Box of " + ItemProps.ItemType + "s");
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE), oItem);
            SetItemCharges(oItem, iStack);
            SetLastName(oItem, sText);
            SetDescription(oItem, sDesc);
            DestroyObject(oItem);
            SetShowMessage("You have a new Ammo Box capable of creating " + IntToString(iStack) + " stacks of " + ItemProps.ItemType + "s.");
            iGotMsg = TRUE;
         } else if (sText!="SEED_VALIDATED" && !CSLStringStartsWith(sText, "ULA_")) {
            sText = "CRAFTED_" + SDB_GetSEID() + "_" + IntToString(CSLIncrementLocalInt(GetModule(), "CRAFT_SEQ", 1));
            if (FindSubString(GetName(oItem), GetName(oPC))==-1) {
               SetFirstName(oItem, GetName(oItem) + " of " + GetName(oPC));
            }
         }
         TakeGoldFromCreature(ItemProps.ItemCost, oPC, TRUE);
         PlaySound("it_coins");
         DeleteLocalInt(oItem, "CRAFTING");
         oItem = CopyObject(oItem, GetLocation(oPC), oPC, sText);
         DeleteWorkingItem();
         if (oCopy!=OBJECT_INVALID && !iGotMsg) {
            DestroyObject(oCopy);
            SetCopiedItem(OBJECT_INVALID);
            SetShowMessage("You sold your old " + GetName(oCopy) + " for " + IntToString(iCopyCost) + " to help pay for the new one.");
            iGotMsg = TRUE;
         }
         if (!iGotMsg) SetNextPage(PAGE_MENU_MAIN);
         return;

      case ACTION_SET_BOXES:
         SetBoxCount(iOptionSubSelected);
         SetNextPage(PAGE_MENU_PROPERTIES);
         return;

      // *****************************************
      // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
      // *****************************************
      case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
         iConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
         switch (iConfirmed) {
            case ACTION_SELECT_BONUS:
               return;
       }
    }
    SetNextPage(PAGE_MENU_MAIN); // If broken, send to main menu
}

void ShowStoreOption(string sWhich) {
   string sStore = GetLocalString(oCrafter, sWhich);
   if (sStore!="") {
      string sName = GetLocalString(oCrafter, sWhich + "_NAME");
      if (sName=="") sName = "View Store";
     else sName = "View " + sName + " Store";
      AddMenuSelectionString(sName, ACTION_OPEN_STORE, sStore);
   }
}

void BuildPage(int nPage)
{
   CSLDataArray_DeleteEntire(oPC, CRAFTER_LIST );
   CSLDataArray_DeleteEntire(oPC, CRAFTER_LIST+"_SUB" );
   string sMsg;
   string sTxt;
   int i = 0;
   int iRemain = 0;
   int iStack = 0;
   SetCurrentPage(nPage);
   object oItem = GetWorkingItem();
   if (oItem!=OBJECT_INVALID) {
      CSLLoadItemProps(oItem);
      if (GetItemStackSize(oItem)>1) ItemProps.ItemCost = ItemProps.ItemCost * GetBoxCount(); // IF AMMO SHOW EXTENDED PRICE
   }
   switch (nPage) {
      case PAGE_MENU_MAIN:
         SetPrompt("I can craft items up to level " + IntToString(GetMaxLevel(oPC, TRUE)) + ". Select the item to craft:");
         if (ShowOption(CRAFT_RANGED)) AddMenuSelectionInt("Ammo, Throwing Weapons"  , PAGE_MENU_AMMO);
         if (ShowOption(CRAFT_ARMOR))  AddMenuSelectionInt("Armor, Helms, Shields"   , PAGE_MENU_AC);
         if (ShowOption(CRAFT_MAGIC))  AddMenuSelectionInt("Clothing and Accessories", PAGE_MENU_ACESSORIES);
         if (ShowOption(CRAFT_RANGED)) AddMenuSelectionInt("Ranged Weapons"          , PAGE_MENU_RANGED);
         if (ShowOption(CRAFT_MELEE))  AddMenuSelectionInt("Melee Weapons"           , PAGE_MENU_WEAPONS);
         AddMenuSelectionInt("Modify Equipped Item"    , PAGE_MENU_EQUIPPED);
         ShowStoreOption("STORE");
         ShowStoreOption("STORE2");
         DeleteWorkingItem();
         SetCopiedItem(OBJECT_INVALID);
         return;

      case PAGE_MENU_EQUIPPED:
         SetPrompt("Modify Item.\n\nSelect the Item to Modify:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         for(i = 0; i < INVENTORY_SLOT_ARROWS; i++) {
            oItem = GetItemInSlot(i, oPC);
            if (GetIsObjectValid(oItem))
            {
               if ( CSLGetItemLevel(GetGoldPieceValue(oItem)) > GetMaxLevel(oPC))
               {
                  AddMenuSelectionObject(FlagTooHigh(CSLInventorySlotToString(i) + ": " + GetName(oItem), TRUE), PAGE_MENU_EQUIPPED, oItem);
               }
               else
               {
               		int nDest = ACTION_COPY_ITEM;
              		if ( CSLStringStartsWith(GetTag(oItem), "NOCRAFT")  || GetTag(oItem) == "dex_bootsvelocity" || GetTag(oItem) == "dex_skullhelm" ) // SPECIAL GAME ITEM CANNOT BE MODIFIED
              		{
              			nDest = PAGE_MENU_EQUIPPED;
              		} 
                  	AddMenuSelectionObject(CSLInventorySlotToString(i) + ": " + GetName(oItem), nDest, oItem);
               }
            }
         }
         break;

      case PAGE_MENU_REMOVE:
         SetPrompt("Remove Item Property.\n\nSelect the Property to Remove:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_PROPERTIES);
         if (ItemProps.PropCount>1) AddMenuSelectionInt("All Properties", ACTION_REMOVE_PROP, 0);
         if (ItemProps.Prop1Desc!="") AddMenuSelectionInt(ItemProps.Prop1Desc, CanRemove(ItemProps.Prop1Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 1);
         if (ItemProps.Prop2Desc!="") AddMenuSelectionInt(ItemProps.Prop2Desc, CanRemove(ItemProps.Prop2Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 2);
         if (ItemProps.Prop3Desc!="") AddMenuSelectionInt(ItemProps.Prop3Desc, CanRemove(ItemProps.Prop3Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 3);
         if (ItemProps.Prop4Desc!="") AddMenuSelectionInt(ItemProps.Prop4Desc, CanRemove(ItemProps.Prop4Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 4);
         if (ItemProps.Prop5Desc!="") AddMenuSelectionInt(ItemProps.Prop5Desc, CanRemove(ItemProps.Prop5Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 5);
         if (ItemProps.Prop6Desc!="") AddMenuSelectionInt(ItemProps.Prop6Desc, CanRemove(ItemProps.Prop6Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 6);
         if (ItemProps.Prop7Desc!="") AddMenuSelectionInt(ItemProps.Prop7Desc, CanRemove(ItemProps.Prop7Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 7);
         if (ItemProps.Prop8Desc!="") AddMenuSelectionInt(ItemProps.Prop8Desc, CanRemove(ItemProps.Prop8Type) ? ACTION_REMOVE_PROP : PAGE_MENU_REMOVE, 8);
         break;

      case PAGE_MENU_AMMO:
         SetPrompt("Ammo and Throwing Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Arrows"       , ACTION_START_ITEM99, "nw_wamar001");
         AddMenuSelectionString("Bolts"        , ACTION_START_ITEM99, "nw_wambo001");
         AddMenuSelectionString("Bullets"      , ACTION_START_ITEM99, "nw_wambu001");
         AddMenuSelectionString("Darts"        , ACTION_START_ITEM50, "nw_wthdt001");
         AddMenuSelectionString("Shurikens"    , ACTION_START_ITEM50, "nw_wthsh001");
         AddMenuSelectionString("Throwing Axes", ACTION_START_ITEM50, "nw_wthax001");
         break;
      case PAGE_MENU_AC:
         SetPrompt("Armor, Helms, Shields.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionInt("Armor",   PAGE_MENU_ARMOR);
         AddMenuSelectionString("Helm", ACTION_START_ITEM, "arcanehelm");
         AddMenuSelectionInt("Shields", PAGE_MENU_SHIELD);
         break;
      case PAGE_MENU_ARMOR:
         SetPrompt("Armor.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_AC);
         AddMenuSelectionString("AC 0: Robe"           , ACTION_START_ITEM, GetFactionResRef("arcanerobe"));
         AddMenuSelectionString("AC 1: Padded"         , ACTION_START_ITEM, GetFactionResRef("nw_aarcl009"));
         AddMenuSelectionString("AC 2: Leather"        , ACTION_START_ITEM, GetFactionResRef("nw_aarcl001"));
         AddMenuSelectionString("AC 3: Studded Leather", ACTION_START_ITEM, GetFactionResRef("nw_aarcl002"));
         AddMenuSelectionString("AC 4: Chain Shirt"    , ACTION_START_ITEM, GetFactionResRef("nw_aarcl012"));
         AddMenuSelectionString("AC 3: Hide"           , ACTION_START_ITEM, GetFactionResRef("nw_aarcl008"));
         AddMenuSelectionString("AC 4: Scale Mail"     , ACTION_START_ITEM, GetFactionResRef("nw_aarcl003"));
         AddMenuSelectionString("AC 5: Chainmail"      , ACTION_START_ITEM, GetFactionResRef("nw_aarcl004"));
         AddMenuSelectionString("AC 5: Breastplate"    , ACTION_START_ITEM, GetFactionResRef("nw_aarcl010"));
         AddMenuSelectionString("AC 6: Banded Mail"    , ACTION_START_ITEM, GetFactionResRef("nw_aarcl011"));
         AddMenuSelectionString("AC 7: Half-Plate"     , ACTION_START_ITEM, GetFactionResRef("nw_aarcl006"));
         AddMenuSelectionString("AC 8: Full Plate"     , ACTION_START_ITEM, GetFactionResRef("nw_aarcl007"));
         break;
      case PAGE_MENU_SHIELD:
         SetPrompt("Shields.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_AC);
         AddMenuSelectionString("AC 1: Light Shield", ACTION_START_ITEM, GetFactionResRef("nw_ashsw001"));
         AddMenuSelectionString("AC 2: Heavy Shield", ACTION_START_ITEM, GetFactionResRef("nw_ashlw001"));
         AddMenuSelectionString("AC 3: Tower Shield", ACTION_START_ITEM, GetFactionResRef("nw_ashto001"));
         break;

      case PAGE_MENU_ACESSORIES:
         SetPrompt("Clothing and Accessories.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Amulet"     , ACTION_START_ITEM, "arcaneamulet");
         AddMenuSelectionString("Belt"       , ACTION_START_ITEM, "arcanebelt");
         AddMenuSelectionString("Boots"      , ACTION_START_ITEM, "arcaneboots");
         AddMenuSelectionString("Bracers"    , ACTION_START_ITEM, "arcanebracer");
         AddMenuSelectionString("Cloak"      , ACTION_START_ITEM, "arcanecloak");
         AddMenuSelectionString("Ring"       , ACTION_START_ITEM, "arcanering");
         AddMenuSelectionString("Mage Staff" , ACTION_START_ITEM, "arcanestaff");
         break;

      case PAGE_MENU_RANGED:
         SetPrompt("Ranged Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionInt("Normal Weapon - Ammo Required", PAGE_MENU_RANGED_NORMAL);
         AddMenuSelectionInt("Energy Weapon - Endless Ammo",  PAGE_MENU_RANGED_UNLIMITED);
         break;

      case PAGE_MENU_RANGED_NORMAL:
         SetPrompt("Ranged Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Heavy Crossbow", ACTION_START_ITEM, "nw_wbwxh001");
         AddMenuSelectionString("Light Crossbow", ACTION_START_ITEM, "nw_wbwxl001");
         AddMenuSelectionString("Longbow"       , ACTION_START_ITEM, "nw_wbwln001");
         AddMenuSelectionString("Shortbow"      , ACTION_START_ITEM, "nw_wbwsh001");
         AddMenuSelectionString("Sling"         , ACTION_START_ITEM, "nw_wbwsl001");
         break;

      case PAGE_MENU_RANGED_UNLIMITED:
         SetPrompt("Ranged Weapons with Endless Ammo.\n\nSelect the Type and Ammo Material:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Heavy Crossbow - Duskwood" , ACTION_START_ITEM, "ULA_HEAVYXBOW_WOOD");
         AddMenuSelectionString("Heavy Crossbow - Cold Iron", ACTION_START_ITEM, "ULA_HEAVYXBOW_IRON");
         AddMenuSelectionString("Light Crossbow - Duskwood" , ACTION_START_ITEM, "ULA_LIGHTXBOW_WOOD");
         AddMenuSelectionString("Light Crossbow - Cold Iron", ACTION_START_ITEM, "ULA_LIGHTXBOW_IRON");
         AddMenuSelectionString("Longbow - Duskwood"        , ACTION_START_ITEM, "ULA_LONGBOW_WOOD");
         AddMenuSelectionString("Longbow - Cold Iron"       , ACTION_START_ITEM, "ULA_LONGBOW_IRON");
         AddMenuSelectionString("Shortbow - Duskwood"       , ACTION_START_ITEM, "ULA_SHORTBOW_WOOD");
         AddMenuSelectionString("Shortbow - Cold Iron"      , ACTION_START_ITEM, "ULA_SHORTBOW_IRON");
         AddMenuSelectionString("Sling - Duskwood"          , ACTION_START_ITEM, "ULA_SLING_WOOD");
         AddMenuSelectionString("Sling - Cold Iron"         , ACTION_START_ITEM, "ULA_SLING_IRON");
         break;

      case PAGE_MENU_WEAPONS:
         SetPrompt("Melee Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionInt("Axes"          , PAGE_MENU_AXES);
         AddMenuSelectionInt("Bladed"        , PAGE_MENU_BLADED);
         AddMenuSelectionInt("Blunts"        , PAGE_MENU_BLUNTS);
         AddMenuSelectionInt("Double-Sided"  , PAGE_MENU_DOUBLESIDED);
         AddMenuSelectionInt("Exotic"        , PAGE_MENU_EXOTIC);
         AddMenuSelectionInt("Polearms"      , PAGE_MENU_POLEARMS);
         AddMenuSelectionString("Monk Gloves", ACTION_START_ITEM, "arcanegauntlet");
         break;

      case PAGE_MENU_AXES:
         SetPrompt("Axes.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Handaxe"        , ACTION_START_ITEM, "nw_waxhn001");
         AddMenuSelectionString("Dwarven War Axe", ACTION_START_ITEM, "x2_wdwraxe001");
         AddMenuSelectionString("Battle Axe"     , ACTION_START_ITEM, "nw_waxbt001");
         AddMenuSelectionString("Great Axe"      , ACTION_START_ITEM, "nw_waxgr001");
         break;

      case PAGE_MENU_BLADED:
         SetPrompt("Bladed Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Dagger"       , ACTION_START_ITEM, "nw_wswdg001");
         AddMenuSelectionString("Bastard Sword", ACTION_START_ITEM, "nw_wswbs001");
         AddMenuSelectionString("Falchion"     , ACTION_START_ITEM, "n2_wswfl001");
         AddMenuSelectionString("Shortsword"   , ACTION_START_ITEM, "nw_wswss001");
         AddMenuSelectionString("Longsword"    , ACTION_START_ITEM, "nw_wswls001");
         AddMenuSelectionString("Greatsword"   , ACTION_START_ITEM, "nw_wswgs001");
         AddMenuSelectionString("Katana"       , ACTION_START_ITEM, "nw_wswka001");
         AddMenuSelectionString("Rapier"       , ACTION_START_ITEM, "nw_wswrp001");
         AddMenuSelectionString("Scimitar"     , ACTION_START_ITEM, "nw_wswsc001");
         break;

      case PAGE_MENU_BLUNTS:
         SetPrompt("Blunt Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Club"        , ACTION_START_ITEM, "nw_wblcl001");
         AddMenuSelectionString("Great Club"  , ACTION_START_ITEM, "greatclub");
         AddMenuSelectionString("Light Flail" , ACTION_START_ITEM, "nw_wblfl001");
         AddMenuSelectionString("Light Hammer", ACTION_START_ITEM, "nw_wblhl001");
         AddMenuSelectionString("Mace"        , ACTION_START_ITEM, "nw_wblml001");
         AddMenuSelectionString("Morningstar" , ACTION_START_ITEM, "nw_wblms001");
         AddMenuSelectionString("War Hammer"  , ACTION_START_ITEM, "nw_wblhw001");
         AddMenuSelectionString("War Mace"    , ACTION_START_ITEM, "nw_wdbma001");
         break;

      case PAGE_MENU_DOUBLESIDED:
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         SetPrompt("Double Sided Weapons.\n\nSelect the Type:");
//         AddMenuSelectionString("Dire Mace"      , ACTION_START_ITEM, "nw_wdbma001");
//         AddMenuSelectionString("Double Axe"     , ACTION_START_ITEM, "nw_wdbax001");
         AddMenuSelectionString("Quarterstaff"   , ACTION_START_ITEM, "nw_wdbqs001");
//         AddMenuSelectionString("Two-Sided Sword", ACTION_START_ITEM, "nw_wdbsw001");
         break;

      case PAGE_MENU_EXOTIC:
         SetPrompt("Exotic Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Kukri" , ACTION_START_ITEM, "nw_wspku001");
         AddMenuSelectionString("Kama"  , ACTION_START_ITEM, "nw_wspka001");
         AddMenuSelectionString("Sickle", ACTION_START_ITEM, "nw_wspsc001");
         //AddMenuSelectionString("Whip"  , ACTION_START_ITEM, "x2_it_wpwhip");
         break;

      case PAGE_MENU_POLEARMS:
         SetPrompt("Polearms.\n\nSelect the Type:");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         AddMenuSelectionString("Halberd", ACTION_START_ITEM, "nw_wplhb001");
         AddMenuSelectionString("Scythe" , ACTION_START_ITEM, "nw_wplsc001");
         AddMenuSelectionString("Spear"  , ACTION_START_ITEM, "nw_wplss001");
//         AddMenuSelectionString("Trident", ACTION_START_ITEM, "nw_wpltr001");
         break;

      case PAGE_MENU_PROPERTIES:
         sMsg = HeaderMsg();
         sMsg += "What would you like to do now?";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         AddMenuSelectionInt("Add Enchantments", PAGE_MENU_ENCHANTMENTS);
         if (ItemProps.PropCount) {
            AddMenuSelectionInt("Remove Enchantments", PAGE_MENU_REMOVE);
         } else {
            AddMenuSelectionInt(DisabledText("Remove Enchantments"), PAGE_MENU_PROPERTIES);
         }
		 // This is causing a crash?? need to remove until i figure out why
         //AddMenuSelectionInt("Examine Item (refresh)", ACTION_EXAMINE_ITEM);
         if ( GetItemStackSize(oItem)>1 ) AddMenuSelectionInt("Set Box Count (" + IntToString(GetBoxCount())+")", PAGE_MENU_SET_BOXES);
         AddMenuSelectionInt("Buy Item", ACTION_BUY_ITEM);
         AddMenuSelectionInt("Start Over", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_ENCHANTMENTS:
         sMsg = HeaderMsg();
         sMsg += "What property do you want to add?";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_PROPERTIES);
         ShowPropSelection(SHOW_ABILITY       , "Ability Bonus"        , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_ABILITY_BONUS);
         ShowPropSelection(SHOW_AC            , "AC Bonus"             , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_AC_BONUS);
         ShowPropSelection(SHOW_AB            , "Attack Bonus"         , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_ATTACK_BONUS);
         ShowPropSelection(SHOW_DAMAGE        , "Damage Bonus"         , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_DAMAGE_BONUS);
         ShowPropSelection(SHOW_DAMAGERESIST  , "Damage Resistance"    , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_DAMAGE_RESISTANCE);
         //ShowPropSelection(SHOW_DAMAGEREDUCT  , "Damage Reduction"     , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_DAMAGE_REDUCTION);
         ShowPropSelection(SHOW_DAMAGEIMMUNITY, "Damage Immunity"      , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE);
         ShowPropSelection(SHOW_DARKVISION    , "Darkvision"           , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_DARKVISION);
         ShowPropSelection(SHOW_EB            , "Enhancement Bonus"    , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_ENHANCEMENT_BONUS);
         //ShowPropSelection(SHOW_HASTE         , "Haste"                , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_HASTE);
         //ShowPropSelection(SHOW_KEEN          , "Keen"                 , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_KEEN);
         ShowPropSelection(SHOW_LIGHT         , "Light"                , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_LIGHT);
         ShowPropSelection(SHOW_MASSCRITS     , "Massive Criticals"    , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_MASSIVE_CRITICALS);
         ShowPropSelection(SHOW_MIGHTY        , "Mighty"               , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_MIGHTY);
         ShowPropSelection(SHOW_ONHIT         , "On Hit Bonus"         , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_ON_HIT_PROPERTIES);
         ShowPropSelection(SHOW_REGEN         , "Regeneration"         , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_REGENERATION);
         ShowPropSelection(SHOW_SAVESPECIFIC  , "Save Specific"        , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC);
         ShowPropSelection(SHOW_SAVEVS        , "Save vs"              , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_SAVING_THROW_BONUS);
         ShowPropSelection(SHOW_SKILL         , "Skills"               , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_SKILL_BONUS);
         ShowPropSelection(SHOW_SPELLSLOT     , "Spell Slots"          , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N);
         ShowPropSelection(SHOW_VAMP_REGEN    , "Vampiric Regeneration", ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_REGENERATION_VAMPIRIC);
         ShowPropSelection(SHOW_VISUAL        , "Visual Effects"       , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_VISUALEFFECT);
         if (iActivePropCount==0) CSLDataArray_SetString(oPC, CRAFTER_LIST, 0, CSLColorText("[Back] No Properties left to add", TEXT_COLOR) );
         break;

      case PAGE_MENU_ABILITY:
         //SetMaxBonus(SMS_ABILITY_MAX);
         sMsg = HeaderMsg();
         sMsg += "Select type of Ability bonus to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Strength"    , ACTION_SELECT_SUBTYPE, IP_CONST_ABILITY_STR);
         AddMenuSelectionInt("Consitution" , ACTION_SELECT_SUBTYPE, IP_CONST_ABILITY_CON);
         AddMenuSelectionInt("Dexterity"   , ACTION_SELECT_SUBTYPE, IP_CONST_ABILITY_DEX);
         AddMenuSelectionInt("Intelligence", ACTION_SELECT_SUBTYPE, IP_CONST_ABILITY_INT);
         AddMenuSelectionInt("Wisdom"      , ACTION_SELECT_SUBTYPE, IP_CONST_ABILITY_WIS);
         AddMenuSelectionInt("Charisma"    , ACTION_SELECT_SUBTYPE, IP_CONST_ABILITY_CHA); 
         break;
 
      case PAGE_MENU_DAMAGE:
         sMsg = HeaderMsg();
         sMsg += "You are adding type " + IntToString(ItemProps.WeaponModsCount+1) + " out of 3 allowed damage types.";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Acid"    , ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_ACID);
         AddMenuSelectionInt("Cold"    , ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_COLD);
         AddMenuSelectionInt("Fire"    , ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_FIRE);
         AddMenuSelectionInt("Electric", ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_ELECTRICAL);
         if (GetItemStackSize(oItem) > 1) {
            AddMenuSelectionInt("Sonic",       ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_SONIC);
            AddMenuSelectionInt("Bludgeoning", ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_BLUDGEONING);
            AddMenuSelectionInt("Piercing",    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_PIERCING);
            AddMenuSelectionInt("Slashing",    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_SLASHING);
         }
         break;

      case PAGE_MENU_DAMAGERESIST:
         sMsg = HeaderMsg();
         sMsg += "Please select the type of Damage Resistance to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         //AddMenuSelectionInt("Bludgeoning", ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_BLUDGEONING); 
         //AddMenuSelectionInt("Piercing",    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_PIERCING);
         //AddMenuSelectionInt("Slashing",    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_SLASHING);
         break; 
         
      case PAGE_MENU_DAMAGEREDUCT:
         sMsg = HeaderMsg();
         sMsg += "Please select the type of Damage Reduction to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Bludgeoning", ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_BLUDGEONING); 
         AddMenuSelectionInt("Piercing",    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_PIERCING);
         AddMenuSelectionInt("Slashing",    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_SLASHING);
         break; 

      case PAGE_MENU_DAMAGEIMMUNITY:
         sMsg = HeaderMsg();
         sMsg += "Please select the type of Damage Immunity to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Acid"    ,    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_ACID);
         AddMenuSelectionInt("Cold"    ,    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_COLD);
         AddMenuSelectionInt("Fire"    ,    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_FIRE);
         AddMenuSelectionInt("Electric",    ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_ELECTRICAL);
         AddMenuSelectionInt("Sonic",       ACTION_SELECT_SUBTYPE, IP_CONST_DAMAGETYPE_SONIC);         
         break;

      case PAGE_MENU_ONHIT:
         sMsg = HeaderMsg();
         sMsg += "Select type of on-hit bonus to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Daze", ACTION_SELECT_SUBTYPE, IP_CONST_ONHIT_DAZE);
         AddMenuSelectionInt("Fear", ACTION_SELECT_SUBTYPE, IP_CONST_ONHIT_FEAR);
         AddMenuSelectionInt("Hold", ACTION_SELECT_SUBTYPE, IP_CONST_ONHIT_HOLD);
         AddMenuSelectionInt("Slow", ACTION_SELECT_SUBTYPE, IP_CONST_ONHIT_SLOW);
         AddMenuSelectionInt("Stun", ACTION_SELECT_SUBTYPE, IP_CONST_ONHIT_STUN);
         break;

      case PAGE_MENU_SAVEBIG3:
         //SetMaxBonus(SMS_SAVE_BIG3_MAIN_ITEM_MAX);
         sMsg = HeaderMsg();
         sMsg += "Select type of Specific Save bonus to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Fortitude", ACTION_SELECT_SUBTYPE, IP_CONST_SAVEBASETYPE_FORTITUDE);
         AddMenuSelectionInt("Reflex"   , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEBASETYPE_REFLEX);
         AddMenuSelectionInt("Will"     , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEBASETYPE_WILL);
         break;

      case PAGE_MENU_SAVEVS:
         //SetMaxBonus(SMS_SAVE_VS_MAIN_ITEM_MAX);
         sMsg = HeaderMsg();
         sMsg += "Select type of Save Vs bonus to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Acid"       , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_ACID);
         AddMenuSelectionInt("Cold"       , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_COLD);
         AddMenuSelectionInt("Disease"    , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_DISEASE);
//         AddMenuSelectionInt("Death"      , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_DEATH);
         AddMenuSelectionInt("Electrical" , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_ELECTRICAL);
//         AddMenuSelectionInt("Fear"       , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_FEAR);
         AddMenuSelectionInt("Fire"       , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_FIRE);
//         AddMenuSelectionInt("Mind Affect", ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_MINDAFFECTING);
         AddMenuSelectionInt("Poison"     , ACTION_SELECT_SUBTYPE, IP_CONST_SAVEVS_POISON);
         break;


      case PAGE_MENU_SKILLS:
         //SetMaxBonus(SMS_SKILL_MAX);
         sMsg = HeaderMsg();
         sMsg += "Select the Skill to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
//         AddMenuSelectionInt("Appraise"        , ACTION_SELECT_SUBTYPE, SKILL_APPRAISE);
         AddMenuSelectionInt("Bluff"           , ACTION_SELECT_SUBTYPE, SKILL_BLUFF);
         AddMenuSelectionInt("Concentration"   , ACTION_SELECT_SUBTYPE, SKILL_CONCENTRATION);
         AddMenuSelectionInt("Diplomacy"       , ACTION_SELECT_SUBTYPE, SKILL_DIPLOMACY);
         AddMenuSelectionInt("Disable Trap"    , ACTION_SELECT_SUBTYPE, SKILL_DISABLE_TRAP);
         AddMenuSelectionInt("Heal"            , ACTION_SELECT_SUBTYPE, SKILL_HEAL);
         AddMenuSelectionInt("Hide"            , ACTION_SELECT_SUBTYPE, SKILL_HIDE);
//         AddMenuSelectionInt("Intimidate"      , ACTION_SELECT_SUBTYPE, SKILL_INTIMIDATE);
         AddMenuSelectionInt("Listen"          , ACTION_SELECT_SUBTYPE, SKILL_LISTEN);
         AddMenuSelectionInt("Lore"            , ACTION_SELECT_SUBTYPE, SKILL_LORE);
         AddMenuSelectionInt("Move Silently"   , ACTION_SELECT_SUBTYPE, SKILL_MOVE_SILENTLY);
         AddMenuSelectionInt("Open Lock"       , ACTION_SELECT_SUBTYPE, SKILL_OPEN_LOCK);
         AddMenuSelectionInt("Parry"           , ACTION_SELECT_SUBTYPE, SKILL_PARRY);
         AddMenuSelectionInt("Perform"         , ACTION_SELECT_SUBTYPE, SKILL_PERFORM);
//         AddMenuSelectionInt("Ride"            , ACTION_SELECT_SUBTYPE, SKILL_RIDE);
         AddMenuSelectionInt("Search"          , ACTION_SELECT_SUBTYPE, SKILL_SEARCH);
         AddMenuSelectionInt("Set Trap"        , ACTION_SELECT_SUBTYPE, SKILL_SET_TRAP);
//         AddMenuSelectionInt("Slight of Hand"  , ACTION_SELECT_SUBTYPE, SKILL_SLEIGHT_OF_HAND);
         AddMenuSelectionInt("Spellcraft"      , ACTION_SELECT_SUBTYPE, SKILL_SPELLCRAFT);
         AddMenuSelectionInt("Spot"            , ACTION_SELECT_SUBTYPE, SKILL_SPOT);
         AddMenuSelectionInt("Taunt"           , ACTION_SELECT_SUBTYPE, SKILL_TAUNT);
         AddMenuSelectionInt("Tumble"          , ACTION_SELECT_SUBTYPE, SKILL_TUMBLE);
//         AddMenuSelectionInt("Use Magic Device", ACTION_SELECT_SUBTYPE, SKILL_USE_MAGIC_DEVICE);
         break;

      case PAGE_MENU_SPELLCLASS:
         sMsg = HeaderMsg();
         sMsg += "Select type of Spell Slot to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]"       , PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Bard"         , ACTION_SELECT_SUBTYPE, IP_CONST_CLASS_BARD);
         AddMenuSelectionInt("Cleric"       , ACTION_SELECT_SUBTYPE, IP_CONST_CLASS_CLERIC);
         AddMenuSelectionInt("Druid"        , ACTION_SELECT_SUBTYPE, IP_CONST_CLASS_DRUID);
         AddMenuSelectionInt("Favored Soul" , ACTION_SELECT_SUBTYPE, CLASS_TYPE_FAVORED_SOUL);
         AddMenuSelectionInt("Paladin"      , ACTION_SELECT_SUBTYPE, IP_CONST_CLASS_PALADIN);
         AddMenuSelectionInt("Ranger"       , ACTION_SELECT_SUBTYPE, IP_CONST_CLASS_RANGER);
         AddMenuSelectionInt("Sorceror"     , ACTION_SELECT_SUBTYPE, IP_CONST_CLASS_SORCERER);
         AddMenuSelectionInt("Spirit Shaman", ACTION_SELECT_SUBTYPE, CLASS_TYPE_SPIRIT_SHAMAN);
         AddMenuSelectionInt("Wizard"       , ACTION_SELECT_SUBTYPE, IP_CONST_CLASS_WIZARD);
         break;

      case PAGE_MENU_LIGHT:
         sMsg = HeaderMsg();
         sMsg += "Select the Light color to add:";
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Blue"   , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_BLUE  );
         AddMenuSelectionInt("Green"  , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_GREEN );
         AddMenuSelectionInt("Orange" , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_ORANGE);
         AddMenuSelectionInt("Purple" , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_PURPLE);
         AddMenuSelectionInt("Red"    , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_RED   );
         AddMenuSelectionInt("White"  , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_WHITE );
         AddMenuSelectionInt("Yellow" , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_YELLOW);
         break;

      case PAGE_MENU_VISUALEFFECT:
         sMsg = HeaderMsg();
         sMsg += "Select the Visual Effect to add:";
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         AddMenuSelectionInt("Acid"    , ACTION_SELECT_BONUS, ITEM_VISUAL_ACID    );
         AddMenuSelectionInt("Cold"    , ACTION_SELECT_BONUS, ITEM_VISUAL_COLD    );
         AddMenuSelectionInt("Electric", ACTION_SELECT_BONUS, ITEM_VISUAL_ELECTRICAL);
         AddMenuSelectionInt("Evil"    , ACTION_SELECT_BONUS, ITEM_VISUAL_EVIL    );
         AddMenuSelectionInt("Fire"    , ACTION_SELECT_BONUS, ITEM_VISUAL_FIRE    );
         AddMenuSelectionInt("Holy"    , ACTION_SELECT_BONUS, ITEM_VISUAL_HOLY    );
         AddMenuSelectionInt("Sonic"   , ACTION_SELECT_BONUS, ITEM_VISUAL_SONIC   );
         break;

      case PAGE_MENU_BONUSPLUS:
         sMsg = HeaderMsg();
         if (GetPropType()==ITEM_PROPERTY_ABILITY_BONUS) sTxt = " " + CSLAbilityIPToString(GetSubType());
         else sTxt = CSLItemPropTypeToString(GetPropType());
         sMsg += "Select how much" + sTxt + " to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         for (i=1; i<=GetMaxBonus(); i++) {
            AddMenuSelectionInt("+" + IntToString(i), ACTION_SELECT_BONUS, i);
         }
         break;

      case PAGE_MENU_BONUSDICE:
         sMsg = HeaderMsg();
         if (GetPropType()==ITEM_PROPERTY_DAMAGE_BONUS) {
            iRemain = ItemProps.WeaponDamageMax - ItemProps.WeaponDamageCurrent;
            sMsg += IntToString(iRemain) + " of " + IntToString(ItemProps.WeaponDamageMax) + " bonus damage remaining to add.\n";
            sMsg += "Select the amount of " + CSLIPDamagetypeToString(GetSubType()) + " damage to add:";
         } else {
            iRemain = ItemProps.WeaponMassCritMax;
            sMsg += "Select the amount of Massive Critical damage to add:";
         }
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         if (iRemain >=  4) AddMenuSelectionInt(" 4 : Adds 1d4 / " + IntToString(iRemain-4) + " Remaining" , ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_1d4);
         if (iRemain >=  6) AddMenuSelectionInt(" 6 : Adds 1d6 / " + IntToString(iRemain-6) + " Remaining" , ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_1d6);
         if (iRemain >=  8) AddMenuSelectionInt(" 8 : Adds 2d4 / " + IntToString(iRemain-8) + " Remaining" , ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_2d4);
         if (iRemain >= 10) AddMenuSelectionInt("10 : Adds 1d10 /" + IntToString(iRemain-10) + " Remaining", ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_1d10);
         if (iRemain >= 12) AddMenuSelectionInt("12 : Adds 2d6 / " + IntToString(iRemain-12) + " Remaining" , ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_2d6);
         //AddMenuSelectionInt("2d8" , ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_2d8);
         //AddMenuSelectionInt("2d10", ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_2d10);
         //AddMenuSelectionInt("2d12", ACTION_SELECT_BONUS, IP_CONST_DAMAGEBONUS_2d12);
         break;

      case PAGE_MENU_BONUSDC:
         sMsg = HeaderMsg();
         sMsg += "Select the " + CSLItemPropTypeToString(GetPropType()) + " DC to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         AddMenuSelectionInt("DC 14", ACTION_SELECT_BONUS, IP_CONST_ONHIT_SAVEDC_14);
         AddMenuSelectionInt("DC 16", ACTION_SELECT_BONUS, IP_CONST_ONHIT_SAVEDC_16);
         AddMenuSelectionInt("DC 18", ACTION_SELECT_BONUS, IP_CONST_ONHIT_SAVEDC_18);
         AddMenuSelectionInt("DC 20", ACTION_SELECT_BONUS, IP_CONST_ONHIT_SAVEDC_20);
         AddMenuSelectionInt("DC 22", ACTION_SELECT_BONUS, IP_CONST_ONHIT_SAVEDC_22);
         AddMenuSelectionInt("DC 24", ACTION_SELECT_BONUS, IP_CONST_ONHIT_SAVEDC_24);
         AddMenuSelectionInt("DC 26", ACTION_SELECT_BONUS, IP_CONST_ONHIT_SAVEDC_26);
         break;

      case PAGE_MENU_BONUSRESIST:
         sMsg = HeaderMsg();
         sMsg += "Select the amount of " + CSLIPDamagetypeToString(GetSubType()) + " Resistance to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         AddMenuSelectionInt("5/-",  ACTION_SELECT_BONUS, IP_CONST_DAMAGERESIST_5);
         AddMenuSelectionInt("10/-", ACTION_SELECT_BONUS, IP_CONST_DAMAGERESIST_10);
         //AddMenuSelectionInt("15/-", ACTION_SELECT_BONUS, IP_CONST_DAMAGERESIST_15);
         break;

      case PAGE_MENU_BONUSREDUCT:
         sMsg = HeaderMsg();
         sMsg += "Select the amount of " + CSLIPDamagetypeToString(GetSubType()) + " Reduction to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         AddMenuSelectionInt("3/-",  ACTION_SELECT_BONUS, 3);
         AddMenuSelectionInt("6/-",  ACTION_SELECT_BONUS, 6);
         break;

      case PAGE_MENU_BONUSIMMUNITY:
         sMsg = HeaderMsg();
         sMsg += "Select the amount of " + CSLIPDamagetypeToString(GetSubType()) + " Immunity to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         AddMenuSelectionInt("5%",  ACTION_SELECT_BONUS, IP_CONST_DAMAGEIMMUNITY_5_PERCENT);
         AddMenuSelectionInt("10%", ACTION_SELECT_BONUS, IP_CONST_DAMAGEIMMUNITY_10_PERCENT);
         //AddMenuSelectionInt("25%", ACTION_SELECT_BONUS, IP_CONST_DAMAGEIMMUNITY_25_PERCENT);
         break;

      case PAGE_MENU_BONUSSLOT:
         sMsg = HeaderMsg();
         sMsg += "Select the " + CSLItemPropClassToString(GetSubType()) + " spell level to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", PAGE_MENU_SPELLCLASS);
         for (i=1; i<=MaxSpellSlot(GetSubType()); i++) {
            AddMenuSelectionInt("Level " + IntToString(i), ACTION_SELECT_BONUS, i);
         }
         break;

      case PAGE_MENU_SET_BOXES:
         iRemain = GetBoxCount();
         iStack = GetItemStackSize(oItem);
         sMsg = HeaderMsg();
         sMsg += "How many boxes of " + ItemProps.ItemType + "s do you want to buy?";
         SetPrompt(sMsg);
         AddMenuSelectionInt("[Back]", GetBackPage());
         iRemain = CSLGetMin(50, GetGold(oPC) / (GetGoldPieceValue(oItem)+1)); // MAX STACKS THEY CAN AFFORD OR 50
         AddMenuSelectionInt("1 Box - " + IntToString(iStack) + " " + ItemProps.ItemType + "s", ACTION_SET_BOXES, 1);
         for (i=5; i<=iRemain; i+=5) {
            AddMenuSelectionInt(IntToString(i) + " Boxes - " + IntToString(iStack * i) + " " + ItemProps.ItemType + "s", ACTION_SET_BOXES, i);
         }
         break;

      case PAGE_SHOW_MESSAGE:
         DoShowMessage();
         break;
      case PAGE_CONFIRM_ACTION:
         DoConfirmAction();
         break;
    }
}

void CleanUp() {
    CSLDataArray_DeleteEntire( oPC, CRAFTER_LIST );
    CSLDataArray_DeleteEntire( oPC, CRAFTER_LIST+"_SUB" );
    SetCopiedItem(OBJECT_INVALID);
    DeleteWorkingItem();
}

void main() {
   int iEvent = CSLGetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         Init();
         break;
      case DLG_PAGE_INIT:
         BuildPage(GetNextPage());
         CSLSetShowEndSelection(TRUE);
         CSLSetDlgResponseList(CRAFTER_LIST, oPC);
         break;
      case DLG_SELECTION:
         HandleSelection();
         break;
      case DLG_ABORT:
      case DLG_END:
         CleanUp();
         break;
   }
}