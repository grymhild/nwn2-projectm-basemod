//////////////////////////////////////////
//	Author: Drammel						//
//	Date: 10/28/2009					//
//	Title: TB_ct_1w_shadow					//
//	Description: As an immediate action,//
// you gain the defensive immunities of//
// an incorporeal undead creature, 	//
// along with being able to move 		//
// through other creatures and 50% 	//
// concealment. You remain in this 	//
// state until the beginning of your 	//
// next turn. 					//
//////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void DelayedJump(object oTarget)
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	float fGirth = CSLGetGirth(oTarget) + 0.01f;
	location lPop = CalcSafeLocation(oPC, lPC, fGirth, FALSE, TRUE);

	JumpToLocation(lPop);
}

void OneWithShadow( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID)
{
	

	if ((hkCounterGetHasActive(oPC,131)) && (!HkSwiftActionIsActive(oPC)))
	{
		effect eInvis = EffectVisualEffect(VFX_TOB_FADE); // Doesn't play well with other effects in a link.
		effect eAbility = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
		effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
		effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		effect eNeg = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
		effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
		effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);
		effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
		effect eConceal = EffectConcealment(50);
		effect eShadow = EffectLinkEffects(eSneak, eConceal);
		eShadow = EffectLinkEffects(eShadow, eAbility);
		eShadow = EffectLinkEffects(eShadow, eCrit);
		eShadow = EffectLinkEffects(eShadow, eNeg);
		eShadow = EffectLinkEffects(eShadow, eDeath);
		eShadow = EffectLinkEffects(eShadow, eDisease);
		eShadow = EffectLinkEffects(eShadow, ePoison);
		eShadow = SupernaturalEffect(eShadow);

		if (GetCollision(oPC) == TRUE)
		{
			SetCollision(oPC, FALSE);
		}

		object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE);

		DelayCommand(6.0f, SetCollision(oPC, TRUE));
		DelayCommand(6.1f, DelayedJump(oTarget));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oPC, 6.0f);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oPC, 6.0f);
		TOBRunSwiftAction(131, "C");
	}
	else DelayCommand(0.1f, OneWithShadow());
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
	TOBExpendManeuver(131, "C");
	OneWithShadow(oPC,oToB);
}
