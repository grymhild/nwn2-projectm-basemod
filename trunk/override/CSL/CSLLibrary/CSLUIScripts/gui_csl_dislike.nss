#include "_CSLCore_Player"

void main()
{
	//Trim the value string.
	//sValue = GetStringRight(sValue, GetStringLength(sValue) - 17);
	
	object oChar = OBJECT_SELF;
	//SCSpeakIt(OBJECT_SELF, "respawning");
	//SendMessageToPC(oChar, "GUI Script Result 2:"+sValue1+" 2:"+sValue2+" 3:"+sValue3+" 4:"+sValue4);
	//SpeakString( "GUI Script Result 3:"+sValue1+" 2:"+sValue2+" 3:"+sValue3+" 4:"+sValue4 );
	// Categorize and store the character data for easier retrieval.
	// Assign feats (as Raelius Archmannon suggested) or store in your DB.
	//SendMessageToPC(OBJECT_SELF, sField + " = " + sValue);
	
	/*
	object oTarget1 = GetPlayerCreatureExamineTarget( oChar );
	if ( GetIsObjectValid( oTarget1 ) )
	{
		SendMessageToPC(oChar, "GetPlayerCreatureExamineTarget= " + GetName( oTarget1 ) );
	}
	*/
	
	//SetGUIObjectText( oChar, "SCREEN_PLAYERMENU", "MAINSCREEN_EXPERIENCE", 1, "howdy1" );
	//SetGUIObjectText( oChar, "SCREEN_PLAYERMENU", "MAINSCREEN_STATS", 1, "howdy2" );
	
	//object oTarget2 = GetPlayerCurrentTarget( oChar );
	//if ( GetIsObjectValid( oTarget2 ) )
	//{
		//SendMessageToPC(oChar, "GetPlayerCurrentTarget= " + GetName( oTarget2 ) );
		
		
		// These work
		 //SetGUIObjectText( oChar, "SCREEN_PLAYERMENU", "MAINSCREEN_EXPERIENCE", 1, "howdy1" );
		 // SetGUIObjectText( oChar, "SCREEN_PLAYERMENU", "MAINSCREEN_STATS", 1, "howdy2" );
		  // SetGUIObjectText( oChar, "SCREEN_EXAMINE", "EXAMINE_DESCRIPTION_TEXT", 1, "howdy3" );
		
			
		
		//SetGUIObjectText( oChar, "SCREEN_EXAMINE", "EXAMINE_DESCRIPTION_TEXT", -1, "hello world2, " + GetName( oTarget2 ) );
	
	//}
	CSLSetDisLike(oChar, TRUE );
	
}