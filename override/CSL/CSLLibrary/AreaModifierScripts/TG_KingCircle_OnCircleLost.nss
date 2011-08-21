#include "_CSLCore_Environment"
#include "_CSLCore_Messages"

void main()
{
	// get principle actors
	object oPC = OBJECT_SELF;
	object oLever = GetLocalObject( GetModule(), "CSL_CURRENTCIRCLE" );
	
	if ( GetIsObjectValid( oLever ) )
	{
		// get current variables related to state
		object oCurrentMaster = GetLocalObject( oLever, "CSL_CURRENTMASTER" );
		int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
		if ( iCurrentRound < 1 )// heartbeat is not running yet, lets start it, might give folks an extra round for the first time half the time, but it should already be started in the module events.
		{
			CSLEnviroGetControl();
			iCurrentRound = 1;
		}
		int iStartingRound = GetLocalInt( oLever, "CSL_ROUNDSTARTED" );
		int iTotalRounds =  iCurrentRound-iStartingRound;
		
		
		if ( GetIsObjectValid( oCurrentMaster ) && oPC == oCurrentMaster )
		{
			object oKiller = GetLocalObject(oPC, "CIRCLELASTKILLER");
			DeleteLocalObject(oPC, "CIRCLELASTKILLER");
			if ( GetIsObjectValid( oKiller ) )
			{
				SendMessageToPC( oKiller,"You killed the master of the circle" );
				SendMessageToPC( oPC,"You are no longer master of the circler after "+IntToString(iTotalRounds)+" rounds." );
			}
			
			int iMostRounds = GetLocalInt( oLever, "CSL_MOSTROUNDS" );
			if ( iTotalRounds > iMostRounds )
			{
				SetLocalObject( oLever, "CSL_CURRENTMOSTMASTER", oPC );
				SetLocalInt( oLever, "CSL_MOSTROUNDS", iTotalRounds );
				SendMessageToPC( oPC,"Your score of "+IntToString(iTotalRounds)+" rounds is now the best record for this reset." );
			}
		}
			

	}
}