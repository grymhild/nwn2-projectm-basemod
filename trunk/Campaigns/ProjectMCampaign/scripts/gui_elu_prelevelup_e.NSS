/*
Filename:           gui_elu_prelevelup_e
System:             core (OnPreLevelUp event script)
Author:             Edward Beck (0100010)
Date Created:       Aug 2nd, 2009.
Summary:
ELU OnPreLevelUp Event.
This gui script should be called via OnLeftClickX=UIObject_Misc_ExecuteServerScript
from the characterscreen UI xml files on the buttons which displays the levelup UI.

NOTE: OBJECT_SELF in this event is the Owning PlayerCharacter object.
-----------------
Revision:

*/

#include "elu_functions_i"

void main()
{
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	int bPreLevelUpFlag = GetLocalInt(oControlledChar, PRELEVELUP_FLAG);
	if (bPreLevelUpFlag)
		return;
	int nLevel = CSLGetTotalClassLevels(oControlledChar);	
	if (GetXP(oControlledChar) < GetMinimumXPRequiredForLevel(nLevel+1, oControlledChar))
		return;
	SetLocalInt(oControlledChar, PRELEVELUP_FLAG, TRUE);
	
	//Do OnPreLevelUP work here

	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_prelevelup_e");
}