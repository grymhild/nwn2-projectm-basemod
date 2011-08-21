/*
This is a SP Official campaign script for features in the single player game
*/
//ga_pay_bribe
//pays the current bribe amount

void main()
{
	object oPC = GetPCSpeaker();
	object oTarg = GetFirstFactionMember(oPC);
	int nGold = GetGlobalInt("BRIBE_AMOUNT");
	
    while ( GetIsObjectValid(oTarg) )
    {
		TakeGoldFromCreature( nGold,oTarg );
		oTarg = GetNextFactionMember(oPC);
	}
}