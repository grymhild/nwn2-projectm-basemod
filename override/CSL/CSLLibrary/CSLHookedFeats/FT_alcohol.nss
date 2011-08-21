//::///////////////////////////////////////////////
//:: NW_S3_Alcohol.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Makes beverages fun.
	May 2002: Removed fortitude saves. Just instant intelligence loss
*/

#include "_HkSpell"
#include "_SCInclude_Healing"

void DrinkIt(object oTarget)
{
	// AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
	AssignCommand(oTarget,ActionSpeakStringByStrRef(10499));
}

void MakeDrunk(object oTarget, int nPoints)
{
	if (Random(100) + 1 < 40)
	{
		AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
	}
	else
	{
		AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK));
	}
	
	effect eDumb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nPoints);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDumb, oTarget, 60.0);
	//AssignCommand(oTarget, SpeakString(IntToString(GetAbilityScore(oTarget,ABILITY_INTELLIGENCE))));
}


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS;
	object oTarget = HkGetSpellTarget();
	//SendMessageToPC( oTarget, GetTag(GetSpellCastItem()) );
	if (GetTag(GetSpellCastItem())=="curepotion")
	{
		SCCurePC(oTarget, oTarget, 15);
		return;
	} 
	
	if (GetSpellId() == 406) // * Beer
	{
		DrinkIt(oTarget);
		MakeDrunk(oTarget, 1);
	}
	else if (GetSpellId() == 407) // *Wine
	{
		DrinkIt(oTarget);
		MakeDrunk(oTarget, 2);
	}
	else if (GetSpellId() == 408) // * Spirits
	{
		DrinkIt(oTarget);
		MakeDrunk(oTarget, 3);
	}

}