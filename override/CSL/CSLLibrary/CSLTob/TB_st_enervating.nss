//////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 10/28/2009										//
//	Title: TB_st_enervating										//
//	Description: As part of this maneuver, you make a single//
// melee attack. If this attack hits, the target must make //
// a successful Fortitude save (DC 18 + your Wis modifier) //
// or gain 1d4 negative levels. You gain 5 temporary hit 	//
// points for each negative level your enemy gains. 		//
// Temporary hit points gained in this manner last until 	//
// the end of the encounter. The effects of any negative 	//
// levels bestowed by this strike disappear in 24 hours. If//
// the target has at least as many negative levels as Hit //
// Dice, it dies. Each negative level gives a creature a -1//
// penalty on attack rolls, saving throws, skill checks, 	//
// ability checks, and effective level (for determining the//
// power, duration, DC, and other details of spells or 	//
// special abilities). Additionally, a spellcaster loses //
// one spell or spell slot from her highest available 	//
// level. Negative levels stack. In addition to the 		//
// negative levels, your attack deals normal damage, even //
// if the target succeeds on the saving throw.				//
//////////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "tob_i0_spells"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = TOBGetManeuverObject(oToB, 125);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget);

	CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	TOBBasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	TOBExpendManeuver(125, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL)))
	{
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = TOBGetManeuverDC(nWisdom, 0, 18);
		int nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			int nNumber = d4(1);
			
			nNumber = HkApplyTouchAttackCriticalDamage(oTarget, nHit, nNumber, SC_TOUCH_MELEE );

			effect eVis = EffectVisualEffect(VFX_TOB_ENERVATION);
			//effect eEnervating = EffectNegativeLevel(nNumber, TRUE);
			//eEnervating = SupernaturalEffect(eEnervating);
			//eEnervating = SetEffectSpellId(eEnervating, -1);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f);
			SCApplyDeadlyAbilityLevelEffect( nNumber, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oPC );
			
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eEnervating, oTarget); // I think applying this as permanent is pretty close to a 24 hour period.
		}
	}
}
