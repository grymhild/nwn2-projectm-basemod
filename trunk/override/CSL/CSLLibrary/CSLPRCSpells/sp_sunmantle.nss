//::///////////////////////////////////////////////
//:: Name 	Sunmantle
//:: FileName sp_sunmantle.nss
//:://////////////////////////////////////////////
/**@file Sunmantle
Abjuration
Level: Sanctified 4
Components: S, Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: One creature touched
Duration: 1 round/level
Saving Throw: None
Spell Resistance: Yes

This spell cloaks the target in a wavering cloak of
light that illuminates an area around the target
(and dispels darkness) as a daylight spell. However,
its ability to generate bright light is not the
spell's primary function.

The sunmantle grants the target damage reduction
5/-. Furthermore, if the target is struck by a melee
attack that deals hit point damage, a tendril of
light lashes out at the attacker, striking
unerringly and dealing 5 points of damage.

Because of the brilliance of the sunmantle,
creatures sensitive to bright light (such as dark
elves) take the usual attack penalties when in the
light radius of the sunmantle.

Sacrifice: 1d4 points of Strength damage.

Author: 	Tenjac
Created: 	6/20/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SUNMANTLE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = RoundsToSeconds(nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Darkness dispelling

	//DR
	effect eLink = EffectLinkEffects(EffectDamageShield(4, DAMAGE_BONUS_1, DAMAGE_TYPE_MAGICAL), EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5, 0));
			eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5, 0), eLink);
			eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5, 0));

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d4(1), 0);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


