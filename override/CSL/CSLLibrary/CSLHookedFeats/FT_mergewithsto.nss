//::///////////////////////////////////////////////
//:: Merge with Stone
//:: nx_s2_mergestone
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	This spell is based on the Stoneskin spell
	(nw_s0_stoneskn).

	Gives the creature touched 5/Adamantine
	damage reduction.  This lasts for five rounds
	or until twenty points of damage are absorbed.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_FT_mergewithsto();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	object oTarget  = HkGetSpellTarget();
	int nAmount     = 20; // Absorbs 20 points of damage before expiring
	
	float fDuration = RoundsToSeconds(5); // Lasts for 5 rounds
	fDuration       = HkApplyMetamagicDurationMods(fDuration);
	int iDurType    = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Define the damage reduction effect
	effect eStone = EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, nAmount, DR_TYPE_GMATERIAL);
	effect eVis1  = EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );
	eStone        = EffectLinkEffects( eStone, eVis1 );

	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MERGE_WITH_STONE, FALSE));
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELLABILITY_MERGE_WITH_STONE);
	HkApplyEffectToObject(iDurType, eStone, oTarget, fDuration);
	
	HkPostCast(oCaster);
}