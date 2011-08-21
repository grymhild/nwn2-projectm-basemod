//::///////////////////////////////////////////////
//:: Vigor
//:: NX_s0_lsrVigor.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
	Vigor
	Conjuration (Healing)
	Level: Cleric 3, druid 3
	Components: V, S
	Range: Touch
	Target: Living creature touched
	Duration: 10 rounds + 1 round/level (max 25 rounds)
	
	Target gains fast healing 1 for 10 rounds + 1
	round/level (max 15).
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.04.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/18/2007: Weaker versions of vigor will not override the stronger versions,
//:: but versions of the same or greater strength will replace each other.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_lessvigor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LESSER_VIGOR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	



	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eRegen;
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_LESSER_VIGOR );
	
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF, 5 ); // OldGetCasterLevel(OBJECT_SELF);
	int iBonus = 1;
	float fDuration = RoundsToSeconds(10+ HkGetSpellDuration( OBJECT_SELF, 5 ) );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_VIGOR, FALSE));

	//Check for metamagic extend
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Set the bonus save effect
	eRegen = EffectRegenerate(iBonus, 6.0);
	eRegen = EffectLinkEffects( eRegen, eVis );

	// AFW-OEI 07/18/2007: Strip all weaker vigor effcts and replace them with this spell's effects;
	// fizzle the spell if there is a stronger vigor effect active.
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LESSER_VIGOR);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MASS_LESSER_VIGOR);
	if (GetHasSpellEffect(SPELL_VIGOR, oTarget) || GetHasSpellEffect(SPELL_VIGOROUS_CYCLE, oTarget))
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}
	
	CSLRemovePermanencySpells(oTarget);

	//Apply the bonus effect and VFX impact
	HkApplyEffectToObject(iDurType, eRegen, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

