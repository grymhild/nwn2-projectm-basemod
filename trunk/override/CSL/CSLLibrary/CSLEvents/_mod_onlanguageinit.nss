/*
This runs on creation of a new character, or upon the character entering the
server for the first time.

It looks for the feat FEAT_LANG_BASE to determine if it's been run yet.
*/
#include "_SCInclude_Language"


void main()
{
	object oPC = OBJECT_SELF;
	//DEBUGGING = 10;
	//SendMessageToPC( GetFirstPC(), "Language Init is being run");
	if ( !GetHasFeat( FEAT_LANG_BASE, oPC ) ) // this is run the first time around only, soas anything that needs to be merged can be done
	{
		if( CSLGetPreferenceSwitch("LanguagesEnabled", FALSE ) )
		{
			//SendMessageToPC( GetFirstPC(), "Language Init Processing");
			
			if ( !CSLLanguagesGetIsLoaded( ) || IsInConversation( oPC ) )
			{
				//SendMessageToPC( GetFirstPC(), "Not Yet Loaded");
				// Dataobjects are not loaded yet, delay this script until they are ready
				DelayCommand( 9.0f, ExecuteScript("_mod_onlanguageinit", oPC));
				return;
			}
			
			// set up initial language points to start with
			// note lore adjustments will be added in via the get function ( any lore points added also add language points )
			//int iBaseModifier = (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE)-10)/2;
			//int iLanguagePoints = CSLGetMax(1+iBaseModifier,0);
			
			//SendMessageToPC(oPC,"iBaseModifier="+IntToString(iBaseModifier)+" iLanguagePoints="+IntToString(iLanguagePoints) );
			
			//CSLLanguageAdjustLanguagePoints( iLanguagePoints, oPC );
			
			
			int iNewLanguagePoints = CSLFeatGroupToInteger( 8800, 8807, oPC );
			//SendMessageToPC(oPC,"iNewLanguagePoints="+IntToString(iNewLanguagePoints)+" should be the same as iLanguagePoints="+IntToString(iLanguagePoints) );
			// place in code to refer to "csl_lang_regions.2da"
			// ie use a look up to get a regional feat such as FEAT_REGION_MOONSEA, and
			// based on that it's row 26 in the 2da (which is set up for the Moonsea region).
			// or do it based on the current area they are in, opposed to regional feats and
			// just use the regional feat for choices on initializaton
			//SendMessageToPC(oPC,"B");
			int iRegion = -1;
			//SendMessageToPC(oPC,"C");
			// this adds any automatically granted languages, and returns the available languages the player can still take
			string sLanguageOptions = CSLLanguageDetermineAvailable( oPC, iRegion  );
			//SendMessageToPC(oPC,"D");
			// now do a dialog showing the options the player can now choose
			DelayCommand( 0.0f, CSLLanguageOpenChooser( oPC, sLanguageOptions ) );
			//SendMessageToPC(oPC,"E");
			DelayCommand( 0.0f, CSLLanguageUIChatIconRow( oPC ) );
			//SendMessageToPC(oPC,"F");
		}
	
	}
	//SendMessageToPC(oPC,"G");
	DelayCommand( 0.0f, CSLLanguageUIChatIconRow( oPC ) );
}