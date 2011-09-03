#include "elu_fam_ancom_i"

void main(string sResRef, string sFamiliarName)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	string sResRef2 = GetLocalString(oChar, FAMILIAR_LAST_SELECTED);
	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_commitfamiliar: " + sResRef + " " + sResRef2 + " " + sFamiliarName);	
	SetFamiliarOverride(oChar, sResRef);
	SetGUIObjectText(OBJECT_SELF, "SCREEN_LEVELUP_FAMILIARX3","FAMILIAR_NAME_FIELD", -1, sFamiliarName + "\n\n\n" + sResRef);
	DelayCommand(0.1, CloseGUIScreen(oChar, "SCREEN_LEVELUP_FAMILIARX3"));	
}