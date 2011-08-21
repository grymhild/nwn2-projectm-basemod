//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	if ( !GetIsObjectValid(oTarget))
	{
		oTarget = oDM;
	}
	//sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 7);
	object oNewItem = CreateItemOnObject(sParameters, oTarget);
	if (GetIsObjectValid(oNewItem))
	{
		SendMessageToPC(oDM, "<color=indianred>"+"You have created a "+ GetName(oNewItem) +" on "+ GetName(oTarget) + "!"+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"Invalid ResRef! Cannot create " + sParameters + " on " + GetName(oTarget)+"</color>");
	}


}