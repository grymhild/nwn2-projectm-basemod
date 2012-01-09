//::///////////////////////////////////////////////
//:: Power Word: Weaken
//:: NX_s0_pwweaken.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Power Word Weaken
	Divination
	Level: Sorceror/Wizard 3
	Components: V
	Range: Close
	Target: One living creature with 75 hp or less
	Duration: See text
	Saving Throw: None
	Spell Resistance: Yes
	
	You utter a single word of power that instantly
	causes one creature of your choice to become
	weaker, dealing 2 points of damage to its strength,
	whether the creature can hear the word or not.
	
	The specific effect and duration of the spell
	depend on the target's current hit point total,
	as show below.  Any creature that currently has
	75 or more hit points is unaffected by power word
	weaken.
	
	Hit Points           Effect/Duration
	25 or less          The strength damage is ability drain instead
	26-50                Strength damage last 1d4+1 minutes
	51-75                Strength damage lasts 1d4+1 rounds
	
	NOTE: Because this was changed from enchantment
	to Divination, creatures previously immune to
	mind-affecting spells are vulnurable.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 11.28.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
//:: MDiekmann 6/13/07 - Added Signal Event
//:: AFW-OEI 07/10/2007: NX1 VFX.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_pwdweaken();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POWORD_WEAKEN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	object oTarget = HkGetSpellTarget();
	int nTargetHP = GetCurrentHitPoints(oTarget);
	effect eStrDrain = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_POWER_WORD_WEAKEN);
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);
	float fDuration;
	
//Link vfx with strength drain
	effect eLink = EffectLinkEffects(eStrDrain, eDur);
	
//Spell Resistance Check & Target Discrimination

	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
//Determine the nature of the effect
				if (nTargetHP > 75)
				{
					FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, OBJECT_SELF );
				}
				else if (nTargetHP > 50)
				{
					fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(d4()));
					
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else if (nTargetHP > 25)
				{
					fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(d4()));
					
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else
				{
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}
