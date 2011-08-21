//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/18/2010									//
//	Title: TB_bo_encouragement							//
//	Description: When you use this maneuver, select //
// an ally within range. If your attack bonus is //
// higher than that of your ally, you grant a bonus//
// to their attack rolls, equal to the difference //
// between the two bonuses. The effect lasts a 	//
// minimum of one round, up to a number of rounds //
// equal to your Intelligence modifier. If your 	//
// attack bonus is equal to or lower than that of //
// your ally, they gain no benefit and the maneuver//
// is expended. 							//
//////////////////////////////////////////////////////
//#include "bot9s_attack"
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

	if (  oTarget != oPC && !HkSwiftActionIsActive(oPC) && (!GetIsReactionTypeHostile(oTarget, oPC)))
	{
		float fDist = GetDistanceBetween(oPC, oTarget);
		float fCheck = FeetToMeters(30.0f) + CSLGetGirth(oPC) + CSLGetGirth(oTarget); // Distance checks start from the center of the creature, not the edge.

		if (fDist <= fCheck)
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			object oYourWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			object oFoe = GetAttackTarget(oTarget);
			int nMyAB = CSLGetMaxAB(oPC, oWeapon, oFoe);
			int nYourAB = CSLGetMaxAB(oTarget, oYourWeapon, oFoe);

			if (nMyAB > nYourAB)
			{
				int nAB = nMyAB - nYourAB;
				int nInt;

				if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC) < 1)
				{
					nInt = 1;
				}
				else nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);

				float fDuration = RoundsToSeconds(nInt);

				effect eAB = EffectAttackIncrease(nAB);
				effect eVis = EffectVisualEffect(VFX_TOB_ENCOURAGE);
				eAB = ExtraordinaryEffect(eAB);

				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, oTarget, fDuration);
			}
			else SendMessageToPC(oPC, "<color=red>Your attack bonus was too low.</color>");

			TOBRunSwiftAction(208, "B");
			TOBExpendManeuver(208, "B");
		}
		else SendMessageToPC(oPC, "<color=red>This target is farther than 30 feet away.</color>");
	}
	else SendMessageToPC(oPC, "<color=red>You can only target an ally with this maneuver.</color>");
}
