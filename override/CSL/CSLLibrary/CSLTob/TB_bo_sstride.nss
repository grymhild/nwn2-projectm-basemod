//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/19/2009									//
//	Title: TB_bo_sstride								//
//	Description: As part of this maneuver, you 		//
// disappear in a cloud of darkness and teleport up//
// to 50 feet away. You must have line of sight and//
// line of effect to your destination.				//
//////////////////////////////////////////////////////
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
	
	float fx = TOBGetManeuverX(oPC, 137);
	float fy = TOBGetManeuverY(oPC, 137);
	float fz = TOBGetManeuverZ(oPC, 137);
	vector vTarget = Vector(fx, fy, fz);
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));
	location lPC = GetLocation(oPC);

	if (GetIsLocationValid(lTarget) && (GetDistanceBetweenLocations(lTarget, lPC) <= FeetToMeters(50.0f)) && CSLLineOfEffect(oPC, lTarget, TRUE) && LineOfSightVector(GetPositionFromLocation(lPC), vTarget))
	{
		effect eFade = EffectVisualEffect(VFX_TOB_FADE);//Now you see it, now you don't!
		effect eStride = EffectVisualEffect(VFX_TOB_POOF);//Abracadabra!
		effect eHalt = EffectMovementSpeedDecrease(99);
		eHalt = SupernaturalEffect(eHalt); //Simulates using a move action.

		ClearAllActions();
		TOBClearStrikes();
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFade, oPC, 0.5f);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStride, lPC);
		DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eStride, oPC));
		DelayCommand(0.4f, JumpToLocation(lTarget));
		DelayCommand(0.7f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHalt, oPC, 5.3f));
		TOBExpendManeuver(137, "B");
	}
	else SendMessageToPC(oPC, "<color=red>This is not a valid location to teleport to.</color>");
}
