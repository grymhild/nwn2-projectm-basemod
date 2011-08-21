//#include "_SCUtility"
#include "_SCInclude_Language"
//#include "_SCInclude_DMInven"


void main( string sInput, string sPreviousSetting ) // , string sPlayerID = ""
{

	object oPlayer = GetControlledCharacter(OBJECT_SELF);
	
	sInput = GetStringLowerCase( sInput );
	
	//SendMessageToPC( oPlayer,  "sInput="+sInput );
	//object oTarget;
	//oTarget = IntToObject(StringToInt(sPlayerID));
	//if ( oPC != oTarget )
	//{
	//
	//}
	
	if ( sInput == "load" )
	{
		//SendMessageToPC( GetFirstPC(),  "Loading sPreviousSetting="+sPreviousSetting );
		CSLLanguageUIChatIconRow( oPlayer );
	}
	else if ( sInput == "off" )
	{
		CSLLanguageUseNone( oPlayer );
	
	}
	else
	{
		//SendMessageToPC( oPlayer,  "sInput="+sInput + " and sCurrentString"+sCurrentString );
		CSLLanguageUse( sInput, oPlayer );
	}
}