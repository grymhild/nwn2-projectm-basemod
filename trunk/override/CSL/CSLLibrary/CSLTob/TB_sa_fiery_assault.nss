//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/1/2009								//
//	Title: TB_sa_fiery_assault						//
//	Description: While you are in this stance, //
// every melee attack you make deals an extra //
// 1d6 points of fire damage. This stance is a //
// supernatural ability.						//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void FieryAssault(object oPC = OBJECT_SELF)
{
	if (hkStanceGetHasActive(oPC,9))
	{
		object oToB = CSLGetDataStore(oPC);

		if ((GetCurrentAction(oPC) == ACTION_ATTACKOBJECT) || (GetLocalInt(oPC, "bot9s_maneuver_running") > 0))
		{
			effect eFire = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
			eFire = SupernaturalEffect(eFire);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 1.0f);
		}

		DelayCommand(1.0f, FieryAssault(oPC));
	}
}


void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	FieryAssault(oPC);
}