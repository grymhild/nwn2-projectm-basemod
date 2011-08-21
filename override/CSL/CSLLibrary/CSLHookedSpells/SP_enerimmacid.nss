//:://////////////////////////////////////////////////////////////////////////
//:: Level 7 Arcane Spell: Energy Immunity
//:: nw_s0_enerimmu.nss
//:: Created By: Brock Heinz - OEI
//:: Created On:
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Energy Immunity (B)
			E-mail from WotC, up-coming Complete Arcane
			School: Abjuration
			Components: Verbal, Somatic
			Range: Touch
			Target: Creature Touched
			Duration: 24 hours

			This provides complete protection from one of the five energy types:
		acid, cold, electricity, fire, or sonic. They take no damage from the
		selected elemental type.
			[Art] This is a buff spell. This may need an effect depending on
		decisions later.

*/
//:://////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"





void main()
{
	//scSpellMetaData = SCMeta_SP_enerimmacid();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENERGY_IMMUNITY_ACID;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(OBJECT_SELF);
	float fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);
	
	// block this if its an enemy
	if (GetIsObjectValid(oTarget))
	{
		if ( GetIsEnemy( oTarget ) )
		{
				return;
		}
	}
	

	SCUnstackEnergyImmunity( SPELL_ENERGY_IMMUNITY_ACID, oCaster, oTarget );

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//ACID
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	effect eImmu = EffectDamageResistance(iDamageType, 9999, 0);
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION); // NWN1 VFX
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_IMMUNITY ); // NWN2 VFX


	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eImmu, oTarget, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget); // NWN1 VFX
	
	HkPostCast(oCaster);
}

