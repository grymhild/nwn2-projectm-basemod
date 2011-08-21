//::///////////////////////////////////////////////
//:: Lesser Restoration
//:: NW_S0_LsRestor.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Removes all supernatural effects related to ability
	damage, as well as AC, Damage,
*/

// DBR 8/31/06 - RemoveEffect() messes up the iterators, start from beginning of list if RemoveEffect Occurs.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Magic"


void main()
{
	//scSpellMetaData = SCMeta_SP_lessrestorat();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LESSER_RESTORATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE;
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
	
	
	object oTarget = HkGetSpellTarget();
	
	int bRestored = CSLRestore( oTarget, NEGEFFECT_TEMPORARYABILITY|NEGEFFECT_COMBAT );
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
				GetTag(GetEffectCreator(eBad)) == "q6e_ShaorisFellTemple" ||
				GetEffectType(eBad)==EFFECT_TYPE_SKILL_DECREASE) &&
				GetEffectSpellId(eBad)!=SPELL_ENLARGE_PERSON &&
				GetEffectSpellId(eBad)!=SPELL_RIGHTEOUS_MIGHT &&
				GetEffectSpellId(eBad)!=SPELL_STONE_BODY &&
				GetEffectSpellId(eBad)!=SPELL_IRON_BODY &&
				GetEffectSpellId(eBad)!=SPELL_REDUCE_PERSON &&
				GetEffectSpellId(eBad)!=SPELL_REDUCE_ANIMAL &&
				GetEffectSpellId(eBad)!=SPELL_REDUCE_PERSON_GREATER &&
				GetEffectSpellId(eBad)!=SPELL_REDUCE_PERSON_MASS &&	
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
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_LESSER_RESTORATION, FALSE));
	if ( bRestored )
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_LESSER), oTarget);
	}
	HkPostCast(oCaster);
}

