//::///////////////////////////////////////////////
//:: Heavy Armor Optimization
//:: cmi_s2_harmropt
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Aug 16, 2009
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_chars"
//#include "cmi_ginc_spells"


#include "_HkSpell"

void main()
{	
	
	object oPC = OBJECT_SELF;
	int nSpellId = SPELLABILITY_HEAVY_ARMOR_OPTIMIZATION;
	int bHasHArmorOpt = GetHasSpellEffect(nSpellId,oPC);
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_GREATER_HEAVY_ARMOR_OPTIMIZATION, SPELLABILITY_HEAVY_ARMOR_OPTIMIZATION  );
	
	//int bHasHArmorOpt = GetHasSpellEffect(nSpellId,oPC);
	int bValid = 0;
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
	if (oArmor != OBJECT_INVALID && GetArmorRank(oArmor) == ARMOR_RANK_HEAVY )
	{
		effect eSkillBoostHide = EffectSkillIncrease(SKILL_HIDE,1);
		effect eSkillBoostMoveSilent = EffectSkillIncrease(SKILL_MOVE_SILENTLY,1);
		effect eSkillBoostTumble = EffectSkillIncrease(SKILL_TUMBLE,1);
			effect eSkillBoostSoH = EffectSkillIncrease(SKILL_SLEIGHT_OF_HAND,1);	

			effect eSkillBoostOL = EffectSkillIncrease(SKILL_OPEN_LOCK,1);

			effect eSkillBoostParry = EffectSkillIncrease(SKILL_PARRY,1);

			effect eSkillBoostST = EffectSkillIncrease(SKILL_SET_TRAP,1);		
			
		effect eAC = EffectACIncrease(1);
		effect eLink = EffectLinkEffects(eSkillBoostHide,eSkillBoostMoveSilent);
		eLink = EffectLinkEffects(eLink, eSkillBoostTumble);
		eLink = EffectLinkEffects(eLink, eSkillBoostST);	

			eLink = EffectLinkEffects(eLink, eSkillBoostSoH);

			eLink = EffectLinkEffects(eLink, eSkillBoostOL);

			eLink = EffectLinkEffects(eLink, eSkillBoostParry);

		
		eLink = EffectLinkEffects(eLink, eAC);
		eLink = SetEffectSpellId(eLink,nSpellId);
		eLink = SupernaturalEffect(eLink);
		if (!bHasHArmorOpt)
		{
			SendMessageToPC(oPC,"Heavy Armor Optimization bonus enabled.");
		}
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(48), nSpellId, oPC ));
	}
	else if ( GetHasSpellEffect(nSpellId,oPC) )
	{
		SendMessageToPC(oPC,"Heavy Armor Optimization requires heavy armor.");
	}

}