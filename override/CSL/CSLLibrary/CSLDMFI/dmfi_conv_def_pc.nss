////////////////////////////////////////////////////////////////////////////////
// dmfi_conv_def_pc - DM Friendly Initiative -  Defines Player Conversation Tokens
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/14/7
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "_SCInclude_DMFI"

void DMFI_phase3( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase3 Start", GetFirstPC() ); }
	//////////////////////////////////// LIST LANGUAGE PAGE ////////////////////////
	DMFI_AddPage(oTool, "LIST_LANGUAGE");
	
	DMFI_AddPage(oTool, "LIST_DMLANGUAGE");
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase3 End", GetFirstPC() ); }
	//DelayCommand(2.0, DMFI_BuildLanguageDMList(oTool));
}

void DMFI_phase2( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase2 Start", GetFirstPC() ); }
	//////////////////////////////////// SMALL NUMBER PAGE /////////////////////////
	int n;
	DMFI_AddPage(oTool, "LIST_10");
	for (n=1; n<9; n=n+1)
	{
		DMFI_AddConversationElement(oTool, "LIST_10", IntToString(n));
	}
	
	//////////////////////////////////// LIST DICE OPTIONS /////////////////////////
	DMFI_AddPage(oTool, "LIST_DICE");
	
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D2);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D3);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D4);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D6);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D8);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D10);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D12);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D20);
	DMFI_AddConversationElement(oTool, "LIST_DICE", CV_LD_D100);
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase2 End", GetFirstPC() ); }
	DelayCommand(2.0, DMFI_phase3( oTool ) );
}


void DMFI_phase1( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase1 Start", GetFirstPC() ); }
	////////////////////////////////////// TARGET ABILITY //////////////////////////
	DMFI_AddPage(oTool, "LIST_ABILITY");
	
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_ABL_STRENGTH) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "str");
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_ABL_DEXTERITY) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+  "dex");
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_ABL_CONSTITUTION) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+  "cons");
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_ABL_INTELLIGENCE) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+  "inte");
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_ABL_WISDOM) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+ "wis");
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_ABL_CHARISMA) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "cha");
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_SAVE_FORTITUDE) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "fort", COLOR_ORANGE);
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_SAVE_REFLEX) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "ref", COLOR_ORANGE);
	DMFI_AddConversationElement(oTool, "LIST_ABILITY", CSLStringToProper(EMT_SAVE_WILL) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "wil", COLOR_ORANGE);
	
	//////////////////////////////////// TARGET SKILL PAGE /////////////////////////
	DMFI_AddPage(oTool, "LIST SKILL");
	DMFI_Build2DAList(oTool, "LIST SKILL", "skills");
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase1 End", GetFirstPC() ); }
	DelayCommand(2.0, DMFI_phase2( oTool ) );
}


void main()
{
	if (DEBUGGING >= 6) { CSLDebug(  "dmfi_conv_def_pc", GetFirstPC() ); }
	object oTool = OBJECT_SELF;
	
	DelayCommand(2.0, DMFI_phase1( oTool ) );
}