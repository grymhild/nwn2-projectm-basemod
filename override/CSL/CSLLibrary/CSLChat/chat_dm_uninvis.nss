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

	AssignCommand(GetModule(), DoDMUninvis(oDM));
	SendMessageToPC(oDM, "<color=indianred>"+"You are no longer cutsecene invisible or ghosted."+"</color>");
}