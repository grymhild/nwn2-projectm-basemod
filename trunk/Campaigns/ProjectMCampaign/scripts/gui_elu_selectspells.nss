#include "elu_spells_i"

void main(int nLevel)
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_selectspells.");
	object oChar = GetControlledCharacter(OBJECT_SELF);
	if (GetLocalInt(oChar, DONE_PROCESSING_SPELLS)==0)
		return;	

	UpdateSpellListBoxes(oChar, nLevel);
}