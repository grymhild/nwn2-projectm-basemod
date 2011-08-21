#include "seed_db_inc"

void main(string sText)
{
	object oPC = OBJECT_SELF;
	if ( sText != "" )
	{
		SDB_LogMsg("BUG", sText + " >>" + CSLSerializeLocation(GetLocation(oPC)), oPC);
		SendMessageToPC(oPC, "Thanks for helping make DEX better...");
	}
	else
	{
		SendMessageToPC(oPC, "Didn't you have a bug you wanted to report?");
	}
	
	
	CloseGUIScreen( oPC, "SCREEN_STRINGINPUT_MESSAGEBOX" );
}