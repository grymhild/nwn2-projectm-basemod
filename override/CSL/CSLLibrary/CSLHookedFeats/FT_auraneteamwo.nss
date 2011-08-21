//::///////////////////////////////////////////////
//:: Teamwork (Nightsong Enforcer)
//:: cmi_s2_neteamwork
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_auraneteamwo();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
	if (!GetHasSpellEffect(SPELL_SPELLABILITY_AURA_NE_TEAMWORK, OBJECT_SELF))
	{
		effect eAOE = EffectAreaOfEffect(VFX_PER_NE_TEAMWORK, "", "", "", sAOETag);
		//Create an instance of the AOE Object using the Apply Effect function
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPELLABILITY_AURA_NE_TEAMWORK, FALSE));
	    HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget);
		
				int nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_ENFORCER, oTarget);
			
				int nSkillBonus = 2;
				if (nClassLevel > 6)
				{
					nSkillBonus = 4;
				}
						
				effect eSkillBonusListen = EffectSkillIncrease(SKILL_LISTEN,nSkillBonus);
				effect eSkillBonusHide = EffectSkillIncrease(SKILL_HIDE,nSkillBonus);
				effect eSkillBonusMoveSilent = EffectSkillIncrease(SKILL_MOVE_SILENTLY,nSkillBonus);
				effect eSkillBonusSpot = EffectSkillIncrease(SKILL_SPOT,nSkillBonus);
				
				effect eLink = EffectLinkEffects(eSkillBonusListen, eSkillBonusHide);
				eLink = EffectLinkEffects(eLink, eSkillBonusMoveSilent);
				eLink = EffectLinkEffects(eLink, eSkillBonusSpot);			
				eLink = SupernaturalEffect(eLink);
				eLink = SetEffectSpellId (eLink, -SPELL_SPELLABILITY_AURA_NE_TEAMWORK);
			
			    HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, -SPELL_SPELLABILITY_AURA_NE_TEAMWORK );	
						
	}
	HkPostCast(oCaster);		
}