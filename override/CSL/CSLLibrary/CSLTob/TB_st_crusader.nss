//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: TB_st_crusader						//
//	Description: Standard Action; On a		//
//	successful hit the player or an ally	//
//	within ten feet heals 1d6+1 per 		//
//	intitiator level of damage (max +5).	//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 33);

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
	TOBExpendManeuver(33, "STR");

	if (nHit > 0)
	{
		int nMyAlign = CSLGetCreatureAlignment(oPC);
		int nFoeAlign = CSLGetCreatureAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator;

			if (TOBGetInitiatorLevel(oPC) < 5)
			{
				nInitiator = TOBGetInitiatorLevel(oPC);
			}
			else nInitiator = 5;

			object oHeal;

			oHeal = GetFactionMostDamagedMember(oPC);

			if ((oHeal != oPC) && (GetDistanceBetween(oPC, oHeal) > FeetToMeters(10.0f)))
			{
				oHeal = oPC;
			}

			int nHeal = d6(1) + nInitiator;
			effect eHeal = TOBManeuverHealing(oHeal, nHeal);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
		}
	}
}
