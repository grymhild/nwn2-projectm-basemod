#include "_SCInclude_Chat"
#include "hcr2_debug_i"

int StartingConditional(object oSpeaker, object oTarget, int nChannel, string sChatMessage)
{
	int bRet = TRUE;
	if (!GetIsObjectValid(oSpeaker) && GetStringLeft(sChatMessage, 5) == "HCR2_")
		return FALSE;
	//Do Chat logging
	if (GetIsPC(oSpeaker))
	{
		string sChatLog = "CHATLOG: C=" +IntToString(nChannel) + "; ";
		sChatLog += "A=" + GetName(GetArea(oSpeaker)) + "; ";
		sChatLog += "S=" + GetPCPlayerName(oSpeaker) + "_" + GetName(oSpeaker) + "; ";
		sChatLog += "T=" + GetPCPlayerName(oTarget) + "_" + GetName(oTarget) + "; ";
		sChatLog += "M='" + sChatMessage + "'";
		WriteTimestampedLogEntry(sChatLog);
	}
	//bRet = h2_RunModuleChatEventScripts(oSpeaker, oTarget, nChannel, sChatMessage);
	//return bRet;

	return CSLHandleChat( oSpeaker, oTarget, nChannel, sChatMessage ); // moving to library so can also be shared by GUI code
}