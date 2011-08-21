//::///////////////////////////////////////////////
//:: Greater Restoration
//:: NW_S0_GrRestore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Removes all negative effects of a temporary nature
	and all permanent effects of a supernatural nature
	from the character. Does not remove the effects
	relating to Mind-Affecting spells or movement alteration.
	Heals target for 5d8 + 1 point per caster level.
*/

// DBR 8/31/06 - RemoveEffect() messes up the iterators, start from beginning of list if RemoveEffect Occurs.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Healing"
#include "_CSLCore_Magic"


void main()
{
	//scSpellMetaData = SCMeta_SP_grtrestorati();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_RESTORATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iCasterLevel  = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	int bRestored = CSLRestore( oTarget, NEGEFFECT_CURSE|NEGEFFECT_COMBAT|NEGEFFECT_ABILITY|NEGEFFECT_DISEASE|NEGEFFECT_POISON|NEGEFFECT_SLOWED|NEGEFFECT_MENTAL|NEGEFFECT_PERCEPTION|NEGEFFECT_LEVEL );
	/*
	effect eBad = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eBad))  {
		if ((GetEffectType(eBad)==EFFECT_TYPE_ABILITY_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_AC_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_ATTACK_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_DAMAGE_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_SAVING_THROW_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_SKILL_DECREASE ||
				GetEffectType(eBad)==EFFECT_TYPE_BLINDNESS ||
				GetEffectType(eBad)==EFFECT_TYPE_DEAF ||
				GetEffectType(eBad)==EFFECT_TYPE_CURSE ||
				GetEffectType(eBad)==EFFECT_TYPE_DISEASE ||
				GetEffectType(eBad)==EFFECT_TYPE_POISON ||
				GetEffectType(eBad)==EFFECT_TYPE_PARALYZE ||
				GetEffectType(eBad)==EFFECT_TYPE_CHARMED ||
				( GetEffectType(eBad) == EFFECT_TYPE_DOMINATED && !GetLocalInt( oTarget, "SCSummon" ) ) ||
				GetEffectType(eBad)==EFFECT_TYPE_DAZED ||
				GetEffectType(eBad)==EFFECT_TYPE_CONFUSED ||
				GetEffectType(eBad)==EFFECT_TYPE_FRIGHTENED ||
				GetEffectType(eBad)==EFFECT_TYPE_NEGATIVELEVEL ||
				GetEffectType(eBad)==EFFECT_TYPE_PARALYZE ||
				GetTag(GetEffectCreator(eBad)) == "q6e_ShaorisFellTemple" ||
				GetEffectType(eBad)==EFFECT_TYPE_SLOW ||
				GetEffectType(eBad)==EFFECT_TYPE_STUNNED) &&
				GetEffectSpellId(eBad)!=SPELL_ENLARGE_PERSON &&
				GetEffectSpellId(eBad)!=SPELL_RIGHTEOUS_MIGHT &&
				GetEffectSpellId(eBad)!=SPELL_STONE_BODY &&
				GetEffectSpellId(eBad)!=SPELL_IRON_BODY &&
				GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON &&
				GetEffectSpellId(eBad) != SPELL_REDUCE_ANIMAL &&
				GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_GREATER &&
				GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_MASS &&
				GetEffectSpellId(eBad)!=FOREST_MASTER_OAK_HEART &&
				GetEffectSpellId(eBad)!=SPELLABILITY_GRAY_ENLARGE) {
			//Remove effect if it is negative.
			RemoveEffect(oTarget, eBad);
			eBad = GetFirstEffect(oTarget);
		} else {
			eBad = GetNextEffect(oTarget);
		}
	}
	*/
	if ( !CSLGetIsUndead( oTarget ) )
	{
		SCHealHarmTarget(oTarget, iCasterLevel, SPELL_HEAL, TRUE);
	}
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GREATER_RESTORATION, FALSE));
	if ( bRestored )
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_GREATER), oTarget);
	}
	HkPostCast(oCaster);
}

