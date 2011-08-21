//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://

/*
Test case to look for errors in alignment functions.

*/

#include "_SCInclude_Chat"

// need to verify this works, the way alignment is set is relative and not absolute like this
void testSetAlignmentValue(object oTarget, int nLawChaosValue, int nGoodEvilValue)
{
	AdjustAlignment(oTarget, ALIGNMENT_CHAOTIC, 100); // RESET TO 0 - this makes it so i don't have to rely on what it is to begin with
	AdjustAlignment(oTarget, ALIGNMENT_EVIL, 100); // RESET TO 0
	
	AdjustAlignment(oTarget, ALIGNMENT_LAWFUL, nLawChaosValue); // now sets to the proper value
	AdjustAlignment(oTarget, ALIGNMENT_GOOD, nGoodEvilValue); // now sets to the proper value
}

void testAlignment( int iLawChaosValue, int iGoodEvilValue, object oTarget, object oMessageTo )
{
	testSetAlignmentValue(oTarget, iLawChaosValue, iGoodEvilValue); // set the alignment as per the above
	
	int iAlignLawChaosConstant = GetAlignmentLawChaos(oTarget);
	int iAlignGoodEvilConstant = GetAlignmentGoodEvil(oTarget);
	
	int iAlignLawChaosValue = GetLawChaosValue(oTarget);
	int iAlignGoodEvilValue = GetGoodEvilValue(oTarget);
	
	
	string sLawChaosConstantResult;
	if ( iAlignLawChaosConstant == -1 ) { sLawChaosConstantResult = "INVALID ("+IntToString(iAlignLawChaosConstant)+")"; }
	else if ( iAlignLawChaosConstant == ALIGNMENT_ALL ) { sLawChaosConstantResult = "ALIGNMENT_ALL ("+IntToString(iAlignLawChaosConstant)+")"; }
	else if ( iAlignLawChaosConstant == ALIGNMENT_LAWFUL ) { sLawChaosConstantResult = "ALIGNMENT_LAWFUL ("+IntToString(iAlignLawChaosConstant)+")"; }
	else if ( iAlignLawChaosConstant == ALIGNMENT_CHAOTIC ) { sLawChaosConstantResult = "ALIGNMENT_CHAOTIC ("+IntToString(iAlignLawChaosConstant)+")"; }
	else if ( iAlignLawChaosConstant == ALIGNMENT_NEUTRAL ) { sLawChaosConstantResult = "ALIGNMENT_NEUTRAL ("+IntToString(iAlignLawChaosConstant)+")"; }
	
	string sGoodEvilConstantResult;
	if ( iAlignGoodEvilConstant == -1 ) { sGoodEvilConstantResult = "INVALID ("+IntToString(iAlignGoodEvilConstant)+")"; }
	else if ( iAlignGoodEvilConstant == ALIGNMENT_ALL ) { sGoodEvilConstantResult = "ALIGNMENT_ALL ("+IntToString(iAlignGoodEvilConstant)+")"; }
	else if ( iAlignGoodEvilConstant == ALIGNMENT_GOOD ) { sGoodEvilConstantResult = "ALIGNMENT_GOOD ("+IntToString(iAlignGoodEvilConstant)+")"; }
	else if ( iAlignGoodEvilConstant == ALIGNMENT_EVIL ) { sGoodEvilConstantResult = "ALIGNMENT_EVIL ("+IntToString(iAlignGoodEvilConstant)+")"; }
	else if ( iAlignGoodEvilConstant == ALIGNMENT_NEUTRAL ) { sGoodEvilConstantResult = "ALIGNMENT_NEUTRAL ("+IntToString(iAlignGoodEvilConstant)+")"; }
	
	
	string sSet = "Set Law:"+IntToString(iLawChaosValue)+" Good:"+IntToString(iGoodEvilValue);
	
	sSet += " Result\n Law:"+IntToString(iAlignLawChaosValue)+"\n  "+sLawChaosConstantResult+"\n Good:"+IntToString(iAlignGoodEvilValue)+"\n  "+sGoodEvilConstantResult;
	
	SendMessageToPC( oMessageTo, sSet );
}	


void main()
{
	object oPC = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLTrim( CSLGetChatParameters() );
	//string sResRef = "c_succubus"; // resref of creature with SR on it's hide
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
    
    ///if ( sParameters != "" )
    //{
    //	sResRef = sParameters;
    //}
    
    SendMessageToPC( oPC, CSLColorText( "**** TEST CASE: Alignment functions! ****" , COLOR_GREEN) );
    SendMessageToPC( oPC, "Parameters:");
	SendMessageToPC( oPC, "Testing results of getting alignment not returning the right result");
    SendMessageToPC( oPC, "0-30 is evil, 31-69 is neutral, and 70-100 is good");
    SendMessageToPC( oPC, "0-30 is chaos, 31-69 is neutral, and 70-100 is law");
    SendMessageToPC( oPC, "Alignment Constants ( for GetAlignmentLawChaos and GetAlignmentGoodEvil )");
    SendMessageToPC( oPC, "  ALIGNMENT_ALL = 0");
	SendMessageToPC( oPC, "  ALIGNMENT_NEUTRAL = 1");
	SendMessageToPC( oPC, "  ALIGNMENT_LAWFUL = 2");
	SendMessageToPC( oPC, "  ALIGNMENT_CHAOTIC = 3");
	SendMessageToPC( oPC, "  ALIGNMENT_GOOD = 4");
	SendMessageToPC( oPC, "  ALIGNMENT_EVIL = 5");
    
    if ( !GetIsObjectValid( oTarget ) )
	{
		int iOrigAlignLawChaosValue = GetLawChaosValue(oTarget);
		int iOrigAlignGoodEvilValue = GetGoodEvilValue(oTarget);
		
		int iGoodEvilValue;
		int iLawChaosValue = iOrigAlignLawChaosValue; // use character editor to iterate the law evil values, thinking a 100 results will overflow or tmi as it is, add second loop via delay commands later on
		// probably add parameters so the tester can select which parts to actually test as well
		
		for( iGoodEvilValue = 0; iGoodEvilValue <= 100; iGoodEvilValue++ )
		{
			testAlignment( iLawChaosValue, iGoodEvilValue, oTarget, oPC );
		}
		
		// restore to original settings
		testSetAlignmentValue(oTarget, iOrigAlignLawChaosValue, iOrigAlignGoodEvilValue);
	}
}