//::///////////////////////////////////////////////
//:: Aid, Mass
//:: NX_s0_massaid.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Aid, Mass
	Enchantment (Compulsion)[Mind Affecting]
	Level: Cleric 3
	Range: Close
	Duration: ?
	Targets: One or more creatures within a 30ft radius.
	
	Subjects gain +1 on attack rolls and saves against fear
	effects plus temporary hitpoints equal to 1d8 + caster
	level (to a maximum of 1d8 + 15 at caster level 15).
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_msaid();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_AID;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iBonus = HkApplyMetamagicVariableMods(d8(), 8) + CSLGetMin(10, iSpellPower); // 1-8 + 1 Per Lvl (Max Lvl 10)
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	effect eAttack = EffectAttackIncrease(1);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
	effect eHP = EffectTemporaryHitpoints(iBonus);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AID);
	object oTarget = HkGetSpellTarget();
	effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eLink, eVis);
	effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, 1052));
	eLink = EffectLinkEffects(eLink, eOnDispell);
	eHP = EffectLinkEffects(eHP, eOnDispell);
	location lTarget = HkGetSpellTargetLocation();
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			CSLUnstackSpellEffects(oTarget, 1052);
			CSLUnstackSpellEffects(oTarget, SPELL_AID, "Aid");
			SignalEvent(oTarget, EventSpellCastAt(oCaster, 1052, FALSE));
			HkApplyEffectToObject(iDurType, eHP, oTarget, fDuration, 1052);
			HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, 1052);
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	}
	
	HkPostCast(oCaster);
}