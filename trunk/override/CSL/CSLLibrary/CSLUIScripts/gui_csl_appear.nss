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

#include "_SCInclude_DMAppear"
#include "_CSLCore_Player"

//#include "_SCInclude_DMFIComm"




// * sInput is the relevant command or button hit
// * sCommand is the stored variable               sCommand
void main(string sInput, string sPlayerID = "", string sCommand = "", string sParameter= "" )
{
	
	if ( !CSLCheckPermissions( OBJECT_SELF, CSL_PERM_DMONLY ) )
	{
		CloseGUIScreen(OBJECT_SELF, SCREEN_DM_CSLTABLELIST);
		return;
	}
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	
	//SendMessageToPC(oPC,"dmappear sInput="+sInput+" sPlayerID="+sPlayerID+" sCommand="+sCommand+" sParameter="+sParameter );
	
	sInput = GetStringLowerCase( sInput );
	string sPageTitle;
	object oTarget;
	if ( sPlayerID == "targeted" )
	{
		oTarget = GetPlayerCurrentTarget( OBJECT_SELF );
		//if ( !GetIsObjectValid( oTarget )  )
		//{		
		//	oTarget == OBJECT_SELF;
		//}
		
		sPageTitle = "Current Target";
	}
	else
	{
		oTarget = IntToObject(StringToInt(sPlayerID));
		sPageTitle = "Target: "+GetName(oTarget);
	}
	

	string sNum, sPage, sValue, sTest, sScreen;
	int nPage, nCurrent, n;
	
	//string sCategory = GetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY" );

	//SendMessageToPC(oPC,"dmappear"+sPageTitle);
	
	if ( sInput=="category")
	{
		if ( sCommand == "#" ) { sCommand = "~"; }
		SetLocalString( oPC, "CSL_TABLE_CURRENTCATEGORY", sCommand );
		CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_FIRST, sCommand, sPageTitle );
	}
	else if (sInput=="next")
	{
		CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_NEXT, sCommand, sPageTitle );
		return;
	}	
	else if (sInput=="prev")
	{
		CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_PREVIOUS, sCommand, sPageTitle );
		return;
	}
	else if (sInput=="last")
	{
		CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_LAST, sCommand, sPageTitle );
		return;
	}
	else if (sInput=="first")
	{
		CSLDMAppear_Build(oPC, oTarget, CSL_PAGE_FIRST, sCommand, sPageTitle );
		return;
	}
	else if (sInput=="setappear")
	{
		if ( !GetIsObjectValid( oTarget ) ) { return; }
		
		string sTable = GetStringLowerCase( CSLStringBefore( sCommand, "_") ); // works as a safety check mainly
		string sRow = CSLStringAfter( sCommand, "_");
		
		if ( sTable == "appearance" && sRow != "" && StringToInt(sRow) > -1 )
		{
			CSLStoreTrueAppearance(oTarget);
			int iAppearance = GetAppearanceType(oTarget);
			if ( iAppearance >= 3600 )
			{
				int iOverride = CSLGetAnimationOverrideByAppearance( iAppearance );
				SetCreatureAppearanceType(oTarget, StringToInt(sRow));
				CSLAnimationOverride(oTarget, iOverride );
				CSLDMAppear_AnimationModes( oTarget, oPC );	
			}
			else // they are over ridden, try to preserve
			{
				SetCreatureAppearanceType(oTarget, StringToInt(sRow));
			}
		}
		return;
	}
	else if (sInput=="setanim_mode")
	{
		// if ( !GetIsObjectValid( oTarget ) ) { return; }
		
		//string sTable = GetStringLowerCase( CSLStringBefore( sCommand, "_") ); // works as a safety check mainly
		//string sRow = ;
		
		
		CSLStoreTrueAppearance(oTarget);
		CSLAnimationOverride(oTarget, StringToInt( sCommand ));
		
		CSLDMAppear_AnimationModes( oTarget, oPC );	
		//SendMessageToPC(OBJECT_SELF, "Setting "+GetName(oTarget)+" to "+sCommand+", new appearance is "+IntToString( GetAppearanceType(oTarget))+" - "+sPageTitle  );
		
		return;
	}
	else if (sInput=="male")
	{
		if ( !GetIsObjectValid( oTarget ) ) { return; }
		
		//SendMessageToPC(OBJECT_SELF, "Setting "+GetName(oTarget)+" to Male, if an NPC a trip to limbo might make it work, if a Player they must relog for it to take effect" );
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
		if ( !GetIsObjectValid( oTarget ) ) { return; }
		
		// SendMessageToPC(OBJECT_SELF, "Setting "+GetName(oTarget)+" to Female, if an NPC a trip to limbo might make it work, if a Player they must relog for it to take effect" );
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
}				