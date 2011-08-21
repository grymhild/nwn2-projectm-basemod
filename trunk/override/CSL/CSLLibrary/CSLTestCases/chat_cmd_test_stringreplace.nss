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
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLRemoveAllTags" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLRemoveAllTags('dog is (color=gold)really gold(/color)') should return 'dog is really gold' and returns "+CSLRemoveAllTags("dog is <color=gold>really gold</color>") );	
	SendMessageToPC( oPC, "CSLRemoveAllTags('(color=gold)really gold(/color)') should return 'really gold' and returns "+CSLRemoveAllTags("<color=gold>really gold</color>") );	
	SendMessageToPC( oPC, "CSLRemoveAllTags('(color=gold)gold</color)') should return 'gold' and returns "+CSLRemoveAllTags("<color=gold>gold</color>") );	
	SendMessageToPC( oPC, "CSLRemoveAllTags('(color=gold)(/color)') should return '' and returns "+CSLRemoveAllTags("<color=gold></color>") );	
	SendMessageToPC( oPC, "CSLRemoveAllTags('dog is ()really gold()') should return 'dog is really gold' and returns "+CSLRemoveAllTags("dog is <>really gold<>") );	
	SendMessageToPC( oPC, "CSLRemoveAllTags('()really gold()') should return 'really gold' and returns "+CSLRemoveAllTags("<>really gold<>") );	
	SendMessageToPC( oPC, "CSLRemoveAllTags('()gold()') should return 'gold' and returns "+CSLRemoveAllTags("<>gold<>") );	
	SendMessageToPC( oPC, "CSLRemoveAllTags('()()') should return '' and returns "+CSLRemoveAllTags("<><>") );	
	
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLReplaceAllSubStrings" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLReplaceAllSubStrings('dog is a cat', 'cat', 'pig') should return 'dog is a pig' and returns "+CSLReplaceAllSubStrings("dog is a cat", "cat", "pig") );	
	SendMessageToPC( oPC, "CSLReplaceAllSubStrings('dog is a cat', 'frog', 'pig') should return 'dog is a cat' and returns "+CSLReplaceAllSubStrings("dog is a frog", "cat", "pig") );	
	SendMessageToPC( oPC, "CSLReplaceAllSubStrings('cat', 'cat', 'pig') should return 'pig' and returns "+CSLReplaceAllSubStrings("cat", "cat", "pig") );	
	SendMessageToPC( oPC, "CSLReplaceAllSubStrings('cat', 'frog', 'pig') should return 'cat' and returns "+CSLReplaceAllSubStrings("frog", "cat", "pig") );	

	
}