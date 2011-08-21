/*
This runs after level up is completed, offering the player the option to select
languages desired, and adding any automatic languages.

*/
#include "_SCInclude_Language"

void main()
{
	object oPC = OBJECT_SELF;
	if( CSLGetPreferenceSwitch("LanguagesEnabled", FALSE ) )
	{
		if ( !CSLLanguagesGetIsLoaded( ) )
		{
			// Dataobjects are not loaded yet, delay this script until they are ready
			DelayCommand( 9.0f, ExecuteScript("_mod_onlanguagelevelup", oPC));
			return;
		}
		
		// place in code to refer to "csl_lang_regions.2da"
		// ie use a look up to get a regional feat such as FEAT_REGION_MOONSEA, and
		// based on that it's row 26 in the 2da (which is set up for the Moonsea region).
		// or do it based on the current area they are in, opposed to regional feats and
		// just use the regional feat for choices on initializaton
		
		int iRegion = -1;
		
		// this adds any automatically granted
		string sLanguageOptions = CSLLanguageDetermineAvailable( oPC, iRegion  );
		
		
		// now do a dialog showing the options the player can now choose
		CSLLanguageOpenChooser( oPC, sLanguageOptions );
	}
	
}