//::///////////////////////////////////////////////
//:: Ghoul Touch: On Enter
//:: NW_S0_GhoulTchA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The caster attempts a touch attack on a target
	creature.  If successful creature must save
	or be paralyzed. Target exudes a stench that
	causes all enemies to save or be stricken with
	-2 Attack, Damage, Saves and Skill Checks for
	1d6+2 rounds.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_GHOUL_TOUCH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_POISON, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE );
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//Declare major variables
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCreator) && oTarget!=oCreator) {
		if (!HkResistSpell(oCreator, oTarget) && !HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCreator, 0.0f, SAVING_THROW_RESULT_REMEMBER ))
		{
			if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON)) {
				effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
				eLink = EffectLinkEffects(eLink, EffectDamageDecrease(2));
				eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));
				eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
				eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2+d6()));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), oTarget);
			}
		}
	}	
}