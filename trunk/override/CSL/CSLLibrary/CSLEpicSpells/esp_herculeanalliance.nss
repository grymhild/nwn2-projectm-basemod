/////////////////////////////////////////////////
// Herculean Alliance
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/06/2004
// Description: This script changes someone's ability scores
/////////////////////////////////////////////////
/*
	Boneshank - copied Herculean Empowerment, and converted to area/ally spell.
*/
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_HERCALL;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_HERCALL))
	{
		
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF); // Boneshank - changed.
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0,
			HkGetSpellTargetLocation());
		while (GetIsObjectValid(oTarget))
		{
			if (GetFactionEqual(oTarget, OBJECT_SELF))
			{
				int nModify = d4() + 5;
				float fDuration = HoursToSeconds(nCasterLvl);
				effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
				effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
				effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
				effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,nModify);
				effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,nModify);

				//Signal the spell cast at event
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId(), FALSE));

				//Link major effects
				effect eLink = EffectLinkEffects(eStr, eDex);
				eLink = EffectLinkEffects(eLink, eCon);
				eLink = EffectLinkEffects(eLink, eDur);

				// * Making extraodinary so cannot be dispelled (optional)
				eLink = ExtraordinaryEffect(eLink);

				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0,
				HkGetSpellTargetLocation());
		}
	}
	HkPostCast(oCaster);
}
