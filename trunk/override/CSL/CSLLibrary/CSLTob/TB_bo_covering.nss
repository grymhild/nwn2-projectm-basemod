//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/12/2009									//
//	Title: TB_bo_covering								//
//	Description: After you initiate this boost, you //
// can make your attacks as normal. In addition to //
// taking normal melee damage from your blows, a 	//
// foe you strike after initiating this maneuver, //
// that is not attacking you, takes a penalty to 	//
// attack rolls equal to your ranks in Diplomacy 	//
// minus four, divided by four, to a minimum of a //
// minus one penalty to attack rolls.				//
//////////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

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
		SetLocalInt(oPC, "CoveringStrike", 1);
		DelayCommand(6.0f, DeleteLocalInt(oPC, "CoveringStrike"));

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else
		{
			TOBManageCombatOverrides(TRUE);
			DelayCommand(6.0f, TOBProtectedClearCombatOverrides(oPC));
		}

		TOBRunSwiftAction(191, "B");
		TOBExpendManeuver(191, "B");
	}
}
