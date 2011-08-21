//#include "NW_I0_SPELLS"


#include "_HkSpell"

void main()
{	
		
object 		oTarget 		= GetEnteringObject();
object 		oCreator 		= GetAreaOfEffectCreator();
effect 		eDur 			= EffectVisualEffect( VFX_DUR_SPELL_FEAR );
effect 		eFear 			= EffectFrightened();
effect 		eLink 			= EffectLinkEffects(eFear, eDur);
int 		nDC				= 16;
int 		nHD 			= GetHitDice(GetAreaOfEffectCreator());
int 		nDuration 		= GetScaledDuration(nHD, oTarget);

if (GetLevelByClass(CLASS_TYPE_WIZARD,oCreator) > GetLevelByClass(CLASS_TYPE_SORCERER,oCreator))
	{nDC 		= 16 + GetAbilityModifier(ABILITY_INTELLIGENCE, oCreator);}
else
	{nDC 		= 16 + GetAbilityModifier(ABILITY_CHARISMA, oCreator);}

if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY,oCreator,TRUE))
{
nDC = nDC +3;
}
if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY,oCreator,TRUE))
{
nDC = nDC +2;
}
if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY,oCreator,TRUE))
{
nDC = nDC +1;
}
if (GetHasFeat(FEAT_ARCANE_DEFENSE_NECROMANCY,oTarget,TRUE))
{
nDC = nDC -2;
}

if (GetHitDice(oCreator) < GetHitDice(oTarget))return; //The caster must have more HD then the target
if (HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))return;
if (HkResistSpell(oCreator, oTarget))return;
//Apply the VFX impact and effects
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,RoundsToSeconds(nDuration));
}