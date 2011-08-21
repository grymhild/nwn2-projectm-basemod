const int TOKEN_AXIS_GOODEVIL = 101;
const int TOKEN_AXIS_LAWCHAOS = 102;

void main()
{
	
	object oDM = GetPCSpeaker();
	object oTarget = GetLocalObject(oDM, "loDM_WAND_TARGET");
	SetCustomToken(TOKEN_AXIS_GOODEVIL, IntToString(GetGoodEvilValue(oTarget)));
	SetCustomToken(TOKEN_AXIS_LAWCHAOS, IntToString(GetLawChaosValue(oTarget)));
}