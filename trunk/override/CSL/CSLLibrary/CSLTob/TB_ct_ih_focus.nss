/////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 9/18/2009										//
//	Name: TB_ct_ih_focus									//
//	Description: As an immediate action, you can reroll//
// a saving throw you have just made. You must accept //
// the result of this second roll, even if the new 	//
// result is lower than your initial roll.The real 	//
// work for this ability is done in nw_i0_spells, 	//
// under the function HkSavingThrow. 				//
/////////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void IronHeartFocus( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID )
{
	

	if (hkCounterGetHasActive(oPC,84))
	{
		int nIHFocus = GetLocalInt(oToB, "IronHeartFocus");

		if (nIHFocus == 1)
		{
			FloatingTextStringOnCreature("<color=cyan>*Iron Hear Focus!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			SetLocalInt(oToB, "IronHeartFocus", 0);
			TOBRunSwiftAction(84, "C");
		}
		else DelayCommand(1.0f, IronHeartFocus());
	}
}


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
	
	TOBExpendManeuver(84, "C");
	IronHeartFocus(oPC,oToB);
}
