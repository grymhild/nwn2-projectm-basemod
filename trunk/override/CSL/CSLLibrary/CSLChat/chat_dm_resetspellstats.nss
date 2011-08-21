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

	SetLocalInt( oTarget, "SC_HitDice", 0 );
	SendMessageToPC(oDM, GetName(oTarget) + " will have their spellstats reapplied upon next spell they cast");
}