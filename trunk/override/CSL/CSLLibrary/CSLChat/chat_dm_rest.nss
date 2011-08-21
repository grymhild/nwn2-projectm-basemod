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
	
	
	
	DeleteLocalInt(oTarget, "LASTREST");
	AssignCommand(oTarget, ClearAllActions(TRUE ) );
    //AssignCommand(oTarget, PlaySound("al_en_windgust_1"));
    //FloatingTextStringOnCreature("You can now rest again", oTarget, FALSE);
    
    AssignCommand(oTarget, ActionRest(TRUE ) );
	
}