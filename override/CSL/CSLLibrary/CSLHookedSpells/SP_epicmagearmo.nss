//::///////////////////////////////////////////////
//:: Epic Mage Armor
//:: X2_S2_EpMageArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the target +20 AC Bonus to Deflection,
	Armor Enchantment, Natural Armor and Dodge.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_epicmagearmo();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_MAGE_ARMOR;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	effect eVis = EffectVisualEffect(495);
	effect eAC1, eAC2, eAC3, eAC4;
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nAmount = HkCapAC( 6 ); // this caps at 5 normally, boosted to 6 just so its higher for servers with higher magic levels
	
	//Set the four unique armor bonuses
	eAC1 = EffectACIncrease( nAmount, AC_ARMOUR_ENCHANTMENT_BONUS);
	eAC2 = EffectACIncrease( nAmount, AC_DEFLECTION_BONUS);
	eAC3 = EffectACIncrease( nAmount, AC_DODGE_BONUS);
	eAC4 = EffectACIncrease( nAmount, AC_NATURAL_BONUS);
	effect eDur = EffectVisualEffect(VFX_DUR_SANCTUARY);

	effect eLink = EffectLinkEffects(eAC1, eAC2);
	eLink = EffectLinkEffects(eLink, eAC3);
	eLink = EffectLinkEffects(eLink, eAC4);
	eLink = EffectLinkEffects(eLink, eDur);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());

	// * Brent, Nov 24, making extraodinary so cannot be dispelled
	eLink = ExtraordinaryEffect(eLink);

	//Apply the armor bonuses and the VFX impact
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,1.0);
	
	HkPostCast(oCaster);
}

