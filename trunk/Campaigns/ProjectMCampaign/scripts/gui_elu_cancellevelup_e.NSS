/*
Filename:           gui_elu_cancellevelup_e
System:             core (OnCancelLevelUp event script)
Author:             Edward Beck (0100010)
Date Created:       Aug 2nd, 2009.
Summary:
elu OnCancelLevelUp Event.
This gui script should be called via OnRemoveX=UIObject_Misc_ExecuteServerScript
from the levelup_* UI xml files on all the scene event when the gui is removed.

NOTE: OBJECT_SELF in this event is the Owning PlayerCharacter object.
-----------------
Revision:

*/

#include "elu_functions_i"
#include "hcr2_debug_i"

void main()
{	
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	int bPreLevelUpFlag = GetLocalInt(oControlledChar, PRELEVELUP_FLAG);
	if (!bPreLevelUpFlag)
		return;			
	DeleteLocalInt(oControlledChar, PRELEVELUP_FLAG);
	//Do OnCancelLevelUp work here

	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_cancellevelup_e");

}