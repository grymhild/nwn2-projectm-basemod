#include "seed_db_inc"

void main(string sText)
{
	object oPC = OBJECT_SELF;
	
	SendMessageToPC(oPC, "Didn't you have a bug you wanted to report?");

	CloseGUIScreen( oPC, "SCREEN_STRINGINPUT_MESSAGEBOX" );
}