//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
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


	/*
	sParameters = CSLNth_Shift(sParameters, " ");
	string sVar = CSLNth_GetLast();
	sParameters = CSLNth_Shift(sParameters, " ");
	string sValue = CSLNth_GetLast();
	
	int iReturnVal = CSLModifyLocalIntWithRollString(oTarget, sVar, sValue);
	*/
	int iLanguagePoints = CSLFeatGroupToInteger( 8800, 8807, oTarget );
	
	

	CSLIntegerToFeatGroup( iLanguagePoints+StringToInt(sParameters ), 8800, 8807, oTarget );
	
	int iNewLanguagePoints = CSLFeatGroupToInteger( 8800, 8807, oTarget );

	SendMessageToPC(oDM, "Modified "+sParameters+" from" + IntToString(iLanguagePoints  ) +  " to " + IntToString(iNewLanguagePoints ) + " on " + GetName(oTarget));
}