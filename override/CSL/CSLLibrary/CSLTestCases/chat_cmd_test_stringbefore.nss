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
    
    SendMessageToPC( oPC, CSLColorText( "TEST CASE: String Functions" , COLOR_GREEN) );
    SendMessageToPC( oPC, "Parameters:");
	SendMessageToPC( oPC, "Various String Functions from the CSL library");
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLStringBefore" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '1') should return '' and returns "+CSLStringBefore("1234567890", "1") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '2') should return '1' and returns "+CSLStringBefore("1234567890", "2") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '3') should return '12' and returns "+CSLStringBefore("1234567890", "3") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '4') should return '123' and returns "+CSLStringBefore("1234567890", "4") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '5') should return '1234' and returns "+CSLStringBefore("1234567890", "5") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '6') should return '12345' and returns "+CSLStringBefore("1234567890", "6") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '7') should return '123456' and returns "+CSLStringBefore("1234567890", "7") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '8') should return '1234567' and returns "+CSLStringBefore("1234567890", "8") );
	
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '9') should return '12345678' and returns "+CSLStringBefore("1234567890", "9") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', '0') should return '123456789' and returns "+CSLStringBefore("1234567890", "0") );
	SendMessageToPC( oPC, "CSLStringBefore('1234567890', 'X') should return '1234567890' and returns "+CSLStringBefore("1234567890", "X") );
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLStringAfter" , COLOR_GREEN) );
	
	
	
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '1') should return '234567890' and returns "+CSLStringAfter("1234567890", "1") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '2') should return '34567890' and returns "+CSLStringAfter("1234567890", "2") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '3') should return '4567890' and returns "+CSLStringAfter("1234567890", "3") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '4') should return '567890' and returns "+CSLStringAfter("1234567890", "4") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '5') should return '67890' and returns "+CSLStringAfter("1234567890", "5") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '6') should return '7890' and returns "+CSLStringAfter("1234567890", "6") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '7') should return '890' and returns "+CSLStringAfter("1234567890", "7") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '8') should return '90' and returns "+CSLStringAfter("1234567890", "8") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '9') should return '0' and returns "+CSLStringAfter("1234567890", "9") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', '0') should return '' and returns "+CSLStringAfter("1234567890", "0") );
	SendMessageToPC( oPC, "CSLStringAfter('1234567890', 'X') should return '' and returns "+CSLStringAfter("1234567890", "X") );
	
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLNth_GetNthElement" , COLOR_GREEN) );
	SendMessageToPC( oPC, "This function gets the Nth value based on the delimeter, could get the 2nd word for example if delimter is a space." );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('12 34 56 78 90', 2, ' ') should return '34' and returns "+CSLNth_GetNthElement("12 34 56 78 90", 2, " " ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('12 34 56 78 90', 5, ' ') should return '90' and returns "+CSLNth_GetNthElement("12 34 56 78 90", 5, " " ) );
	
	string sPrevRandomAlphabet = "abcdefghijklmnopqrstuvwxyz";
	string sRandomAlphabet = CSLStringShuffle ( sPrevRandomAlphabet );
	SendMessageToPC( oPC, "CSLStringShuffle ( '"+sPrevRandomAlphabet+"' ) and returns "+sRandomAlphabet);
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLStringSplit( sRandomAlphabet,2,"," );
	SendMessageToPC( oPC, "CSLStringSplit( '"+sPrevRandomAlphabet+"',2,',' ) and returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_Sort( sRandomAlphabet );
	SendMessageToPC( oPC, "CSLNth_Sort( "+sPrevRandomAlphabet+" ) returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_Shift( sRandomAlphabet );
	SendMessageToPC( oPC, "CSLNth_Shift( "+sPrevRandomAlphabet+" ) returns "+sRandomAlphabet );
	SendMessageToPC( oPC, "CSLNth_GetLast() returns "+CSLNth_GetLast() );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_Pop( sRandomAlphabet );
	SendMessageToPC( oPC, "CSLNth_Pop( "+sPrevRandomAlphabet+" ) returns "+sRandomAlphabet );
	SendMessageToPC( oPC, "CSLNth_GetLast() returns "+CSLNth_GetLast() );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_Push(sRandomAlphabet, "8" );
	SendMessageToPC( oPC, "CSLNth_Push('"+sPrevRandomAlphabet+"', '8' ) returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_UnShift(sRandomAlphabet, "7" );
	SendMessageToPC( oPC, "CSLNth_UnShift('"+sPrevRandomAlphabet+"', '7' ) returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_UnShift(sRandomAlphabet, "6" );
	SendMessageToPC( oPC, "CSLNth_UnShift('"+sPrevRandomAlphabet+"', '6' ) returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_ReplaceElement(sRandomAlphabet, "5", 1 );
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('"+sPrevRandomAlphabet+"', '5', 1 ) returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_ReplaceElement(sRandomAlphabet, "4", 3 );
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('"+sPrevRandomAlphabet+"', '4', 3 ) returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_RemoveElement(sRandomAlphabet, 1 );
	SendMessageToPC( oPC, "CSLNth_RemoveElement('"+sPrevRandomAlphabet+"', 1 ) returns "+sRandomAlphabet );
	
	sPrevRandomAlphabet = sRandomAlphabet;
	sRandomAlphabet = CSLNth_RemoveElement(sRandomAlphabet, 3 );
	SendMessageToPC( oPC, "CSLNth_RemoveElement('"+sPrevRandomAlphabet+"', 3 ) returns "+sRandomAlphabet );
}