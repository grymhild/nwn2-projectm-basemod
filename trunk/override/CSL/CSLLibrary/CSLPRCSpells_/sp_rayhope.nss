//::///////////////////////////////////////////////
//:: Name 	Ray of Hope
//:: FileName sp_ray_hope.nss
//:://////////////////////////////////////////////
/**@file Ray of Hope
Enchantment (Compulsion) [Good, Mind-Affecting]
Level: Brd 1, Clr 1
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: 1 round/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

Powerful hope wells up in the subject, who gains a
+2 morale bonus on saving throws, attack rolls,
ability checks, and skill checks.

Author: 	Tenjac
Created: 	7/2/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_CSLCore_Combat"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAY_OF_HOPE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Make touch attack

	//Beam VFX. Ornedan is my hero.
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oCaster, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		effect eLink = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}

	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}








