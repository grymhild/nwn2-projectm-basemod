#include "elu_functions_i"

void main(int  nStat)
{
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);	
	int nTotalLevels = CSLGetTotalClassLevels(oControlledChar) + 1;
	if (nTotalLevels % 4 != 0)	
	{
		WriteTimestampedLogEntry("gui_elu_statchange was called by " + GetPCPlayerName(OBJECT_SELF) + " at a level not divisible by 4");	
		return;
	}
	if (GetLocalInt(oControlledChar, LVL_STATBUMP) == 0)
		SetLocalInt(oControlledChar, LVL_STATBUMP, nStat);	
}