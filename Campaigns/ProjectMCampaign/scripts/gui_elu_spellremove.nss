#include "elu_spells_i"

void main(int nLevel, int nSpellID)
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_spellremove SpellID:" + IntToString(nSpellID));
	object oChar = GetControlledCharacter(OBJECT_SELF);
	RemoveSpell(oChar, nLevel, nSpellID);
}