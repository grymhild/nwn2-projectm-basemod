//::///////////////////////////////////////////////
//:: Paragon Visionary
//:: cmi_s2_paravis
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"
//#include "nwn2_inc_metmag"
//#include "cmi_ginc_spells"



#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_PARAGON_VISIONARY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_NONE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS) );

	int nBonus = GetAbilityModifier(ABILITY_WISDOM, oCaster) * 2;
	if (6 > nBonus)
		nBonus = 6;
	if (nBonus > 20)
		nBonus = 20;

	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_PARAGON_VISIONARY );

	effect eSkill1 = EffectSkillIncrease(SKILL_SPOT, nBonus);
	effect eSkill2 = EffectSkillIncrease(SKILL_LISTEN, nBonus);
	effect eTrueSight = EffectTrueSeeing();

	effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_DARKONESLUCK);
	effect eLink = EffectLinkEffects(eTrueSight, eDur);
	eLink = EffectLinkEffects(eLink, eSkill1);
	eLink = EffectLinkEffects(eLink, eSkill2);

	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);


	//Fire cast spell at event for the specified target
	SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELLABILITY_PARAGON_VISIONARY, FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	
	HkPostCast(oCaster);
}