//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"

#include "_HkSpell"

void main()
{	
	
object oPC = OBJECT_SELF;
object oTarget = GetSpellTargetObject();
effect eEffect = EffectSkillDecrease(SKILL_BLUFF, 50);
float fDuration = RoundsToSeconds(HkGetCasterLevel(oPC));

if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()))
{
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
}
}