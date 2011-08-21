/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/
void main(string sName, int iValue, int iMinutes)
{
object oPC = GetPCSpeaker();
//string sCD = GetPCPublicCDKey(oPC);
//string sPCName = GetName(oPC);
//string sVariable = sName+"_"+sCD+"_"+sPCName;

if( iValue != 0 )
	{
	SetLocalInt(oPC, sName, iValue);
	if( iMinutes != 0 )
		DelayCommand( IntToFloat(iMinutes*60), DeleteLocalInt(oPC, sName));
	}
else
	DeleteLocalInt(oPC, sName);
}