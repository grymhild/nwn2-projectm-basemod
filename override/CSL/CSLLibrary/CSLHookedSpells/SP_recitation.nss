//::///////////////////////////////////////////////
//:: Recitation
//:: NX_s0_recitation.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Recitation
	Creation (Conjuration)
	Level: Cleric 4
	Components: V, S
	Targets: All allies within a 60-ft.-radius of caster
	Duration: 1 round/level
	Saving Throw: None
	Spell Resistance: Yes
	
	This spell affects all allies within the spell's area at
	the moment you cast it.  Your allies gain a +2 bonus to
	AC, attack rolls, and saving throws, or a + 3 bonus if
	they worship the same diety as you.

	
	Note: SC says that this spell also targets foes in the
	area, but doesn't say exactly what it does to them.
	Presumably it also gives them the bonus but the
	description is unclear.
	
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_recitation();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RECITATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	float fRadius = HkApplySizeMods(RADIUS_SIZE_VAST);
	int iDuration = HkGetSpellDuration( oCaster );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lTarget = GetLocation(oCaster);
	int iBonus;
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_RECITATION);
	effect eLink;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			CSLUnstackSpellEffects(oTarget, GetSpellId());
			iBonus = ( CSLGetIsSameFaith( oCaster, oTarget) ) ? 3 : 2;
			eLink = EffectLinkEffects(eVis,  EffectACIncrease(iBonus, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL));
			eLink = EffectLinkEffects(eLink, EffectAttackIncrease(iBonus));
			eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus, SAVING_THROW_TYPE_ALL));
			HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, HkGetSpellId());
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

