//:://///////////////////////////////////////////////
//:: Righteous Might
//:: nw_s0_sngodisc.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/11/05
//::////////////////////////////////////////////////
/*
		5.2.5.3.1 Righteous Might
		PHB, pg. 273
		School:        Transmutation
		Components:  Verbal, Somatic
		Range:      Personal
		Target:        You
		Duration:   1 round / level

		This increases the size of the caster by 50%. All size increasing spells
		use this effect, and no size increasing spells stack (the second size
		increasing spell automatically fails if targeted on someone who has Enlarge
		Person cast on them for example). They get a +4 Strength Bonus, +2 Constitution Bonus,
		and a +2 natural armor AC bonus. Additionally the caster gains damage resistance 3/evil
		(if they are non-evil) or 5/good (if they are evil). At 12th level the damage
		resistance goes up to 6, and at 15th it goes up to 9. They get a -1 attack
		and -1 AC penalty because of size. All melee weapons deal +3 damage.

		[B] They threaten opponents within 10 feet instead of 5 feet. This may
		not be implemented depending on how the AoO works in the Aurora engine.


		[Rules Note] In 3.5 melee weapons actually go up one size category. The
		+3 damage is an average of some of the typical weapons a PC would use.
		E.g. a longsword goes from 1d8 to 2d6 (avg. gain of 2.5) and a two-handed
		sword goes from 2d6 to 3d6 (avg. gain of 3.5).
		Also in the Righteous Might description in the PHB it covers cases where
		you don't have enough space to grow that much. That part of the spell is
		removed from NWN2 for simplicity's sake. Also the stats don't match the
		PHB - they match the errata on the WotC web-site.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"







void main()
{	
	//scSpellMetaData = SCMeta_SP_righteousmig();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RIGHTEOUS_MIGHT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	// Determine and validate the target (this SHOULD be the caster!)
	object oTarget = HkGetSpellTarget();
	if (CSLGetHasSizeIncreaseEffect(oTarget)) {
		FloatingTextStrRefOnCreature(3734, oTarget);  //"Failed"
		return;
	}

	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	float fDuration  = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int nAlignment = GetAlignmentGoodEvil(oTarget);

	int nDmgType = (nAlignment==ALIGNMENT_EVIL) ? ALIGNMENT_GOOD : ALIGNMENT_EVIL;
	int nDmgResist = 3;
	if (iSpellPower>=15)
	{
		nDmgResist = 9;
	}
	else if (iSpellPower>=12)
	{
		nDmgResist = 6;
	}

	effect eLink = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 2));
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(nDmgResist, nDmgType, 0, DR_TYPE_ALIGNMENT));
	eLink = EffectLinkEffects(eLink, EffectACIncrease(2, AC_NATURAL_BONUS));
	eLink = EffectLinkEffects(eLink, EffectACDecrease(1, AC_DODGE_BONUS));
	eLink = EffectLinkEffects(eLink, EffectAttackDecrease(1, ATTACK_BONUS_MISC));
	//eLink = EffectLinkEffects(eLink, EffectDamageIncrease(3, DAMAGE_TYPE_MAGICAL ));
	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(3, 3 ));
	eLink = EffectLinkEffects(eLink, EffectSetScale(1.5));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_HIT_SPELL_ENLARGE_PERSON));

	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, HkGetSpellId());
	
	CSLConstitutionBugCheck( oTarget );
	
	HkPostCast(oCaster);
}