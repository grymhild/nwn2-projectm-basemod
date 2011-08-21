void main(int TokenID, string sVarName)
{
	object oPC=GetPCSpeaker();
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	SetCustomToken(TokenID,FloatToString(GetLocalFloat(oPC, sVarName)));
}