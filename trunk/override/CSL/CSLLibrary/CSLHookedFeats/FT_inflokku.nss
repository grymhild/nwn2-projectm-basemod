//::///////////////////////////////////////////////
//:: Okku Influence feats
//:: nx_s2_influence_okku.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At Loyal, Okku gains Immunity to Fear.
	
	At Devoted, Okku gains Immunity to Fear, and
	Immunity to Mind-Affecting Spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/18/2007
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_inflokku();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();

	// Does not stack with itself
	if (!GetHasSpellEffect(SPELLABILITY_INFLUENCE_OKKU_LOYAL, oTarget) &&
			!GetHasSpellEffect(SPELLABILITY_INFLUENCE_OKKU_DEVOTED, oTarget) )
	{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE)); //Fire cast spell at event for the specified target
	
		effect eInfluenceEffects;
		effect eImmuneFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
		
		if (iSpellId == SPELLABILITY_INFLUENCE_OKKU_DEVOTED)
		{ // Devoted grants more stuff
			effect eImmuneMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
			eInfluenceEffects = EffectLinkEffects(eImmuneFear, eImmuneMind);
			
			// AFW-OEI 09/13/2007: Regenerate 4 HP every round (6 seconds).
			effect eRegen = EffectRegenerate(4, 6.0);
			eInfluenceEffects = EffectLinkEffects(eRegen, eInfluenceEffects);
		}
		else
		{ // Otherwise, it's just Immunity to Fear by itself.
			eInfluenceEffects = eImmuneFear;
		}
	
			//Apply the effects
		eInfluenceEffects = ExtraordinaryEffect(eInfluenceEffects); // Cannot dispell.
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eInfluenceEffects, oTarget);
	}
	
	HkPostCast(oCaster);
}