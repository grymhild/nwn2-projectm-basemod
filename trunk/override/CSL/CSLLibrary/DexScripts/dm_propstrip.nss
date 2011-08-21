#include "_CSLCore_Items"
//#include "dmfi_inc_conv"
#include "seed_db_inc"
#include "_CSLCore_Items"
#include "_SCInclude_DynamConvos"

// PERSIST VARIABLE STRINGS
const string CRAFTER_LIST        = "CRAFTER_LIST";
const string CRAFTER_CONFIRM     = "CRAFTER_CONFIRM";

// PAGES
const int PAGE_MENU_MAIN          =   1;
const int PAGE_SHOW_MESSAGE       =   2;
const int PAGE_CONFIRM_ACTION     =   3;
const int PAGE_MENU_REMOVE        =  32;

const int ACTION_CONFIRM          = 101;
const int ACTION_CANCEL           = 102;
const int ACTION_END_CONVO        = 103;
const int ACTION_REMOVE_PROP      = 112;
const int ACTION_EXAMINE_ITEM     = 113;

const int TEXT_COLOR = COLOR_BLUE;

void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = CRAFTER_LIST);
void   DoConfirmAction();
void   DoShowMessage();
int    GetConfirmedAction();
int    GetNextPage();
int    GetPageOptionSelected(string sList = CRAFTER_LIST);
int    GetPageOptionSelectedInt(string sList = CRAFTER_LIST);
void   SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No");
void   SetNextPage(int nPage);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO);

object oPC = CSLGetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = CRAFTER_LIST) {
   CSLDataArray_SetInt(oPC, sList, CSLDataArray_PushString( oPC, sList, CSLColorText(sSelectionText, TEXT_COLOR) ), nSelectionValue );
   CSLDataArray_PushInt( oPC, sList+"_SUB", nSubValue);
}
void SetPrompt(string sText) {
   CSLSetDlgPrompt(CSLColorText(sText, TEXT_COLOR));
}
int GetPageOptionSelected(string sList = CRAFTER_LIST) {
   return CSLDataArray_GetInt( oPC, sList, CSLGetDlgSelection() );
}
int GetPageOptionSelectedInt(string sList = CRAFTER_LIST) {
   return CSLDataArray_GetInt( oPC, sList + "_SUB", CSLGetDlgSelection() );
}
int GetNextPage() {
   return GetLocalInt(oPC, CRAFTER_LIST + "_NEXTPAGE");
}
void SetNextPage(int nPage) {
   SetLocalInt(oPC, CRAFTER_LIST + "_NEXTPAGE", nPage);
}
object GetWorkingItem() {
    return GetLocalObject(oPC, "DM_STRIP");
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


/*
struct ItemPropsStruct {
   int ItemLevel;
   int ItemCost;
   int Prop1Type;    int Prop1SubType;    int Prop1Bonus;   string Prop1Desc;
   int Prop2Type;    int Prop2SubType;    int Prop2Bonus;   string Prop2Desc;
   int Prop3Type;    int Prop3SubType;    int Prop3Bonus;   string Prop3Desc;
   int Prop4Type;    int Prop4SubType;    int Prop4Bonus;   string Prop4Desc;
   int Prop5Type;    int Prop5SubType;    int Prop5Bonus;   string Prop5Desc;
   int Prop6Type;    int Prop6SubType;    int Prop6Bonus;   string Prop6Desc;
   int Prop7Type;    int Prop7SubType;    int Prop7Bonus;   string Prop7Desc;
   int Prop8Type;    int Prop8SubType;    int Prop8Bonus;   string Prop8Desc;
   int PropCount;
   string PropList;
};
*/

//struct ItemPropsStruct ItemProps;



void DMFILoadItemProps(object oItem)
{
   int iPropType;
   int iSubType;
   int iBonus;
   string sPropDesc;
   int iPropCnt = 0;
   ItemProps.ItemLevel = CSLGetItemLevel(GetGoldPieceValue(oItem));
   ItemProps.ItemCost = GetGoldPieceValue(oItem);

   itemproperty ipProperty =  GetFirstItemProperty(oItem);
   ItemProps.PropList = "None";
   while (GetIsItemPropertyValid(ipProperty))
   {
      iPropCnt++;
      iPropType = GetItemPropertyType(ipProperty);
      iSubType=GetItemPropertySubType(ipProperty);
      iBonus = GetItemPropertyCostTableValue(ipProperty);
      int iParam1 = GetItemPropertyParam1Value(ipProperty);
      sPropDesc = CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1);
      CSLSetProp(iPropCnt, iPropType, iSubType, iBonus, sPropDesc);
      ipProperty =  GetNextItemProperty(oItem);
   }

}

void Init()
{
   SetNextPage(PAGE_MENU_MAIN);
}

