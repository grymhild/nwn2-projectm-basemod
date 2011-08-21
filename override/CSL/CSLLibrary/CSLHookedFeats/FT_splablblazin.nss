//::///////////////////////////////////////////////
//:: Blazing Aura
//:: nx_s2_blazingaura.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Caster gains additional 1d10 fire damage and
	inflicts 1d6 fire damage on melee attackers
	for 5 + WIS rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/29/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 07/17/2007: NX1 VFX.

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iDuration = 5 + GetAbilityModifier(ABILITY_WISDOM);

	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_BLAZING_AURA, SC_SHAPE_AURA ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDur = EffectVisualEffect( iShapeEffect );
	effect eShield = EffectDamageShield(0, DAMAGE_BONUS_1d6, iDamageType);
	effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d10, iDamageType );
	effect eLink = EffectLinkEffects(eShield, eDamage);
	eLink = EffectLinkEffects(eLink, eDur);

	//Fire cast spell at event for the specified target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

	// Spell does not stack
	if (GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
	{
			//SCRemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	}

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	
	HkPostCast(oCaster);
}