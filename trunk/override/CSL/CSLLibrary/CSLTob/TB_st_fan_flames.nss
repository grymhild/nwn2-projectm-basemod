//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/28/2009									//
//	Title: TB_st_fan_flames							//
//	Description: If you make a successful ranged 	//
// touch attack, your target takes 6d6 points of 	//
// fire damage.									//
//////////////////////////////////////////////////////
//#include "bot9s_inc_2da"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 8);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "DesertWindStrike", 0));

	int nHit = TouchAttackRanged(oTarget);
	float fHitDist = CSLGetGirth(oTarget);
	float fDist = GetDistanceBetween(oPC, oTarget);

	if (fDist <= ((FeetToMeters(30.0f) + fHitDist)))
	{
		location lPC = GetLocation(oPC);

		if (nHit > 0)
		{
			int nDamage;

			if (nHit == 1)
			{
				nDamage = d6(6);
			}
			else nDamage = d6(12);

			effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
			float fDelay = CSLGetSpellEffectDelay(lPC, oTarget);

			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		}

		CSLWatchOpponent(oTarget, oPC);
		CSLPlayCustomAnimation_Void(oPC, "Throw", 0);
		SpawnSpellProjectile(oPC, oTarget, lPC, GetLocation(oTarget), SPELL_FIREBALL, PROJECTILE_PATH_TYPE_DEFAULT);
		TOBExpendManeuver(8, "STR");
	}
	else SendMessageToPC(oPC, "<color=red>You must be within 30 feet of your target to use this maneuver.</color>");
}
