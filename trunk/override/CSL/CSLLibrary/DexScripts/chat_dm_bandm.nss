//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	SetLocalInt(oTarget, "FKY_CHT_BANDM", TRUE);//temp ban em
	SendMessageToPC(oTarget, "<color=indianred>"+"You have been temporarily banned from using the DM channel. The ban will be lifted after the next server reset."+"</color>");//tell em
	SendMessageToPC(oDM, "<color=indianred>"+"You have temp banned "+ GetName(oTarget)+" from the DM channel."+"</color>");


}