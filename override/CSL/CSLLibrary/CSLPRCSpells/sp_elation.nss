//::///////////////////////////////////////////////
//:: Name 	Elation
//:: FileName sp_elation.nss
//:://////////////////////////////////////////////
/**@file Elation
Enchantment [Mind-Affecting]
Level: Brd 2, Clr 2, Sor/Wiz 3
Components: V, S
Casting Time: 1 standard action
Range: 80 ft.
Targets: Allies in an 80-ft.radius spread of you
Duration: 1 round/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

Your allies become elated, full of energy and joy.
Affected creatures gain a +2 morale bonus to
effective Strength and Dexterity, and their speed
increases by +5 feet.

Elation does not remove the condition of fatigue,
but it does offset most of the penalties for being
fatigued.

Author: 	Tenjac
Created: 	6/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ELATION; // put spell constant here
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

	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 24.4f, GetLocation(oCaster), FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//int nMetaMagic = HkGetMetaMagicFeat();

	

	if (oTarget == oCaster)
	{
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 24.4f, GetLocation(oCaster), FALSE, OBJECT_TYPE_CREATURE);
	}

	effect eBuff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 2), EffectAbilityIncrease(ABILITY_DEXTERITY, 2));

	while(GetIsObjectValid(oTarget))
	{
		if(!GetIsEnemy(oTarget, oCaster))
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 24.4f, GetLocation(oCaster), FALSE, OBJECT_TYPE_CREATURE);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

