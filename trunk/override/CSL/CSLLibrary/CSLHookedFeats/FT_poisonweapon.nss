//::///////////////////////////////////////////////
//:: Poison Weapon spellscript
//:: x2_s2_poisonwp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Spell allows to add temporary poison properties
	to a melee weapon or stack of arrows

	The exact details of the poison are loaded from
	a 2da defined in _CSLCore_Items X2_IP_POSIONWEAPON_2DA
	taken from the row that matches the last three letters
	of GetTag(GetSpellCastItem())

	Example: if an item is given the poison weapon property
				and its tag ending on 004, the 4th row of the
				2da will be used (1d2IntDmg DC14 18 seconds)

				Rows 0 to 99 are bioware reserved

	Non Assassins have a chance of poisoning themselves
	when handling an item with this spell

	Restrictions
	... only weapons and ammo can be poisoned
	... restricted to piercing / slashing  damage

*/
#include "_HkSpell"
#include "_CSLCore_Items"
#include "X2_inc_switches"


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;

	object oItem   = GetSpellCastItem();
	object oPC     = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	string sTag    = GetTag(oItem);

	if (oTarget==OBJECT_INVALID || GetObjectType(oTarget)!=OBJECT_TYPE_ITEM) {
		FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
		return;
	}
	int nType = GetBaseItemType(oTarget);
	int bAmmo = BASE_ITEM_SHURIKEN || BASE_ITEM_DART || BASE_ITEM_THROWINGAXE;

	if (!CSLItemGetIsMeleeWeapon(oTarget) && !CSLItemGetIsAmmo(oTarget) && !bAmmo) {
		FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
		return;
	}

	if (CSLItemGetIsBludgeoningWeapon(oTarget)) {
		FloatingTextStrRefOnCreature(83367,oPC);         //"Weapon does not do slashing or piercing damage "
		return;
	}

	if (CSLGetItemHasItemOnHitPropertySubType(oTarget, IP_CONST_ONHIT_ITEMPOISON)) {
		FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
		return;
	}

	if (CSLGetItemHasItemOnHitPropertySubType(oTarget, IP_CONST_ONHIT_CASTSPELL_POISON)) {
		FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
		return;
	}

	int iSaveDC;
	int iDuration = 20;
	int nPoisonType;
	int nApplyDC;
	int iLevelBonus = 0;
	int iPoisonLevel;

	int bSpecialPoison = CSLStringStartsWith(sTag, "POISON_");

	// Get the 2da row to lookup the poison from the last three letters of the tag
	if (bSpecialPoison) { // POISON_TYPE_LEVEL = POISON_100
		nPoisonType = StringToInt(GetSubString(sTag, 7, 3));
		//iPoisonLevel = StringToInt(GetSubString(sTag, 10, 2)); // THERE IS NO "LEVEL" FOR POISON, DC IS FROM 2DA
		nApplyDC = StringToInt(Get2DAString("poison", "Handle_DC", nPoisonType));
		iLevelBonus = CSLGetMax(GetLevelByClass(CLASS_TYPE_ASSASSIN), GetLevelByClass(CLASS_TYPE_BLACKGUARD));

	} else { // PRESERVE THE OLD NWN2 POISON SYSTEM
		int nRow = StringToInt(GetStringRight(sTag,3));
		if (!nRow) {
			FloatingTextStrRefOnCreature(83360, oPC);         //"Nothing happens
			return;
		}
		iSaveDC     = StringToInt(Get2DAString(SC_IP_POISONWEAPON_2DA, "SaveDC", nRow));
		nPoisonType = StringToInt(Get2DAString(SC_IP_POISONWEAPON_2DA, "PoisonType", nRow)); // ON HIT DC AND % FROM HERE
		nApplyDC    = 16 + iSaveDC * 2; //= StringToInt(Get2DAString(SC_IP_POISONWEAPON_2DA, "ApplyCheckDC",nRow));
	}
	float fDuration = RoundsToSeconds(iDuration + iLevelBonus * 3);
	int nCheck = d20(1);
	if (!GetHasFeat(FEAT_USE_POISON, oPC)) { // without handle poison feat, do ability check
		if (!GetIsInCombat(oPC)) nCheck = 20;
		else AssignCommand(oPC, ClearAllActions(TRUE)); // * Force attacks of opportunity
	} else {
		nCheck = 20;
	}
	int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	string sMsg = " [d20+DEX Mod+Max(Assn lvl/BkGd lvl) = " + IntToString(nCheck) + "+" + IntToString(nDex) + "+" + IntToString(iLevelBonus) + " = " + IntToString(nCheck+nDex+iLevelBonus) + " vs DC " + IntToString(nApplyDC) + "]";
	if (nCheck+nDex+iLevelBonus < nApplyDC) {
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nApplyDC/2, DAMAGE_TYPE_ACID), oPC);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPoison(nPoisonType), oPC, fDuration);
		SendMessageToPC(oPC, "<color=pink>Your attempt to use poison failed and you poison yourself!\n" + sMsg);
		FloatingTextStringOnCreature("<color=pink>*Use Poison Failure*" + sMsg, oPC);
		return;
	}
	SendMessageToPC(oPC, "<color=limegreen>You successfully apply the poison to the weapon.\n" + sMsg);

	int nPropType;
	int nPropSubType;
	itemproperty ipPoison;
	if (bSpecialPoison) {
		SetLocalString(oTarget, "SPECIALPOISON", GetName(oItem));
		SetLocalInt(oTarget, "SPECIALPOISON_TYPE", nPoisonType);
		DelayCommand(fDuration, DeleteLocalString(oTarget, "SPECIALPOISON"));
		DelayCommand(fDuration, DeleteLocalInt(oTarget, "SPECIALPOISON_TYPE"));
		nPropType = ITEM_PROPERTY_ONHITCASTSPELL;
		nPropSubType = IP_CONST_ONHIT_CASTSPELL_POISON;
		ipPoison = ItemPropertyOnHitCastSpell(nPropSubType, 20);
	} else {
		nPropType = ITEM_PROPERTY_ON_HIT_PROPERTIES;
		nPropSubType = IP_CONST_ONHIT_ITEMPOISON;
		ipPoison = ItemPropertyOnHitProps(nPropSubType, iSaveDC, nPoisonType);
	}
	CSLSafeAddItemProperty(oTarget, ipPoison, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);

	if (CSLGetItemPropertyExists(oTarget, nPropType, nPropSubType)) {
		FloatingTextStringOnCreature("*Success! Weapon covered with " + GetName(oItem) + "*", oPC);
		CSLSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, FALSE);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_NATURE), GetItemPossessor(oTarget));
	} else {
		FloatingTextStrRefOnCreature(83360, oPC);         //"Nothing happens
	}
}