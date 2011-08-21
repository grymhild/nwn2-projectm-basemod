///////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 5/15/2009										//
//	Name: TB_smiteA									//
//	Description: Handles the daily uses of the Crusader's//
//	Smite ability.										//
///////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
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
	
	int nLevel = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nUses;

	if (nLevel > 29) // Epic support, in keeping with the gap between increases of this feat's use.
	{
		nUses += 3;
	}
	else if (nLevel > 17)
	{
		nUses += 2;
	}
	else if (nLevel > 5)
	{
		nUses += 1;
	}

	if (GetHasFeat(FEAT_EXTRA_SMITING, oPC))
	{
		nUses += 2;
	}

	if (GetLastRestEventType() == REST_EVENTTYPE_REST_FINISHED)
	{
		SetLocalInt(oToB, "SmiteUses", nUses);
	}
}
