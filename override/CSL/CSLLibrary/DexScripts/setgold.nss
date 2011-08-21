#include "goldinclude"

void main(int GoldAmount)
{
	object oPC=GetPCSpeaker();
	effect eGold;
	int GoldDifference=GoldAmount-GetGold(oPC);

	GiveGold(oPC, GoldDifference);
}