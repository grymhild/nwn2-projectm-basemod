// gui_party_hench_change
/*
	Party behavior script for the character sheet behavior sub-panel
*/

//#include "gui_bhvr_inc"

#include "_SCInclude_AI"


void HenchSetPartyOption(int nCondition, int bNewState, object oPlayerObject)
{
	switch (nCondition)
	{
		case HENCH_PARTY_UNEQUIP_WEAPONS:
			SCSetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS, bNewState, oPlayerObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232568, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232567, "");
			}
			break;
		case HENCH_PARTY_SUMMON_FAMILIARS:
			SCSetHenchPartyState(HENCH_PARTY_SUMMON_FAMILIARS, bNewState, oPlayerObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232571, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232570, "");
			}
			break;
		case HENCH_PARTY_SUMMON_COMPANIONS:
			SCSetHenchPartyState(HENCH_PARTY_SUMMON_COMPANIONS, bNewState, oPlayerObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232574, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232573, "");
			}
			break;
			
		case HENCH_PARTY_LOW_ALLY_DAMAGE:			
			SCSetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, TRUE, oPlayerObject);
			SCSetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, FALSE, oPlayerObject);
			SCSetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232576, "");
			break;

		case HENCH_PARTY_MEDIUM_ALLY_DAMAGE:			
			SCSetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, FALSE, oPlayerObject);
			SCSetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, TRUE, oPlayerObject);
			SCSetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232577, "");
			break;

		case HENCH_PARTY_HIGH_ALLY_DAMAGE:			
			SCSetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, FALSE, oPlayerObject);
			SCSetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, FALSE, oPlayerObject);
			SCSetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, TRUE, oPlayerObject);
			SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232578, "");
			break;

		case HENCH_PARTY_DISABLE_PEACEFUL_MODE:
			SCSetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE, bNewState, oPlayerObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232581, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232580, "");
			}
			break;

		case HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF:
			SCSetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF, bNewState, oPlayerObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232584, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", 232583, "");
			}
			break;
			
		case HENCH_PARTY_DISABLE_WEAPON_EQUIP_MSG:
			SCSetHenchPartyState(HENCH_PARTY_DISABLE_WEAPON_EQUIP_MSG, bNewState, oPlayerObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", -1, "Party members will not give weapon switching messages.");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", -1, "Party members will give weapon switching messages.");
			}
			break;

		case HENCH_PARTY_ENABLE_PUPPET_FOLLOW:
			SCSetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW, bNewState, oPlayerObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", -1, "Party members that have puppet mode on will follow and do other activities when not in combat.");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, "SCREEN_CHARACTER", "BEHAVIORDESC_TEXT", -1, "Party members that have puppet mode on won't do anything unless directed.");
			}
			break;
			
		default:
			if (DEBUGGING >= 4) { CSLDebug( "gui_party_hench_change: Behavior " + IntToString( nCondition ) + " definition does not exist." ); }
	}	

}


void main(int nCondition, int bNewState)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	if (DEBUGGING >= 4) { CSLDebug( "gui_bhvr_hench_change." ); }
			
	HenchSetPartyOption(nCondition, bNewState, oPlayerObject);
	SCHenchGuiBehaviorInit(oPlayerObject, oPlayerObject, "SCREEN_CHARACTER");
}