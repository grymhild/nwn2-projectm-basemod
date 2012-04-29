//::///////////////////////////////////////////////
//:: Melee Weapon Mastery (Blunt)
//:: EQ_mwpnmast_b
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Aug 16, 2009
//:://////////////////////////////////////////////

#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"

void main()
{
		object oPC = OBJECT_SELF;
		int nSpellId = SPELLABILITY_MELEE_WEAPON_MASTERY_B;
		int nMWM_BValid = IsMWM_BValid();
		int bHasMWM_B = GetHasSpellEffect(nSpellId,oPC);
		
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_MELEE_WEAPON_MASTERY_P, SPELLABILITY_MELEE_WEAPON_MASTERY_S, SPELLABILITY_MELEE_WEAPON_MASTERY_B );
		
		if (nMWM_BValid)
		{
			effect eAB = EffectAttackIncrease(2);
			effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING);
			effect eLink = EffectLinkEffects(eAB, eDmg);
			eLink = SetEffectSpellId(eLink,nSpellId);
			eLink = SupernaturalEffect(eLink);
			if (!bHasMWM_B)
			{
				SendMessageToPC(oPC,"Melee weapon mastery bonus enabled.");			
			}
			DelayCommand(0.1f, HkSafeApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48),nSpellId));												
										
			
		}
		else
		{
			if (!bHasMWM_B)
			{
	    		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, nSpellId );
				SendMessageToPC(oPC,"Melee weapon mastery bonus disabled, you must wield the correct weapon type in your main hand.");			
			}
		}		
}