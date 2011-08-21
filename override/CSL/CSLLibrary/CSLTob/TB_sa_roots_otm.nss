//////////////////////////////////////////
// Author: Drammel						//
// Date: 9/1/2009						//
// Title: TB_sa_roots_otm					//
// Description: Grants +2 AC as long as//
//	the player doesn't move.			//
//////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void ReduceTumble( object oPC = OBJECT_SELF )
{
	int nParry = GetSkillRank(SKILL_PARRY, oPC);
	location lPC = GetLocation(oPC);
	float fRange = CSLGetMeleeRange(oPC);
	effect eTumbleDown = EffectSkillDecrease(SKILL_TUMBLE, nParry);
	eTumbleDown = ExtraordinaryEffect(eTumbleDown);

	object oFoe;

	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	while (GetIsObjectValid(oFoe))
	{
		if (GetIsReactionTypeHostile(oFoe, oPC))
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTumbleDown, oFoe, 1.0f);
		}

		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
	}
}

void RootsotMountain(object oPC = OBJECT_SELF)
{

	if (hkStanceGetHasActive(oPC,159))
	{
		location lRoots = GetLocalLocation(oPC, "RootsotMountain");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lRoots);

		if (fDist <= FeetToMeters(5.0f))
		{
			effect eDR = EffectDamageReduction(2, DR_TYPE_NONE, 0, GMATERIAL_METAL_ADAMANTINE);
			eDR = ExtraordinaryEffect(eDR);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, 1.0f);
			AssignCommand(oPC, ReduceTumble(oPC));
			DelayCommand(1.0f, RootsotMountain(oPC));
		}
		else
		{
			DeleteLocalLocation(oPC, "RootsotMountain");

			object oToB = CSLGetDataStore(oPC);

			if (GetLocalInt(oToB, "Stance") == 159)
			{
				hkSetStance1(0,oPC);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Stonefoot Stance. Stancefoot Stance has ended.</color>");
			}
			else if (GetLocalInt(oToB, "Stance2") == 159)
			{
				SetLocalInt(oToB, "Stance2", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Stonefoot Stance. Stancefoot Stance has ended.</color>");
			}
		}
	}
	else DeleteLocalLocation(oPC, "RootsotMountain");
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

	SetLocalLocation(oPC, "RootsotMountain", GetLocation(oPC));
	RootsotMountain(oPC);
}