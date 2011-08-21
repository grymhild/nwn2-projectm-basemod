/*
Filename:           i_hcr2_lantern_ue
System:             torches and lanterns system (lantern item script)
Author:             Edward Beck (0100010)
Date Created:       Apr. 3rd, 2007
Summary:
Torchs and lanterns system item event script. (alternate item unequipped script)
This script fires whenever the hcr2_lantern item is unequipped.

Revision Info should only be included for post-release revisions.
-----------------
Revision:

*/

void main()
{
	ExecuteScript("hcr2_lantern", GetModule());
}