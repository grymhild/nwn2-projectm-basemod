//::///////////////////////////////////////////////
//:: Sirine's Grace
//:: cmi_s0_sirinegrce
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: October 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_sirinesgrace();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Sirines_Grace;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eChaBonus = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
	effect eDexaBonus = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
	
	int nChaMod = GetAbilityModifier(ABILITY_CHARISMA) + 2;
	effect eDeflAC = EffectACIncrease(nChaMod,AC_DEFLECTION_BONUS);
	effect ePerform = EffectSkillIncrease(SKILL_PERFORM,8);
		
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eLink = EffectLinkEffects(eChaBonus, eDexaBonus);
	
	eLink = EffectLinkEffects(eLink, eDeflAC);
	eLink = EffectLinkEffects(eLink, ePerform);
	eLink = EffectLinkEffects(eLink, eVis);	
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, HkGetSpellId());
	
	HkPostCast(oCaster);	
}

