//::///////////////////////////////////////////////
//:: Chasing Perfection
//:: cmi_s0_chaseperf
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 22, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_chasingperfe();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Chasing_Perfection;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
  	object oTarget = HkGetSpellTarget();
	  	
	effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA,4);
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,4);	
	effect eWis = EffectAbilityIncrease(ABILITY_WISDOM,4);
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
	effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,4);
				
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
 		
	effect eLink = EffectLinkEffects(eCha, eStr);
	eLink = EffectLinkEffects(eLink, eDex);
	eLink = EffectLinkEffects(eLink, eWis);
	eLink = EffectLinkEffects(eLink, eInt);		
	eLink = EffectLinkEffects(eLink, eVis);	
		
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
		
    CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, iSpellId, SPELL_BEARS_ENDURANCE, SPELL_MASS_BEAR_ENDURANCE );	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );
	
	
	CSLConstitutionBugCheck( oTarget );

	

    if (GetHasSpellEffect(SPELL_GREATER_BEARS_ENDURANCE, oTarget))
    {
		SendMessageToPC(oTarget, "You already have a stronger spell boosting your Constitution active. The Con boost from this spell was not applied.");	
    }	
	else
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCon, oTarget, fDuration, iSpellId);	
	}
	
	
	
	HkPostCast(oCaster);	
}

