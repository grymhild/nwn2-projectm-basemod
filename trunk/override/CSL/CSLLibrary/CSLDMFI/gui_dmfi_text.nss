////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_text - DM Friendly Initiative - Code to run all voice throw / language code
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/25/7
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// Script runs DM and Player side code for handling text entered from input box.

//#include "dmfi_inc_initial"
//#include "dmfi_inc_emotes"
#include "_SCInclude_DMFI"


void main (string sInput)
{
	//int nState;
	object oPC = GetControlledCharacter(OBJECT_SELF);
	//object oTarget, oTool;
	//string sLang = GetLocalString(OBJECT_SELF, DMFI_LANGUAGE_TOGGLE);
	///string sLangTest = GetLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
	//string sConvertUsing, sTest;
	
	//CSLMessage_SendText(oPC, "DEBUGGING: sLang from ObjectSelf: " + sLang + " : " +GetName(OBJECT_SELF));	
	
	if (sInput==".language_off")
	{ // Close button on UI
		//DMFI_LanguageOff(oPC);
		return;
	}	
	
	SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "INPUT_BOX", -1, "");
	//oTarget = GetPlayerCurrentTarget(oPC);
	
	
	SendChatMessage(oPC, OBJECT_INVALID, CHAT_MODE_TALK, sInput, TRUE );
	
	
}	