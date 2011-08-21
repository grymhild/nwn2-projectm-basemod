//::///////////////////////////////////////////////
//:: Draconic Might
//:: cmi_s0_dracmight
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: June 27, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_dracomight();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Draconic_Might;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

    	
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);	
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
	effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, 4); 
	effect eNatAC = EffectACIncrease(4, AC_NATURAL_BONUS);
	effect eImmuneSleep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect eImmunePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_GREATER_HEROISM);
		
	effect eLink = EffectLinkEffects(eStr, eCon);
	eLink = EffectLinkEffects(eLink, eCha);
	eLink = EffectLinkEffects(eLink, eNatAC);
	eLink = EffectLinkEffects(eLink, eImmuneSleep);	
	eLink = EffectLinkEffects(eLink, eImmunePara);	
	eLink = EffectLinkEffects(eLink, eVis);	
	
	object oTarget = HkGetSpellTarget();
		
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
		
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
	
	CSLConstitutionBugCheck( oTarget );
	
	HkPostCast(oCaster);
}

