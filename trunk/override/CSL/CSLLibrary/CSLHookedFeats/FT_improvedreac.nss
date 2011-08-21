//::///////////////////////////////////////////////////////////////////////////
//::
//:: nw_s2_impreact.nss
//::
//:: Gives the targeted creature one extra partial
//:: action per round.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//:: Created by: Brian Fox
//:: Created on: 7/9/06
//::
//::///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Transmutation"



////#include "_inc_helper_functions"
//#include "_SCUtility"
//#include "ginc_henchman"

void main()
{
	//scSpellMetaData = SCMeta_FT_improvedreac();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	
/*
	if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF) == TRUE)
	{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, OBJECT_SELF, SPELL_EXPEDITIOUS_RETREAT );
			//SCRemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, OBJECT_SELF);
	}

	if (GetHasSpellEffect(SPELL_HASTE, OBJECT_SELF) == TRUE)
	{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, OBJECT_SELF, SPELL_HASTE );
			//SCRemoveSpellEffects(SPELL_HASTE, OBJECT_SELF, OBJECT_SELF);
	}

	if (GetHasSpellEffect(SPELL_MASS_HASTE, OBJECT_SELF) == TRUE)
	{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, OBJECT_SELF, SPELL_MASS_HASTE );
			//SCRemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, OBJECT_SELF);
	}
*/
	int iCasterLevel = GetLevelByClass( CLASS_TYPE_DUELIST );
	float fDuration = RoundsToSeconds(iCasterLevel);

	//Fire cast spell at event for the specified target
	//SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_IMPROVED_REACTION, FALSE));
	
	// Create the Effects
	//effect eHaste = EffectHaste();
	//effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
	//effect eLink = EffectLinkEffects(eHaste, eDur);

	// Apply effects to the currently selected target.
	//HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration );
	SCApplyHasteEffect( oCaster, oCaster, SPELLABILITY_IMPROVED_REACTION, fDuration, DURATION_TYPE_TEMPORARY );
	
	HkPostCast(oCaster);
}