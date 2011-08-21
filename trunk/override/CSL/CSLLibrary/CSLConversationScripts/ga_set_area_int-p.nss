/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/
void main(string sVariable, int nValue)
{
	object oArea = GetArea(GetPCSpeaker());

	SetLocalInt(oArea, sVariable, nValue);
}