//::///////////////////////////////////////////////
//:: Name 	Divine Inspiration
//:: FileName sp_divine_insp.nss
//:://////////////////////////////////////////////
/**@file Divine Inspiration
Divination
Level: Sanctified 1
Components: Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: One creature touched
Duration: 1d4 rounds
Saving Throw: None
Spell Resistance: Yes (harmless)

This spell helps to tip the momentum of combat in
the favor of good, granting limited precognitive
ability that enables the spell's recipient to
circumvent the defenses of evil opponents. The
target of the spell gains a +3 sacred bonus on all
attack rolls made against evil creatures. This
bonus does not apply to attacks made against
non-evil creatures.

Sacrifice: 1d2 points of Strength damage.

Author: 	Tenjac
Created: 	6/9/06
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
	int iSpellId = SPELL_DIVINE_INSPIRATION; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	
	object oTarget = HkGetSpellTarget();
	object oSkin = CSLGetPCSkin(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	itemproperty iBonus = ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 3);
	//float fDur = RoundsToSeconds(d4(1));
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(d4(), SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	CSLSafeAddItemProperty(oSkin, iBonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);

	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d2(), 0);
}
