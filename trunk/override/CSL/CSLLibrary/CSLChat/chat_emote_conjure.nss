//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	string sParameters = CSLGetChatParameters();


	CSLEmoteDoConjure(oPC, sParameters);
}