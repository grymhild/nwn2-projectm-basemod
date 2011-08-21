/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC;
	object oTrigger;
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_CREATURE ) // script is being manually run on the target, generally done via areas
	{
		oPC = OBJECT_SELF;
		oTrigger = GetArea(oPC);
	}
	else // if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_TRIGGER || GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		oPC = GetExitingObject();
		oTrigger = OBJECT_SELF;
	}
	
	CSLEnviroExit( oPC, GetLocalInt( oTrigger, "CSL_ENVIRO" ) );
}