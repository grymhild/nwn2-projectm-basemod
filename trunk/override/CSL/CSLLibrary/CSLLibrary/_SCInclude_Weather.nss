/** @file
* @brief Include file for Weather and related User Interfaces
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_CSLCore_UI"
#include "_CSLCore_Environment"
#include "_CSLCore_Player"


void SCWeather_Display( object oTargetToDisplay, object oPC = OBJECT_SELF, string sScreenName = SCREEN_WEATHER )
{
	if ( !GetIsObjectValid( oTargetToDisplay) )
	{
		CloseGUIScreen( oPC,sScreenName );
		return;
	}

	//CSLDMVariable_SetLvmTarget(oPCToShowVars, oTargetToDisplay);
	DisplayGuiScreen(oPC, sScreenName, FALSE, XML_WEATHER);
	//CSLDMVariable_InitTargetVarRepository (oPCToShowVars, oTargetToDisplay);
	//SCCacheStats( oTargetToDisplay );
	//DelayCommand( 0.5, SCCharEdit_Build( oTargetToDisplay, oPC, sScreenName ) );
}