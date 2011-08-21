//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPlayer = CSLGetChatSender();

	string sPlayername;
	string sMessage = "";
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
	{
		sPlayername = CSLGetMyPlayerName(oPC);
		if (GetLocalInt(oPlayer, "CHT_IGNORE" + sPlayername)==TRUE)
		{
			sMessage += "<color=indianred>"+"You are currently ignoring "+sPlayername+"."+"</color>"+"\n";
		}
		oPC = GetNextPC();
	}
	if (sMessage != "") SendMessageToPC(oPlayer, sMessage);
	else SendMessageToPC(oPlayer, "<color=indianred>"+"You are currently not ignoring anyone."+"</color>");
}