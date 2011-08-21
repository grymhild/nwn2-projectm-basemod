/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC =  GetEnteringObject(); // only works if it's in a trigger or an AOE
	if( !GetIsObjectValid( oPC ) ) // this is to make it runnable via rs command or execute as well
	{
		if ( GetObjectType(OBJECT_SELF)==OBJECT_TYPE_CREATURE )
		{
			oPC == OBJECT_SELF;
		}
	}
	
	if (  GetIsObjectValid( oPC ) && ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC ) )  )
	{
		CSLAnimationOverride( oPC, CSL_ANIMATEOVERRIDE_NONE );
		SendMessageToPC( oPC, "You exited"  );
	}
}