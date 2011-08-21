//::///////////////////////////////////////////////
//:: Elemental Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Caster gains 50% cold and fire immunity.  Also anyone
	who strikes the caster with melee attacks takes
	1d6 + 1 per caster level in damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_fireshield();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ELEMENTAL_SHIELD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE; // int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDamageAmount = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iMetaMagic = HkGetMetaMagicFeat();
	object oTarget = OBJECT_SELF;
	

   	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFXSC_DUR_SPELLSHIELD_FIRE, SC_SHAPE_SHIELD ); // note this does not return a visual effect ID, but an AOE ID for walls
	//int iHitEffect = HkGetHitEffect( VFX_IMP_FLAME_M );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
    int iOppositeDamageType = CSLGetOppositeDamageType(iDamageType );
   	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
	//PKM OEI 09.29.06 - The following check is to make sure this spell maximizes properly
	effect eShield;
	if ( iMetaMagic == METAMAGIC_MAXIMIZE )
	{
		eShield = EffectDamageShield( iDamageAmount, DAMAGE_BONUS_6, iDamageType);
	}
	else if ( iMetaMagic == METAMAGIC_EMPOWER )
	{
		eShield = EffectDamageShield( iDamageAmount, DAMAGE_BONUS_1d8, iDamageType);
	}
	else
	{
		eShield = EffectDamageShield( iDamageAmount, DAMAGE_BONUS_1d6, iDamageType);
	}
	
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
	eShield = EffectLinkEffects( eShield, EffectDamageImmunityIncrease(iDamageType, 50) );
	eShield = EffectLinkEffects( eShield, EffectDamageImmunityIncrease(iOppositeDamageType, 50) );
	eShield = EffectLinkEffects( eShield, EffectVisualEffect( VFX_DUR_ELEMENTAL_SHIELD ) );
	//Link effects
	//effect eLink = EffectLinkEffects(eShield, eCold);
	//eLink = EffectLinkEffects(eLink, eFire);
	//eLink = EffectLinkEffects(eLink, eDur);
	//eLink = EffectLinkEffects(eLink, eVis); // NWN1 VFX
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_MESTILS_ACID_SHEATH, SPELL_ELEMENTAL_SHIELD, SPELL_DEATH_ARMOR, SPELL_Sonic_Shield, SPELLR_WOUNDING_WHISPERS );
	//  *GZ: No longer stack this spell
	//if (GetHasSpellEffect(GetSpellId(),oTarget))
	//{
	//		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oTarget, GetSpellId() );
			//SCRemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
	//}
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eShield, oTarget, fDuration );
	
	HkPostCast(oCaster);
}