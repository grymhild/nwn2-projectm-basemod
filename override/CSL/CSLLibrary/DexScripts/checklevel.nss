#include "setlevel"

int StartingConditional(int ETGTLT, int Level)
{
	object oPC=GetPCSpeaker();
	int PCLevel=GetLevelFromXP(GetXP(oPC), 0, GetSubRace(oPC));
	int Match=0;

	switch (ETGTLT)
	{
		case 1:
			if (PCLevel==Level) Match=1;
			break;
		case 2:
			if (PCLevel>Level) Match=1;
			break;
		case 3:
			if (PCLevel<Level) Match=1;
			break;
	}
	return Match;
}