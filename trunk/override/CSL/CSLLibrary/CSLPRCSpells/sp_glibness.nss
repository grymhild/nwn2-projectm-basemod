/*
	sp_glibness

	Transmutation
	Level: Brd 3
	Components: S
	Casting Time: 1 standard action
	Range: Personal
	Target: You
	Duration: 10 min./level (D)
	Your speech becomes fluent and more believable. You gain a +30 bonus on Bluff checks made to convince another of the truth of your words. (This bonus doesn't apply to other uses of the Bluff skill, such as feinting in combat, creating a diversion to hide, or communicating a hidden message via innuendo.)
	If a magical effect is used against you that would detect your lies or force you to speak the truth the user of the effect must succeed on a caster level check (1d20 + caster level) against a DC of 15 + your caster level to succeed. Failure means the effect does not detect your lies or force you to speak only the truth.

	By: Flaming_Sword
	Created: Oct 4, 2006
	Modified: Oct 4, 2006
*/
//#include "prc_sp_func"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GLIBNESS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 

	object oTarget = HkGetSpellTarget();
	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_BLUFF, 30), oTarget, fDuration );

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}