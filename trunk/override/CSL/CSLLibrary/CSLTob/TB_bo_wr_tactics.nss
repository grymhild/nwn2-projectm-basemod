//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/24/2009								//
//	Title: TB_bo_wr_tactics						//
//	Description: Grants the effects of the spell//
// Haste to a single ally for a duration of one//
// round per initiator level.					//
//////////////////////////////////////////////////
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
	
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));

	if ( oTarget != oPC && !HkSwiftActionIsActive(oPC) && (!GetIsReactionTypeHostile(oTarget, oPC)))
	{
		float fDist = GetDistanceBetween(oPC, oTarget);
		float fCheck = FeetToMeters(10.0f) + CSLGetGirth(oPC) + CSLGetGirth(oTarget); // Distance checks start from the center of the creature, not the edge.

		if (fDist <= fCheck)
		{
			float fDuration = RoundsToSeconds(TOBGetInitiatorLevel(oPC));
			effect eHaste = EffectHaste();
			effect eVis = EffectVisualEffect(VFX_TOB_WR_TACTICS);
			eHaste = ExtraordinaryEffect(eHaste);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, oTarget, fDuration);
			TOBRunSwiftAction(207, "B");
			TOBExpendManeuver(207, "B");
		}
		else SendMessageToPC(oPC, "<color=red>This target is farther than 10 feet away.</color>");
	}
	else SendMessageToPC(oPC, "<color=red>You can only target an ally with this maneuver.</color>");
}
