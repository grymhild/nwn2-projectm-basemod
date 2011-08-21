//::///////////////////////////////////////////////
//:: Curse of Impending Blades
//:: nw_s0_bladecurse.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Curse of Impending Blades
	Necromancy
	Level: Bard 2, ranger 2, sorceror/wizard 2
	Components: V, S
	Range: Medium
	Target: One creature
	Duration: 1 minute/level
	Saving Throw: None
	Spell Resistance: Yes
	
	The target of the spell has a hard time avoiding
	attacks, sometimes even seeming to stumble into
	harm's way.  The subject takes a -2 penalty to AC.
	
	This curse cannot be dispelled, but can be removed
	with remove curse.
	
	NOTE: This spell can also be removed with break
	enchantment, limited wish, miracle, and wish, but
	we don't have these spells.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_curseblades();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CURSE_OF_BLADES;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				float fDuration   = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration( oCaster )));
				int iDurType =  HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CURSE_OF_BLADES, TRUE ));
				CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget,  SPELL_GREATER_CURSE_OF_BLADES, SPELL_CURSE_OF_BLADES );
				
				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_CURSE_OF_BLADES);
				eLink = EffectLinkEffects(eLink, EffectACDecrease(2));
				eLink = EffectLinkEffects(eLink, EffectCurse(0, 0, 0, 0, 0, 0));
				eLink = SupernaturalEffect(eLink);
				HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);     
				
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_CURSE_OF_IMPENDING_BLADES), oTarget);
			}
		}
	}
	
	HkPostCast(oCaster);
}

