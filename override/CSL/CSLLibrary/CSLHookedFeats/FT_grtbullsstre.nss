//::///////////////////////////////////////////////
//:: Greater Bull's Strength
//:: NW_S0_GrBullStr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Raises targets Str by 8
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:: Updated 2003-07-17 to fix stacking issue with blackguard
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/07/05 NWN2 3.5)

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_grtbullsstre();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
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
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eRaise;
	effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	int nRaise = 8;
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_BULLS_STRENGTH, FALSE));

	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Apply effects and VFX to target
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_BULLS_STRENGTH, SPELLABILITY_BG_BULLS_STRENGTH, SPELL_GREATER_BULLS_STRENGTH );

	//Set Adjust Ability Score effect
	eRaise = EffectAbilityIncrease(ABILITY_STRENGTH, nRaise);
	effect eLink = EffectLinkEffects(eRaise, eDur);

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}