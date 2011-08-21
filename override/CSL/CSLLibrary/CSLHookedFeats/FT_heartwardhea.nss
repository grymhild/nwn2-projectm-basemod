//::///////////////////////////////////////////////
//:: Citadel Training
//:: cmi_s2_heartpass
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 26, 2008
//:://////////////////////////////////////////////

//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

/*----  Kaedrin PRC Content ---------*/


void main()
{	
	//scSpellMetaData = SCMeta_FT_heartwardhea();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_HEARTWARD_HEART_PASSION;
	int iClass = CLASS_TYPE_NONE;
	//int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iAttributes = 0;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	//if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	//{
	//	return;
	//}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
		
	
	effect eDiplo = EffectSkillIncrease(SKILL_DIPLOMACY, 2);
	effect eBluff = EffectSkillIncrease(SKILL_BLUFF, 2);
	effect eIntim = EffectSkillIncrease(SKILL_INTIMIDATE, 2);
	effect ePerform = EffectSkillIncrease(SKILL_PERFORM, 2);
	effect eUMD = EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, 2);
			
	effect eLink = EffectLinkEffects(eDiplo, eBluff);
	eLink = EffectLinkEffects(eLink, eIntim);
	eLink = EffectLinkEffects(eLink, ePerform);
	eLink = EffectLinkEffects(eLink, eUMD);	
	
	if (GetLevelByClass(CLASS_HEARTWARDER) == 10)
	{
		effect eLowLight = EffectLowLightVision();
		effect eCharm = EffectImmunity(IMMUNITY_TYPE_CHARM);
		effect eDomin = EffectImmunity(IMMUNITY_TYPE_DOMINATE);
		eLink = EffectLinkEffects(eLink, eLowLight);	
		eLink = EffectLinkEffects(eLink, eCharm);	
		eLink = EffectLinkEffects(eLink, eDomin);					
	}
		
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF, 0.0f, iSpellId));
	
	//HkPostCast(oCaster);
}