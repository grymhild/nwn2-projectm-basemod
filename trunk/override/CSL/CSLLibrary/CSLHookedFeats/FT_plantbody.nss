//::///////////////////////////////////////////////
//:: Plant Body
//:: cmi_s0_plantbody
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 8, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_FT_plantbody();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) * 10 );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	effect eMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect ePsn = EffectImmunity(IMMUNITY_TYPE_POISON);
	effect ePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eSleep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
		
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	
	effect eLink = EffectLinkEffects(eVis, eCrit);
	eLink = EffectLinkEffects(eLink, eMind);
	eLink = EffectLinkEffects(eLink, ePsn);
	eLink = EffectLinkEffects(eLink, ePara);
	eLink = EffectLinkEffects(eLink, eSneak);
	eLink = EffectLinkEffects(eLink, eSleep);
	eLink = EffectLinkEffects(eLink, eStun);					
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
	
	HkPostCast(oCaster);	
}