//:://////////////////////////////////////////////
//:: FileName: "ss_ep_thewitheri"
/* 	Purpose: The Withering - over the course of 20 rounds (or unless saved vs),
		the target will lose 40 total ability points from any of STR, DEX or CON
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"

void DoWithering(object oTarget, int nDC, int nDuration);


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_THEWITH;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_THEWITH))
	{
		object oTarget = HkGetSpellTarget();
		int nDuration = 60; // Lasts 20 rounds, but fires thrice per round.
		effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget,
			EventSpellCastAt(OBJECT_SELF, SPELL_BESTOW_CURSE, FALSE));
		//Make SR Check
		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			DoWithering(oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget)+10, nDuration);
		}
	}
	HkPostCast(oCaster);
}

void DoWithering(object oTarget, int nDC, int nDuration)
{
	int nX;
	int nAbil;
	effect eDown;
	//Make a Fort Save each time
	if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC))
	{
		// Lower one of either STR, DEX, or CON by 1 every 2 seconds
		nX = d3();
		if (nX == 1) nAbil = ABILITY_STRENGTH;
		if (nX == 2) nAbil = ABILITY_DEXTERITY;
		if (nX == 3) nAbil = ABILITY_CONSTITUTION;
		eDown = EffectAbilityDecrease(nAbil, 1);
		eDown = SupernaturalEffect(eDown);
		if (GetAbilityScore(oTarget, nAbil) > 3)
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDown, oTarget);
	}
	nDuration--;
	if (nDuration >= 1)
		DelayCommand(2.0, DoWithering(oTarget, nDC, nDuration));
}
