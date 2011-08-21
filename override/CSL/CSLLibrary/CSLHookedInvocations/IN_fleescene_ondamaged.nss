//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
#include "_SCInclude_AI"

void main()
{
	object oDamager = GetLastDamager();
	if (GetIsObjectValid(oDamager))
	{
	// don't do anything, we don't have a valid damager
		AssignCommand( oDamager, SpeakString("NW_SNEAKERFOUND", TALKVOLUME_SILENT_TALK) );
	}
}