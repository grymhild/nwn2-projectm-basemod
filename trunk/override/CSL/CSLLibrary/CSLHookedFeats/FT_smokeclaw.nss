//::///////////////////////////////////////////////
//:: Smoke Claws
//:: NW_S1_SmokeClaw
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If a Belker succeeds at a touch attack the
	target breaths in part of the Belker and suffers
	3d4 damage per round until a Fortitude save is
	made.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 23 , 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main ()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int bSave = FALSE;
	effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
	effect eSmoke;
	float fDelay = 0.0;
	//Make a touch attack
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Make a saving throw check
			while (bSave == FALSE)
			{
				//Make a saving throw check
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, 14, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
				{
					bSave = TRUE;
				}
				else
				{
					//Set damage
					eSmoke = EffectDamage(d4(3));
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					//Increment the delay
					fDelay = fDelay + 6.0;
				}
			}
		}
	}
}

