//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/6/2009							//
//	Title: TB_st_rallying						//
//	Description: As part of initiating this //
// strike, you must make a successful melee//
// attack against an enemy whose alignment //
// has at least one component different 	//
// from yours. This foe must pose a threat //
// to you or your allies in some direct, 	//
// immediate way. If your attack hits, you //
// and all allies within 30 feet of you 	//
// heal 3d6 points of damage + 1 point per //
// initiator level (maximum +15).			//
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
	
	object oTarget = TOBGetManeuverObject(oToB, 46);

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
	TOBExpendManeuver(46, "STR");

	if (nHit > 0)
	{
		int nMyAlign = CSLGetCreatureAlignment(oPC);
		int nFoeAlign = CSLGetCreatureAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator;

			if (TOBGetInitiatorLevel(oPC) < 15)
			{
				nInitiator = TOBGetInitiatorLevel(oPC);
			}
			else nInitiator = 15;

			float fRange = FeetToMeters(30.0f);
			location lPC = GetLocation(oPC);
			int nHeal;
			object oHeal;
			effect eHeal;

			oHeal = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oHeal))
			{
				if (!GetIsReactionTypeHostile(oHeal, oPC))
				{
					nHeal = d6(3) + nInitiator;
					eHeal = TOBManeuverHealing(oHeal, nHeal);

					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
				}

				oHeal = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}
		}
	}
}
