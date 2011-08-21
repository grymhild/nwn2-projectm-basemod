// gc_talkto(string sTarget)
/* This checks to see if you have not talked to this person before. See ga_talkto.nss.

   Parameters:
     string sTarget = Target of the NPC. If blank, use dialog OWNER.
*/
// FAB 9/30
// BMA 4/28/05 added CSLGetTarget()

#include "_CSLCore_Messages"

int StartingConditional(string sTarget)
{
    object oTarget = CSLGetTarget(sTarget, CSLTARGET_OWNER);
    
    if (GetLocalInt(oTarget, "TalkedTo") != 1)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

