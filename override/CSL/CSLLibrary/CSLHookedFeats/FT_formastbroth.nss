//::///////////////////////////////////////////////
//:: Sanctuary
//:: NW_S0_Sanctuary.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the target creature invisible to hostile
    creatures unless they make a Will Save to ignore
    the Sanctuary Effect
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook" 

//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_formastbroth();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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
	//effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_SANCTUARY);
	int iDC = GetAbilityModifier(ABILITY_WISDOM) + 19;
    effect eSanc = EffectSanctuary(iDC);
    
    effect eLink = EffectLinkEffects(eDur, eSanc);
    //eLink = EffectLinkEffects(eLink, eDur);

    int iDuration = HkGetSpellDuration(OBJECT_SELF);
    //Enter Metamagic conditions
    	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SANCTUARY, FALSE));
    //Apply the VFX impact and effects
    HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
    
    HkPostCast(oCaster);
}