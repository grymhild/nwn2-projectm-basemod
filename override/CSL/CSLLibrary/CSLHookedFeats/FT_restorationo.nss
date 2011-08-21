//::///////////////////////////////////////////////
//:: Restoration
//:: x2_s0_restother.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Removes all negative effects unless they come
	from Poison, Disease or Curses.
	Can only be cast on Others - not on oneself.
	Caster takes 5 points of damage when this
	spell is cast.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 3/03
//:://////////////////////////////////////////////
//::

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_restorationo();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
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
	effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
	int bValid;
	if (oTarget != OBJECT_SELF)
	{
			effect eBad = GetFirstEffect(oTarget);
			//Search for negative effects
			while(GetIsEffectValid(eBad))
			{
				if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
					GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
					GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
					GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
					GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
					{
							//Remove effect if it is negative.
							RemoveEffect(oTarget, eBad);
					}
				eBad = GetNextEffect(oTarget);
			}
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			
			//Apply Damage Effect to the Caster
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5), OBJECT_SELF);
	}
	
	HkPostCast(oCaster);
}