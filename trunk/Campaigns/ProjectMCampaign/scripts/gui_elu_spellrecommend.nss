#include "hcr2_debug_i"
#include "elu_spells_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executing gui_elu_spellrecommend");
	
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);
	int nClass = GetLocalInt(oControlledChar, LAST_SELECTED_CLASS);
	string packageline = Get2DAString("classes", "Package", nClass);
	string spellpackage = "";
	if (packageline != "")
		spellpackage = Get2DAString("packages", "SpellPref2DA", StringToInt(packageline));
	if (spellpackage == "")	
		WriteTimestampedLogEntry("WARNING: There is no spell package associated with ClassID: " + IntToString(nClass));		
	else
		AllocateSpellsByPackage(oControlledChar, spellpackage, nClass);
}