void HandleSelection()
{
   object oItem = GetWorkingItem();
   int iSelection = CSLGetDlgSelection(); // THE NUMBER OF THE OPTION SELECTED
   int iOptionSelected = GetPageOptionSelected(); // THE ACTION/PAGE ASSOCIATED WITH THE OPTION
   int iOptionSubSelected = GetPageOptionSelectedInt(); // THE SUB VALUE ASSOCIATED WITH THE OPTION
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
   int iStack = 1;

   switch (iOptionSelected) {
      // ********************************
      // HANDLE SIMPLE PAGE TURNING FIRST
      // ********************************
      case PAGE_MENU_MAIN        :
      case PAGE_SHOW_MESSAGE     :
      case PAGE_CONFIRM_ACTION   :
      case PAGE_MENU_REMOVE      :
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
         //AssignCommand(oPC, ActionExamine(oItem));
         
		if ( GetIsObjectValid( oItem ) )
		{
			DisplayGuiScreen(oPC, "SCREEN_INVENTORY", FALSE);
			
			oItem = CopyItem(oItem, oPC, TRUE);
			if ( GetIsObjectValid( oItem ) )
			{
				SetIdentified(oItem, TRUE);
				//DelayCommand(0.4, AssignCommand(oPC, ActionExamine(oItem)));
				CSLExamine( oItem, oPC, 0.4 );
				DestroyObject(oItem, 0.6, FALSE);
			}
			DelayCommand(0.6, CloseGUIScreen(oPC, "SCREEN_INVENTORY"));
		}
         return;

      case ACTION_REMOVE_PROP:
         ipProperty =  GetFirstItemProperty(oItem);
         sText = "All Properties ";
         ItemProps.PropList = "None";
         SetLocalInt(oPC, "REMPROP", iOptionSubSelected);
         SetLocalInt(oPC, "REMPROPSUB", iOptionSubSelected);
         while (GetIsItemPropertyValid(ipProperty)) {
            iPropCnt++;
            iPropSeq++;
            iPropType = GetItemPropertyType(ipProperty);
            iSubType = GetItemPropertySubType(ipProperty);
            iBonus = GetItemPropertyCostTableValue(ipProperty);
            int iParam1 = GetItemPropertyParam1Value(ipProperty);
            if (iPropSeq==iOptionSubSelected || iOptionSubSelected==0) {
               //RemoveItemProperty(oItem, ipProperty);
               iPropCnt--;
               if (iOptionSubSelected!=0) {
                  sText = CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1);
               }
            } else {
               CSLSetProp(iPropSeq, iPropType, iSubType, iBonus, CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1));
            }
            ipProperty = GetNextItemProperty(oItem);
         }
         sText = "Remove " + sText+ "?\n\n" + "Properties:   " + ItemProps.PropList + "\n\n";
         SetShowMessage(sText, PAGE_MENU_MAIN);
         SetConfirmAction(sText, ACTION_REMOVE_PROP, PAGE_MENU_MAIN);
         return;


      // *****************************************
      // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
      // *****************************************
      case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
         iConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
         switch (iConfirmed) {
            case ACTION_REMOVE_PROP:
               iOptionSubSelected = GetLocalInt(oPC, "REMPROP");
               iOptionSubSelected = GetLocalInt(oPC, "REMPROPSUB");

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
                  if (iPropSeq==iOptionSubSelected || iOptionSubSelected==0) {
                     RemoveItemProperty(oItem, ipProperty);
                     iPropCnt--;
                     if (iOptionSubSelected!=0) {
                        sText = CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1);
                     }
                  } else {
                     CSLSetProp(iPropSeq, iPropType, iSubType, iBonus, CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1));
                  }
                  ipProperty = GetNextItemProperty(oItem);
               }
               sText = "Removed " + sText+ "\n\n" + "Properties:   " + ItemProps.PropList + "\n\n";
               SetShowMessage(sText, PAGE_MENU_MAIN);
               return;
       }
    }
    SetNextPage(PAGE_MENU_MAIN); // If broken, send to main menu
}

void BuildPage(int nPage) {
   CSLDataArray_DeleteEntire(oPC, CRAFTER_LIST );
   CSLDataArray_DeleteEntire(oPC, CRAFTER_LIST+"_SUB");
   string sMsg;
   int i = 0;
   object oItem = GetWorkingItem();
   DMFILoadItemProps(oItem);
   switch (nPage) {
      case PAGE_MENU_MAIN:
         SetPrompt("Property Stripper!\n\nSelect the Property to remove:");
         AddMenuSelectionInt("Examine", ACTION_EXAMINE_ITEM);
         if (ItemProps.Prop1Desc!="") AddMenuSelectionInt(ItemProps.Prop1Desc, ACTION_REMOVE_PROP, 1);
         if (ItemProps.Prop2Desc!="") AddMenuSelectionInt(ItemProps.Prop2Desc, ACTION_REMOVE_PROP, 2);
         if (ItemProps.Prop3Desc!="") AddMenuSelectionInt(ItemProps.Prop3Desc, ACTION_REMOVE_PROP, 3);
         if (ItemProps.Prop4Desc!="") AddMenuSelectionInt(ItemProps.Prop4Desc, ACTION_REMOVE_PROP, 4);
         if (ItemProps.Prop5Desc!="") AddMenuSelectionInt(ItemProps.Prop5Desc, ACTION_REMOVE_PROP, 5);
         if (ItemProps.Prop6Desc!="") AddMenuSelectionInt(ItemProps.Prop6Desc, ACTION_REMOVE_PROP, 6);
         if (ItemProps.Prop7Desc!="") AddMenuSelectionInt(ItemProps.Prop7Desc, ACTION_REMOVE_PROP, 7);
         if (ItemProps.Prop8Desc!="") AddMenuSelectionInt(ItemProps.Prop8Desc, ACTION_REMOVE_PROP, 8);
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
    CSLDataArray_DeleteEntire(oPC, CRAFTER_LIST );
    CSLDataArray_DeleteEntire(oPC, CRAFTER_LIST+"_SUB" );
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