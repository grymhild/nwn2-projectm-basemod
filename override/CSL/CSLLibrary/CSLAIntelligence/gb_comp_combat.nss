// gb_comp_combat.nss
/*
	Companion OnEndCombatRound handler
	
	Based off Associate End of Combat End (NW_CH_AC3)	
*/
// ChazM 12/5/05
// BMA-OEI 7/08/06
// DBR - 08/03/06 added support for CSL_ASC_MODE_PUPPET
// BMA_OEI 09/13/06 -- Added CSL_ASC_MODE_STAND_GROUND check

#include "_SCInclude_AI"


void main()
{
//	float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;
//	Jug_Debug("*****" + GetName(OBJECT_SELF) + " end combat round action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

   	SCHenchResetCombatRound();
	
	if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
	{
		if (!SCGetHasPlayerQueuedAction(OBJECT_SELF) && SCHenchGetIsEnemyPerceived(FALSE))
		{
			SCHenchCheckPlayerPause();
		}
	}
	else if (!SCGetHasPlayerQueuedAction(OBJECT_SELF) &&
		!SCGetSpawnInCondition(CSL_FLAG_SET_WARNINGS) &&	
		!SCHenchCheckEventClearAllActions(TRUE))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " end combat round combat round");
		SCHenchDetermineCombatRound();
	}
    if(SCGetSpawnInCondition(CSL_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }
}