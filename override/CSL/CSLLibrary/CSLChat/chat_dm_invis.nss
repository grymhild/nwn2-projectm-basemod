//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_DMFI"

void main()
{
	object oDM = CSLGetChatSender();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	AssignCommand(GetModule(), DoDMInvis(oDM));
	SendMessageToPC(oDM, "<color=indianred>"+"You are now cutsecene invisible and ghosted."+"</color>");

}