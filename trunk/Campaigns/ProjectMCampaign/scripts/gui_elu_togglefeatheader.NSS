#include "csl_listbox_i"

void main(string sScreen, string sListBox, string sFeatheader)
{
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	object oListBoxObject = CSLGetListBoxObject(oControlledChar, sScreen, sListBox);		
	WriteTimestampedLogEntry("toggle " + sScreen + " " + sListBox + " " + sFeatheader + GetTag(oListBoxObject));
	CSLToggleListBoxHeader(oListBoxObject, sFeatheader);
}