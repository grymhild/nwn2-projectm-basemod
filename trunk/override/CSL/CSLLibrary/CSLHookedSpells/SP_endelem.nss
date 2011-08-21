//::///////////////////////////////////////////////
//:: Endure Elements
//:: NW_S0_EndEle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Offers 10 points of elemental resistance.  If 20
	points of a single elemental type is done to the
	protected creature the spell fades
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 23, 2001
//:://////////////////////////////////////////////


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_endelem();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENDURE_ELEMENTS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	float fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS); //HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int nAmount = 20;
	int nResistance = 10;
	effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
	effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
	effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
	effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
	effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);
	//effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS); // no longer using NWN1 VFX
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_ENDURE_ELEMENTS );  // uses NWN2 VFX
	//effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION); // no longer using NWN1 VFX
	//effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);   // no longer using NWN1 VFX

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENDURE_ELEMENTS, FALSE));

	//Link Effects
	effect eLink = EffectLinkEffects(eCold, eFire);
	eLink = EffectLinkEffects(eLink, eAcid);
	eLink = EffectLinkEffects(eLink, eSonic);
	eLink = EffectLinkEffects(eLink, eElec);
	eLink = EffectLinkEffects(eLink, eDur);
	//eLink = EffectLinkEffects(eLink, eDur2);  // no longer using NWN1 VFX


	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
	CSLRemovePermanencySpells(oTarget);

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  // no longer using NWN1 VFX
	
	HkPostCast(oCaster);
}

