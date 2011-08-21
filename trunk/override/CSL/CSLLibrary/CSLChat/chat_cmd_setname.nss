//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	
	if ( ENABLE_PLAYER_SETNAME || CSLVerifyDMKey(oPC) || CSLVerifyAdminKey(oPC) )
	{
		int nCheck;
		int nPos = FindSubString(sParameters, "@");
		string sSort = GetStringLeft(sParameters, nPos);
		sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - (nPos+1));
		object oItem = GetFirstItemInInventory(oPC);
		while (GetIsObjectValid(oItem) && (nCheck != 1))
		{
			if (GetName(oItem)==sSort)
			{
				DelayCommand(0.1, SetFirstName(oItem, sParameters));
				nCheck = 1;
			}
			oItem = GetNextItemInInventory(oPC);
		}
	}
}