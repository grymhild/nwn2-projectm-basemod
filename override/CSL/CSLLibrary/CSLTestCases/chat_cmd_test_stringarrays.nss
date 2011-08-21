//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://

/*
Test case to show the effect of applying a con bonus to a caster while he already has a con item equpped that should prevent stacking.

You can specify an item as a paramter. By default i_conitem will be used if no parameters provided. ( need to get another item which is in the vanilla game instead. )

You can select a creature in most talk modes, or send a tell to do the same thing.

*/

#include "_SCInclude_Chat"
#include "_HkSpell"

void main()
{
	
	
	object oPC = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	
	//string sResRef = "x2_it_mneck003"; // Amulet of Vitaltiy +4
	
	if ( !GetIsObjectValid( oTarget ) )
	{
		oTarget = oPC;
	}
	
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
    
    SendMessageToPC( oPC, CSLColorText( "TEST CASE: String Array Functions" , COLOR_GREEN) );
    SendMessageToPC( oPC, "Parameters: none");
	SendMessageToPC( oPC, "Various String Array Functions from the CSL library");
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLNth_GetCount" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7,8,9,0') should return '10' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7,8,9,0" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7,8,9') should return '9' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7,8,9" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7,8') should return '8' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7,8" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7') should return '7' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6') should return '6' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5') should return '5' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4') should return '4' and returns "+IntToString(CSLNth_GetCount("1,2,3,4" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3') should return '3' and returns "+IntToString(CSLNth_GetCount("1,2,3" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2') should return '2' and returns "+IntToString(CSLNth_GetCount("1,2" )) );
	
	SendMessageToPC( oPC, "CSLNth_GetCount('1') should return '1' and returns "+IntToString(CSLNth_GetCount("1" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('') should return '0' and returns "+IntToString(CSLNth_GetCount("" )) );
	
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLNth_GetPosition" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 1) should return '0' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 1 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 2) should return '2' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 2 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 3) should return '4' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 3 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 4) should return '6' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 4 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 5) should return '8' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 5 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 6) should return '10' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 6 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 7) should return '12' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 7 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 8) should return '14' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 8 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 9) should return '16' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 9 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 10) should return '18' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 10 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 11) should return '-1' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 11 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 12) should return '-1' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 12 )) );	

	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1', 1) should return '0' and returns "+IntToString(CSLNth_GetPosition("1", 1 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2', 2) should return '2' and returns "+IntToString(CSLNth_GetPosition("1,2", 1 )) );

	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLNth_GetNthElement" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 1) should return '0' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 1 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1', 1) should return '1' and returns "+CSLNth_GetNthElement("1", 1 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2', 2) should return '2' and returns "+CSLNth_GetNthElement("1,2", 2 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 2) should return '2' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 2 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 3) should return '3' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 3 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 4) should return '4' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 4 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 5) should return '5' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 5 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 6) should return '6' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 6 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 7) should return '7' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 7 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 8) should return '8' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 8 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 9) should return '9' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 9 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 10) should return '0' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 10 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 11) should return '' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 11 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 12) should return '' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 12 ) );
	
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('1,2,3,4,5,6,7,8,9,0', 'three', 3) should return '1,2,three,4,5,6,7,8,9,0' and returns "+CSLNth_ReplaceElement("1,2,3,4,5,6,7,8,9,0", "three", 3) );
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('1,2,3,4,5,6,7,8,9,0', 'one', 1) should return 'one,2,3,4,5,6,7,8,9,0' and returns "+CSLNth_ReplaceElement("1,2,3,4,5,6,7,8,9,0", "one", 1) );
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('1,2,3,4,5,6,7,8,9,0', 'ten', 10) should return '1,2,3,4,5,6,7,8,9,ten' and returns "+CSLNth_ReplaceElement("1,2,3,4,5,6,7,8,9,0", "ten", 10) );
	
	
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLStringArray" , COLOR_GREEN) );
	CSLStringArrayCreate("1,2,3,4,5,6,7,8,9AA,10" );
	SendMessageToPC( oPC, "CSLStringArrayCreate('1,2,3,4,5,6,7,8,9AA,10') results in ( "+CSLStringArrayPrint( )+" ) " );
	
	
	SendMessageToPC( oPC, "CSLStringArrayFirst() should return '1' and results in "+CSLStringArrayFirst()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayNext() should return '2' and results in "+CSLStringArrayNext()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayNext() should return '3' and results in "+CSLStringArrayNext()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayNext() should return '4' and results in "+CSLStringArrayNext()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayLast() should return '10' and results in "+CSLStringArrayLast()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayPrev() should return '9AA' and results in "+CSLStringArrayPrev()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayPrev() should return '8' and results in "+CSLStringArrayPrev()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayPrev() should return '7' and results in "+CSLStringArrayPrev()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayFirst() should return '1' and results in "+CSLStringArrayFirst()+" ( "+CSLStringArrayPrint( )+" ) " );
	
	SendMessageToPC( oPC, "CSLStringArrayIndex(1) should return '1' and results in "+CSLStringArrayIndex(1)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(2) should return '2' and results in "+CSLStringArrayIndex(2)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(3) should return '3' and results in "+CSLStringArrayIndex(3)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(4) should return '4' and results in "+CSLStringArrayIndex(4)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(5) should return '5' and results in "+CSLStringArrayIndex(5)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(6) should return '6' and results in "+CSLStringArrayIndex(6)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(7) should return '7' and results in "+CSLStringArrayIndex(7)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(8) should return '8' and results in "+CSLStringArrayIndex(8)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(9) should return '9AA' and results in "+CSLStringArrayIndex(9)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(10) should return '10' and results in "+CSLStringArrayIndex(10)+" ( "+CSLStringArrayPrint( )+" ) " );
	
	SendMessageToPC( oPC, "CSLStringArrayPop() should return '10' and results in "+CSLStringArrayPop()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayShift() should return '1' and results in "+CSLStringArrayShift()+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayPush("A");
	SendMessageToPC( oPC, "CSLStringArrayPush('A') should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayUnShift("B");
	SendMessageToPC( oPC, "CSLStringArrayUnShift('B') should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayReplace( "X", 1 );
	SendMessageToPC( oPC, "CSLStringArrayReplace( 'X', 1 ) should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayReplace( "Y", 5 );
	SendMessageToPC( oPC, "CSLStringArrayReplace( 'Y', 5 ) should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	
	CSLStringArrayReplace( "Z", 10 );
	SendMessageToPC( oPC, "CSLStringArrayReplace( 'Z', 10 ) should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayDelete();
	SendMessageToPC( oPC, "CSLStringArrayDelete() should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLRollStringtoInt" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLRollStringtoInt('1+2+3+1d4+2d8') results in ( "+IntToString(CSLRollStringtoInt( "1+2+3+1d4+2d8"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('1+2') results in ( "+IntToString(CSLRollStringtoInt( "1+2"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('2') results in ( "+IntToString(CSLRollStringtoInt( "2"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('10') results in ( "+IntToString(CSLRollStringtoInt( "10"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('1d4') results in ( "+IntToString(CSLRollStringtoInt( "1d4"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('1d4+1') results in ( "+IntToString(CSLRollStringtoInt( "1d4+1"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('1+1') results in ( "+IntToString(CSLRollStringtoInt( "1+1"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('2+1') results in ( "+IntToString(CSLRollStringtoInt( "2+1"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('3+1') results in ( "+IntToString(CSLRollStringtoInt( "3+1"))+" ) " );
	SendMessageToPC( oPC, "CSLRollStringtoInt('4+1') results in ( "+IntToString(CSLRollStringtoInt( "4+1"))+" ) " );
	
	SendMessageToPC( oPC, "CSLRollStringtoInt('15d54+2d4+13d12+1d20+1d2') results in ( "+IntToString(CSLRollStringtoInt( "15d54+2d4+13d12+1d20+1d2"))+" ) " );
	
	
	/*

	
	int CSLNth_GetCount( string sIn, string sDelimiter=",", int iStart = 0 )
	
	
	string CSLRemoveParsed(string sIn,string sParsed,string sDelimiter=".")
	
	int CSLNth_GetPosition( string sIn, int iOccurance = 1, string sDelimiter=",", int iStart = 0 )
	
	string CSLNth_GetNthElement(string sIn, int iOccurance, string sDelimiter="_")
	
	int CSLStringArrayCreate( string sIn, string sDelimiter = "," )
	
	void CSLStringArrayDelete( )
	
	string CSLStringArrayCurrent( )
	
	int CSLStringArrayCurrentIndex( )
	
	string CSLStringArrayIndex( int iIndex )

	
	

	
	
	
	string CSLStringArrayGet()
	
	
	
	void CSLStringArrayReplace( string sElement, int iIndex )
	
	*/
	
	
	
	
	
}