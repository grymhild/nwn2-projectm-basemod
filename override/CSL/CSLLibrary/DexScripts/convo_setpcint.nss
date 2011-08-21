void main(string sVarName, int Value)
{
	object oPC=GetPCSpeaker();
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	SetLocalInt(oPC, sVarName, Value);
}