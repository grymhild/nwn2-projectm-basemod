//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the targeted creature one extra partial
	action per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects

#include "_HkSpell"
#include "_SCInclude_Transmutation"

void main()
{
	//scSpellMetaData = SCMeta_FT_epicblinding();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	// CSLRemoveEffectSpellIdGroup( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oTarget, GetSpellId(), SPELL_EXPEDITIOUS_RETREAT, SPELL_HASTE, SPELL_MASS_HASTE );

	//effect eHaste = EffectHaste();
	//effect eVis = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	//effect eLink = EffectLinkEffects(eHaste, eDur);

	//Fire cast spell at event for the specified target
	//SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 647, FALSE));
	//Check for metamagic extension
	SCApplyHasteEffect( oTarget, oCaster, 647, RoundsToSeconds(5), DURATION_TYPE_TEMPORARY );
	// Apply effects to the currently selected target.
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5)); // AFW-OEI 02/02/2007: Duration is now 5 rounds.
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), oTarget);
	
	HkPostCast(oCaster);
}