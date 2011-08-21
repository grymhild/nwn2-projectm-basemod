#include "setlevel"

void main(int Levels)
{
	object oPC=GetPCSpeaker();
	int PCLevel=GetLevelFromXP(GetXP(oPC), 0, GetSubRace(oPC))+Levels;
	if (PCLevel<1) PCLevel=1;
	
	SetLevel(oPC, PCLevel);
}