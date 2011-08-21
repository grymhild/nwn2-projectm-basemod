//::///////////////////////////////////////////////
//:: Death Armor
//:: X2_S0_DthArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	You are surrounded with a magical aura that injures
	creatures that contact it. Any creature striking
	you with its body or handheld weapon takes 1d4 points
	of damage +1 point per 2 caster levels (maximum +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Jan 6, 2003
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

// JLR - OEI 08/24/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



//#include "ginc_debug"

void main()
{
	//scSpellMetaData = SCMeta_SP_deatharm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DEATH_ARMOR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = OBJECT_SELF; // HkGetSpellTarget(); // ensures target is the caster of the spell
	float fDuration = RoundsToSeconds( HkGetSpellDuration(oTarget) );
	int iMetaMagic = GetMetaMagicFeat();
	
	int iDamageAmount = HkGetSpellPower(oTarget, 10)/2; // half casters level with a max of 5
		
	effect eShield;
	
	
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_MAGICAL );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_DEATH_ARMOR, SC_SHAPE_AURA ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NONE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_MAGICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
	
	
	if (!GetIsPC(oTarget) && GetTag(oTarget)=="drakkenmage")
	{
		iDamageType = DAMAGE_TYPE_NEGATIVE;
		iDamageAmount = 10;
	}
		
	int iDamageConstant = HkApplyMetamagicConstDamageBonusMods( DAMAGE_BONUS_1d4, iMetaMagic );
	eShield = EffectDamageShield(iDamageAmount, iDamageConstant, iDamageType );
	
	eShield = EffectLinkEffects( eShield, EffectVisualEffect( iShapeEffect ) );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	//int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Stacking Spellpass, 2003-07-07, Georg
	//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_MESTILS_ACID_SHEATH, SPELL_ELEMENTAL_SHIELD, SPELL_DEATH_ARMOR, SPELL_Sonic_Shield, SPELLR_WOUNDING_WHISPERS );
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oTarget, fDuration);
	
	HkPostCast(oCaster);
}

