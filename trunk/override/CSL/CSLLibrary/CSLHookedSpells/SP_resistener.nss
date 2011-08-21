//::///////////////////////////////////////////////
//:: Resist Energy
//:: NW_S0_ResEnergy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Offers 20 points of elemental resistance.  If 30
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
	//scSpellMetaData = SCMeta_SP_resistener();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RESIST_ENERGY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE|SCMETA_DESCRIPTOR_COLD|SCMETA_DESCRIPTOR_ACID|SCMETA_DESCRIPTOR_SONIC|SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	int nAmount = 30;
	int nResistance = 20;
	
	effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
	effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
	effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
	effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
	effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RESIST_ENERGY );
	//effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
	//effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESIST_ENERGY, FALSE)); // JLR - OEI 07/11/05 -- Name Changed
	
	//Link Effects
	effect eLink = EffectLinkEffects(eCold, eFire);
	eLink = EffectLinkEffects(eLink, eAcid);
	eLink = EffectLinkEffects(eLink, eSonic);
	eLink = EffectLinkEffects(eLink, eElec);
	eLink = EffectLinkEffects(eLink, eDur);
		
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}

