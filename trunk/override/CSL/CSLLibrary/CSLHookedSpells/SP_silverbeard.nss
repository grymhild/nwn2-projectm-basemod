//::///////////////////////////////////////////////
//:: Silverbeard
//:: cmi_s0_silverbeard
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: June 25, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
#include "_SCInclude_Class"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_silverbeard();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Silverbeard;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

    	
	effect eAC = EffectACIncrease(2);
	effect eSkill = EffectSkillIncrease(SKILL_DIPLOMACY, 2);
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
		
	effect eLink = EffectLinkEffects(eSkill, eAC);	
	eLink = EffectLinkEffects(eLink,eVis);
		
    //int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
			
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	//Instant effect
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, HkGetSpellId());
	
	HkPostCast(oCaster);
}

