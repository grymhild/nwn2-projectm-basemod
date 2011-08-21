void main(string VarName)
{
	object oPC=GetPCSpeaker();
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	DeleteLocalFloat(oPC, VarName);
}