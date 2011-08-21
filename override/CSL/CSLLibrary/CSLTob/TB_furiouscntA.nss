///////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 5/13/2009										//
//	Name: TB_furiouscountA								//
//	Description: Controls wether or not the PC accepts	//
//	healing	to their Delayed damage pool.				//
///////////////////////////////////////////////////////////

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
	
	int nFurious = GetLocalInt(oToB, "FuriousCounterstrike");

	if (nFurious == 0)
	{
		SetLocalInt(oToB, "FuriousCounterstrike", 1);
		FloatingTextStringOnCreature("<color=cyan>*Delayed Damage Pool Healing Disabled.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
	}
	else
	{
		SetLocalInt(oToB, "FuriousCounterstrike", 0);
		FloatingTextStringOnCreature("<color=cyan>*Delayed Damage Pool Healing Enabled.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
	}
}
