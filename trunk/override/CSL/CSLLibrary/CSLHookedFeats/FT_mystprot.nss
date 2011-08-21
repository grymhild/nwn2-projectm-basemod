//::///////////////////////////////////////////////
//:: Mystic Protection
//:: cmi_s2_mystprot
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 25, 2007
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x0_i0_spells"
//#include "x2_inc_spellhook"

void main()
{	
	//scSpellMetaData = SCMeta_FT_mystprot();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
    int iCasterLevel = GetLevelByClass(CLASS_TYPE_CLERIC,OBJECT_SELF);
	float fDuration = RoundsToSeconds( iCasterLevel );
	
	int nChaMod = GetAbilityModifier(ABILITY_CHARISMA);
	effect eSaveBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,nChaMod,SAVING_THROW_ALL);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eLink = EffectLinkEffects(eVis,eSaveBonus);
	
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , OBJECT_SELF, fDuration);
	
	HkPostCast(oCaster);
}