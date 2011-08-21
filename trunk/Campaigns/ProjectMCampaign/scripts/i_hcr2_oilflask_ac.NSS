/*
Filename:           i_hcr2_oilflask_ac
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Apr. 3rd, 2007
Summary:
 torches and lanterns system item event script. (alternate item activation script)
This script fires whenever the hcr2_oilflask items are  activated.

-----------------
Revision:

*/

void main()
{
	ExecuteScript("hcr2_oilflask", GetModule());
}