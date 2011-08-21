//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/22/2009							//
//	Title: TB_st_drain_vit						//
//	Description: As part of this maneuver, //
//	make a single melee attack. If this 	//
//	attack hits, you deal normal melee		//
//	damage and the target must make a 		//
//	successful Fortitude save (DC 12 + your //
//	Wis modifier) or take 2 points of 		//
//	Constitution damage. A successful save //
//	negates the Constitution damage but not //
//	the normal melee damage.				//
//////////////////////////////////////////////
//#include "tob_i0_spells"
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
	
	object oTarget = TOBGetManeuverObject(oToB, 124);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "ShadowHandStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(124, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
	{
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = TOBGetManeuverDC(nWisdom, 0, 12);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			int nNumber;

			if (nHit == 2) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = 4;
			}
			else nNumber = 2;

			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
			effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nNumber);
			eDamage = ExtraordinaryEffect(eDamage);
			eDamage = SetEffectSpellId(eDamage, -1);

			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
			DelayCommand(0.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(0.4f, TOBDropDead(oTarget, ABILITY_CONSTITUTION));
		}
	}
}
