//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/10/2009								//
//	Title: TB_st_douse_flms						//
//	Description: If this strike hits, both you	//
//	and your target take a penalty to attack 	//
//	rolls equal to your ranks in Diplomacy minus//
//	four, divided by four, to a minimum of a 	//
//	minus one penalty to attack rolls.			//
//////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 192);

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
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(192, "STR");

	if (nHit > 0)
	{
		int nRank = GetSkillRank(SKILL_DIPLOMACY, oPC);
		int nDiplomacy;

		nDiplomacy = (nRank - 4)/4;

		if (nDiplomacy < 1)
		{
			nDiplomacy = 1;
		}

		effect eDouse = EffectAttackDecrease(nDiplomacy);
		eDouse = ExtraordinaryEffect(eDouse);
		effect eVisual = EffectVisualEffect(VFX_TOB_CIRCLE_BLUEFIRE);

		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDouse, oPC, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDouse, oTarget, 6.0f);
	}
}
