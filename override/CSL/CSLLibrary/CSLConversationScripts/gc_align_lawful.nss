// gc_align_lawful.nss
/*
   Check if player's alignment is Lawful
*/
// BMA-OEI 7/25/05
// ChazM 4/9/07 - updated

//#include "ginc_alignment"

#include "_CSLCore_Reputation"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	return (CSLGetIsLawful(oPC));
/*	
	int nAlignment = GetLawChaosValue(oPC); // 100(lawful) - 0(chaotic)
	if (nAlignment >= ALIGN_VALUE_LAWFUL)
	{ 
		return TRUE;
	}
	else
	{
		return FALSE;
	}
*/	
}