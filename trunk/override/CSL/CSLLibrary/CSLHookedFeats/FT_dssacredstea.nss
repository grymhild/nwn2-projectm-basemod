//::///////////////////////////////////////////////
//:: Sacred Stealth
//:: cmi_s2_sacredstlth
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_FT_dssacredstea();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
	int nSkillDur = GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
	if (nSkillDur <= 0)
		nSkillDur = 1;
		
	effect eHide = EffectSkillIncrease(SKILL_HIDE,10);
	effect eMoveSilent = EffectSkillIncrease(SKILL_MOVE_SILENTLY,10);
	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);

		
	effect eLink = EffectLinkEffects(eHide, eMoveSilent);
	eLink = EffectLinkEffects(eLink, eVis);	
	
	float fDuration = TurnsToSeconds( nSkillDur );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
	
	HkPostCast(oCaster);	
}