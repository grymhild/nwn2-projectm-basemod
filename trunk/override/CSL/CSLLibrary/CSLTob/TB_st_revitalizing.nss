//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 8/25/2009							//
//	Title: TB_st_revitalizing					//
//	Description: Standard Action; On a		//
//	successful hit the player or an ally	//
//	within ten feet heals 3d6+1 per 		//
//	intitiator level of damage (max +10).	//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_variables"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 47);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(47, "STR");

	if (nHit > 0)
	{
		int nMyAlign = CSLGetCreatureAlignment(oPC);
		int nFoeAlign = CSLGetCreatureAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator;

			if (TOBGetInitiatorLevel(oPC) < 10)
			{
				nInitiator = TOBGetInitiatorLevel(oPC);
			}
			else nInitiator = 10;

			object oHeal;

			oHeal = GetFactionMostDamagedMember(oPC);

			if (GetDistanceBetween(oPC, oHeal) > FeetToMeters(10.0f))
			{
				oHeal = oPC;
			}

			int nHeal = d6(3) + nInitiator;
			effect eHeal = TOBManeuverHealing(oHeal, nHeal);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
		}
	}
}
