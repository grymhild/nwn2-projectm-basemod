//::///////////////////////////////////////////////
//:: Veil of Darkness
//:: cmi_s0_veildarkness
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: November 27, 2010
//:://////////////////////////////////////////////
//#include "NW_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	if (iSpellId == SPELL_BG_Darkness)
	{
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	else if (iSpellId == SPELL_ASN_Spellbook_2 || iSpellId == SPELL_ASN_Darkness)
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nDuration = HkGetSpellDuration(oCaster);
	object oTarget = HkGetSpellTarget();
	
	effect eConceal = EffectConcealment(20);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	
	effect eLink = EffectLinkEffects(eVis, eConceal);
	
	float fDuration = TurnsToSeconds( nDuration );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

}