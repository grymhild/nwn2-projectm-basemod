//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_CSLCore_Position"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_NONE ) )
	{
		return;
	}
	if ( !GetIsObjectValid(oTarget))
	{
		oTarget = oDM;
	}
		
	CreateObject(OBJECT_TYPE_PLACEABLE, sParameters, CSLGetAheadLocation(oDM), FALSE, sParameters);
	//sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 7);
	/*
	object oNewItem = CreateItemOnObject(sParameters, oTarget);
	if (GetIsObjectValid(oNewItem))
	{
		SendMessageToPC(oDM, "<color=indianred>"+"You have created a "+ GetName(oNewItem) +" on "+ GetName(oTarget) + "!"+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"Invalid ResRef! Cannot create " + sParameters + " on " + GetName(oTarget)+"</color>");
	}
	*/

}