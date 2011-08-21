/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	//object oTrigger;
	//object oArea;
	object oPC;
	
	int iSelfType = GetObjectType( OBJECT_SELF );
	if ( iSelfType == OBJECT_TYPE_CREATURE )
	{
		oPC = OBJECT_SELF;
		//oArea = GetArea(oPC);

	}
	else if ( iSelfType == OBJECT_TYPE_TRIGGER )
	{
		//oTrigger = OBJECT_SELF;
		oPC = GetExitingObject();
		//oArea = GetArea(oPC);
	}
	else
	{
		oPC = GetExitingObject();
	
	}
	
	
	CSLEnviroExit( oPC, CSL_ENVIRO_WATER ); // can only be a single bit at a time
}