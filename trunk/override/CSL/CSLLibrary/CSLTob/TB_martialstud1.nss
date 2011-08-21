//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/5/2009							//
//	Title: TB_martialstud1						//
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
		SetLocalInt(oToB, "MartialStudy1", nManeuverLevel);
	}
	else DelayCommand(0.1f, EnforceData());
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

	if (GetLocalInt(oToB, "MartialStudy1") == 0)
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

	if (!GetHasFeat(FEAT_MARTIAL_STUDY_TOGGLE, oPC))
	{
		CSLWrapperFeatAdd(oPC, FEAT_MARTIAL_STUDY_TOGGLE, FALSE);
	}
}
