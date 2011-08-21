/*
Filename:           hcr2_oilflask
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Jan. 21st, 2007
Summary:
HCR2 hcr2_oilflask item script.
This script fires via tag based scripting for the Item OnActivate event for this item.

-----------------
Revision:

*/

#include "hcr2_torchesandlanterns_i"
#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC   = GetItemActivator();
        object oItem = GetItemActivated();
        object oTarget = GetItemActivatedTarget();
        location loc = GetItemActivatedTargetLocation();
        if (GetIsObjectValid(oTarget))
        {
            if (GetTag(oTarget) == H2_LANTERN)
            {
                h2_FillLantern(oItem, oTarget);
                return;
            }
        }
        SendMessageToPC(oPC, H2_TEXT_CANNOT_USE_ON_TARGET);
    }
}