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

	sParameters = CSLNth_Shift(sParameters, " "); // NEXT ONE IS LENGTH
	int nLength = StringToInt(CSLNth_GetLast());
	sParameters = CSLNth_Shift(sParameters, " "); // REMAINING IS REASON
	string sPeriod = CSLNth_GetLast();
	if (CSLStringStartsWith(sPeriod, "day")) nLength *= 24; // DAYS TO HOURS
	if (sParameters=="")
	{
		SendMessageToPC(oDM, "You must give a reason for the banning (255 chars max).");
		return;
	}
	SDB_ApplyBan(oTarget, SDB_BANTYPE_TEMP, nLength, sParameters); // TEMP BAN
}