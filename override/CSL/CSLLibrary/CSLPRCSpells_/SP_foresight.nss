//::///////////////////////////////////////////////
//:: Name      Foresight
//:: FileName  sp_foresight.nss
//::///////////////////////////////////////////////
/** @file Foresight
Divination
Level:  Drd 9, Knowledge 9, Sor/Wiz 9, Hlr 9
Components:       V, S, M/DF
Casting Time:     1 standard action
Range:            Personal
Target:       See text
Duration:     10 min./level
Saving Throw:     None
Spell Resistance: No

This spell grants you a powerful sixth sense in
relation to yourself or another. Once foresight is
cast, you receive instantaneous warnings of
impending danger or harm to the subject of the spell.
You are never surprised or flat-footed. In addition,
the spell gives you a general idea of what action you
might take to best protect yourself and gives you a
+2 insight bonus to AC and Reflex saves. This insight
bonus is lost whenever you would lose a Dexterity
bonus to AC.

Arcane Material Component: A hummingbird’s feather.
**/

#include "_HkSpell"
#include "prc_alterations"
#include "spinc_common"

void main()
{
    //--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FORESIGHT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------


    object oPC = OBJECT_SELF;
    int nCasterLvl = HkGetCasterLevel(oPC);
    int nMetaMagic = HkGetMetaMagicFeat();
    //float fDur = (600.0f * nCasterLvl);

    int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //feat constant renamed - NWN2
    itemproperty iDodge = ItemPropertyBonusFeat(FEAT_UNCANNY_DODGE);
    effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), EffectACIncrease(2, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL));
    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2, SAVING_THROW_TYPE_ALL));
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
    CSLSafeAddItemProperty(oArmor, iDodge, fDuration);

    
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

