//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/30/2009						//
//	Title: TB_st_righteous						//
//	Description: When you make this strike, //
// you or one ally within 10 feet of you 	//
// gains the benefit of a heal spell cast //
// as a cleric of your character level. To //
// gain the benefit of this maneuver, you //
// must strike an enemy creature whose 	//
// alignment has at least one component 	//
// different from yours. This foe must pose//
// a threat to you or your allies in some //
// direct, immediate way. 				//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_variables"
//#include "tob_inc_spells"
#include "_HkSpell"
#include "_SCInclude_Healing"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 50);

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
	TOBExpendManeuver(50, "STR");

	if (nHit > 0)
	{
		int nMyAlign = CSLGetCreatureAlignment(oPC);
		int nFoeAlign = CSLGetCreatureAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator = TOBGetInitiatorLevel(oPC);

			object oHeal;

			oHeal = GetFactionMostDamagedMember(oPC);

			if ((oHeal != oPC) && (GetDistanceBetween(oPC, oHeal) > FeetToMeters(10.0f)))
			{
				oHeal = oPC;
			}

			// Heal target will figure out if whether it needs to heal or harm.
			SCHealHarmTarget(oHeal, nInitiator, SPELL_HEAL, TRUE);
		}
	}
}
