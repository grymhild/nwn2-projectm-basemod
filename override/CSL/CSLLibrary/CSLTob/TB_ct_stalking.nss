//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/18/2009							//
//	Title: TB_ct_stalking						//
//	Description: When an opponent adjacent //
// to you moves, you can initiate this 	//
// maneuver to immediately move adjacent to//
// her as soon as she stops moving, as long//
// as the distance you cover is less than //
// or equal to your speed. This movement 	//
// does not provoke attacks of opportunity.//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void StalkingShadow(object oPC, object oToB)
{
	object oTarget = GetLocalObject(oToB, "StalkingShadow");

	if ((hkCounterGetHasActive(oPC,112)) && GetIsObjectValid(oTarget))
	{
		location lTarget = GetLocation(oTarget);
		location lLast = GetLocalLocation(oPC, "Stalking_loc");

		if (lLast != lTarget)
		{
			if ((GetDistanceBetweenLocations(lLast, lTarget) >= FeetToMeters(5.0f)) && (CSLLineOfEffect(oPC, lLast, TRUE)))
			{
				TOBClearStrikes();
				ClearAllActions();
				JumpToLocation(lLast);
				FloatingTextStringOnCreature("<color=cyan>*Stalking Shadow!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
				TOBRunSwiftAction(112, "C");
			}
			else DelayCommand(1.0f, StalkingShadow(oPC, oToB));
		}
		else DelayCommand(1.0f, StalkingShadow(oPC, oToB));
	}
	else DeleteLocalLocation(oPC, "Stalking_loc");
}



void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));

	if (TOBNotMyFoe(oPC, oTarget))
	{
		SendMessageToPC(oPC, "<color=red>You cannot target yourself or your allies with this maneuver.</color>");
		return;
	}

	if (GetDistanceBetween(oPC, oTarget) - CSLGetGirth(oTarget) <= FeetToMeters(8.0f))
	{
		SetLocalObject(oToB, "StalkingShadow", oTarget);
		SetLocalLocation(oPC, "Stalking_loc", GetLocation(oTarget));
		TOBExpendManeuver(112, "C");
		StalkingShadow(oPC, oToB);
	}
	else SendMessageToPC(oPC, "<color=red>You must choose a target adjacent to you.</color>");
}
