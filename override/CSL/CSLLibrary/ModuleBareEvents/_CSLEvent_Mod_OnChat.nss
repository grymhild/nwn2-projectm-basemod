#include "_SCInclude_Chat" 

int StartingConditional(object oSender, object oTarget, int nChannel, string sMessage)
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	return CSLHandleChat( oSender, oTarget, nChannel, sMessage ); // moving to library so can also be shared by GUI code
}