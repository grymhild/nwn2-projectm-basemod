/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/
void main(string sVariable, string sChange)
{
    object oTarg = GetPCSpeaker();
	
	SetLocalInt(oTarg, sVariable, StringToInt(sChange));
}