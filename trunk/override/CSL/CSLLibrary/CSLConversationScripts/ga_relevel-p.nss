#include "_CSLCore_Player"
//#include "inc_generic"
//#include "inc_ap"
void main(int iNumber, int iCost)
{
	object oPC=GetPCSpeaker();
	int iPlayer_Level = GetHitDice(oPC);
	int iECL = CSLGetRaceDataECL( GetSubRace(oPC) );
	int inHD;
	int	iPlayer_XP;
	if (iNumber!=0)
	{
		inHD = iPlayer_Level + iECL - iNumber; 
		iPlayer_XP = (500*(inHD*(inHD-1)));
		//UseAP(oPC, iNumber*iCost, "ap_relvl:"+IntToString(iNumber));	
	}
	else
	{
		iNumber=iPlayer_Level-1;
		iPlayer_XP=0;
		//UseAP(oPC, 20*iCost, "ap_relvl:"+IntToString(iNumber));
	}
	SetXP(oPC, iPlayer_XP );	
	CreateItemOnObject( "LEVELUP_MEDAL", oPC, iNumber);
}