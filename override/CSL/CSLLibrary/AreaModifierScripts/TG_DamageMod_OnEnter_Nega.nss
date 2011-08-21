/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC =  GetEnteringObject();
	
	if (  GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
	{
		SetLocalInt( oPC, "HKPERM_damagemodtype", DAMAGE_TYPE_NEGATIVE );
	}
}