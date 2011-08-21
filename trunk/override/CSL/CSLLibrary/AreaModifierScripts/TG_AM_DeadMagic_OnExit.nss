/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC =  GetEnteringObject();
	
	if (  GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
	{
		SetLocalInt( oPC, "HKPERM_Blocked", FALSE );
	}
	
	CSLEnviroExit( oPC, CSL_ENVIRO_DEADMAGIC );
	//CSLEnviroCheckDeadMagicState( oPC );
}