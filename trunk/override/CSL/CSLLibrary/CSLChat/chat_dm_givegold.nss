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
	if ( !GetIsObjectValid( oTarget )  )
	{
		SendMessageToPC(oDM, "ERROR: Target was Invalid, please select a target or send via a tell");
		return;
	}
	//sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 7);
	
	GiveGoldToCreature(oTarget, StringToInt(sParameters), FALSE );
	//GiveXPToCreature(oTarget, StringToInt(sParameters));
	SendMessageToPC(oDM, "<color=indianred>"+"You have awarded "+ IntToString(StringToInt(sParameters))+" Gold to "+GetName(oTarget) + "!"+"</color>");
	SendMessageToPC(oTarget, "<color=indianred>"+"The DM has awarded your character "+GetName(oTarget)+ IntToString(StringToInt(sParameters))+" in gold." + "!"+"</color>");
}