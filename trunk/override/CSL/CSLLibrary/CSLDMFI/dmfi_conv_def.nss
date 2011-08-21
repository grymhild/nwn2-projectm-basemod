////////////////////////////////////////////////////////////////////////////////
// dmfi_conv_def - DM Friendly Initiative -  Defines DM Conversation Tokens
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/12/7  Qk 10/08/07
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "_SCInclude_DMFI"

void DMFI_phase5( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase5 Start", GetFirstPC() ); }
	
	///////////////////////////////////// TARGET_EFFECT PAGE /////////////////////////
	DMFI_AddPage(oTool, "TARGET_EFFECT");
	
	///////////////////////////////////// LIST_EFFECT PAGE /////////////////////////
	DMFI_AddPage(oTool, "LIST_EFFECT");
	
	/////////////////////////////////////// TARGET_SOUND PAGE /////////////////////////
	DMFI_AddPage(oTool, "LIST_SOUND_CITY");
	DMFI_AddPage(oTool, "LIST_SOUND_MAGIC");
	DMFI_AddPage(oTool, "LIST_SOUND_NATURE");
	DMFI_AddPage(oTool, "LIST_SOUND_PEOPLE");
	
	DelayCommand(6.0, DMFI_BuildPlaceableSoundList(oTool));
	//return;
	//////////////////////////////////////APPEARANCE TYPE DATA///////////////////////
	
	DMFI_AddPage(oTool, "LIST_APPEARANCE");
	//DelayCommand(8.0, DMFI_BuildAppearanceList(oTool));
	
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase5 End", GetFirstPC() ); }	
}


void DMFI_phase4( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase4 Start", GetFirstPC() ); }
	
	///////////////////////////////////// DURATION VALUE PAGE //////////////////////////
	DMFI_AddPage(oTool, "LIST_DURATIONS");
	SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", "LIST_DURATIONS");
	CSLAddReplyLinkInt("5", "", COLOR_NONE, 5);
	CSLAddReplyLinkInt("10", "", COLOR_NONE, 10);
	CSLAddReplyLinkInt("20", "", COLOR_NONE, 20);
	CSLAddReplyLinkInt("40", "", COLOR_NONE, 40);
	CSLAddReplyLinkInt("60", "", COLOR_NONE, 60);
	CSLAddReplyLinkInt("90", "", COLOR_NONE, 90);
	CSLAddReplyLinkInt("120", "", COLOR_NONE, 120);
	CSLAddReplyLinkInt("180", "", COLOR_NONE, 180);
	CSLAddReplyLinkInt("300", "", COLOR_NONE, 300);
	CSLAddReplyLinkInt("99999", "", COLOR_NONE, 99999);
	
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
	

	DelayCommand(2.0, DMFI_phase5( oTool ) );
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase4 End", GetFirstPC() ); }	
}

void DMFI_phase3( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase3 Start", GetFirstPC() ); }
	
		//////////////////////////////////// SIMPLE NUMBER PAGES ///////////////////////
	int n;
	DMFI_AddPage(oTool, "LIST_50");
	for (n=0; n<51; n++)
	{
		DMFI_AddConversationElement(oTool, "LIST_50", IntToString(n));
	}
	
	DMFI_AddPage(oTool, "LIST_300");										
	for (n=10; n<301; n=n+10)
	{
		DMFI_AddConversationElement(oTool, "LIST_300", IntToString(n));
	}
	
	DMFI_AddPage(oTool, "LIST_100");
	for (n=10; n<101; n=n+10)
	{
		DMFI_AddConversationElement(oTool, "LIST_100", IntToString(n));
	}
		
	DMFI_AddPage(oTool, "LIST_10");
	for (n=1; n<10; n=n+1)
	{
		DMFI_AddConversationElement(oTool, "LIST_10", IntToString(n));
	}
	
	DMFI_AddPage(oTool, "LIST_24");											
	for (n=1; n<25; n++)
	{
		DMFI_AddConversationElement(oTool, "LIST_24", IntToString(n));
	}
	
	//////////////////////////////////// DM LANGUAGE LIST - COMPLETE LISTING //////////
	DMFI_AddPage(oTool, "LIST_DMLANGUAGE");
	//DelayCommand(3.0,DMFI_BuildLanguageDMList(oTool));
	
	DelayCommand(2.0, DMFI_phase4( oTool ) );
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase3 End", GetFirstPC() ); }	
}

