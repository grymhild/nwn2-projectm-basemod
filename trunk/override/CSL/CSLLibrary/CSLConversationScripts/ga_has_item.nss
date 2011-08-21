/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/
#include "_CSLCore_Messages"
#include "_CSLCore_Items"

int StartingConditional(string sItem)
{

    // Make sure the PC speaker has these items in their inventory
    if( CSLHasItemByTag(GetPCSpeaker(), sItem))
    {
        return TRUE;
	}
    return FALSE;
}