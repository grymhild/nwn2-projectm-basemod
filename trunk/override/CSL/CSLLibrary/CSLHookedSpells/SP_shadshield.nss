//::///////////////////////////////////////////////
//:: Shadow Shield
//:: NW_S0_ShadShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants the caster +5 AC and 10 / +3 Damage
	Reduction and immunity to death effects
	and negative energy damage for 3 Turns per level.
	Makes the caster immune Necromancy Spells
	
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_shadshield();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHADOW_SHIELD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	

	//effect eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE); // 3.0 DR rules
	effect eStone = EffectDamageReduction( 10, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL ); // 3.5 DR approximation
	effect eAC = EffectACIncrease(5, AC_NATURAL_BONUS);
	effect eShadow = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
	effect eSpell = EffectSpellLevelAbsorption(9, 0, SPELL_SCHOOL_NECROMANCY);
	effect eImmDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
	effect eImmNeg = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 9999,0);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	//Link major effects
	effect eLink = EffectLinkEffects(eStone, eAC);
	eLink = EffectLinkEffects(eLink, eShadow);
	eLink = EffectLinkEffects(eLink, eImmDeath);
	eLink = EffectLinkEffects(eLink, eImmNeg);
	eLink = EffectLinkEffects(eLink, eSpell);
	//eLink = EffectLinkEffects(eLink, eDur);

	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHADOW_SHIELD, FALSE));
	//Apply linked effect
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_SHADOW_SHIELD );
	
	HkPostCast(oCaster);
}

