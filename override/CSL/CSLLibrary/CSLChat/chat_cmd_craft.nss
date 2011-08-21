//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
//#include "nwnx_craft_system"
	
void main()
{

	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	if (CSLGetIsPolymorphed(oPC))
	{
		SendMessageToPC(oPC,"Cannot craft while polymorphed.");
		return;
	}
	
	if ( !GetLocalInt(GetModule(),"XC_CRAFTCONFIGURED" ) )
	{	
		// Just in case it's not being run for some reason on the module load up script
		ExecuteScript("nwnx_craft_set_constants", GetModule() );
	}
	
	AssignCommand(oPC, ClearAllActions(TRUE));
	AssignCommand(oPC, ActionStartConversation(oPC, "dlg_nwnx_craft", TRUE, FALSE));
}