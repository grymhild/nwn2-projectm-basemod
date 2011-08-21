//::///////////////////////////////////////////////////////////////////////////
//::
//::  nw_s0_shadescaster.nss
//::
//::  This is the ImpactScript for spell ID 969. If the caster clicks on
//::  himself he will cast Premonition, Protection from Spells, and Shield.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created by: Brian Fox
//::  Created on: 6/27/06
//::
//::///////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_shadtargetca();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHADES_TARGET_CASTER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_SHADOW, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nDamageLimit = HkGetSpellPower( oCaster ) * 10;
	int iDuration = HkGetSpellDuration( oCaster );
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	object oTarget = HkGetSpellTarget();
	if (oTarget==oCaster) // This may be redundant since the 2DA defines the spell as self-only
	{ 
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
		
		// Get rid of old effects
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_PROTECTION_FROM_SPELLS, SPELL_PREMONITION, SPELL_SHIELD, SPELL_SHIELDIMPROVED, GetSpellId() );
		
		effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_PREMONITION) );
		
		// Premonition
		effect ePremonition = EffectDamageReduction( 30, GMATERIAL_METAL_ADAMANTINE, nDamageLimit, DR_TYPE_GMATERIAL );
		ePremonition = EffectLinkEffects(ePremonition, eOnDispell );
		
		// Protection from Spells
		effect eLink = EffectVisualEffect( VFX_SPELL_SHADES_BUFF );
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 8, SAVING_THROW_TYPE_SPELL) );
		
		// Shield
		eLink = EffectLinkEffects(eLink, EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS) );
		//eLink = EffectLinkEffects(eLink, EffectVisualEffect( VFXSC_DUR_SPELLWEAP_SHIELD_NEGATIVE ) );
		eLink = EffectLinkEffects(eLink, EffectVisualEffect( VFX_DUR_SPELL_SHIELD ) );
		eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_MAGIC_MISSILE) );
		eLink = EffectLinkEffects(eLink, eOnDispell );
		
		//Apply the armor bonuses and the VFX impact
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePremonition, oTarget, fDuration );
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
	}
	
	HkPostCast(oCaster);
}

