//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/27/2009						//
//	Title: TB_ct_diamond_def					//
//	Description: You can initiate this 	//
// maneuver any time before you would be 	//
// required to make a saving throw. You 	//
// gain a bonus on that save equal to your //
// initiator level. You use this maneuver //
// before you roll the saving throw. 		//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void DiamondDefense()
{
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------

	int nBonus = TOBGetInitiatorLevel(oPC);

	if (hkCounterGetHasActive(oPC,57))
	{
		effect eBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
		eBonus = ExtraordinaryEffect(eBonus);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 0.99f);

		object oTest = IntToObject(GetLocalInt(oToB, "SaveTarget"));

		if ((oTest == oPC) && (GetLocalInt(oToB, "SaveType") == SAVING_THROW_ALL) && !HkSwiftActionIsActive(oPC) )
		{
			SetLocalInt(oToB, "SaveType", 0);
			SetLocalInt(oToB, "SaveTarget", 0);
			FloatingTextStringOnCreature("<color=cyan>*Diamond Defense!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			TOBRunSwiftAction(57, "C");
		}
		else DelayCommand(1.0f, DiamondDefense());
	}
}

void main()
{	
	
	TOBExpendManeuver(57, "C");
	DiamondDefense();
}
