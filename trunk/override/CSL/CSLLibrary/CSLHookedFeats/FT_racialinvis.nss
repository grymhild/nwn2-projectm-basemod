//::///////////////////////////////////////////////
//:: Invisibility (Svirfneblin Racial Ability)
//:: NW_S2_Invisib.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target creature becomes invisibility
*/

// JLR-OEI 03/21/06: For GDD Update

	
	
// JLR - OEI 08/24/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{

	//scSpellMetaData = SCMeta_FT_racialinvis();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	
	effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	effect eLink = EffectLinkEffects(eInvis, eDur);
	eLink = EffectLinkEffects(eLink, eVis);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));

	int iCasterLevel = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); //GetTotalLevels(OBJECT_SELF, TRUE); //HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);

	float fDuration = TurnsToSeconds(iCasterLevel);

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}