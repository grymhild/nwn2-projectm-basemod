/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/

void main(string sVariable, string sValue)
{
	object oTarget = GetPCSpeaker();

	//PrintString("ga_local_string: Object '" + GetName(oTarget) + "' variable '" + sVariable + "' set to '" + sValue + "'");
	SetLocalString(oTarget, sVariable, sValue);		
}