//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/9/2009							//
//	Title: gui_TB_st_blflourish				//
//	Description: Standard Action; All 		//
//	creatures within a 30ft radius must		//
//	succeed on a DC 11+WIS check or become	//
//	dazzled.								//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
//#include "tob_i0_spells"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

effect EffectDazzled()
{
	effect eAttack = EffectAttackDecrease(1, ATTACK_BONUS_MISC);
	effect eSearch = EffectSkillDecrease(SKILL_SEARCH, 1);
	effect eSpot = EffectSkillDecrease(SKILL_SPOT, 1);

	effect eRet = EffectLinkEffects(eSearch, eSpot);
	eRet = EffectLinkEffects(eRet, eAttack);
	eRet = SupernaturalEffect(eRet);
	return eRet;
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
	
	int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
	location lLocation = GetLocation(oPC);
	float fRange = FeetToMeters(30.0f) + CSLGetGirth(oPC);
	object oTarget;
	effect eDazzle = EffectDazzled();

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	int nDC = TOBGetManeuverDC(nWis, 0, 11);
	effect eVis = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER, FALSE);
	int nFort;

	CSLPlayCustomAnimation_Void(oPC, "*fidgetM01", 0);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	TOBExpendManeuver(1, "STR");

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLocation);

	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oPC))
		{
			nFort = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC);

			if (nFort == 0)
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, 60.f);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLocation);
	}
}
