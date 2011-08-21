//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: TB_songwhiterav									//
//	Description: While in a White Raven Stance you	//
//	can activate Inspire Courage as a swift action.	//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_constants"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------

	if ( !HkSwiftActionIsActive(oPC) )
	{
		if ( hkStanceGetHasActive( oPC, STANCE_BOLSTERING_VOICE,STANCE_LEADING_THE_CHARGE,STANCE_PRESS_THE_ADVANTAGE,STANCE_SWARM_TACTICS,STANCE_TACTICS_OF_THE_WOLF) )
		{
			ExecuteScript("SG_songinspcour", oPC);
			TOBRunSwiftAction(215, "F");
		}
	}
}
