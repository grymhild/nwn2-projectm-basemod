//////////////////////////////////////////////////////
// Author: Drammel									//
// Date: 10/1/2009	(Oops! Missed this one!)		//
// Title: TB_bo_wind_stride							//
// Description: The desert wind envelops you and 	//
// carries you across the battlefield, giving you a//
// burst of speed to move around and through your //
// enemies. Until the end of your turn, you gain a //
// +10-foot enhancement bonus to your land speed.	//
//////////////////////////////////////////////////////
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
	
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));

	if (oTarget != oPC)
	{
		SendMessageToPC(oPC, "<color=red>You can only use Wind Stride on yourself.</color>");
		return;
	}

	if ( !HkSwiftActionIsActive(oPC) )
	{
		effect eStride = EffectMovementSpeedIncrease(33);// Roughly ten feet more per round.
		effect eVis = EffectVisualEffect(VFX_TOB_LEAFSPIN);
		eStride = ExtraordinaryEffect(eStride);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStride, oPC, 6.0f);
		TOBRunSwiftAction(25, "B");
		TOBExpendManeuver(25, "B");
	}
}
