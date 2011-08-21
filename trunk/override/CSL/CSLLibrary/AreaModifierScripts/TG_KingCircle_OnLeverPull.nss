#include "_CSLCore_Environment"
#include "_CSLCore_Messages"

void main()
{
	// get principle actors
	object oPC =  GetLastUsedBy();
	object oLever = OBJECT_SELF;
	
	// get current variables related to state
	object oPreviousMaster = GetLocalObject( oLever, "CSL_CURRENTMASTER" );
	int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
	if ( iCurrentRound < 1 )// heartbeat is not running yet, lets start it, might give folks an extra round for the first time half the time, but it should already be started in the module events.
	{
		CSLEnviroGetControl();
		iCurrentRound = 1;
	}
	int iStartingRound = GetLocalInt( oLever, "CSL_ROUNDSTARTED" );
	int iTotalRounds = iCurrentRound-iStartingRound;
	
	
	if ( GetIsObjectValid( oPreviousMaster ) )
	{
		if ( oPreviousMaster == oPC )
		{
			// he's already in control
			SendMessageToPC( oPC,"You have been the master for "+IntToString(iTotalRounds)+" rounds, enjoy it while it lasts" );
			return;
		}
		
		if ( !GetIsDead(oPreviousMaster) && GetLocalInt( oPreviousMaster, "CSL_INCIRCLE") && GetArea( oPreviousMaster ) == GetArea( oLever )  )
		{
			SendMessageToPC( oPC,"You need to first kill or chase off "+GetName(oPreviousMaster) );
			return;
		}
	}
	
	if ( GetIsObjectValid( oPreviousMaster ) )
	{
		SendMessageToPC( oPreviousMaster,"Your mastery of the circle has been defeated by "+GetName(oPC)+ " after "+IntToString(iTotalRounds)+" rounds." );
		SendMessageToPC( oPC,"You are now master of the circle and have defeated "+GetName(oPreviousMaster)+ " who has been master for "+IntToString(iTotalRounds)+" rounds." );
		
		CSLShoutMsg( GetName(oPC)+" has defeated "+GetName(oPreviousMaster)+" who was master of the circle for "+IntToString(iTotalRounds)+" rounds." );
		
		int iMostRounds = GetLocalInt( oLever, "CSL_MOSTROUNDS" );
		if ( iTotalRounds > iMostRounds )
		{
			SetLocalObject( oLever, "CSL_CURRENTMOSTMASTER", oPreviousMaster );
			SetLocalInt( oLever, "CSL_MOSTROUNDS", iTotalRounds );
			SendMessageToPC( oPreviousMaster,"Your score of "+IntToString(iTotalRounds)+" rounds is now the best record for this reset." );
		}
	}
	else
	{
		SendMessageToPC( oPC,"You have stolen mastery of the circle without opposition" );
		
		CSLShoutMsg( GetName(oPC)+" is now master of the circle" );
	}
	
	SetLocalObject( GetModule(), "CSL_CURRENTCIRCLE", oLever );
	
	SetLocalObject( oLever, "CSL_CURRENTMASTER", oPC );
	SetLocalInt( oLever, "CSL_ROUNDSTARTED", iCurrentRound );
	
	SetLocalObject( oPC, "CSL_CURRENTCIRCLE", oLever );
	//SetLocalObject( oPC, "CSL_CURRENTCIRCLE", oLever );
	SetLocalInt( oPC, "CSL_INCIRCLE", TRUE ); // in case the trigger is not present
	
	//SendMessageToPC( oPC,"You are now the master of the circle!");
}