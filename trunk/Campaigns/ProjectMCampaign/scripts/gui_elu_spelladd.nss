#include "elu_spells_i"

void main(int nLevel, int nSpellID)
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_spelladd SpellID:" + IntToString(nSpellID));
	object oChar = GetControlledCharacter(OBJECT_SELF);
	AddSpell(oChar, nLevel, nSpellID);
}