#include "_CSLCore_Environment"
#include "_CSLCore_Messages"
#include "_CSLCore_Player"

void main()
{
	// get principle actors
	
	if ( GetLocalInt( GetModule(), "CSL_CIRCLEHASENDED" ) )
	{
		return; // keep its from running too often
	}
			
	SetLocalInt( GetModule(), "CSL_CIRCLEHASENDED", TRUE );
	DelayCommand( HoursToSeconds(1), DeleteLocalInt( GetModule(), "CSL_CIRCLEHASENDED" ) );
	
	object oLever = GetLocalObject( GetModule(), "CSL_CURRENTCIRCLE" );
	if ( GetIsObjectValid( oLever ) )
	{
		// get current variables related to state
		 object oCurrentMaster = GetLocalObject( oLever, "CSL_CURRENTMASTER" );
		
		 object oMostMaster = GetLocalObject( oLever, "CSL_CURRENTMOSTMASTER" );
		
		int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
		if ( iCurrentRound < 1 )// heartbeat is not running yet, lets start it, might give folks an extra round for the first time half the time, but it should already be started in the module events.
		{
			CSLEnviroGetControl();
			iCurrentRound = 1;
		}
		int iStartingRound = GetLocalInt( oLever, "CSL_ROUNDSTARTED" );
		int iTotalRounds =  iCurrentRound-iStartingRound;
		
		int iMostRounds = GetLocalInt( oLever, "CSL_MOSTROUNDS" );
		if ( iTotalRounds > iMostRounds )
		{
			SetLocalObject( oLever, "CSL_CURRENTMOSTMASTER", oCurrentMaster );
			SetLocalInt( oLever, "CSL_MOSTROUNDS", iTotalRounds );
			iMostRounds = iTotalRounds;
			//SendMessageToPC( oPC,"Your score of "+IntToString(iTotalRounds)+" rounds is now the best record for this reset." );
		}
		
		
		
		if ( GetIsObjectValid( oCurrentMaster ) && GetIsObjectValid( oMostMaster ) && oCurrentMaster == oMostMaster && iMostRounds > 30 )
		{
			SendMessageToPC( oCurrentMaster,"Your score of "+IntToString(iMostRounds)+" rounds is now the best record for this reset and you are king of circle at end of reset." );
			int iRealLevel = CSLGetRealLevel(oCurrentMaster);
			GiveXPToCreature(oCurrentMaster, 1000+250*iRealLevel );
		
		}
		else
		{
			if ( GetIsObjectValid( oCurrentMaster ) && iTotalRounds > 30 )
			{
				SendMessageToPC( oCurrentMaster,"You are king of circle at end of reset, Your score was "+IntToString(iTotalRounds)+" rounds." );
				int iRealLevel = CSLGetRealLevel(oCurrentMaster);
				GiveXPToCreature(oCurrentMaster, 250+50*iRealLevel );
				
			}
			
			if ( GetIsObjectValid( oMostMaster ) && iMostRounds > 30 )
			{
				SendMessageToPC( oCurrentMaster,"Your score of "+IntToString(iMostRounds)+" rounds is the best record for this session." );
				int iRealLevel = CSLGetRealLevel(oCurrentMaster);
				GiveXPToCreature(oCurrentMaster, 500+100*iRealLevel );
			}
		}
	}
	
}