//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 4/27/2009								//
//	Name: TB_dualboost						//
//	Description: Allows a PC to use two Boost	//
//	maneuvers in the same round 3 times per day.//
//////////////////////////////////////////////////

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
	
	int nDualBoost = GetLocalInt(oToB, "DualBoost");

	if (nDualBoost > 0)
	{
		FloatingTextStringOnCreature("<color=cyan>*Dual Boost Active!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		SetLocalInt(oToB, "DualBoostActive", 1);
	}
	else SendMessageToPC(oPC, "<color=red>You must rest before you can use Dual Boost again.</color>");
}
