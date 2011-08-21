//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 10/6/2009										//
//	Title: TB_bo_ih_endurance								//
//	Description: If you have half or fewer of your full //
// normal hit points remaining, you can initiate this //
// maneuver to heal hit points equal to 2 × your level.//
//////////////////////////////////////////////////////////
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

	if ( !HkSwiftActionIsActive(oPC) )
	{
		int nHp = GetCurrentHitPoints(oPC);
		int nHalf = GetMaxHitPoints(oPC) / 2;

		if (nHp <= nHalf)
		{
			int nHeal = GetHitDice(oPC) * 2;
			effect eHeal = TOBManeuverHealing(oPC, nHeal);
			effect eEndurance = EffectVisualEffect(VFX_TOB_IH_ENDURANCE);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEndurance, oPC, 2.0f);
			TOBExpendManeuver(83, "B");
			TOBRunSwiftAction(83, "B");
		}
		else SendMessageToPC(oPC, "<color=red>You cannot initiate Iron Heart Endurance unless your current hit point value is below half of its maximum value.</color>");
	}
}