void DMFI_phase2( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase2 Start", GetFirstPC() ); }
	
	////////////////////////////////////// TARGET_VFX PAGE /////////////////////////
	DMFI_AddPage(oTool, "LIST_VFX_SPELL");
	DMFI_AddPage(oTool, "LIST_VFX_IMP");
	DMFI_AddPage(oTool, "LIST_VFX_DUR");
	DMFI_AddPage(oTool, "LIST_VFX_MISC");
	
	DelayCommand(3.0, DMFI_BuildVFXList(oTool));
	
	DMFI_AddPage(oTool, "LIST_VFX_RECENT");
	
	//////////////////////////////////// TAREGET DISEASE PAGE //////////////////////
	DMFI_AddPage(oTool, "LIST_DISEASE");
	DelayCommand(5.0,DMFI_Build2DAList(oTool, "LIST_DISEASE", "disease"));
	
	//////////////////////////////////// TAREGET DISEASE PAGE //////////////////////
	DMFI_AddPage(oTool, "LIST_POISON");
	DelayCommand(7.0,DMFI_Build2DAList(oTool, "LIST_POISON", "poison"));
	
	DelayCommand(2.0, DMFI_phase3( oTool ) );
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase2 End", GetFirstPC() ); }	
}

void DMFI_phase1( object oTool )
{
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase1 Start", GetFirstPC() ); }
	
		//////////////////////////////////// TARGET_MUSIC PAGE /////////////////////////
	DMFI_AddPage(oTool, "LIST_MUSIC_NWN2");
	DMFI_AddPage(oTool, "LIST_MUSIC_NWN1");
	DMFI_AddPage(oTool, "LIST_MUSIC_XP");
	DMFI_AddPage(oTool, "LIST_MUSIC_BATTLE");
	DMFI_AddPage(oTool, "LIST_MUSIC_MOTB");
		
	DelayCommand(2.0,DMFI_Build2DAAMusicList());
	
	////////////////////////////////// TARGET_AMBIENT PAGE /////////////////////////
	DMFI_AddPage(oTool, "LIST_AMBIENT_CAVE");
	DMFI_AddPage(oTool, "LIST_AMBIENT_MAGIC");
	DMFI_AddPage(oTool, "LIST_AMBIENT_PEOPLE");
	DMFI_AddPage(oTool, "LIST_AMBIENT_MISC");
	
	DelayCommand(2.0,DMFI_Build2DAASoundsList());
	
	////////////////////////////////////// TARGET ABILITY //////////////////////////
	DMFI_AddPage(oTool, "LIST_ABILITY");
	
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_ABL_STRENGTH) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "str");
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_ABL_DEXTERITY) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+  "dex");
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_ABL_CONSTITUTION) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+  "cons");
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_ABL_INTELLIGENCE) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+  "inte");
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_ABL_WISDOM) , CHAT_DMCOMMAND_SYMBOL + "roll"  +" "+ "wis");
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_ABL_CHARISMA) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "cha");
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_SAVE_FORTITUDE) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "fort", COLOR_ORANGE);
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_SAVE_REFLEX) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "ref", COLOR_ORANGE);
	DMFI_AddConversationElement(oTool,  "LIST_ABILITY",        CSLStringToProper(EMT_SAVE_WILL) , CHAT_DMCOMMAND_SYMBOL + "roll" +" "+ "wil", COLOR_ORANGE);
	
	//////////////////////////////////// TARGET SKILL PAGE /////////////////////////
	DMFI_AddPage(oTool, "LIST SKILL");
	DelayCommand(3.0,DMFI_Build2DAList(oTool, "LIST SKILL", "skills"));
	
	DelayCommand(2.0, DMFI_phase2( oTool ) );
	if (DEBUGGING >= 6) { CSLDebug(  "DMFI_phase1 End", GetFirstPC() ); }	
}

void main()
{
	// if (DEBUGGING >= 8) { CSLDebug(  "dmfi_conv_def Start", oPC ); }
	if (DEBUGGING >= 6) { CSLDebug(  "dmfi_conv_def", GetFirstPC() ); }
	object oTool = OBJECT_SELF;
	
	DelayCommand(2.0, DMFI_phase1( oTool ) );
	
	
	SetLocalObject(oTool, "DLG_HOLDER", oTool);  // Required for new CTDS functions
	///////////////////////////// INTRODUCTION PAGE ////////////////////////////////
}