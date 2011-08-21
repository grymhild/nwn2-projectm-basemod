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
	float fNewCR = StringToFloat(sParameters);
	float fOldCR = CSLGetChallengeRating(oTarget);
	
	CSLSetChallengeRating( oTarget, fNewCR );
	
	fNewCR = CSLGetChallengeRating(oTarget);
			  
	SendMessageToPC(oDM, "<color=indianred>"+"Set CR of "+GetName(oTarget)+" from "+CSLFormatFloat(fOldCR)+" to "+CSLFormatFloat(fNewCR) + "!"+"</color>");
}