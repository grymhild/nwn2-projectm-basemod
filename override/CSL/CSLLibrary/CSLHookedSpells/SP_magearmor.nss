//::///////////////////////////////////////////////
//:: Mage Armor
//:: [NW_S0_MageArm.nss]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the target +4 AC. (Updated JLR - OEI 07/05/05 NWN2 3.5)
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_magearmor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAGE_ARMOR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool=SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool=SPELL_SUBSCHOOL_CREATION;
	if ( GetSpellId() == SPELL_SHADOW_CONJURATION_MAGE_ARMOR || GetSpellId() == SPELL_MSC_MAGE_ARMOR )
	{
		iSpellSchool=SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool=SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iShapeEffect = VFX_DUR_SPELL_MAGE_ARMOR; //HkGetShapeEffect( VFXSC_DUR_SPELLWEAP_ARMOR, SC_SHAPE_SPELLWEAP_ARMOR );

	
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);

	float fDuration = HkApplyMetamagicDurationMods(HoursToSeconds(HkGetSpellDuration( oCaster )));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

	effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
	effect eDur = EffectVisualEffect(iShapeEffect);// VFX_DUR_SPELL_MAGE_ARMOR
	effect eLink = EffectLinkEffects(eAC, eDur);

	if (CSLCheckNonStackingSpell(oTarget, SPELL_IMPROVED_MAGE_ARMOR, "Improved Mage Armor")) return;
	CSLUnstackSpellEffects(oTarget, SPELL_MAGE_ARMOR);

	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

