// gc_align_evil.nss
/*
   Check if player's alignment is Evil
*/
// BMA-OEI 7/25/05
// ChazM 4/9/07 - updated

//#include "ginc_alignment"

#include "_CSLCore_Reputation"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	return (CSLGetIsEvil(oPC));
/*	
	int nAlignment = GetGoodEvilValue(oPC); // 100(good) - 0(evil)
	
	if (nAlignment <= ALIGN_VALUE_EVIL)
	{ 
		return TRUE;
	}
	else
	{
		return FALSE;
	}
*/	
}