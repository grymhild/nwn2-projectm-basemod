//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTideB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	You create an aura that steals energy from your
	enemies. Your enemies suffer a -2 circumstance
	penalty on saves, attack rolls, and damage rolls,
	once entering the aura. On casting, you gain a
	+2 circumstance bonus to your saves, attack rolls,
	and damage rolls.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	// was doing this but it makes no sense --> if(GetEffectType(eAOE) == EFFECT_TYPE_ATTACK_DECREASE || EFFECT_TYPE_DAMAGE_DECREASE || EFFECT_TYPE_SAVING_THROW_DECREASE)
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_BATTLETIDE, SPELLABILITY_WARPRIEST_BATTLETIDE );
}