#include "_SCInclude_TomeBattle"
#include "_SCInclude_Language"

// this event is designed to enable customization by those using it, and expose something hard to access in a way multiple things can be done with it
// Options in cslpreferences.2da allow existing things to be turned on or off with very little overhead

// this event fires when a player possesses or controls a familar or companion, it's intended to FIX issues in the
// UI caused by a character being changed, and runs with OBJECT_SELF as the character which has this run 0.25 seconds after the switch

// note that this is not always a real switch, this runs when it MIGHT have switched

// currently a lot of things from TOB are integrated into this, but also the language system, and other custom systems
void main()
{
	object oPC = OBJECT_SELF;  //Despite who the player controls OBJECT_SELF is the person that opened the GUI.
	object oCurrentCharacter = GetControlledCharacter(oPC); // this is the actual character now controlled
  
	//AssignCommand(oCurrentCharacter,SpeakString("I am now active "+GetName(oCurrentCharacter) ));
  	if ( CSLGetPreferenceSwitch( "LanguagesEnabled", FALSE) ) // possible to add option for clearing all actions for all players
	{
		CSLLanguageUIChatIconRow( oCurrentCharacter );
	}
	
  	if ( CSLGetPreferenceSwitch( "EnableTomeOfBattle", FALSE) ) // possible to add option for clearing all actions for all players
	{
		TOBCloseScreens(oCurrentCharacter, FALSE);
		DelayCommand(0.05f, TOBOpenScreens(oCurrentCharacter));
	}
  	
  	// update the displayed info, this catches any missed character switches
  	CSLUpdateStatsUIDisplay( oCurrentCharacter );
  	SetLocalGUIVariable(oCurrentCharacter,"SCREEN_PLAYERMENU",999,IntToString(ObjectToInt(oCurrentCharacter))); 
}