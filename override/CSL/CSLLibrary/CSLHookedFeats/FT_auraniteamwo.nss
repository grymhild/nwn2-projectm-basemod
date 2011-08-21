//::///////////////////////////////////////////////
//:: Teamwork (Nightsong Infiltrator)
//:: cmi_s2_niteamwork
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_auraniteamwo();
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
	
	if (!GetHasSpellEffect(SPELL_SPELLABILITY_AURA_NI_TEAMWORK, OBJECT_SELF))
	{
		effect eAOE = EffectAreaOfEffect(84, "", "", "", sAOETag);
	
		//Create an instance of the AOE Object using the Apply Effect function
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPELLABILITY_AURA_NI_TEAMWORK, FALSE));
	    HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget);
		
				int nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR, OBJECT_SELF);
				
				int nReflexBonus = 1;
				int nSkillBonus = 2;
				int nSneak = 1;
				
				switch (nClassLevel)
				{
					case 1:
					{
						nReflexBonus = 1;
						break;
					}
					case 2:
					{
						nReflexBonus = 1;
						break;
					}
					case 3:
					{
						nReflexBonus = 1;
						break;
					}
					case 4:
					{
						nReflexBonus = 2;
						break;
					}
					case 5:
					{
						nReflexBonus = 2;
						break;
					}
					case 6:
					{
						nReflexBonus = 2;
						break;
					}
					case 7:
					{
						nReflexBonus = 3;
						break;
					}
					case 8:
					{
						nReflexBonus = 3;
						nSkillBonus = 4;
						nSneak = 2;
						break;
					}
					case 9:
					{
						nReflexBonus = 3;
						nSkillBonus = 4;
						nSneak = 2;
						break;
					}														
					case 10:
					{
						nReflexBonus = 4;
						nSkillBonus = 4;
						nSneak = 2;
						break;
					}	
				}
				
				//float fDuration = HkApplyDurationCategory(12, SC_DURCATEGORY_HOURS);
				
				itemproperty iBonusFeat;
				if (nClassLevel > 7)
					iBonusFeat = ItemPropertyBonusFeat(33); // Sneak Attack 2
				else	
					iBonusFeat = ItemPropertyBonusFeat(32); // Sneak Attack 1
						
				effect eSkillBonusDisable = EffectSkillIncrease(SKILL_DISABLE_TRAP,nSkillBonus);
				effect eSkillBonusHide = EffectSkillIncrease(SKILL_HIDE,nSkillBonus);
				effect eSkillBonusMoveSilent = EffectSkillIncrease(SKILL_MOVE_SILENTLY,nSkillBonus);
				effect eSkillBonusOpenLock = EffectSkillIncrease(SKILL_OPEN_LOCK,nSkillBonus);
				effect eSkillBonusSearch = EffectSkillIncrease(SKILL_SEARCH,nSkillBonus);
				effect eSkillBonusTumble = EffectSkillIncrease(SKILL_TUMBLE,nSkillBonus);
				effect eReflexBonus = EffectSavingThrowIncrease(SAVING_THROW_REFLEX,nReflexBonus,SAVING_THROW_TYPE_TRAP);
				
				effect eLink = EffectLinkEffects(eSkillBonusDisable, eSkillBonusHide);
				eLink = EffectLinkEffects(eLink, eSkillBonusMoveSilent);
				eLink = EffectLinkEffects(eLink, eSkillBonusOpenLock);
				eLink = EffectLinkEffects(eLink, eSkillBonusSearch);
				eLink = EffectLinkEffects(eLink, eSkillBonusTumble);
				eLink = EffectLinkEffects(eLink, eReflexBonus);				
				eLink = SupernaturalEffect(eLink);
				eLink = SetEffectSpellId (eLink, -SPELL_SPELLABILITY_AURA_NI_TEAMWORK);

			    HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, -SPELL_SPELLABILITY_AURA_NI_TEAMWORK);
		
	}
	
	HkPostCast(oCaster);
}