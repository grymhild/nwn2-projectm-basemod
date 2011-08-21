//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/19/2009									//
//	Name: TB_fallingsunat							//
//	Description: Allows the PC to incorperate a 	//
//	Stunning Fist attack into a Setting Sun strike	//
//	by decalaring the feat as active and running the//
//	effect from Setting Sun strikes.				//
//////////////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------

	if (GetHasFeat(FEAT_STUNNING_FIST))
	{
		object oToB = CSLGetDataStore(oPC);

		SetLocalInt(oToB, "FallingSun", 1);
		DelayCommand(6.0f, SetLocalInt(oToB, "FallingSun", 0));
		FloatingTextStringOnCreature("<color=cyan>Falling Sun Attack has been declared for six seconds.</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	}
}