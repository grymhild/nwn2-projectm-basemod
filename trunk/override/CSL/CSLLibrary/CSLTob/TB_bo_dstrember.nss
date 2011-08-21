//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 1/19/2009							//
//	Title:	TB_bo_dstrember					//
//	Description: Swift Action; Creates a 	//
//	fire elemental to flank with.			//
//////////////////////////////////////////////
//#include "tob_x0_i0_position"
//#include "bot9s_inc_2da"
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

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	object oDstrEmber = GetNearestObjectByTag("c_distractingember", oPC);
	float fDistance = SC_DISTANCE_TINY;
	float fRange = FeetToMeters(30.0f) + CSLGetGirth(oTarget);
	string sTemplate = "c_distractingember";
	location lLocation = CSLGetBehindLocation(oTarget, fDistance);
	float fDelay = 6.0f;

	if (GetDistanceToObject(oTarget) <= fRange)
	{
		if ( !HkSwiftActionIsActive(oPC) )
		{
			TOBRunSwiftAction(6, "B");

			effect eSummon = EffectSummonCreature(sTemplate, VFX_FNF_SMOKE_PUFF);
			HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lLocation, fDelay);
			AssignCommand(oTarget, ClearAllActions());
			AssignCommand(oTarget, ActionAttack(oDstrEmber));
			AssignCommand(oTarget, CSLTurnToFaceObject(oDstrEmber, oTarget));
			TOBExpendManeuver(6, "B");
		}
	}
	else SendMessageToPC(oPC, "<color=red>The target is out of range.</color>");
}
