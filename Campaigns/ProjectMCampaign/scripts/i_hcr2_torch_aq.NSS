/*
Filename:           i_hcr2_torch_aq
System:             torches and lanterns system (torch item script)
Author:             Edward Beck (0100010)
Date Created:       Feb. 17th, 2008
Summary:
Torchs and lanterns system item event script. (alternate item acquired script)
This script fires whenever the hcr2_torch item is acquired.

Revision Info should only be included for post-release revisions.
-----------------
Revision:

*/

void main()
{
	ExecuteScript("hcr2_torch", GetModule());
}