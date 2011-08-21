//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/23/2009								//
//	Title: TB_ct_shield_block						//
//	Description: As an immediate action, you can//
// grant an AC bonus to an adjacent ally equal //
// to your shield’s AC bonus + 4. You apply 	//
// this bonus in response to a single melee or //
// ranged attack that targets your ally. You 	//
// initiate this maneuver after an opponent 	//
// makes his attack roll.						//
//////////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
//#include "tob_i0_spells"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void GenerateFoes(object oPC, object oToB, object oTarget)
{
	int n;
	object oFoe;

	n = 1;
	oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oTarget, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (GetIsReactionTypeHostile(oFoe, oPC)))
		{
			SetLocalObject(oToB, "ShieldBlockFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oTarget, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void ShieldBlock(object oPC, object oToB, object oTarget, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, oTarget, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "SHIELDBLOCK", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "SHIELDBLOCK" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if ((hkCounterGetHasActive(oPC,48)) && (GetLocalInt(oTarget, "ShieldBlockActive") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB, oTarget));

		object oFoe1 = GetLocalObject(oToB, "ShieldBlockFoe1");

		if ((GetIsObjectValid(oFoe1)) && (GetAttackTarget(oFoe1) == oTarget))
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

		object oFoe2 = GetLocalObject(oToB, "ShieldBlockFoe2");

		if ((GetIsObjectValid(oFoe2)) && (GetAttackTarget(oFoe2) == oTarget))
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

		object oFoe3 = GetLocalObject(oToB, "ShieldBlockFoe3");

		if ((GetIsObjectValid(oFoe3)) && (GetAttackTarget(oFoe3) == oTarget))
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

		object oFoe4 = GetLocalObject(oToB, "ShieldBlockFoe4");

		if ((GetIsObjectValid(oFoe4)) && (GetAttackTarget(oFoe4) == oTarget))
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

		object oFoe5 = GetLocalObject(oToB, "ShieldBlockFoe5");

		if ((GetIsObjectValid(oFoe5)) && (GetAttackTarget(oFoe5) == oTarget))
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

		object oFoe6 = GetLocalObject(oToB, "ShieldBlockFoe6");

		if ((GetIsObjectValid(oFoe6)) && (GetAttackTarget(oFoe6) == oTarget))
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

		object oFoe7 = GetLocalObject(oToB, "ShieldBlockFoe7");

		if ((GetIsObjectValid(oFoe7)) && (GetAttackTarget(oFoe7) == oTarget))
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

		object oFoe8 = GetLocalObject(oToB, "ShieldBlockFoe8");

		if ((GetIsObjectValid(oFoe8)) && (GetAttackTarget(oFoe8) == oTarget))
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

		object oFoe9 = GetLocalObject(oToB, "ShieldBlockFoe9");

		if ((GetIsObjectValid(oFoe9)) && (GetAttackTarget(oFoe9) == oTarget))
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

		object oFoe10 = GetLocalObject(oToB, "ShieldBlockFoe10");

		if ((GetIsObjectValid(oFoe10)) && (GetAttackTarget(oFoe10) == oTarget))
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

		DelayCommand(6.0f, ShieldBlock( oPC, oToB, oTarget, iSpellId, iSerial ));
	}
	else
	{
		DeleteLocalInt(oTarget, "ShieldBlockActive");
		DeleteLocalObject(oToB, "ShieldBlockFoe1");
		DeleteLocalObject(oToB, "ShieldBlockFoe2");
		DeleteLocalObject(oToB, "ShieldBlockFoe3");
		DeleteLocalObject(oToB, "ShieldBlockFoe4");
		DeleteLocalObject(oToB, "ShieldBlockFoe5");
		DeleteLocalObject(oToB, "ShieldBlockFoe6");
		DeleteLocalObject(oToB, "ShieldBlockFoe7");
		DeleteLocalObject(oToB, "ShieldBlockFoe8");
		DeleteLocalObject(oToB, "ShieldBlockFoe9");
		DeleteLocalObject(oToB, "ShieldBlockFoe10");
		//AssignCommand(oTarget, RemoveEffectsFromSpell(oTarget, 6542));
		
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, 6542 );
	}
}

void ShieldBlockCheck(object oPC, object oToB, object oTarget)
{
	if ((GetLocalInt(oTarget, "ShieldBlockActive") == 2) && !HkSwiftActionIsActive(oPC) )
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

		DeleteLocalInt(oTarget, "ShieldBlockActive");
		//AssignCommand(oTarget, RemoveEffectsFromSpell(oTarget, 6542));
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, 6542 );
		CSLStrikeAttackSound(oWeapon, oTarget, 1, 0.0f, FALSE);
		FloatingTextStringOnCreature("<color=cyan>*Shield Block!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		TOBRunSwiftAction(48, "C");
	}
	else
	{
		SetLocalInt(oTarget, "ShieldBlockActive", 1);
		DelayCommand(0.1f, ShieldBlockCheck(oPC, oToB, oTarget));
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
	
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int nType = GetBaseItemType(oShield);

	if (!GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC, "<color=red>You must have a shield equipped to initiate this maneuver.");
		return;
	}
	else if ((nType != BASE_ITEM_LARGESHIELD) && (nType != BASE_ITEM_SMALLSHIELD) && (nType != BASE_ITEM_TOWERSHIELD))
	{
		SendMessageToPC(oPC, "<color=red>You must have a shield equipped to initiate this maneuver.");
		return;
	}

	int nTarget = GetLocalInt(oToB, "Target");
	object oTarget = IntToObject(nTarget);
	float fDist = GetDistanceBetween(oPC, oTarget) - CSLGetGirth(oTarget);
	int nBonus = GetItemACValue(oShield) + 4;

	if ((oTarget != oPC) && (fDist <= FeetToMeters(8.0f)) && (!GetIsReactionTypeHostile(oTarget, oPC)))
	{
		effect eAC = EffectACIncrease(nBonus, AC_SHIELD_ENCHANTMENT_BONUS);
		eAC = ExtraordinaryEffect(eAC);
		eAC = SetEffectSpellId(eAC, 6542); // Placeholder for Counters in spells.2da

		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oTarget);
		SetLocalInt(oTarget, "ShieldBlockActive", 1); //Switched off in bot9s_inc_maneuvers
		ShieldBlock(oPC, oToB, oTarget);
		ShieldBlockCheck(oPC, oToB, oTarget);
		TOBExpendManeuver(48, "C");
	}
	else SendMessageToPC(oPC, "<color=red>You must select an adjacent ally with this ability.</color>");
}
