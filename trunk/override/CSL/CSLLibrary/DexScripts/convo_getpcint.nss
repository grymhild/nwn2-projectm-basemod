void main(int TokenID, string sVarName)
{
	object oPC=GetPCSpeaker();
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	SetCustomToken(TokenID,IntToString(GetLocalInt(oPC, sVarName)));
}