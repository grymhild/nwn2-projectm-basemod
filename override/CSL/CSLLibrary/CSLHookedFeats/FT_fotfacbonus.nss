//::///////////////////////////////////////////////
//:: Fist of the Forest - AC Bonus
//:: cmi_s2_fotfacbonus
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
	int nSpellId = SPELLABILITY_FOTF_AC_BONUS;

	int bHasFOTFacbonus = GetHasSpellEffect(nSpellId,oPC);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, nSpellId );
	
	if (CSLGetHasEffectType( oPC, EFFECT_TYPE_POLYMORPH))
	{
		SendMessageToPC(oPC,"Fist of the Forest AC Bonus may not be used while under the effects of any kind of polymorph ability.");
		return;						
	}
	
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
	if ((oArmor != OBJECT_INVALID && GetArmorRank(oArmor) == ARMOR_RANK_NONE) || oArmor == OBJECT_INVALID)
	{
		if (bHasFOTFacbonus)
		{
			RefreshSpellEffectDurations(oPC,nSpellId, HoursToSeconds(48));
		}
		else
		{
			
			int iAbilityScore = CSLGetNaturalAbilityScore( oPC, ABILITY_CONSTITUTION );
			//int nSubrace = GetSubRace(OBJECT_SELF);
			//int	nBonus = CSLGetRaceDataConAdjust( nSubrace );

			//nBonus += GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, TRUE);
			int nBonus = (iAbilityScore - 10) / 2;

			if (nBonus > 0)
			{

				effect eLink = EffectACIncrease(nBonus);
				eLink = SetEffectSpellId(eLink,nSpellId);
				eLink = SupernaturalEffect(eLink);
				if (!bHasFOTFacbonus)
				{
					SendMessageToPC(oPC,"Fist of the Forest AC Bonus is now active.");
				}
				DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48), nSpellId, oPC));

			}
		}
	}
	else
	{
		if (bHasFOTFacbonus)
		{
				
			SendMessageToPC(oPC,"Fist of the Forest AC Bonus requires light or no armor.");
		}
	}
}