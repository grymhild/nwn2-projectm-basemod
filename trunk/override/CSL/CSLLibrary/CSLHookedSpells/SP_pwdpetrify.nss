//::///////////////////////////////////////////////
//:: Power Word: Weaken
//:: NX_s0_pwweaken.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
	Power Word Petrify
	Divination (Formerly Enchantment)
	Level Sorc/Wiz 8
	Components: V
	Range: Close
	Target: One living creature with 100 hp or less
	Saving Throw: None
	Spell Resistance: Yes

	You utter a single word of power that instantly
	causes one creature of your choice to become
	petrified, whether or the creature can hear the
	word or not.  Any creature that currently has
	101 or more hit points is unaffected by power
	word petrify.
	
	NOTE: Because this was changed from enchantment
	to Divination, creatures previously immune to
	mind-affecting spells are vulnurable.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 11.28.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
//:: MDiekmann 6/13/07 - Added SignalEvent
//:: AFW-OEI 07/10/2007: NX1 VFX

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_pwdpetrify();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POWORD_PETRIFY;
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
	effect ePetrify = EffectPetrify();
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_POWER_WORD_PETRIFY);
	float fDuration;
	
//Link vfx with strength drain
	effect eLink = EffectLinkEffects(ePetrify, eVis);
	
//Spell Resistance Check & Target Discrimination

	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
//Determine the nature of the effect
				if (nTargetHP > 100)
				{
					FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, OBJECT_SELF );
				}
				else
				{
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

