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
	
	object oNewItem;
	sParameters = CSLNth_Shift(sParameters, " ");
	string sVar = CSLNth_GetLast();
	SendMessageToPC(oDM, GetName(oTarget) + " : " + sVar + " : Str : " +  GetLocalString(oTarget, sVar));
	SendMessageToPC(oDM, GetName(oTarget) + " : " + sVar + " : Int : " + IntToString(GetLocalInt(oTarget, sVar)));
	SendMessageToPC(oDM, GetName(oTarget) + " : " + sVar + " : Flt : " + FloatToString(GetLocalFloat(oTarget, sVar)));
	oNewItem = GetLocalObject(oTarget, sVar);
	if (oNewItem==OBJECT_INVALID)
	{
		sParameters="OBJECT_INVALID";
	}
	else
	{
		sParameters= "Tag : " + GetTag(oNewItem) + " : Name : " + GetName(oNewItem);
	}
	SendMessageToPC(oDM, GetName(oTarget) + " : " + sVar + " : Obj : " + sParameters);

}