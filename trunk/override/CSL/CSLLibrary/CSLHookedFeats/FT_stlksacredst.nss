//::///////////////////////////////////////////////
//:: Sacred Stealth
//:: cmi_s2_scrdstlth
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: December 22, 2008
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SHDWSTLKR_SACRED_STEALTH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_FNF_FIREBALL;
	int iAttributes = -1;
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
	if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
	{
		SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
	}
	else
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId ); // RemoveSpellEffects(iSpellId, OBJECT_SELF, OBJECT_SELF);

		int nClass = GetLevelByClass(CLASS_SHADOWBANE_STALKER, OBJECT_SELF);
		int nBonus = 4;
		if (nClass > 6) //7th
			nBonus = 8;

		effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

		int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
		if (nCharismaBonus>0)
		{
			effect eSkill1 = EffectSkillIncrease(SKILL_HIDE, nBonus);
			effect eSkill2 = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);
			effect eLink = EffectLinkEffects(eSkill1, eSkill2);
			eLink = SetEffectSpellId(eLink,iSpellId);
			eLink = SupernaturalEffect(eLink);

			//Fire cast spell at event for the specified target
			SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

			//Apply Link and VFX effects to the target
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nCharismaBonus));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
		}

		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
	}
}