/*
This runs on creation of a new character, or upon the character entering the
server for the first time.

It looks for the feat FEAT_LANG_BASE to determine if it's been run yet.
*/
#include "_SCInclude_Chat"
#include "_SCInclude_Language"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	object oPC = oDM;
	
			
	//SendMessageToPC(oPC,"Initing");
	// place in code to refer to "csl_lang_regions.2da"
	// ie use a look up to get a regional feat such as FEAT_REGION_MOONSEA, and
	// based on that it's row 26 in the 2da (which is set up for the Moonsea region).
	// or do it based on the current area they are in, opposed to regional feats and
	// just use the regional feat for choices on initializaton
	
	int iRegion = -1;
	
	// this adds any automatically granted languages, and returns the available languages the player can still take
	string sLanguageOptions = CSLLanguageDetermineAvailable( oPC, iRegion  );
	SendMessageToPC(oPC,"Debugging: "+sLanguageOptions);
	// now do a dialog showing the options the player can now choose
	CSLLanguageOpenChooser( oPC, sLanguageOptions );
	CSLLanguageUIChatIconRow( oPC );
}