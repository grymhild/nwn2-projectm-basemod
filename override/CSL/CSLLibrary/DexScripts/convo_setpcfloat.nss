void main(string sVarName, float Value)
{
	object oPC=GetPCSpeaker();
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);

	SetLocalFloat(oPC, sVarName, Value);
}