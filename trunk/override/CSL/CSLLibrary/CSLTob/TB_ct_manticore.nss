//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/9/2009									//
//	Title: TB_ct_manticore								//
//	Description: When you initiate this maneuver, 	//
// you can attempt to block an enemy's melee attack//
// that targets you and redirect it to another 	//
// target adjacent to you. Make a melee attack 	//
// roll. If your result is greater than your foe's //
// attack roll, you bat aside the strike and direct//
// it against a target of your choice that stands //
// adjacent to you. You initiate this maneuver 	//
// after the before attacks and before you know 	//
// whether or not the attack you are attempting to //
// deflect actually hits. If you succeed in 		//
// deflecting the attack, you use the result of 	//
// your opponent's attack roll to determine if it //
// strikes the new target. This maneuver functions//
// only against armed melee attacks. You cannot use//
// it against unarmed attacks, natural weapons, or //
// touch spells. 							//
//////////////////////////////////////////////////////

	//Most of the work of this maneuver is handled in bot9s_inc_maneuvers.
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
			SetLocalObject(oToB, "ManticoreParryFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void ManticoreParry(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "MANTICOREPARRY", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "MANTICOREPARRY" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if ((hkCounterGetHasActive(oPC,88)) && (GetLocalInt(oPC, "ManticoreParry") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "ManticoreParryFoe1");

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

		object oFoe2 = GetLocalObject(oToB, "ManticoreParryFoe2");

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

		object oFoe3 = GetLocalObject(oToB, "ManticoreParryFoe3");

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

		object oFoe4 = GetLocalObject(oToB, "ManticoreParryFoe4");

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

		object oFoe5 = GetLocalObject(oToB, "ManticoreParryFoe5");

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

		object oFoe6 = GetLocalObject(oToB, "ManticoreParryFoe6");

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

		object oFoe7 = GetLocalObject(oToB, "ManticoreParryFoe7");

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

		object oFoe8 = GetLocalObject(oToB, "ManticoreParryFoe8");

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

		object oFoe9 = GetLocalObject(oToB, "ManticoreParryFoe9");

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

		object oFoe10 = GetLocalObject(oToB, "ManticoreParryFoe10");

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

		DelayCommand(6.0f, ManticoreParry(oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oPC, "ManticoreParry");
		DeleteLocalObject(oToB, "ManticoreParryFoe1");
		DeleteLocalObject(oToB, "ManticoreParryFoe2");
		DeleteLocalObject(oToB, "ManticoreParryFoe3");
		DeleteLocalObject(oToB, "ManticoreParryFoe4");
		DeleteLocalObject(oToB, "ManticoreParryFoe5");
		DeleteLocalObject(oToB, "ManticoreParryFoe6");
		DeleteLocalObject(oToB, "ManticoreParryFoe7");
		DeleteLocalObject(oToB, "ManticoreParryFoe8");
		DeleteLocalObject(oToB, "ManticoreParryFoe9");
		DeleteLocalObject(oToB, "ManticoreParryFoe10");
	}
}

void ManticoreParryCheck(object oPC, object oToB)
{
	if ((GetLocalInt(oPC, "ManticoreParry") == 2) && !HkSwiftActionIsActive(oPC) )
	{
		DeleteLocalInt(oPC, "ManticoreParry");
		TOBRunSwiftAction(88, "C");
	}
	else
	{
		SetLocalInt(oPC, "ManticoreParry", 1);
		DelayCommand(0.1f, ManticoreParryCheck(oPC, oToB));
	}
}


void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------

	SetLocalInt(oPC, "ManticoreParry", 1); //Switched off in bot9s_inc_maneuvers
	ManticoreParry(oPC, oToB);
	ManticoreParryCheck(oPC, oToB);
	TOBExpendManeuver(88, "C");
}
