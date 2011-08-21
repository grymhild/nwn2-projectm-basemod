/*
This is a SP Official campaign script for features in the single player game
*/
// ga_levelup_pc
//
// Automatic levelup script for the PC(s).
//
// JSH-OEI 6/25/07

#include "_CSLCore_Player"
#include "_CSLCore_Messages"

int GetRaceECL(object oTarget)
{
	int iSubRace = GetSubRace(oTarget);
	int iRet = StringToInt(Get2DAString("RacialSubTypes", "ECL", iSubRace));
	// PrettyDebug ("This character has an ECL of " + IntToString(iRet));
	return (iRet);
}

int GetTotalLevel(object oTarget)						
{
	int iRet = GetRaceECL(oTarget) + GetHitDice(oTarget);
	return (iRet);
}

void main(int iMinStartLevel)
{
	object oPC			= GetFirstFactionMember(GetFirstPC(), FALSE);
	while(GetIsObjectValid(oPC))
	{
		int nPlayerLevel	= GetTotalLevel(oPC);
		int nPackage		= GetLevelUpPackage(oPC); 
		int bNeedToLevel	= FALSE;
	
		//PrettyDebug("Auto-leveling up!");
		//ResetCreatureLevelForXP(oPC, nExperience, FALSE);
	
		bNeedToLevel = GetTotalLevel(oPC) < iMinStartLevel;
	
		while (nPlayerLevel < iMinStartLevel)
		{
			LevelUpHenchman(oPC, CLASS_TYPE_INVALID, TRUE, nPackage);
			nPlayerLevel = GetTotalLevel(oPC);
		}
		
		oPC = GetNextFactionMember(GetFirstPC(), FALSE);
	}
}