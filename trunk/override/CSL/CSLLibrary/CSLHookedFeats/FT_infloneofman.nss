//::///////////////////////////////////////////////
//:: One of Many Influence feats (Player)
//:: nx_s2_influence_oneofmany.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At Loyal, Player gains Regen 3/round.
	
	At Devoted, Player gains Regen 6/round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/20/2007
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_infloneofman();
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
	if (!GetHasSpellEffect(SPELLABILITY_INFLUENCE_ONEOFMANY_LOYAL_PLAYER, oTarget) &&
			!GetHasSpellEffect(SPELLABILITY_INFLUENCE_ONEOFMANY_DEVOTED_PLAYER, oTarget) )
	{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE)); //Fire cast spell at event for the specified target
	
		int nRegen = 3; // Default to 3
		if (iSpellId == SPELLABILITY_INFLUENCE_ONEOFMANY_DEVOTED_PLAYER)
		{
			nRegen = 6;
		}
		
		effect eRegen = EffectRegenerate(nRegen, RoundsToSeconds(1));
		
			//Apply the effects
		eRegen = ExtraordinaryEffect(eRegen); // Cannot dispell.
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oTarget);
	}
	
	HkPostCast(oCaster);
}