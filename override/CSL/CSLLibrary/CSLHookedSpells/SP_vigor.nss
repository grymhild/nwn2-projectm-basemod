//::///////////////////////////////////////////////
//:: Vigor
//:: NX_s0_Vigor.nss
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
	
	The subject gains fast healing 2, enabling it
	to heal 2 hit points per round until the spell ends.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.04.06
//:://////////////////////////////////////////////
//:: AFW-OEI 06/07/2007: Spell should be single-target only.
//:: AFW-OEI 07/18/2007: Weaker versions of vigor will not override the stronger versions,
//:: but versions of the same or greater strength will replace each other.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_vigor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VIGOR;
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
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_VIGOR );
	
	int iSpellPower = HkGetSpellPower( OBJECT_SELF, 15 ); // OldGetCasterLevel(OBJECT_SELF);

	int iBonus = 2;
	float fDuration = RoundsToSeconds(10+HkGetSpellDuration( OBJECT_SELF ));
	
	//Set the bonus save effect
	eRegen = EffectRegenerate(iBonus, 6.0);
	eRegen = EffectLinkEffects( eRegen, eVis );

	//Check for metamagic
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
	{
		// AFW-OEI 07/18/2007: Strip all weaker vigor effcts and replace them with this spell's effects;
		// fizzle the spell if there is a stronger vigor effect active.
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LESSER_VIGOR);
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MASS_LESSER_VIGOR);
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_VIGOR);
		if (GetHasSpellEffect(SPELL_VIGOROUS_CYCLE, oTarget))
		{
			FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
			return;
		}
		
		//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1020, FALSE));

		//Apply the bonus effect and VFX impact
			HkUnstackApplyEffectToObject(iDurType, eRegen, oTarget, fDuration, HkGetSpellId() );
	}
	HkPostCast(oCaster);
}

