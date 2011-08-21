//::///////////////////////////////////////////////
//:: Sonic Might
//:: SOZ UPDATE BTM
//:: cmi_s2_sncmight
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 23, 2008
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = FEAT_LYRIC_THAUM_SONIC_MIGHT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
		
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
		
	float fDuration = RoundsToSeconds( GetLevelByClass(CLASS_LYRIC_THAUMATURGE, oCaster) ); // Seconds
	
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
	effect eVis =  EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	eVis = SetEffectSpellId(eVis,iSpellId);
	DelayCommand(0.1f, HkApplyEffectToObject(iDurType, eVis, oCaster, fDuration));	
	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
	HkPostCast(oCaster);
}      

