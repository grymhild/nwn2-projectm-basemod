//::///////////////////////////////////////////////
//:: Legend Lore
//:: NW_S0_Lore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the caster a boost to Lore skill of 10
	plus 1 / 2 caster levels.  Lasts for 1 Turn per
	caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: 2003-10-29: GZ: Corrected spell target object
//::             so potions work wit henchmen now

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_legendlore();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LEGEND_LORE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iLevel = HkGetSpellPower(oTarget);
	int iBonus = 10 + (iLevel / 2);
	effect eLore = EffectSkillIncrease(SKILL_LORE, iBonus);
	//effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_LEGEND_LORE );
	effect eLink = EffectLinkEffects(eLore, eDur);
	
	//Meta-Magic checks
	float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds(iLevel) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Make sure the spell has not already been applied
	if(!GetHasSpellEffect(SPELL_IDENTIFY, oTarget) || !GetHasSpellEffect(SPELL_LEGEND_LORE, oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEGEND_LORE, FALSE));
		//Apply linked and VFX effects
		HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_LEGEND_LORE );
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	
	HkPostCast(oCaster);
}

