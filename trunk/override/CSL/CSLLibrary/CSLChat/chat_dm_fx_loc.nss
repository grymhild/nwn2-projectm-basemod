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

	//sParameters = GetStringLowerCase(GetStringRight(sParameters, GetStringLength(sParameters) - 7));
	AssignCommand(oDM, DoVFX(oDM, sParameters, oTarget, TRUE));//assigncommand ensures DM is creator


}