//::///////////////////////////////////////////////
//:: Fist of the Forest - Unarmed Damage Increase
//:: cmi_s2_fotfunarmed
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
	int nSpellId = SPELLABILITY_FOTF_UNARMED_BONUS;

	int bHasFOTFUnarmed = GetHasSpellEffect(nSpellId,oPC);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, nSpellId );
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	if (oWeapon == OBJECT_INVALID)
	{
		if (bHasFOTFUnarmed)
			RefreshSpellEffectDurations(OBJECT_SELF,nSpellId, HoursToSeconds(48));
		else
		{
			effect eLink = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BLUDGEONING);
			eLink = SetEffectSpellId(eLink,nSpellId);
			eLink = SupernaturalEffect(eLink);
			if (!bHasFOTFUnarmed)
			{
				SendMessageToPC(oPC,"Fist of the Forest Unarmed Damage Increase is now active.");
			}
			DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(48), nSpellId, oPC));
		}
	}
	else
	{
		if (bHasFOTFUnarmed)
		{
				SendMessageToPC(oPC,"Fist of the Forest Unarmed Damage Increase is for unarmed strikes only.");
		}
	}
}