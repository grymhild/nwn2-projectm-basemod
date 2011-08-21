//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "seed_db_inc"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	//sParameters = CSLNth_Shift(sParameters, " "); // POP SUBCOMMAND
	//sParameters = CSLNth_GetLast(); // GET SUBCOMMAND
	sParameters = ( sParameters == "add" ) ? "1" : "0";
	
	CSLNWNX_SQLExecDirect("update account set ac_dm = "+sParameters+" where ac_acid=" + SDB_GetACID(oTarget));
	sParameters = (sParameters=="1") ? "added" : "removed";
	sParameters = " been " + sParameters + " as a Player DM.";
	SendMessageToPC(oTarget, "You have" + sParameters);
	SendMessageToPC(oDM, GetName(oTarget) + " has" + sParameters);
}