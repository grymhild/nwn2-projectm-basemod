//::///////////////////////////////////////////////
//:: Teamwork (Nightsong Enforcer)
//:: cmi_s2_neteamworka
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "cmi_includes"

//#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_FT_auraneteamwo(); //SPELL_SPELLABILITY_AURA_NE_TEAMWORK;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
		
	if (oTarget != oCaster)
	{
	    if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) || (oTarget == oCaster))
	    {
			if (!GetHasSpellEffect(SPELL_SPELLABILITY_AURA_NE_TEAMWORK, OBJECT_SELF))
			{
				int nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_ENFORCER, oCaster);
			
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
				//eLink = SetEffectSpellId (eLink, SPELL_SPELLABILITY_AURA_NE_TEAMWORK);
			
				SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELL_SPELLABILITY_AURA_NE_TEAMWORK, FALSE));	
			    HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, SPELL_SPELLABILITY_AURA_NE_TEAMWORK);			
			}
		}	
	}	
		
}