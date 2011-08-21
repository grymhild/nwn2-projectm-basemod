//::///////////////////////////////////////////////
//:: Name 	Crown of Might
//:: FileName sp_crown_mght.nss
//:://////////////////////////////////////////////
/**@file Crown of Might
Transmutation
Level: Cleric 3, duskblade 3, sorcerer/wizard 3
Components: V,S,F
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 hour/level (D) or until discharged
Saving Throw: Will negates (harmles)

This spell creates a crown of magical energy that
grants the spell's recipient a +2 enhancement bonus
to Strength.

As an immediate action, the creature wearing a crown
of might can discharge its magic to gain a +8
enhancement bonus to Strength for 1 round. The spell
ends after the wearer uses the crown in this manner.

The crown occupies space on the body as a headband,
hat, or helm. If the crown is removed, the spell
immediately ends.

Focus: A copper hoop 6 inches in diameter.
**/
////////////////////////////////////////////////////
// Author: Tenjac
// Date: 	21.9.06
/////////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"

#include "_CSLCore_Items"
#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CROWN_OF_MIGHT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//


	
	object oTarget = HkGetSpellTarget();
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	object oCrown = CreateItemOnObject("prc_crown_might", oTarget, 1);
	//float fDur = HoursToSeconds(nCasterLevel);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
	int nMetaMagic = HkGetMetaMagicFeat();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,FALSE, SPELL_CROWN_OF_MIGHT, oCaster);

	itemproperty iBonus = ItemPropertyAbilityBonus(ABILITY_STRENGTH, 2);

	CSLSafeAddItemProperty(oCrown, iBonus, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);

	ClearAllActions(TRUE);

	//Force equip
	CSLForceEquip(oTarget, oCrown, INVENTORY_SLOT_HEAD);

	//Schedule Destruction
	DelayCommand(fDuration, DestroyObject(oCrown));

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


