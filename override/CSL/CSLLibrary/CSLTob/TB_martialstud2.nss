//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/5/2009							//
//	Title: TB_martialstud12					//
//	Description: Allows the player to learn	//
//	any maneuver except stance. Can be		//
//	taken up to three times.				//
//////////////////////////////////////////////
//#include "bot9s_include"
//#include "bot9s_inc_constants"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void EnforceData()
{
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);

	if (GetIsObjectValid(oToB))
	{
		int nManeuverLevel = GetHitDice(oPC);
		SetLocalInt(oToB, "MartialStudy2", nManeuverLevel);
	}
	else DelayCommand(0.1f, EnforceData());
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

	if (GetLocalInt(oToB, "MartialStudy2") == 0)
	{
		EnforceData();
	}

	if (!GetHasFeat(FEAT_MARTIAL_ADEPT, oPC))
	{
		CSLWrapperFeatAdd(oPC, FEAT_MARTIAL_ADEPT, FALSE);
	}

	if (!GetHasFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC))
	{
		CSLWrapperFeatAdd(oPC, FEAT_STUDENT_OF_THE_SUBLIME_WAY, FALSE);
	}
}
