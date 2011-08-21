//::///////////////////////////////////////////////
//:: PW Invisibility workaround module heartbeat
//:: dd_inv_hb.nss
//:: Copyright (c) 2007 Dedo
//:://////////////////////////////////////////////
/*
	Put on Module HeartBeat. PG now are really invisible
*/


//#include "_HkSpell"
//#include "_SCInclude_Invisibility"
#include "_SCInclude_Class"

void main()
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oPC;
	oPC = GetFirstPC();
	while ( GetIsObjectValid( oPC ) )
	{
		// Add in other heartbeat checks here, make sure everything here is very optimized as it gets run a lot
		// Need to look at how this gets implemented in the long run
		//SendMessageToPC( oPC, "Heart beating");
		
		
		
		checkHeartBeatElaborateParry( oPC );
		checkHeartBeatDeadlyDefense( oPC );
		checkHeartBeatTwoWeaponDefense( oPC );
		checkHeartBeatDervishParry( oPC );
		// This is probably obsolete
		// Note that this is only for the MP Invis fix, and if not used the entire heartbeat could be removed, and if used this variable check should be removed as well
		//if ( GetLocalInt( GetModule(), "SC_MPINVISFIX" ) == TRUE )
		//{
		//	// this checks for the invisibility status, and removes or adds it as needed
		//	SCHeartBeatInvisCheck( oPC );
		//}
		
		
		oPC = GetNextPC();
	}
}