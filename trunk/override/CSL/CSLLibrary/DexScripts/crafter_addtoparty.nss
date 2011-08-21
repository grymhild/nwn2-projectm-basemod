#include "crafter_include"

void main ()
{
	object oPC=GetPCSpeaker();
	//object oNPC=GetLastSpeaker();
	object oNPC=GetNearestObjectByTag("craft", oPC, 1);
	
	//SendMessageToPC(oPC, GetFirstName(oNPC)+" "+GetLastName(oNPC)+"("+GetTag(oNPC)+")");
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);
	AddCrafterToParty(oPC, oNPC);
}