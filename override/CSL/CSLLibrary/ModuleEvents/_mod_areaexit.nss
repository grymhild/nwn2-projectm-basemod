#include "_SCInclude_Graves"
#include "_CSLCore_Environment"

void main()
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oPC = GetExitingObject();
	object oArea = OBJECT_SELF;
	if (!GetIsPC(oPC)) return;
	
	SetLocalInt( oPC, "TRANSITION", TRUE );
	ClearAreaSpellsDeactivated(oArea, oPC); // IF AREA HAS NO SPELLS FLAG, REMOVE THE EFFECT FROM PC
	
	CSLEnviroAreaExit( oPC, oArea );
	
}