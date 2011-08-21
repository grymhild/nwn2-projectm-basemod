//::///////////////////////////////////////////////
//:: Default: On Spell Cast At
//:: NW_C2_DEFAULTB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
	if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_defaultb Start "+GetName(OBJECT_SELF) + " Action =" +IntToString(GetCurrentAction()), GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
	
	giCSLTotalScriptsRunning = CSLIncrementLocalInt_Timed(GetModule(), "CSLHENCH_TOTALSCRIPTSRUNNING", 6.0f, 1);
	object oCharacter = OBJECT_SELF;
    int iFocused = SCGetIsFocused(oCharacter);

	// spell cast at me so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
	{
		SetLocalInt(oCharacter, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused
	}

    if (iFocused == FOCUSED_FULL)
	{
        // remain focused
    }
    else if(GetLastSpellHarmful())
    {
		object oCaster = GetLastSpellCaster();
       // ------------------------------------------------------------------
        // If I was hurt by someone in my own faction
        // Then clear any hostile feelings I have against them
        // After all, we're all just trying to do our job here
        // if we singe some eyebrow hair, oh well.
        // ------------------------------------------------------------------
        if (GetFactionEqual(oCaster, oCharacter))
        {
            ClearPersonalReputation(oCaster, oCharacter);
            // Send the user-defined event as appropriate
            if(SCGetSpawnInCondition(CSL_FLAG_SPELL_CAST_AT_EVENT))
            {
                SignalEvent(oCharacter, EventUserDefined(EVENT_SPELL_CAST_AT));
            }
            return;
        }
		SCCheckRemoveStealth();
        if(!SCGetIsFighting(oCharacter) && SCGetIsValidRetaliationTarget(oCaster))
        {
            if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
            {
                SCHenchDetermineSpecialBehavior(oCaster);
            }
            else
            {
                SCHenchDetermineCombatRound(oCaster);
            }
        }
    }
    if(SCGetSpawnInCondition(CSL_FLAG_SPELL_CAST_AT_EVENT))
    {
        SignalEvent(oCharacter, EventUserDefined(EVENT_SPELL_CAST_AT));
    }
    if (DEBUGGING >= 10) { CSLDebug(  "nw_c2_defaultb End", GetFirstPC(), OBJECT_INVALID, "YellowGreen" ); }
}