//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/17/2009							//
//	Title: TB_sa_prey_otw							//
//	Description: Whenever an opponent within 10 //
// feet of you drops to zero or fewer hit 	//
// points, whether from your attack, an ally's //
// strike, or some other cause, you make an 	//
// attack against each opponent within your 	//
// threatened area for the number of enemies 	//
// that died that round. 					//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void Attack(object oWeapon, object oTarget, int nHit)
{
	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void AttackFoes(int nAttacks, object oPC = OBJECT_SELF)
{
	object oToB = CSLGetDataStore(oPC);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oFoe1 = GetLocalObject(oToB, "Weak1");
	object oFoe2 = GetLocalObject(oToB, "Weak2");
	object oFoe3 = GetLocalObject(oToB, "Weak3");
	object oFoe4 = GetLocalObject(oToB, "Weak4");
	object oFoe5 = GetLocalObject(oToB, "Weak5");
	object oFoe6 = GetLocalObject(oToB, "Weak6");
	object oFoe7 = GetLocalObject(oToB, "Weak7");
	object oFoe8 = GetLocalObject(oToB, "Weak8");
	object oFoe9 = GetLocalObject(oToB, "Weak9");
	object oFoe10 = GetLocalObject(oToB, "Weak10");
	float fRange;

	if (CSLGetMeleeRange(oPC) < FeetToMeters(8.0f))
	{
		fRange = FeetToMeters(8.0f);
	}
	else fRange = CSLGetMeleeRange(oPC);

	if ((nAttacks > 0) && (GetIsObjectValid(oFoe1)) && (GetDistanceBetween(oFoe1, oPC) - CSLGetGirth(oFoe1) <= fRange))
	{
		int nHit1 = TOBStrikeAttackRoll(oWeapon, oFoe1);

		Attack(oWeapon, oFoe1, nHit1);
	}

	if ((nAttacks > 1) && (GetIsObjectValid(oFoe2)) && (GetDistanceBetween(oFoe2, oPC) - CSLGetGirth(oFoe2) <= fRange))
	{
		int nHit2 = TOBStrikeAttackRoll(oWeapon, oFoe2);

		Attack(oWeapon, oFoe2, nHit2);
	}

	if ((nAttacks > 2) && (GetIsObjectValid(oFoe3)) && (GetDistanceBetween(oFoe3, oPC) - CSLGetGirth(oFoe3) <= fRange))
	{
		int nHit3 = TOBStrikeAttackRoll(oWeapon, oFoe3);

		Attack(oWeapon, oFoe3, nHit3);
	}

	if ((nAttacks > 3) && (GetIsObjectValid(oFoe4)) && (GetDistanceBetween(oFoe4, oPC) - CSLGetGirth(oFoe4) <= fRange))
	{
		int nHit4 = TOBStrikeAttackRoll(oWeapon, oFoe4);

		Attack(oWeapon, oFoe4, nHit4);
	}

	if ((nAttacks > 4) && (GetIsObjectValid(oFoe5)) && (GetDistanceBetween(oFoe5, oPC) - CSLGetGirth(oFoe5) <= fRange))
	{
		int nHit5 = TOBStrikeAttackRoll(oWeapon, oFoe5);

		Attack(oWeapon, oFoe5, nHit5);
	}

	if ((nAttacks > 5) && (GetIsObjectValid(oFoe6)) && (GetDistanceBetween(oFoe6, oPC) - CSLGetGirth(oFoe6) <= fRange))
	{
		int nHit6 = TOBStrikeAttackRoll(oWeapon, oFoe6);

		Attack(oWeapon, oFoe6, nHit6);
	}

	if ((nAttacks > 6) && (GetIsObjectValid(oFoe7)) && (GetDistanceBetween(oFoe7, oPC) - CSLGetGirth(oFoe7) <= fRange))
	{
		int nHit7 = TOBStrikeAttackRoll(oWeapon, oFoe7);

		Attack(oWeapon, oFoe7, nHit7);
	}

	if ((nAttacks > 7) && (GetIsObjectValid(oFoe8)) && (GetDistanceBetween(oFoe8, oPC) - CSLGetGirth(oFoe8) <= fRange))
	{
		int nHit8 = TOBStrikeAttackRoll(oWeapon, oFoe8);

		Attack(oWeapon, oFoe8, nHit8);
	}

	if ((nAttacks > 8) && (GetIsObjectValid(oFoe9)) && (GetDistanceBetween(oFoe9, oPC) - CSLGetGirth(oFoe9) <= fRange))
	{
		int nHit9 = TOBStrikeAttackRoll(oWeapon, oFoe9);

		Attack(oWeapon, oFoe9, nHit9);
	}

	if ((nAttacks > 9) && (GetIsObjectValid(oFoe10)) && (GetDistanceBetween(oFoe10, oPC) - CSLGetGirth(oFoe10) <= fRange))
	{
		int nHit10 = TOBStrikeAttackRoll(oWeapon, oFoe10);

		Attack(oWeapon, oFoe10, nHit10);
	}
}

void GenerateFoes(float fRange, object oPC = OBJECT_SELF)
{
	object oToB = CSLGetDataStore(oPC);
	location lPC = GetLocation(oPC);

	int n;
	object oFoe;

	n = 1;
	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (GetIsReactionTypeHostile(oFoe, oPC)) && (GetCurrentHitPoints(oFoe) >= 1))
		{
			SetLocalObject(oToB, "Prey" + IntToString(n), oFoe);
			SetLocalInt(oToB, "PreyTotal", n);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}
}

