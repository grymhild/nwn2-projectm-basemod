//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/23/2009							//
//	Title: TB_st_tactical						//
//	Description: As part of this maneuver, //
//	you you deal an extra 2d6 points of		//
//	damage. In addition, each ally adjacent	//
// to the target gains a temporary bonus to//
//	thier speed.							//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 201);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2)));
	TOBExpendManeuver(201, "STR");

	if (nHit > 0)
	{
		effect eTactical = EffectMovementSpeedIncrease(17); //Roughly equivalent to a boost in speed of about 5 feet more per round.
		eTactical = ExtraordinaryEffect(eTactical);
		float fRange = CSLGetMeleeRange(oTarget);
		location lTarget = GetLocation(oTarget);
		object oFriend;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget);

		while (GetIsObjectValid(oFriend))
		{
			if ((oPC != oFriend) && (!GetIsReactionTypeHostile(oFriend, oPC)))
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTactical, oFriend, 6.0f);
			}

			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget);
		}
	}
}
