//::///////////////////////////////////////////////
//:: Owl's Insight
//:: x0_S0_OwlIns
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target's widsom bonus becomes equal to half caster's level
	Duration: 1 hr/ caster level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////
//:: July 2002: Modified for Owl's Insight

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_owlsinsight();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_OWLS_INSIGHT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eRaise;
	//effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_OWL_INSIGHT );
	
	int nRaise = CSLGetMax( 1, HkGetSpellPower(OBJECT_SELF) / 2 );
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Set Adjust Ability Score effect
	eRaise = EffectAbilityIncrease(ABILITY_WISDOM, nRaise);
	effect eLink = EffectLinkEffects(eRaise, eDur);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_OWLS_INSIGHT, FALSE));

	//Apply the VFX impact and effects
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_OWLS_INSIGHT );
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}


