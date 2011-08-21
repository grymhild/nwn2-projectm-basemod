//::///////////////////////////////////////////////
//:: Protection from Energy
//:: NW_S0_ProEnergy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Offers 30 points of elemental resistance.  If 40
	points of a single elemental type is done to the
	protected creature the spell fades
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_protener();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PROTECTION_FROM_ENERGY;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_BG_Protection_from_Energy )
	{
		iClass=CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	int iDuration = 24;
	int nAmount = 40;
	int nResistance = 30;
	effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
	effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
	effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
	effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
	effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_PROT_ENERGY);
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PROTECTION_FROM_ENERGY, FALSE)); // JLR - OEI 07/11/05 -- Name Changed
	
	//Link Effects
	effect eLink = EffectLinkEffects(eCold, eFire);
	eLink = EffectLinkEffects(eLink, eAcid);
	eLink = EffectLinkEffects(eLink, eSonic);
	eLink = EffectLinkEffects(eLink, eElec);
	eLink = EffectLinkEffects(eLink, eDur);
		
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
	
	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	
	HkPostCast(oCaster);
}

