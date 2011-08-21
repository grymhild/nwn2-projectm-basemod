//::///////////////////////////////////////////////
//:: Mestil's Acid Sheath
//:: SOZ UPDATE BTM
//:: X2_S0_AcidShth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates an acid shield around your
    person. Any creature striking you with its body
    does normal damage, but at the same time the
    attacker takes 1d6 points +2 points per caster
    level of acid damage. Weapons with exceptional
    reach do not endanger thier uses in this way.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:://////////////////////////////////////////////w
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MESTILS_ACID_SHEATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    object oTarget = oCaster;
    
    int iDuration = HkGetSpellDuration( oCaster );
    int iSpellPower = HkGetSpellPower( oCaster );

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	int iShapeEffect = HkGetShapeEffect( VFXSC_DUR_SPELLSHIELD_ACID, SC_SHAPE_SHIELD );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eShield = EffectDamageShield( CSLGetMin( iSpellPower*2, 30 ), 0, iDamageType);
    eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eShield = EffectLinkEffects(eShield, EffectVisualEffect(iShapeEffect));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId, SPELL_ELEMENTAL_SHIELD, SPELL_DEATH_ARMOR, SPELL_Sonic_Shield, SPELLR_WOUNDING_WHISPERS ); // SPELL_MESTILS_ACID_SHEATH

    //Apply the VFX impact and effects
    HkApplyEffectToObject(iDurType, eShield, oTarget, fDuration, iSpellId );
    
    HkPostCast(oCaster);
}