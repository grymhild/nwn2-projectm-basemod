//::///////////////////////////////////////////////
//:: Invisibilty Purge: On Enter
//:: NW_S0_InvPurgeA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All invisible creatures in the AOE become
	visible.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

/*
int RemoveInvisSpellEffect(object oTarget, int iSpellId) {
	if (GetHasSpellEffect(SPELL_GREATER_INVISIBILITY, oTarget)) {
		RemoveAnySpellEffects(SPELL_GREATER_INVISIBILITY, oTarget);
		return TRUE;
	}
	return FALSE;
}
*/

void main()
{
	//scSpellMetaData = SCMeta_SP_invispurge(); //SPELL_INVISIBILITY_PURGE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_INVISIBILITY_PURGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();

	int bRemovedEffect = FALSE;
	
	// removes up to 9 effects
	bRemovedEffect = CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_GREATER_INVISIBILITY, SPELL_INVISIBILITY, SPELLABILITY_AS_GREATER_INVISIBLITY, SPELLABILITY_AS_INVISIBILITY, SPELL_DISAPPEAR );
	
	if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) )
	{
		bRemovedEffect = CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster,  SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY  );
	}
	
	//bRemovedEffect = CSLRemoveEffectTypeSingle(SC_REMOVE_ALLCREATORS,  oCaster, oTarget, EFFECT_TYPE_GREATERINVISIBILITY );
	//bRemovedEffect = CSLRemoveEffectTypeSingle(SC_REMOVE_ALLCREATORS,  oCaster, oTarget, EFFECT_TYPE_INVISIBILITY );

	if (bRemovedEffect) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INVISIBILITY_PURGE, CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_SPELL_INVISIBILITY_PURGE), oTarget);
	}
	if (DEBUGGING >= 6) { CSLDebug("Entering Purge firing", oTarget ); }
	// now apply a dummy effect soas to keep track of folks in purged area
	effect eLink = EffectSkillIncrease(SKILL_SPOT, 0);
	eLink = SetEffectSpellId(eLink, SPELL_INVISIBILITY_PURGE);
	HkApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget);
	
}