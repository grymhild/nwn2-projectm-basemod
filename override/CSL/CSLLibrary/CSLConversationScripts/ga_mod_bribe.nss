/*
This is a SP Official campaign script for features in the single player game
*/
//ga_mod_bribe
//modifies a bribe based on diplomacy score
#include "_SCInclude_Overland"

void main(int nBribeDC)
{
	object oPC = GetPCSpeaker();
	int nPCSkill = GetSkillRank(SKILL_DIPLOMACY, oPC);
	
	int nMargin = (nPCSkill - nBribeDC);
	float fModPercent;
	
	
	if (nMargin < 9)
		fModPercent = 95.0f - (IntToFloat(nMargin) * 5.0f);
	
	else
		fModPercent = 50.0f;
	
	ModEncounterBribeValue(fModPercent);
}