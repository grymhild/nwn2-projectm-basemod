#include "elu_functions_i"
#include "hcr2_core_i"

const string FAMILIAR_OVERRIDE = "FAMILIAR_OVERRIDE";
const string FAMILIAR_LAST_SELECTED = "FAMILIAR_LAST_SELECTED";

void HandleUnsummon(object oSummoned)
{
	string sResRef = GetResRef(oSummoned);
	//Handle special cases for custom familiars and such.
	object oMaster = GetMaster(oSummoned);
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oMaster);
	if (GetSubString(sResRef, 0, 11) == "c_fam_raven")
	{
		h2_RemoveEffectsWithSpellId(oMaster, 6483);
		DeleteLocalInt(GetMaster(oSummoned), "FT_FAM_IMPAPPRAISE");
	}
	else if (GetSubString(sResRef, 0, 11) == "c_fam_viper")
	{
		h2_RemoveEffectsWithSpellId(oMaster, 6483);
		DeleteLocalInt(GetMaster(oSummoned), "FT_FAM_IMPINTIMIDATE");
	}
}

int GetFamiliarLevel(object oChar)
{
	int nFamLevelWiz = GetLevelByClass(CLASS_TYPE_WIZARD, oChar);
	int nFamLevelSor = GetLevelByClass(CLASS_TYPE_SORCERER, oChar);
	int nFamLevel = nFamLevelWiz + nFamLevelSor;

	int i = 2;
	for(i = 2; i <= 4; i++)
	{
		int nClass = GetClassByPosition(i,oChar);
		string sFeatMap = Get2DAString("classes", "BonusCasterFeatByClassMap", nClass);
		if (sFeatMap != "")
		{
			int nFeatIDWiz = StringToInt(Get2DAString(sFeatMap, "SpellCasterFeat", CLASS_TYPE_WIZARD));
			int nFeatIDSor = StringToInt(Get2DAString(sFeatMap, "SpellCasterFeat", CLASS_TYPE_SORCERER));
			if (GetHasFeat(nFeatIDWiz, oChar, TRUE) && nFamLevelWiz > 0)
				nFamLevel += GetLevelByClass(nClass, oChar);
			if (GetHasFeat(nFeatIDSor, oChar, TRUE) && nFamLevelSor > 0)
				nFamLevel += GetLevelByClass(nClass, oChar);
		}
	}
	return nFamLevel;
}

int GetFamiliarRange(object oChar)
{
	int nLevel = GetFamiliarLevel(oChar);
	nLevel = (nLevel / 2);
	return nLevel;
}

int GetElemFamRange(object oChar)
{
	int nLevel = GetFamiliarLevel(oChar);
	int nRange = 1;
	if (nLevel > 27)
		nRange = 6;
	else
	if (nLevel > 21)
		nRange = 5;
	else
	if (nLevel > 15)
		nRange = 4;
	else
	if (nLevel > 9)
		nRange = 3;
	else
	if (nLevel > 3)
		nRange = 2;
	return nRange;
}

void SetFamiliarOverride(object oChar, string sOverride)
{
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);
	if (!GetIsObjectValid(oSkin))
	{
		h2_LogMessage(H2_LOG_ERROR, "A player skin is required for SetFamiliarOverride, and it was not detected.");
		return;
	}
	SetLocalString(oSkin, FAMILIAR_OVERRIDE, sOverride);
}

string GetFamiliarOverrideResRef(object oChar)
{
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oChar);
	if (!GetIsObjectValid(oSkin))
	{
		h2_LogMessage(H2_LOG_ERROR, "A player skin is required for GetFamiliarOverrideResRef, and it was not detected.");
		return "";
	}
	string sOverride = GetLocalString(oSkin, FAMILIAR_OVERRIDE);
	if (sOverride == "")
		return "";

	if (FindSubString(sOverride, "csl_ancom_ele") > -1)
		sOverride += IntToString(GetElemFamRange(oChar));
	else
		sOverride += IntToString(GetFamiliarRange(oChar));

	return sOverride;
}



