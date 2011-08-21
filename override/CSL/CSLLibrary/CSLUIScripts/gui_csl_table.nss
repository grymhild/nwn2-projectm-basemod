////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_dmlist - DM Friendly Initiative - GUI script for the DM 30 Entry List
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/12/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// NOTE: Two UIs actually run through this script.
// One is the 30 DM LIST UI and the second is the PLAYER CHOOSE LANGUAGE UI.
// Saves us one script in the package.

#include "_SCInclude_DMFI"
#include "_SCInclude_DMFIComm"

#include "_CSLCore_UI"

// * sInput is the relevant command or button hit
// * sRowVariable is the stored variable
void main(string sInput, string sRowVariable )
{
	
	if ( !CSLCheckPermissions( OBJECT_SELF, CSL_PERM_DMONLY ) )
	{
		CloseGUIScreen(OBJECT_SELF, SCREEN_DM_CSLTABLELIST);
		return;
	}

	object oPC = GetControlledCharacter(OBJECT_SELF);
	
	//SendMessageToPC( oPC, "running csl table "+sInput+", "+sRowVariable );
	//object oTool = CSLDMFI_GetTool(OBJECT_SELF);
	string sCommand, sNum, sPage, sValue, sTest, sScreen;
	int nPage, nCurrent, n;
	
	string sCategory = "";
	//sPage = GetLocalString(OBJECT_SELF, DMFI_UI_PAGE);
	if (GetStringLeft(sInput,9)=="CATEGORY-")
	{
		sCategory = CSLStringAfter( sInput, "-");
		SetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY", sCategory );
		CSLTableShowListUI(oPC, CSL_PAGE_FIRST );
	}
	else
	{
		sCategory = GetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY" );
	}
	// HANDLE NEXT AND PREVIOUS BUTTONS
	if (sInput=="next")
	{
		CSLTableShowListUI(oPC, CSL_PAGE_NEXT );
		return;
	}	
	else if (sInput=="prev")
	{
		CSLTableShowListUI(oPC, CSL_PAGE_PREVIOUS );
		return;
	}
	else if (sInput=="last")
	{
		CSLTableShowListUI(oPC, CSL_PAGE_LAST );
		return;
	}
	else if (sInput=="first")
	{
		CSLTableShowListUI(oPC, CSL_PAGE_FIRST );
		return;
	}
	
		
	// sNum = GetStringRight(sInput, (GetStringLength(sInput)-4));  // Remove 'list'
	int iButtonNumber = StringToInt( sInput );	
	string sTable = GetStringLowerCase( CSLStringBefore( sRowVariable, "_") ); // works as a safety check mainly
	string sRow = CSLStringAfter( sRowVariable, "_");
	
	//SendMessageToPC( OBJECT_SELF, "sInput="+sInput+" sRowVariable="+sRowVariable+" sTable= "+sTable+" sRow= "+sRow  );
	
	//sCommand = GetLocalString(OBJECT_SELF, DMFI_LAST_UI_COM);
	
	// SPECIAL EXCEPTION FOR A LIST CALLING A SUB-LIST:  Number >> Dice >> ACTION
	/*
	if ((sPage=="LIST_10") && (sCommand=="roll "))
	{
		SetLocalString(OBJECT_SELF, DMFI_LAST_UI_COM, sCommand + sNum);		
		SetLocalString(OBJECT_SELF, DMFI_UI_PAGE, "LIST_DICE");
		SetGUIObjectText(OBJECT_SELF, SCREEN_DMFI_DMLIST, "DMListTitle", -1, TXT_CHOOSE_TYPE);
		n=0;
		while (n<10)
		{
			sTest = GetLocalString(oTool, LIST_PREFIX + "LIST_DICE" + "." + IntToString(n));
			SetGUIObjectText(OBJECT_SELF, SCREEN_DMFI_DMLIST, "dmlist"+IntToString(n+1), -1, sTest);
			n++;
		}		
		return;
	}
	*/
	
	//CloseGUIScreen(OBJECT_SELF, SCREEN_DM_CSLTABLELIST );
	
	
	
	
	object oTarget = GetPlayerCurrentTarget( OBJECT_SELF );
	if ( !GetIsObjectValid( oTarget )  )
	{		
		oTarget == OBJECT_SELF;
		if ( !GetIsObjectValid( oTarget )  )
		{
			// just get out of here
			return;
		}
	}
	
	// need to add a permission check
	//if ( sTable == "appearance"  )
	//{
		if (sInput=="male")
		{
			SendMessageToPC(OBJECT_SELF, "3Setting "+GetName(oTarget)+" to Male, if an NPC a trip to limbo might make it work, if a Player they must relog for it to take effect" );
			CSLStoreTrueAppearance(oTarget);
			SetGender(oTarget, GENDER_MALE);
			if( !GetIsPC( oTarget ) )
			{
				location lLastLocation = GetLocation(oTarget);
				object oArea = GetFirstArea();
				if ( oArea == GetArea(oTarget) )
				{
					oArea = GetNextArea();
				}
				location lOtherLocation = CSLGetCenterPointOfArea( oArea );
				//DelayCommand(0.1f, SendCreatureToLimbo(oTarget) );
				//DelayCommand(0.5f, RecallCreatureFromLimboToLocation(oTarget, lLastLocation) );
				//DelayCommand(0.75f, AssignCommand(oTarget, ActionJumpToLocation( lLastLocation ) ) );
				AssignCommand(oTarget,ClearAllActions());
				AssignCommand(oTarget, JumpToLocation( lOtherLocation ) );
				AssignCommand(oTarget, JumpToLocation( lLastLocation ) );
			}
			return;
		}	
		else if (sInput=="female")
		{
			SendMessageToPC(OBJECT_SELF, "3Setting "+GetName(oTarget)+" to Female, if an NPC a trip to limbo might make it work, if a Player they must relog for it to take effect" );
			CSLStoreTrueAppearance(oTarget);
			SetGender(oTarget, GENDER_FEMALE);
			location lLastLocation = GetLocation(oTarget);
			object oArea = GetFirstArea();
			if ( oArea == GetArea(oTarget) )
			{
				oArea = GetNextArea();
			}
			location lOtherLocation = CSLGetCenterPointOfArea( oArea );
			//DelayCommand(0.1f, SendCreatureToLimbo(oTarget) );
			//DelayCommand(0.5f, RecallCreatureFromLimboToLocation(oTarget, lLastLocation) );
			//DelayCommand(0.75f, AssignCommand(oTarget, ActionJumpToLocation( lLastLocation ) ) );
			AssignCommand(oTarget, ActionJumpToLocation( lOtherLocation ) );
			AssignCommand(oTarget, ActionJumpToLocation( lLastLocation ) );
			return;
		}
		else if (sInput=="smaller")
		{
			CSLStoreTrueAppearance(oTarget);
			CSLScaleAppearance( 0.8f, oTarget );
			return;
		}
		else if (sInput=="bigger")
		{
			CSLStoreTrueAppearance(oTarget);
			CSLScaleAppearance( 1.25f, oTarget );
			return;
		}
		else if (sInput=="reset")
		{
			CSLRestoreTrueAppearance( oTarget );
			return;
		}
		else if (  sRow != "" )
		{
			CSLStoreTrueAppearance(oTarget);
			SetCreatureAppearanceType(oTarget, StringToInt(sRow));
			return;
		}
	//}
	
	/*
	// SPECIAL EXCEPTIONS WHERE WE HAVE TO UPDATE THE COMMAND FROM "ABOVE"
	if (sCommand=="set ambient ")
	{
		sCommand = sCommand + GetLocalString(oTool, DMFI_AMB_NIGHT) + " ";
	}
	else if (sCommand=="set music ")
	{
		sCommand = sCommand + GetLocalString(oTool, DMFI_MUSIC_TIME) + " ";
	}				
	
	sPage = GetLocalString(OBJECT_SELF, DMFI_UI_PAGE);
	nPage = GetLocalInt(OBJECT_SELF, sPage + DMFI_CURRENT);
	nCurrent = (nPage*30) + nNum-1;

	// SPECIAL EXCEPTION FOR UPDATING NUMERIC VALUES THAT ARE CURRENTLY DISPLAYED ON THE UI		
	if (FindSubString(sCommand, "update")!=-1)
	{
		// Get the screen because we need it to update the values
		sScreen = GetLocalString(OBJECT_SELF, "DMFI_UI_USE");
		sScreen = SCREEN_DMFI_ + sScreen;
	
		sTest = GetStringRight(sCommand, GetStringLength(sCommand)-7);
				
		if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT)==2)
			sValue = IntToString(nCurrent);
		else if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT))
			sValue = IntToString(GetLocalInt(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent)));
		else	
			sValue = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
				
		DMFI_UpdateNumberToken(oTool, sTest, sValue);
		SetGUIObjectText(OBJECT_SELF, sScreen, "update_" + sTest, -1, sValue);  // GUI Buttons must be named "update_PARAM"
		CloseGUIScreen(OBJECT_SELF, SCREEN_DMFI_DMLIST);
		return;
	}	

	// SPECIAL EXCEPTION FOR THE DISPLAY PREFIX FOR SOUND ENTRIES	
	if (FindSubString(sPage, "DISPLAY")!=-1)
		sPage = GetStringRight(sPage, GetStringLength(sPage)-7);
		
	// SPECIAL EXCEPTION TO HIDE THE CHOOSEN LANGUAGE BUTTON
	if (FindSubString(sCommand, "grant")!=-1)
		SetGUIObjectHidden(OBJECT_SELF, SCREEN_DMFI_CHOOSE, "btn"+IntToString(nCurrent+1), TRUE);	
	
	// FINALLY FINISHED WITH EXCEPTIONS... We grab the result and run the command.
	if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT)==2)		// actual list location
		sCommand = sCommand + IntToString(nCurrent);
	else if (GetLocalInt(OBJECT_SELF, DMFI_REQ_INT))		// replaced int value
		sCommand = sCommand + IntToString(GetLocalInt(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent)));
	else						// string value
		sCommand = sCommand + GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));

	if (sPage=="LIST_DMLANGUAGE")
	{  // We have to set this BEFORE the command code because we loose access to OBJECT_SELF
		sTest =  GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
		SetLocalString(OBJECT_SELF, DMFI_LANGUAGE_TOGGLE, GetStringLowerCase(sTest));	
	}	
		
		
	oPC = DMFI_UITarget(OBJECT_SELF, oTool);
	DMFI_DefineStructure(oPC, sCommand);
	DMFI_RunCommandCode(oTool, oPC, sCommand);
	*/
}				