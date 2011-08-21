//::///////////////////////////////////////////////
//:: Lips of Rapture
//:: cmi_s2_lipsrapture
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 27, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_FT_heartwardlip();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_HEARTWARD_LIPS_RAPTURE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
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
	

	
  	object oTarget = HkGetSpellTarget();	

	effect eAB = EffectAttackIncrease(2);
	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2);
	effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS,2);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
	
	effect eLink = EffectLinkEffects(eSave, eSkill);
	eLink = EffectLinkEffects(eLink, eDmg);
	eLink = EffectLinkEffects(eLink, eAB);	
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
			
	float fDuration = RoundsToSeconds( 5 );
	effect eKiss = EffectDazed();	
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, iSpellId );	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKiss, oTarget, 6.0f);
	
	HkPostCast(oCaster);
}