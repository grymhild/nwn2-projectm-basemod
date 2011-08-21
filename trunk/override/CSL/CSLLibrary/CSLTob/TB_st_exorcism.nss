//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/28/2009								//
//	Title: TB_st_exorcism							//
//	Description: As part of this maneuver, make //
//	a single melee attack against an opponent.	//
//	This is a touch attack rather than a 		//
//	standard melee attack. If you hit, you deal //
//	normal melee damage.						//
//////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_attack"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_variables"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 81);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(81, "STR");

	object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

	if ((GetIsObjectValid(oFoeWeapon)) && (nHit > 0 ))
	{
		int nBonus;
		int nFoeBonus;

		if (CSLGetIsHeldWeaponTwoHanded(oPC))
		{
			nBonus += 4;
		}

		if (CSLItemGetIsLightWeapon(oWeapon, oPC))
		{
			nBonus -= 4;
		}

		int nMySize = GetCreatureSize(oPC);
		int nFoeSize = GetCreatureSize(oTarget);
		int nBig = abs(nMySize - nFoeSize);

		if (nMySize > nFoeSize)
		{
			nBonus += 4 * nBig;
		}
		else if (nFoeSize > nMySize)
		{
			nFoeBonus += 4 * nBig;
		}

		int nAB = CSLGetMaxAB(oPC, oWeapon, oTarget);
		int nFoeAB = CSLGetMaxAB(oTarget, oFoeWeapon, oPC);
		int nd20 = d20();
		int nFoed20 = d20();
		int nRoll = nd20 + nAB + nBonus;
		int nFoeRoll = nFoed20 + nFoeAB + nFoeBonus;

		SendMessageToPC(oPC, "<color=chocolate>Exorcism of Steel: Sunder: (" + IntToString(nd20) + " + " + IntToString(nAB) + " + " + IntToString(nBonus) + " = " + IntToString(nRoll) + ") vs. " + GetName(oTarget) + "'s opposed roll: (" + IntToString(nFoed20) + " + " + IntToString(nFoeAB) + " + " + IntToString(nFoeBonus) + " = " + IntToString(nFoeRoll) + ").</color>");

		if (nRoll >= nFoeRoll)
		{
			int nDamageType = CSLGetWeaponDamageType(oFoeWeapon);
			int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
			int nDC = TOBGetManeuverDC(nStr, 0, 13);
			int nWill = HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC);
			int nPenalty;

			if (nWill == 0)
			{
				nPenalty = 4;
			}
			else if (GetHasFeat(6818, oTarget)) // Mettle
			{
				nPenalty = 0;
			}
			else nPenalty = 2;

			effect eExorcism = EffectDamageDecrease(nPenalty, nDamageType);
			eExorcism = ExtraordinaryEffect(eExorcism);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExorcism, oTarget, 60.0f);
		}
	}
}
