/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/
void main(string sVariable, string sChange)
{
    object oTarg = GetPCSpeaker();
	
	SetLocalFloat(oTarg, sVariable, StringToFloat(sChange));
}