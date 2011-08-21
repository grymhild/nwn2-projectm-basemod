//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/17/2009								//
//	Title: TB_st_colossus								//
//	Description: As part of this maneuver, you make //
// a melee attack against your foe. This attack 	//
// deals an extra 6d6 points of damage, and the 	//
// creature struck must succeed on a Fortitude save//
// (DC 17 + your Str modifi er) or be hurled 1d4 	//
// squares away from you, falling prone in that 	//
// square. A creature of a smaller size category 	//
// than yours gets a –2 penalty on this save; a 	//
// creature of a larger size category than yours 	//
// gets a +2 bonus on the save. The enemy’s 		//
// movement doesn’t provoke attacks of opportunity.//
// If an obstacle blocks the creature’s movement, //
// it instead stops in the first unoccupied square //
//////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 147);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "StoneDragonStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
	TOBExpendManeuver(147, "STR");

	if (nHit > 0)
	{
		int nMySize = GetCreatureSize(oPC);
		int nFoeSize = GetCreatureSize(oTarget);
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC;

		nDC = TOBGetManeuverDC(nStr, 0, 17);

		if (nMySize > nFoeSize)
		{
			nDC += 2;
		}
		else if (nMySize < nFoeSize)
		{
			nDC -= 2;
		}

		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			float fSpace = GetDistanceBetween(oPC, oTarget);
			float fDist = fSpace + (5.0f * IntToFloat(d4(1)));
			effect eHit = EffectVisualEffect(VFX_COM_SPARKS_PARRY);
			effect eKnockdown = EffectKnockdown();

			DelayCommand(0.3f, CSLThrowTarget(oTarget, fDist));
			DelayCommand(0.29f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
			DelayCommand(1.0f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f));
		}
	}
}
