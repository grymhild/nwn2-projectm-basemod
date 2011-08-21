//::///////////////////////////////////////////////
//:: Fox's Cunning
//:: NW_S0_FoxCunng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Raises targets Int by 4
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_foxscunning();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FREEDOM_OF_MOVEMENT;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_Freedom_of_Movement )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	else if ( GetSpellId() == SPELL_ASN_Freedom_of_Movement )
	{
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

		
	
	int iDuration = HkGetSpellDuration( oCaster );
	
	object oTarget = HkGetSpellTarget();
	int nModify = 4;
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FOXS_CUNNING, FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds( iDuration ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_FOX_CUNNING);
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nModify));
	eLink = SetEffectSpellId(eLink, SPELL_FOXS_CUNNING);
	
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_FOXS_CUNNING );
	
	HkPostCast(oCaster);
}

