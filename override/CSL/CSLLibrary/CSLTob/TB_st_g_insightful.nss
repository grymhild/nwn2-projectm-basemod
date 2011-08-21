//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 10/6/2009										//
//	Title: TB_st_g_insightful								//
//	Description: This maneuver functions like insightful//
// strike, except that you deal damage equal to 2 × 	//
// your Concentration check result.					//
//////////////////////////////////////////////////////////
//#include "bot9s_inc_fx"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 63);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	TOBExpendManeuver(63, "STR");
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 1.2f);
	CSLPlayCustomAnimation_Void(oPC, "*sneakattack", 0);
	TOBStrikeTrailEffect(oWeapon, nHit, 2.0f);
	TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, 0, FALSE, TRUE); //Damage is supressed, but all other relavent events fire.

	if (nHit > 0)
	{
		int nd20 = d20();
		int nConcentration;

		if (GetHasFeat(6908, oPC)) // Blade Meditation adds to the skill, but is not included in GetSkillRank.
		{
			nConcentration += 1;
		}

		nConcentration += GetSkillRank(SKILL_CONCENTRATION, oPC);

		if ((nHit == 2) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			nConcentration = nConcentration * 2;
			nd20 = nd20 * 2;
		}

		if (nConcentration < 1)
		{
			nConcentration = 1;
		}

		int nDamage = (nConcentration + nd20) * 2;
		int nDamageType = CSLGetWeaponDamageType(oWeapon);
		effect eDamage = EffectDamage(nDamage, nDamageType);

		SendMessageToPC(oPC, "<color=chocolate>Greater Insightful Strike: Concentration : " + "(" + IntToString(nConcentration) + " + " + IntToString(nd20) + " x 2 " + " = " + IntToString(nDamage) + ").</color>");
		DelayCommand(1.34f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		DelayCommand(1.34f, SpawnBloodHit(oTarget, OVERRIDE_ATTACK_RESULT_PARRIED, oPC));
	}
}
