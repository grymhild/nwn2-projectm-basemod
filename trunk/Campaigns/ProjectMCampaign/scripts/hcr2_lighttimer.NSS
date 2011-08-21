/*
Filename:           hcr2_lighttimer
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Jan. 21st, 2007
Summary:
HCR2 torches and lanterns timer script.
This script fires when the timer for an equipped light source elapses.

-----------------
Revision:

*/

#include "hcr2_torchesandlanterns_i"

void main()
{
	if (GetLocalInt(OBJECT_SELF, H2_FIRST_EQUIPPED))
	{
		DeleteLocalInt(OBJECT_SELF, H2_FIRST_EQUIPPED);
		return;
	}
		
    if (GetTag(OBJECT_SELF) == H2_LANTERN)
        h2_BurnOutLightSource(OBJECT_SELF, TRUE);
    else
        h2_BurnOutLightSource(OBJECT_SELF, FALSE);
}