//////////////////////////////////////////////////
// Author: Drammel								//
// Date: 9/18/2009								//
// Title: TB_sa_shifting_def						//
// Description: While you are in this stance, //
// after you take damage you gain a temporary //
// damage absorbtion effect for one and a half //
// seconds. The armor class value of this 	//
// effect is equal to your current armor class //
// plus your dexterity modifier. You gain this//
// effect only once per round.					//
//////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void ShiftingDefense( object oPC = OBJECT_SELF )
{
	object oToB = CSLGetDataStore(oPC);

	if (hkStanceGetHasActive(oPC,110))
	{
		int nMyHp = GetLocalInt(oToB, "ShiftingDefenseHP");
		int nMyHp2 = GetCurrentHitPoints();

		if ((nMyHp > nMyHp2) && (GetLocalInt(oToB, "ShiftingDefense") == 0))
		{
			int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
			effect eVis = EffectVisualEffect(VFX_TOB_SHIFTING);
			effect eShiftingDefense = EffectAbsorbDamage(nDex);
			eShiftingDefense = ExtraordinaryEffect(eShiftingDefense);

			SetLocalInt(oToB, "ShiftingDefense", 1); //Only once a round.
			DelayCommand(6.0f, SetLocalInt(oToB, "ShiftingDefense", 0));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShiftingDefense, oPC, 1.5f);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 1.5f);
		}

		DelayCommand(0.1f, ShiftingDefense(oPC));
	}
	else DeleteLocalInt(oToB, "ShiftingDefenseHP");
}

void RunRoundHealth(object oPC = OBJECT_SELF)
{
	if (hkStanceGetHasActive(oPC,110))
	{
		object oPC = OBJECT_SELF;
		object oToB = CSLGetDataStore(oPC);

		SetLocalInt(oToB, "ShiftingDefenseHP", GetCurrentHitPoints());
		DelayCommand(5.8f, RunRoundHealth(oPC));
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
	
	RunRoundHealth(oPC);
	ShiftingDefense(oPC);
}