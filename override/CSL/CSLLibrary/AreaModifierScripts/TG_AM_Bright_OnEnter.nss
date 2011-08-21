/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC;
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_CREATURE ) // script is being manually run on the target, generally done via areas
	{
		oPC = OBJECT_SELF;
	}
	else // if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_TRIGGER || GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		oPC = GetEnteringObject();
	}
	
	CSLEnviroEntry( oPC, CSL_ENVIRO_BRIGHT );
	//CSLEnviroCheckDeadMagicState( oPC );
}