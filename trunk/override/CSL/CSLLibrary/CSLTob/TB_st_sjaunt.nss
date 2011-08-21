//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 7/31/2009									//
//	Title: TB_st_sjaunt								//
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
	
	float fx = TOBGetManeuverX(oPC, 135);
	float fy = TOBGetManeuverY(oPC, 135);
	float fz = TOBGetManeuverZ(oPC, 135);
	vector vTarget = Vector(fx, fy, fz);
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));
	location lPC = GetLocation(oPC);

	if (GetIsLocationValid(lTarget) && (GetDistanceBetweenLocations(lTarget, lPC) <= FeetToMeters(50.0f)) && CSLLineOfEffect(oPC, lTarget, TRUE) && LineOfSightVector(GetPositionFromLocation(lPC), vTarget))
	{
		effect eFade = EffectVisualEffect(VFX_TOB_FADE);//Now you see it, now you don't!
		effect eJaunt = EffectVisualEffect(VFX_TOB_POOF);//Abracadabra!

		ClearAllActions();
		TOBClearStrikes();
		SetScriptHidden(oPC, TRUE); //Maintains the illusion of the PC not being there.
		DelayCommand(4.0f, SetScriptHidden(oPC, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFade, oPC, 4.0f);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eJaunt, lPC);
		DelayCommand(4.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eJaunt, oPC));
		DelayCommand(3.9f, JumpToLocation(lTarget));
		TOBExpendManeuver(135, "STR");
	}
	else SendMessageToPC(oPC, "<color=red>This is not a valid location to teleport to.</color>");
}
