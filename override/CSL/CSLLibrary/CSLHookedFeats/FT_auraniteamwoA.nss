//::///////////////////////////////////////////////
//:: Teamwork (Nightsong Infiltrator)
//:: cmi_s2_niteamworka
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
	//scSpellMetaData = SCMeta_FT_auraniteamwo(); //SPELL_SPELLABILITY_AURA_NI_TEAMWORK;
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
	    if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
	    {
			if (!GetHasSpellEffect(SPELL_SPELLABILITY_AURA_NI_TEAMWORK, oTarget))
			{
				int nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR, oCaster);
				
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
				
				float fDuration = HkApplyDurationCategory(12, SC_DURCATEGORY_HOURS) ;
				
				itemproperty iBonusFeat;
				if (nClassLevel > 7)
				{
					iBonusFeat = ItemPropertyBonusFeat(33); // Sneak Attack 2
				}
				else
				{
					iBonusFeat = ItemPropertyBonusFeat(32); // Sneak Attack 1
				}
						
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
				eLink = SetEffectSpellId(eLink, SPELL_SPELLABILITY_AURA_NI_TEAMWORK);
				
				SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELL_SPELLABILITY_AURA_NI_TEAMWORK, FALSE));		

	
			    HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, SPELL_SPELLABILITY_AURA_NI_TEAMWORK );
				if (oTarget != oCaster)
				{
					object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
					if ( !GetIsObjectValid( oArmorNew ) )
					{
						oArmorNew = CreateItemOnObject("x2_it_emptyskin", oTarget, 1, "", FALSE);
						AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oArmorNew,fDuration);
						DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
						AssignCommand( oTarget, ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR) );		
					}
					else
					{
				        CSLSafeAddItemProperty(oArmorNew, iBonusFeat, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
					}
				}						
			}
			
		}
		
	}	
	
}