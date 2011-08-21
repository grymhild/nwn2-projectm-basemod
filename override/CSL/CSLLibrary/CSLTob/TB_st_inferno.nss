//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/30/2009											//
//	Title: TB_st_inferno 											//
//	Description: You focus your internal ki into a blinding hot //
// burst of fire that deals 100 points of fire damage to all 	//
// creatures in the area. You are not harmed by your own 		//
// inferno blast. 									//
//////////////////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_inc_constants"
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
	

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));
	CSLPlayCustomAnimation_Void(oPC, "mspirit", 0);

	float fRange = FeetToMeters(60.0f);
	location lPC = GetLocation(oPC);
	int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
	int nDC = TOBGetManeuverDC(nWisdom, 0, 19);
	effect eHit = EffectVisualEffect(VFX_TOB_PHOENIX_HIT);
	effect eVis = EffectVisualEffect(VFX_TOB_INFERNO);

	object oBurned;
	int nDamage;
	effect eDamage;
	float fDist, fDelay;

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 4.0f);
	oBurned = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oBurned))
	{
		if ((oBurned != oPC) && (CSLSpellsIsTarget(oBurned, SCSPELL_TARGET_STANDARDHOSTILE, oPC)))
		{
			fDist = GetDistanceBetween(oPC, oBurned);
			fDelay = fDist / 20;
			nDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,100, oBurned, nDC, SAVING_THROW_TYPE_FIRE);

			DelayCommand(1.0f + fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHit, oBurned, 2.0f));

			if (nDamage > 0)
			{
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
				DelayCommand(1.0f + fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBurned));
			}
		}

		oBurned = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}

	TOBExpendManeuver(17, "STR");
}
