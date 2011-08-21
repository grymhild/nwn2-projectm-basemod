//::///////////////////////////////////////////////
//:: Power Word: Disable
//:: NX_s0_pwDisable.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
	Power Word Disable
	Divination (Changed from Enchantment)
	Level: Sorceror/wizard 5
	Components: V
	Range: Close
	Target: One living creature with 50 hp or less
	Saving Throw: None
	Spell Resistance: Yes
	
	You utter a single word of power that instantly
	reduces the hit points of one creature of your
	choice to 1.  Any creature that currently had 51
	or more hit points is unaffected by  power word
	disable.
	
	NOTE: I have changed the function of this spell
	so that it reduces a target to 5 hit point, rather
	than 0, to better match the intended function
	since 0 HP in 3.5 is the brink of death, but 0 in
	NWN2 is actually death.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.12.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
// MDiekmann 6/13/07 - Added SignalEvent
// AFW-OEI 07/05/2007: Take you down to 1 HP, not 5 HP.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_pwddisable();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POWER_WORD_DISABLE;
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
	effect eDisable = HkEffectDamage(nTargetHP - 1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);

//Link vfx with strength drain
	effect eLink = EffectLinkEffects(eDisable, eVis);
	
//Spell Resistance Check & Target Discrimination
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE )); // Move signal above SR check.
	
			if (!HkResistSpell(oCaster, oTarget))
			{
				//Determine the nature of the effect
				if (nTargetHP > 50)
				{
					FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, OBJECT_SELF );
				}
				else
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

