//::///////////////////////////////////////////////
//:: Briar Web - OnExit
//:: cmi_s0_briarwebb
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Briar Web
//:: Transmutation
//:: Caster Level(s): Druid 2, Ranger 2
//:: Component(s): Verbal, Somatic
//:: Range: Medium
//:: Area of Effect / Target: 40-ft.-radius spread
//:: Duration: 3 minutes.
//:: Save: None
//:: Spell Resistance: No
//:: This spell causes grasses, weeds, bushes, and even trees to grow thorns and
//:: wrap and twist around creatures in or entering the area. The spell's area
//:: becomes difficult terrain and creatures move at half speed within the
//:: affected area. Any creature moving through the area or that stays within it
//:: takes 6 points of piercing damage.
//:: 
//:: A creature with Freedom of Movement or the woodland stride ability
//:: is unaffected by this spell.
//:: 
//:: With a sound like a thousand knives being unsheathed, the plants in the
//:: area grow sharp thorns and warp into a thick briar patch.
//:://////////////////////////////////////////////



#include "_HkSpell"

void main()
{	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_BRIAR_WEB );
	
	// attempts to fix the haste boots needing to be re-equipped on exiting an effect that slows the target
	CSLFixSlowingOnExit( GetExitingObject() );
}