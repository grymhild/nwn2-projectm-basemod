//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/28/2009								//
//	Title: TB_ct_zephyr_dance						//
//	Description: You gain a +4 dodge bonus to AC//
// against a single attack. You use this 		//
// maneuver before an opponent resolves his 	//
// attack.										//
//////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
//#include "tob_i0_spells"
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
			SetLocalObject(oToB, "ZephyrDanceFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void ZephyrDance(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "ZEPHYRDANCE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "ZEPHYRDANCE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if ((hkCounterGetHasActive(oPC,27)) && (GetLocalInt(oPC, "ZephyrDanceActive") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "ZephyrDanceFoe1");

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

		object oFoe2 = GetLocalObject(oToB, "ZephyrDanceFoe2");

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

		object oFoe3 = GetLocalObject(oToB, "ZephyrDanceFoe3");

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

		object oFoe4 = GetLocalObject(oToB, "ZephyrDanceFoe4");

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

		object oFoe5 = GetLocalObject(oToB, "ZephyrDanceFoe5");

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

		object oFoe6 = GetLocalObject(oToB, "ZephyrDanceFoe6");

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

		object oFoe7 = GetLocalObject(oToB, "ZephyrDanceFoe7");

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

		object oFoe8 = GetLocalObject(oToB, "ZephyrDanceFoe8");

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

		object oFoe9 = GetLocalObject(oToB, "ZephyrDanceFoe9");

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

		object oFoe10 = GetLocalObject(oToB, "ZephyrDanceFoe10");

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

		DelayCommand(6.0f, ZephyrDance(oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oPC, "ZephyrDanceActive");
		DeleteLocalObject(oToB, "ZephyrDanceFoe1");
		DeleteLocalObject(oToB, "ZephyrDanceFoe2");
		DeleteLocalObject(oToB, "ZephyrDanceFoe3");
		DeleteLocalObject(oToB, "ZephyrDanceFoe4");
		DeleteLocalObject(oToB, "ZephyrDanceFoe5");
		DeleteLocalObject(oToB, "ZephyrDanceFoe6");
		DeleteLocalObject(oToB, "ZephyrDanceFoe7");
		DeleteLocalObject(oToB, "ZephyrDanceFoe8");
		DeleteLocalObject(oToB, "ZephyrDanceFoe9");
		DeleteLocalObject(oToB, "ZephyrDanceFoe10");
		//AssignCommand(oPC, RemoveEffectsFromSpell(oPC, 6542));
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, 6542 );
	}
}

void ZephyrDanceCheck(object oPC, object oToB)
{
	if ((GetLocalInt(oPC, "ZephyrDanceActive") == 2) && !HkSwiftActionIsActive(oPC) )
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

		DeleteLocalInt(oPC, "ZephyrDanceActive");
		//AssignCommand(oPC, RemoveEffectsFromSpell(oPC, 6542));
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, 6542 );
		
		//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, 6542 );
		CSLStrikeAttackSound(oWeapon, oPC, 1, 0.0f, FALSE);
		FloatingTextStringOnCreature("<color=cyan>*Zephyr Dance!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		TOBRunSwiftAction(27, "C");
	}
	else
	{
		SetLocalInt(oPC, "ZephyrDanceActive", 1);
		DelayCommand(0.1f, ZephyrDanceCheck(oPC, oToB));
	}
}


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	int nTarget = GetLocalInt(oToB, "Target");
	object oTarget = IntToObject(nTarget);

	if (oTarget == oPC)
	{
		effect eAC = EffectACIncrease(4);
		eAC = ExtraordinaryEffect(eAC);
		eAC = SetEffectSpellId(eAC, 6542); // Placeholder for Counters in spells.2da

		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
		SetLocalInt(oPC, "ZephyrDanceActive", 1); //Switched off in bot9s_inc_maneuvers
		ZephyrDance(oPC, oToB);
		ZephyrDanceCheck(oPC, oToB);
		TOBExpendManeuver(27, "C");
	}
	else 
	{
		SendMessageToPC(oPC, "<color=red>You can only target yourself with this maneuver.</color>");
	}
}
