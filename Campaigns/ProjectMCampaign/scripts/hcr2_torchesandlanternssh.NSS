/*
Filename:           hcr2_torchesandlanternssh
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Jan. 21st, 2007
Summary:
HCR2 hcr2_torchesandlanternssh spell hook event script.

-----------------
Revision:

*/

#include "x2_inc_switches"
#include "hcr2_torchesandlanterns_i"

void main()
{
    object oItem = GetSpellCastItem();
    int spellID = GetSpellId();
    if (GetTag(oItem) == H2_OILFLASK && GetSpellId() == SPELL_GRENADE_FIRE)
    {
        if (d2()==1)
        {
            SendMessageToPC(OBJECT_SELF, H2_TEXT_OIL_FLASK_FAIED_TO_IGNITE);
            SetModuleOverrideSpellScriptFinished();
        }
    }
}