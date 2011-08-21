// gc_align_good.nss
/*
   Check if player's alignment is Good
*/
// BMA-OEI 7/25/05
// ChazM 4/9/07 - updated

//#include "ginc_alignment"
#include "_CSLCore_Reputation"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	return (CSLGetIsGood(oPC));
/*	
	int nAlignment = GetGoodEvilValue(oPC); // 100(good) - 0(evil)
	
	if (nAlignment >= ALIGN_VALUE_GOOD)
	{ 
		return TRUE;
	}
	else
	{
		return FALSE;
	}
*/	
}