void PreyOnTheWeak(float fRange, object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "PREYONTHEWEAK", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "PREYONTHEWEAK" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,177))
	{
		int nPrey = GetLocalInt(oToB, "PreyTotal"); //How many targets were alive that we're checking on.
		object oFoe1 = GetLocalObject(oToB, "Prey1");
		object oFoe2 = GetLocalObject(oToB, "Prey2");
		object oFoe3 = GetLocalObject(oToB, "Prey3");
		object oFoe4 = GetLocalObject(oToB, "Prey4");
		object oFoe5 = GetLocalObject(oToB, "Prey5");
		object oFoe6 = GetLocalObject(oToB, "Prey6");
		object oFoe7 = GetLocalObject(oToB, "Prey7");
		object oFoe8 = GetLocalObject(oToB, "Prey8");
		object oFoe9 = GetLocalObject(oToB, "Prey9");
		object oFoe10 = GetLocalObject(oToB, "Prey10");
		int nAttacks;

		if (nPrey > 0)
		{
			if (!GetIsObjectValid(oFoe1) || (GetCurrentHitPoints(oFoe1) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 1)
		{
			if (!GetIsObjectValid(oFoe2) || (GetCurrentHitPoints(oFoe2) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 2)
		{
			if (!GetIsObjectValid(oFoe3) || (GetCurrentHitPoints(oFoe3) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 3)
		{
			if (!GetIsObjectValid(oFoe4) || (GetCurrentHitPoints(oFoe4) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 4)
		{
			if (!GetIsObjectValid(oFoe5) || (GetCurrentHitPoints(oFoe5) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 5)
		{
			if (!GetIsObjectValid(oFoe6) || (GetCurrentHitPoints(oFoe6) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 6)
		{
			if (!GetIsObjectValid(oFoe7) || (GetCurrentHitPoints(oFoe7) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 7)
		{
			if (!GetIsObjectValid(oFoe8) || (GetCurrentHitPoints(oFoe8) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 8)
		{
			if (!GetIsObjectValid(oFoe9) || (GetCurrentHitPoints(oFoe9) < 1))
			{
				nAttacks += 1;
			}
		}

		if (nPrey > 9)
		{
			if (!GetIsObjectValid(oFoe10) || (GetCurrentHitPoints(oFoe10) < 1))
			{
				nAttacks += 1;
			}
		}

		location lPC = GetLocation(oPC);
		float fMelee = CSLGetMeleeRange(oPC);
		object oWeak;
		int n;

		oWeak = GetFirstObjectInShape(SHAPE_SPHERE, fMelee, lPC, TRUE);
		n = 1;

		while (GetIsObjectValid(oWeak))
		{
			if ((oWeak != oPC) && (GetIsReactionTypeHostile(oWeak, oPC)) && (GetCurrentHitPoints(oWeak) > 0))
			{
				SetLocalObject(oToB, "Weak" + IntToString(n), oWeak);
				n++;
			}

			if (n > nAttacks)
			{
				break;
			}

			oWeak = GetNextObjectInShape(SHAPE_SPHERE, fMelee, lPC, TRUE);
		}

		DelayCommand(0.1f, AttackFoes(nAttacks));
		DelayCommand(0.2f, GenerateFoes(fRange,oPC));
		DelayCommand(6.0f, PreyOnTheWeak(fRange,oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oToB, "PreyTotal");
		DeleteLocalObject(oToB, "Prey1");
		DeleteLocalObject(oToB, "Prey2");
		DeleteLocalObject(oToB, "Prey3");
		DeleteLocalObject(oToB, "Prey4");
		DeleteLocalObject(oToB, "Prey5");
		DeleteLocalObject(oToB, "Prey6");
		DeleteLocalObject(oToB, "Prey7");
		DeleteLocalObject(oToB, "Prey8");
		DeleteLocalObject(oToB, "Prey9");
		DeleteLocalObject(oToB, "Prey10");
		DeleteLocalObject(oToB, "Weak1");
		DeleteLocalObject(oToB, "Weak2");
		DeleteLocalObject(oToB, "Weak3");
		DeleteLocalObject(oToB, "Weak4");
		DeleteLocalObject(oToB, "Weak5");
		DeleteLocalObject(oToB, "Weak6");
		DeleteLocalObject(oToB, "Weak7");
		DeleteLocalObject(oToB, "Weak8");
		DeleteLocalObject(oToB, "Weak9");
		DeleteLocalObject(oToB, "Weak10");
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
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	float fRange = CSLGetGirth(oPC) + FeetToMeters(10.0f);
	GenerateFoes(fRange,oPC);
	
	DelayCommand(0.5f, PreyOnTheWeak(fRange,oPC));
}
