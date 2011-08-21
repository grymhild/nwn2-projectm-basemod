//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/30/2009							//
//	Title: TB_sa_swarm								//
//	Description: While you are in this stance, //
// you use your tactical knowledge and mastery //
// to improve your allies' teamwork. If you are//
// adjacent to one or more opponents, your 	//
// allies gain a +5 bonus on attack rolls made //
// against the opponent you are currently 	//
// attacking. 							//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void SwarmTactics( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "SWARMTACTICS", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "SWARMTACTICS" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,199))
	{
		object oTarget = GetAttackTarget(oPC);
		float fGirth = CSLGetGirth(oTarget);
		float fDist = fGirth + CSLGetMeleeRange(oPC);

		if (GetDistanceBetween(oPC, oTarget) <= fDist)
		{
			location lPC = GetLocation(oPC);
			float fRange = FeetToMeters(60.0f);
			effect eAttack = EffectAttackIncrease(5);
			eAttack = ExtraordinaryEffect(eAttack);

			object oFriend, oFoe;

			oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oFriend))
			{
				oFoe = GetAttackTarget(oFriend);

				if ((oFriend != oPC) && (oTarget == oFoe) && (!GetIsReactionTypeHostile(oFriend, oPC)))
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oFriend, 6.0f);
				}

				oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}
		}

		DelayCommand(6.0f, SwarmTactics(oPC, oToB, iSpellId, iSerial));
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
	
	SwarmTactics(oPC, oToB);
}
