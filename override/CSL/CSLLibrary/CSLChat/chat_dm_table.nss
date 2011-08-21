//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_DMInven"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	
	
	SendMessageToPC(oDM, "Version 2" );
	
	string sNewParameters = CSLNth_Shift( GetStringLowerCase( sParameters ), " ");
	string sCommand = CSLNth_GetLast();
	SendMessageToPC(oDM, "sCommand="+sCommand );
	if ( sCommand != "show" && sCommand != "get" && sCommand != "set")
	{
		string sMessage = "DM_Table Commands"+"\n";
		sMessage += "DM_Table Show [2daName]"+"\n";
		sMessage += "DM_Table Get [2daName] [Row] [Field]"+"\n";
		SendMessageToPC(oDM, sMessage );
		return;
	}
	
	
	sNewParameters = CSLNth_Shift( sNewParameters , " ");
	string s2DA = CSLNth_GetLast();
	sNewParameters = CSLNth_Shift( sNewParameters , " ");
	int iRow = StringToInt( CSLNth_GetLast() );
	sNewParameters = CSLNth_Shift( sNewParameters , " ");
	string sField = CSLNth_GetLast();
	SendMessageToPC(oDM, "s2DA="+s2DA );
	SendMessageToPC(oDM, "iRow="+IntToString(iRow) );
	SendMessageToPC(oDM, "sField="+sField );
	
	object oTable = CSLDataObjectGet( s2DA );
	
	if ( GetIsObjectValid( oTable ) )
	{
		
		
		if ( sCommand == "show" )
		{
			CSLDMVariable_Display( oTable, oDM );
			return;
		}
		
		if ( sCommand == "get" )
		{
			iRow = CSLDataTableGetRowByIndex( oTable, iRow );
			string sString = CSLDataTableGetStringByRow( oTable, sField, iRow );
			SendMessageToPC(oDM, sField+" on row "+IntToString(iRow)+" is "+sString );
			return;
		}
		
		
	}
	else
	{
		SendMessageToPC(oDM, s2DA+" Is Not a Valid Data Object");
	}
}