//::///////////////////////////////////////////////
//:: Entropic Shield
//:: x0_s0_entrshield.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	20% concealment to ranged attacks including
	ranged spell attacks

	Duration: 1 turn/level

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 18, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:


// JLR - OEI 08/24/05 -- Metamagic changes



/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_entropicshie();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENTROPIC_SHIELD;
	int iClass = CLASS_TYPE_NONE;
	if ( iSpellId == SPELLABILITY_ENTROPIC_SHIELD )
	{
		iClass = CLASS_TYPE_RACIAL;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	object oTarget = HkGetSpellTarget();
	
	// AFW-OEI 08/07/2007: If you're casting it as a Svirfneblin racial, use HD.
	int iDuration = HkGetSpellDuration(oCaster, 60, iClass); // OldGetCasterLevel(OBJECT_SELF);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));


	//Set the four unique armor bonuses
	effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_ENTROPIC_SHIELD);
	effect eLink = EffectLinkEffects(eShield, eDur);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId);

	//Apply the armor bonuses and the VFX impact
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, iSpellId);
	
	HkPostCast(oCaster);
}

