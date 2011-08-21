//::///////////////////////////////////////////////
//:: Associate: On Dialogue
//:: gb_assoc_conv
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    by the generic script after dialogue or a
    shout is initiated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
    object oMaster = GetMaster();
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    
    object oIntruder;
    if (nMatch == -1)
    {	
        if(GetCurrentAction() != ACTION_OPENLOCK &&
		   !(SCGetCreatureNegEffects(OBJECT_SELF) & HENCH_EFFECT_DISABLED))
        {
            ClearAllActions();
                // restore associate settings
			SCHenchGetDefSettings();
            // * if in XP2, use an alternative dialog file
            string sDialog = "";
            if (GetLocalInt(GetModule(), "X2_L_XP2") == 1)
            {
                sDialog = "x2_associate";
            }
            BeginConversation(sDialog);
        }
    }
//	Jug_Debug(GetName(OBJECT_SELF) + " - I heard shout: " + IntToString(nMatch) + " from: " + GetName(oShouter));
	// listening pattern matched. Respond to the master, or anybody in the faction if it's a single player game
	if (GetIsObjectValid(oShouter) && ((oMaster == oShouter) || (GetIsSinglePlayer() && GetFactionEqual(oShouter, OBJECT_SELF))))
    {
        SetCommandable(TRUE);
        SCAIRespondToShout(oShouter, nMatch, oIntruder, TRUE);
    }

    // Signal user-defined event
    if(SCGetSpawnInCondition(CSL_FLAG_ON_DIALOGUE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}