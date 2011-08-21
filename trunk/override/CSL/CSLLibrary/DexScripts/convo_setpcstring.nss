void main(string sVarName, string Value)
{
	object oPC=GetPCSpeaker();
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	SetLocalString(oPC, sVarName, Value);
}