void main(string VarName)
{
	object oPC=GetPCSpeaker();
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	DeleteLocalString(oPC, VarName);
}