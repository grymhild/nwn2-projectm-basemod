/*
This is a SP Official campaign script for features in the single player game
*/
// ga_give_gold - NX2 Campaign Override
/*
    This gives the player some gold.
        nGP     = The amount of gold coins given to the PC
        bAllPartyMembers = This DOES NOTHING for NX2. Gold is always divided among all human player characters.
*/
// FAB 9/30
// MDiekmann 4/9/07 using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nAllPCs to bAllPartyMembers
// NChapman 9/17/08 - refactored for NX2 campaign override.


void main(int nGP, int bAllPartyMembers)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	if ( bAllPartyMembers == FALSE )
	{
    	GiveGoldToCreature( oPC,nGP );
    }
    else
    {
		int nPartyCounter = 0;
		
		object oCounter = GetFirstFactionMember(oPC);
		while(GetIsObjectValid(oCounter))
		{
			++nPartyCounter;
			oCounter = GetNextFactionMember(oPC);
		}
		
		if(nPartyCounter != 0)
		{
			nGP /= nPartyCounter;
		}
		
		object oTarg = GetFirstFactionMember(oPC);
		while(GetIsObjectValid(oTarg))
		{
			GiveGoldToCreature( oTarg,nGP );
			oTarg = GetNextFactionMember(oPC);
		}
	}
}