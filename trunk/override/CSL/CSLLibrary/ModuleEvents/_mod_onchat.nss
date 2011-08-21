#include "_SCInclude_Chat" 

//int testGlobalScopeFunction()
//{
//	return 42;
//}

//int iAnswerToLife = testGlobalScopeFunction();

int StartingConditional(object oSender, object oTarget, int nChannel, string sMessage)
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	//SendMessageToPC( GetFirstPC(), "The answer to life the universe and everything is "+IntToString(iAnswerToLife) );
	//SendMessageToPC( GetFirstPC(), "Sending message "+sMessage+" from "+GetName(oSender)+" to "+GetName(oTarget)+" Channel="+IntToString(nChannel) );
	
	return CSLHandleChat( oSender, oTarget, nChannel, sMessage ); // moving to library so can also be shared by GUI code
}