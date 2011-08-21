//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/18/2009								//
//	Title: TB_ct_wallofblades						//
//	Description: When an enemy makes a melee or //
// ranged attack against you, you can initiate //
// this counter to oppose that attack by making//
// an attack roll with any melee weapon you are//
//	holding. Use the higher of your AC or your //
// attack roll as your effective AC against the//
// incoming attack. You can’t use this maneuver//
// if you are denied your Dexterity bonus to AC//
// against your attacker.						//
//////////////////////////////////////////////////
//#include "bot9s_attack"
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void GenerateFoes(object oPC, object oToB)
{
	int n;
	object oFoe;

	n = 1;
	oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (GetIsReactionTypeHostile(oFoe, oPC)))
		{
			if (GetObjectSeen(oFoe, oPC) || GetObjectHeard(oFoe, oPC))
			{
				SetLocalObject(oToB, "WallofBladesFoe" + IntToString(n), oFoe);
				n++;

				if (n > 10)//Only so many that I can manually keep track of.
				{
					break;
				}
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void WallOfBlades(object oPC, object oToB, int nRoll, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, nRoll, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "WALLOFBLADES", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "WALLOFBLADES" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if ((hkCounterGetHasActive(oPC,96)) && (GetLocalInt(oPC, "WallofBladesActive") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "WallofBladesFoe1");

		if ((GetIsObjectValid(oFoe1)) && (GetAttackTarget(oFoe1) == oPC))
		{
			if (GetLocalInt(oFoe1, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe1, TOBManageCombatOverrides(TRUE, oFoe1));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe1));
			}
		}

		object oFoe2 = GetLocalObject(oToB, "WallofBladesFoe2");

		if ((GetIsObjectValid(oFoe2)) && (GetAttackTarget(oFoe2) == oPC))
		{
			if (GetLocalInt(oFoe2, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe2, TOBManageCombatOverrides(TRUE, oFoe2));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe2));
			}
		}

		object oFoe3 = GetLocalObject(oToB, "WallofBladesFoe3");

		if ((GetIsObjectValid(oFoe3)) && (GetAttackTarget(oFoe3) == oPC))
		{
			if (GetLocalInt(oFoe3, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe3, TOBManageCombatOverrides(TRUE, oFoe3));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe3));
			}
		}

		object oFoe4 = GetLocalObject(oToB, "WallofBladesFoe4");

		if ((GetIsObjectValid(oFoe4)) && (GetAttackTarget(oFoe4) == oPC))
		{
			if (GetLocalInt(oFoe4, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe4, TOBManageCombatOverrides(TRUE, oFoe4));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe4));
			}
		}

		object oFoe5 = GetLocalObject(oToB, "WallofBladesFoe5");

		if ((GetIsObjectValid(oFoe5)) && (GetAttackTarget(oFoe5) == oPC))
		{
			if (GetLocalInt(oFoe5, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe5, TOBManageCombatOverrides(TRUE, oFoe5));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe5));
			}
		}

		object oFoe6 = GetLocalObject(oToB, "WallofBladesFoe6");

		if ((GetIsObjectValid(oFoe6)) && (GetAttackTarget(oFoe6) == oPC))
		{
			if (GetLocalInt(oFoe6, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe6, TOBManageCombatOverrides(TRUE, oFoe6));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe6));
			}
		}

		object oFoe7 = GetLocalObject(oToB, "WallofBladesFoe7");

		if ((GetIsObjectValid(oFoe7)) && (GetAttackTarget(oFoe7) == oPC))
		{
			if (GetLocalInt(oFoe7, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe7, TOBManageCombatOverrides(TRUE, oFoe7));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe7));
			}
		}

		object oFoe8 = GetLocalObject(oToB, "WallofBladesFoe8");

		if ((GetIsObjectValid(oFoe8)) && (GetAttackTarget(oFoe8) == oPC))
		{
			if (GetLocalInt(oFoe8, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe8, TOBManageCombatOverrides(TRUE, oFoe8));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe8));
			}
		}

		object oFoe9 = GetLocalObject(oToB, "WallofBladesFoe9");

		if ((GetIsObjectValid(oFoe9)) && (GetAttackTarget(oFoe9) == oPC))
		{
			if (GetLocalInt(oFoe9, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe9, TOBManageCombatOverrides(TRUE, oFoe9));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe9));
			}
		}

		object oFoe10 = GetLocalObject(oToB, "WallofBladesFoe10");

		if ((GetIsObjectValid(oFoe10)) && (GetAttackTarget(oFoe10) == oPC))
		{
			if (GetLocalInt(oFoe10, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe10, TOBManageCombatOverrides(TRUE, oFoe10));
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oFoe10));
			}
		}

		DelayCommand(6.0f, WallOfBlades(oPC, oToB, nRoll, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oPC, "WallofBladesActive");
		DeleteLocalObject(oToB, "WallofBladesFoe1");
		DeleteLocalObject(oToB, "WallofBladesFoe2");
		DeleteLocalObject(oToB, "WallofBladesFoe3");
		DeleteLocalObject(oToB, "WallofBladesFoe4");
		DeleteLocalObject(oToB, "WallofBladesFoe5");
		DeleteLocalObject(oToB, "WallofBladesFoe6");
		DeleteLocalObject(oToB, "WallofBladesFoe7");
		DeleteLocalObject(oToB, "WallofBladesFoe8");
		DeleteLocalObject(oToB, "WallofBladesFoe9");
		DeleteLocalObject(oToB, "WallofBladesFoe10");
		TOBRemoveAttackRollOverride(oPC, 1);
	}
}

void WallOfBladesCheck(object oPC, object oToB)
{
	if ((GetLocalInt(oPC, "WallofBladesActive") == 2) && !HkSwiftActionIsActive(oPC) )
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

		DeleteLocalInt(oPC, "WallofBladesActive");
		TOBRemoveAttackRollOverride(oPC, 1);
		CSLStrikeAttackSound(oWeapon, oPC, 1, 0.0f, FALSE);
		FloatingTextStringOnCreature("<color=cyan>*Wall of Blades!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		TOBRunSwiftAction(96, "C");
	}
	else
	{
		SetLocalInt(oPC, "WallofBladesActive", 1);
		DelayCommand(0.1f, WallOfBladesCheck(oPC, oToB));
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
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nD20 = d20();
	int nAB = CSLGetMaxAB(oPC, oWeapon, oPC); //Not a true attack roll, therefore vs self to normalize the return roll.
	int nAC = GetAC(oPC);
	int nRoll = nD20 + nAB;

	SendMessageToPC(oPC, "<color=chocolate>Wall of Blades: Attack Roll: (" + IntToString(nD20) + " + " + IntToString(nAB) + " = " + IntToString(nRoll) + ") vs. " + GetName(oPC) + "'s AC: " + IntToString(nAC) + ".</color>");
	TOBExpendManeuver(96, "C");

	if (nRoll > nAC)
	{
		object oToB = CSLGetDataStore(oPC);

		CSLOverrideAttackRollAC(oPC, 3, nRoll);
		SetLocalInt(oPC, "WallofBladesActive", 1); //Switched off in bot9s_inc_maneuvers
		WallOfBlades(oPC, oToB, nRoll);
		WallOfBladesCheck(oPC, oToB);
	}
}