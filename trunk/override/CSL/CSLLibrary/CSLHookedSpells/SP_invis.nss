//::///////////////////////////////////////////////
//:: Invisibility
//:: NW_S0_Invisib.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target creature becomes invisibility
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// JLR - OEI 08/24/05 -- Metamagic changes
// PKM-OEI 08.09.06 -- VFX update
//:: AFW-OEI 08/03/2007: Account for Assassins.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Invisibility"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_INVISIBILITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_ILLUSION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_GLAMER;
	if ( GetSpellId() == SPELL_ASN_Invisibility || GetSpellId() == SPELL_ASN_Spellbook_3 || GetSpellId() == SPELLABILITY_AS_INVISIBILITY )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	else if ( GetSpellId() == SPELLABILITY_INVISIBILITY )
	{
		iClass = CLASS_TYPE_RACIAL;
	}
	else if ( GetSpellId() == SPELL_SHADOW_CONJURATION_INIVSIBILITY )
	{
		iSpellSchool=SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool=SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	
	/*
	effect eVis = EffectVisualEffect( VFX_DUR_INVISIBILITY );
	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); //NWN1 VFX

	//effect eLink = EffectLinkEffects(eInvis, eDur);
	//eLink = EffectLinkEffects(eLink, eVis);
	effect eLink = EffectLinkEffects( eInvis, eVis );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));
*/
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster, 60, iClass ) ));
	
	//float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES);

	//Enter Metamagic conditions
	//fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods( DURATION_TYPE_TEMPORARY );

	// Apply the VFX impact and effects
	// HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	SCApplyInvisibility( oTarget, oCaster, fDuration, SPELL_INVISIBILITY, 0 );
	
	HkPostCast(oCaster);
}