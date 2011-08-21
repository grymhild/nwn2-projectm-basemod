//::///////////////////////////////////////////////
//:: Improved Mage Armor
//:: [NW_S0_ImpMagArm.nss]
//:://////////////////////////////////////////////

/*
	Gives the target +3 +1/per 2 caster lvls AC.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_impmagearmor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_IMPROVED_MAGE_ARMOR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	int iShapeEffect = VFX_DUR_SPELL_MAGE_ARMOR; //HkGetShapeEffect( VFXSC_DUR_SPELLWEAP_ARMOR, SC_SHAPE_SPELLWEAP_ARMOR );
	
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);

	float fDuration = HkApplyMetamagicDurationMods(HoursToSeconds( HkGetSpellDuration( oCaster ) ));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

	effect eAC = EffectACIncrease(6, AC_ARMOUR_ENCHANTMENT_BONUS);
	effect eDur = EffectVisualEffect(iShapeEffect); // VFX_DUR_SPELL_MAGE_ARMOR
	effect eLink = EffectLinkEffects(eAC, eDur);

	CSLUnstackSpellEffects(oTarget, SPELL_IMPROVED_MAGE_ARMOR);
	CSLUnstackSpellEffects(oTarget, SPELL_MAGE_ARMOR, "Mage Armor");   // 10/16/06 - BDF

	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

