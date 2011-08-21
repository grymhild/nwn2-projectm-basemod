/*
	sp_jump

	Transmutation
	Level: Drd 1, Rgr 1, Sor/Wiz 1
	Components: V, S, M
	Casting Time: 1 standard action
	Range: Touch
	Target: Creature touched
	Duration: 1 min./level (D)
	Saving Throw: Will negates (harmless)
	Spell Resistance: Yes
	The subject gets a +10 enhancement bonus on Jump checks. The enhancement bonus increases to +20 at caster level 5th, and to +30 (the maximum) at caster level 9th.
	Material Component: A grasshopper's hind leg, which you break when the spell is cast.

	By: Flaming_Sword
	Created: Sept 27, 2006
	Modified: Sept 27, 2006
*/
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
#include "_HkSpell"
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return TRUE; 	//return TRUE if spell charges should be decremented
}
*/




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_JUMP; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);
	int nBonus;
	if(nCasterLevel >= 9) nBonus = 30;
	else if (nCasterLevel >= 5) nBonus = 20;
	else nBonus = 10;

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_JUMP, nBonus), oTarget, fDuration );
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}