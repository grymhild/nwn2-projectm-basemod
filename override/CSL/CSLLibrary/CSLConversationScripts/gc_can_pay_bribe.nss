//gc_can_pay_bribe
//Check to see if the PC can pay the current bribe amount

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	int nBribe = GetGlobalInt("BRIBE_AMOUNT");
	int nGold = GetGold(oPC);
	
	if(nGold >= nBribe)
		return TRUE;
		
	else
		return FALSE;
}