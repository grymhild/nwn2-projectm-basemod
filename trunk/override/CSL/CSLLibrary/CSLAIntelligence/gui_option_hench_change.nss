// gui_option_hench_change
/*
	Global option script for the character sheet behavior sub-panel
*/


#include "_SCInclude_AI"


void HenchSetOption(int nCondition, int bNewState, object oPlayerObject, object oTargetObject, string sScreen)
{
	switch (nCondition)
	{
		case HENCH_OPTION_STEALTH:
			SCSetHenchOption(HENCH_OPTION_STEALTH, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233032, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233033, "");
			}
			break;
			
		case HENCH_OPTION_WANDER:
			SCSetHenchOption(HENCH_OPTION_WANDER, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233035, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233036, "");
			}
			break;
			
		case HENCH_OPTION_OPEN:
			SCSetHenchOption(HENCH_OPTION_OPEN, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233038, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233039, "");
			}
			break;
			
		case HENCH_OPTION_UNLOCK:
			SCSetHenchOption(HENCH_OPTION_UNLOCK, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233041, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233042, "");
			}
			break;
			
		case HENCH_OPTION_KNOCKDOWN_DISABLED:
			SCSetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED, bNewState);
			SCSetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES, FALSE);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233044, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233047, "");
			}
			break;
		case HENCH_OPTION_KNOCKDOWN_SOMETIMES:		
			SCSetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED, FALSE);
			SCSetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES, TRUE);
			SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233046, "");
			break;
			
		case HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET:
			SCSetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET, bNewState);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233049, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233050, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_AUTO_BUFF:
			SCSetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF, bNewState);
			SCSetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF, FALSE);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233052, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233054, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF:
			SCSetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF, bNewState);
			SCSetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233053, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233054, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_ITEM_CREATION:
			SCSetHenchOption(HENCH_OPTION_ENABLE_ITEM_CREATION, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233056, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233057, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE:
			SCSetHenchOption(HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233059, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233060, "");
			}
			break;

		case HENCH_OPTION_HIDEOUS_BLOW_INSTANT:
			SCSetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233062, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233063, "");
			}
			break;

		case HENCH_OPTION_MONSTER_ALLY_DAMAGE:
			SCSetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233065, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", 233066, "");
			}
			break;
			
		case HENCH_OPTION_DISABLE_HB_DETECTION:
			SCSetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION, !bNewState);
			SCSetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING, FALSE);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "Use hearing and seeing heartbeat detection.");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "Disable heartbeat detection.");
			}
			break;
			
		case HENCH_OPTION_DISABLE_HB_HEARING:
			SCSetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION, FALSE);
			SCSetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "Use seeing heartbeat detection only.");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "Disable heartbeat detection.");
			}
			break;
			
		case HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH:
			SCSetHenchOption(HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "When puppet mode is on for a companion during combat, the game will pause and switch control to the companion when they need to do something.");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "Puppet mode for a companion does not pause the game.");
			}
			break;			
			
		case HENCH_OPTION_ENABLE_PAUSE_FOR_TRAPS:
			SCSetHenchOption(HENCH_OPTION_ENABLE_PAUSE_FOR_TRAPS, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "Pauses the game when a trap is detected by any party member.");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", -1, "Detected traps do not pause the game.");
			}
			break;
			
		default:
			if (DEBUGGING >= 4) { CSLDebug( "gui_bhvr_hench_change: Behavior " + IntToString( nCondition ) + " definition does not exist." ); }
	}
}


void main(int nCondition, int bNewState)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	string sScreen;
	
	oTargetObject = oPlayerObject;
	sScreen = "SCREEN_CHARACTER";
	
	HenchSetOption(nCondition, bNewState, oPlayerObject, oTargetObject, sScreen);
	SCHenchGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}