//::///////////////////////////////////////////////
//:: Aid
//:: NW_S0_Aid.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target creature gains +1 to attack rolls and saves vs fear.
	Also gains +1d8 +1/lvl temporary HP.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_aid();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_AID;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iBonus = HkApplyMetamagicVariableMods(d8(), 8) + CSLGetMin(10, iSpellPower); // 1-8 + 1 Per Lvl (Max Lvl 10)
	//float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration( oCaster )));
	//int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eAttack = EffectAttackIncrease(1);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);

	effect eHP = EffectTemporaryHitpoints(iBonus);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AID);
	object oTarget = HkGetSpellTarget();

	effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eLink, eVis);
	//eLink = EffectLinkEffects(eLink, eHP);

	effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_AID));
	eLink = EffectLinkEffects(eLink, eOnDispell);
	eHP = EffectLinkEffects(eHP, eOnDispell);

	CSLUnstackSpellEffects(oTarget, GetSpellId());
	CSLUnstackSpellEffects(oTarget, 1052, "Mass Aid");

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eHP, oTarget, fDuration);
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

