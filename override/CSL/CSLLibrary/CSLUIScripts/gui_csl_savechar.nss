#include "seed_db_inc"


void main()
{
	//Trim the value string.
	//sValue = GetStringRight(sValue, GetStringLength(sValue) - 17);
	
	object oChar = OBJECT_SELF;
	
	// Prevent abuse of this, only once every 12 seconds, or rather less often
	int bJustRan = CSLIncrementLocalInt_Timed(oChar, "SCREEN_SAVED", 12.0, 1);
	if ( bJustRan > 1 )
	{
		SendMessageToPC( oChar, "Please only hit Save Character once");
	}
	else
	{
		
		// SetGUIObjectHidden(oChar, "SCREEN_PLAYERMENU", GUI_PLAYERMENU_AI_OFF_BUTTON, nAllPuppetMode!=1);
		SetGUIObjectDisabled( oChar, "SCREEN_PLAYERMENU", "SAVE_TOGGLE_BUTTON", TRUE );
		DelayCommand( 30.0f, SetGUIObjectDisabled( oChar, "SCREEN_PLAYERMENU", "SAVE_TOGGLE_BUTTON", FALSE ) );
		
		SDB_UpdatePlayerStatus(oChar);
	}
}