//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/13/2009									//
//	Name: TB_avengingstri							//
//	Description: Handles the daily uses of the feat	//
//	Avenging Strike.								//
//////////////////////////////////////////////////////
//#include "bot9s_include"
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
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------

	if (!GetHasFeat(FEAT_AVENGING_STRIKE, oPC))
	{
		CSLWrapperFeatAdd(oPC, FEAT_AVENGING_STRIKE, FALSE);
	}

	int nMyCHA = GetAbilityModifier(ABILITY_CHARISMA);

	if (GetLastRestEventType() == REST_EVENTTYPE_REST_FINISHED)
	{
		SetLocalInt(oPC, "AvengingStrikeUses", nMyCHA);
	}
}