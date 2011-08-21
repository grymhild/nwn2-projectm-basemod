#include "seed_db_inc"
#include "_SCInclude_Graves"

#include "_CSLCore_Environment"

void main()
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oPC = GetEnteringObject();
	object oArea = OBJECT_SELF;
	if(!GetIsPC(oPC))  return;
	SDB_OnAreaEnter(oArea);
	DelayCommand( 6.0f, DeleteLocalInt(oPC, "TRANSITION") );
	CheckAreaSpellsDeactivated(oArea, oPC); // IF AREA HAS THE NO MAGIC FLAG, GIVE PC NO MAGIC EFFECT
	
	CSLEnviroAreaEntry( oPC, oArea );
}