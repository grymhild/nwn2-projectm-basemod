//::///////////////////////////////////////////////
//:: Name 	Lesser Shivering Touch
//:: FileName sp_less_shivtch.nss
//:://////////////////////////////////////////////
/**@file Lesser Shivering Touch
Necromancy [cold]
Level: Cleric 1, Sorceror/Wizard 1
Components: V, S
Casting Time: 1 Standard Action
Range: Touch
Target: Creature Touched
Duration: 1 round/level
Saving Throw: None
Spell Resistance: Yes

On a succesful melee attack, you instantly suck the
heat from the target's body, rendering it numb. The
target takes 1d6 points of Dexterity damage.
Creatures with the cold subtype are immune to the
effects of Shivering Touch.

Author: 	Tenjac
Created: 	5/14/06
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
	int iSpellId = SPELL_LESSER_SHIVERING_TOUCH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	

	int iTouch = CSLTouchAttackMelee(oTarget);
	int nMetaMagic = HkGetMetaMagicFeat();
	int iSpellPower = HkGetSpellPower( oCaster, 10 );
	
	int nDam = HkApplyMetamagicVariableMods(d6(), 6);
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_LESSER_SHIVERING_TOUCH, oCaster);

	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		//Check Spell Resistance
		if (!HkResistSpell(oCaster, oTarget ))
		{
			effect eDrain = EffectAbilityDecrease(ABILITY_DEXTERITY, nDam);
			effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, fDuration);
		}


	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}