//////////////////////////////////////////////
// Author: Drammel							//
// Date: 10/22/2009						//
// Title: TB_crbookssaint					//
// Description: Creates the Book of the 	//
// Nine Swords and Martial Journal for the //
// Saint. After these have been created 	//
// this button toggles on and off the 	//
// Saint's martial adept menu. 			//
//////////////////////////////////////////////
//#include "bot9s_inc_index"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void main()
{	
	// this forces it to echo out debugging always
	DEBUGGING = 7;
	if (DEBUGGING >= 7) { CSLDebug(  "TB_crbookscrusa Start", GetFirstPC() ); }
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------

	//Ensures that the game checks an item unique to the player.
	//This is to prevent script confusion with characters of the same class.
}