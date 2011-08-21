//::///////////////////////////////////////////////
//:: Dissonant Chord - Break Concentration
//:: cmi_s2_brkconca
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: October 18, 2009
//:://////////////////////////////////////////////
//#include "x0_i0_spells"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_spells"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELLABILITY_DISCHORD_BREAK_CONC;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//SpeakString("nw_s2_auradespairA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS) );

	//SendMessageToPC(oCaster,GetName(oTarget));
	int nPenalty = GetLevelByClass(CLASS_DISSONANT_CHORD, oCaster);
	nPenalty += GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	effect eConcPenalty = EffectSkillDecrease(SKILL_CONCENTRATION, nPenalty);
	eConcPenalty		= SupernaturalEffect(eConcPenalty);

	// Doesn't work on self
	if (oTarget != oCaster)
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));


		//Faction Check
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
			//SpeakString("nw_s2_auradespairA.ns: On Enter: target is enemy");
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConcPenalty, oTarget, fDuration);
		}
	}
}