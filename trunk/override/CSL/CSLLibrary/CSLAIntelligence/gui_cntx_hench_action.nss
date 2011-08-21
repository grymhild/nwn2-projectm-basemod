// gui_cntx_hench_action
/*
	Behavior script for the character sheet behavior sub-panel
*/

//#include "gui_bhvr_inc"


#include "_SCInclude_AI"


const int HENCH_CNTX_MENU_PC     = 1;
const int HENCH_CNTX_MENU_SELF   = 2;
const int HENCH_CNTX_MENU_ALL    = 3;


void StartUpCommands(object oSelf, object oTarget, int nType)
{
    SCSetPlayerQueuedTarget(oSelf, OBJECT_INVALID);
	SCHenchResetHenchmenState();
    SetLocalInt(oSelf, "HenchCurHealCount", 1);
    SetLocalObject(oSelf, "Henchman_Spell_Target", oTarget);
    SetLocalInt(oSelf, "HenchHealType", nType);
    SetLocalInt(oSelf, "HenchHealState", HENCH_CNTX_MENU_BUFF_LONG);
    ExecuteScript("hench_o0_heal", oSelf);
}
            

void HenchStartUpCommand(int nType, int nTarget, object oCaster)
{
    object oTarget;
        
	if (nTarget == HENCH_CNTX_MENU_ALL)
	{
		oTarget = OBJECT_INVALID;
	}
	else if (nTarget == HENCH_CNTX_MENU_SELF)
	{
		oTarget = oCaster;
	}
	else
	{
		oTarget = GetControlledCharacter(OBJECT_SELF);
	}        
//    Jug_Debug("set type" + IntToString(nType) + " target " + IntToString(nTarget) + " caster " + GetName(oCaster) + " target " + GetName(oTarget));
    AssignCommand(oCaster, StartUpCommands(oCaster, oTarget, nType));   
}


// start up command on all non PCs in party
void HenchStartUpCommandAll(int nType, int nTarget)
{
	//CSLMessage_PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
 		if (!(GetIsPC(oPartyMember) && SCGetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF)))
		{
			HenchStartUpCommand(nType, nTarget, oPartyMember);
		}
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}

void HenchDoScout(object oSpeaker)
{
    object oClosest =  GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                        oSpeaker, 1);
    if (GetIsObjectValid(oClosest) && GetDistanceBetween(oClosest, oSpeaker) <= HENCH_MAX_SCOUT_DISTANCE)
    {
        SetLocalInt(OBJECT_SELF, "Scouting", TRUE);
        SetLocalObject(OBJECT_SELF, "ScoutTarget", oClosest);
        ClearAllActions();
        if (SCCheckStealth())
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
        }
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
    }
    else
    {
		//	indicate failure?
		//	"This area looks safe enough."
		SendMessageToPC(oSpeaker, GetStringByStrRef(230437));
        DeleteLocalInt(OBJECT_SELF, "Scouting");
    }
}

// reset follow on entire party
void HenchResetFollowAll()
{
	//CSLMessage_PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		SCHenchSetDefaultLeader(oPartyMember);
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}

// follow no one on entire party
void HenchFollowNoOneAll()
{
	//CSLMessage_PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		if (GetAssociateType(oPartyMember) == ASSOCIATE_TYPE_NONE)
		{
			SCHenchSetNoLeader(oPartyMember);
		}
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}

// reset guard on entire party
void HenchResetGuard()
{
	//CSLMessage_PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		SCHenchSetDefaultDefendee(oPartyMember);
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}


// auto set follow order
void HenchSetAutoSetFollow(object oLeader, int columns)
{
	// sort party members by BAB
	DeleteLocalObject(oLeader, "HenchAllyLineOfSight");
    object oPartyMember = GetFirstFactionMember(oLeader, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
//		Jug_Debug("Party member " + GetName(oPartyMember) + " tag " + GetTag(oPartyMember));
		if ((oPartyMember != oLeader) && (GetAssociateType(oPartyMember) == ASSOCIATE_TYPE_NONE))
		{
			int memberBAB = GetBaseAttackBonus(oPartyMember);
			int memberAC = GetAC(oPartyMember);
			object oPrevTestObject = oLeader;
			object oTestObject = GetLocalObject(oLeader, "HenchAllyLineOfSight");
	  		while (GetIsObjectValid(oTestObject))
			{
				int testBAB = GetBaseAttackBonus(oTestObject);
				if (testBAB < memberBAB)
				{
					break;
				}
				if ((testBAB == memberBAB) && (GetAC(oTestObject) < memberAC))
				{
					break;
				}
				oPrevTestObject = oTestObject;
				oTestObject = GetLocalObject(oTestObject, "HenchAllyLineOfSight");
			}
			SetLocalObject(oPrevTestObject, "HenchAllyLineOfSight", oPartyMember);
			SetLocalObject(oPartyMember, "HenchAllyLineOfSight", oTestObject);
		}
        oPartyMember = GetNextFactionMember(oLeader, FALSE);
    }
	
	SCHenchSetNoLeader(oLeader);
	int columnNumber;
	for (columnNumber = 0; columnNumber < columns; columnNumber++)
	{	
		object oCurLeader = oLeader;
		int curMemberCount;
	
		oPartyMember = GetLocalObject(oLeader, "HenchAllyLineOfSight");
		while (GetIsObjectValid(oPartyMember))
		{
//			Jug_Debug("checking " + GetName(oPartyMember));
			if ((curMemberCount % columns) == columnNumber)
			{
//				Jug_Debug(GetName(oPartyMember) + " set leader to " + GetName(oCurLeader));
				CSLSetAssociateState(CSL_ASC_DISTANCE_2_METERS, TRUE, oPartyMember);
				CSLSetAssociateState(CSL_ASC_DISTANCE_4_METERS, FALSE, oPartyMember);
				CSLSetAssociateState(CSL_ASC_DISTANCE_6_METERS, FALSE, oPartyMember);
				SCHenchSetLeader(oPartyMember, oCurLeader);
				oCurLeader = oPartyMember;
			}
			curMemberCount ++;
			oPartyMember = GetLocalObject(oPartyMember, "HenchAllyLineOfSight");
		}
	}
}


void ResetWeaponPreference(object oTarget, int iWeaponType)
{
	string weaponPrefString = GetTag(oTarget) + "HenchStoredPrefWeapon";
	object oTest;
	switch (iWeaponType)
	{
		case HENCH_AI_STORED_MELEE_FLAG:
			DeleteLocalInt(oTarget, weaponPrefString);			
		case HENCH_AI_STORED_RANGED_FLAG:
			oTest = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			break;
		case HENCH_AI_STORED_SHIELD_FLAG:
		case HENCH_AI_STORED_OFF_HAND_FLAG:
			oTest = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
			break;
	}
	if (GetIsObjectValid(oTest))
	{
		if (GetLocalInt(oTest, weaponPrefString) == iWeaponType)
		{
//			Jug_Debug("deleting weapon pref for " + GetName(oTest));
			DeleteLocalInt(oTest, weaponPrefString);
		}
	}
	oTest = GetFirstItemInInventory(oTarget);
	while (GetIsObjectValid(oTest))
	{
		if (GetLocalInt(oTest, weaponPrefString) == iWeaponType)
		{
//			Jug_Debug("deleting weapon pref for " + GetName(oTest));
			DeleteLocalInt(oTest, weaponPrefString);
		}
		oTest = GetNextItemInInventory(oTarget);	
	}
}


void HenchSetAIWeapons(object oTarget, object oWeapon, int iWeaponType)
{
	if (iWeaponType == HENCH_AI_STORED_MELEE_FLAG)
	{
		if (oWeapon == oTarget)
		{
			if (!GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oTarget) ||
				!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget)) ||	
				!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget)) ||	
				!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget)))
			{
				//	" is not a melee weapon."
				SpeakString(GetName(oWeapon) + GetStringByStrRef(230440));
				return;			
			}	
		}
		else if ((GetWeaponType(oWeapon) == WEAPON_TYPE_NONE) || GetWeaponRanged(oWeapon))
		{
			//	" is not a melee weapon."
			SpeakString(GetName(oWeapon) + GetStringByStrRef(230440));
			return;
		}		
		SetLocalObject(oTarget, "HenchStoredMeleeWeapon", oWeapon);	
	}
	else if (iWeaponType == HENCH_AI_STORED_RANGED_FLAG)
	{
		if (!GetWeaponRanged(oWeapon))
		{
			//	" is not a ranged weapon."
			SpeakString(GetName(oWeapon) + GetStringByStrRef(230441));
			return;
		}		
		SetLocalObject(oTarget, "HenchStoredRangedWeapon", oWeapon);		
	}
	else if (iWeaponType == HENCH_AI_STORED_SHIELD_FLAG)
	{
		int nItemType = GetBaseItemType(oWeapon);
		if ((nItemType != BASE_ITEM_TOWERSHIELD) && (nItemType != BASE_ITEM_LARGESHIELD) &&
			(nItemType != BASE_ITEM_SMALLSHIELD) && (nItemType != BASE_ITEM_TORCH))
		{
			//	" is not a shield."
			SpeakString(GetName(oWeapon) + GetStringByStrRef(230442));
			return;
		}		
		SetLocalObject(oTarget, "StoredShield", oWeapon);
	}
	else if (iWeaponType == HENCH_AI_STORED_OFF_HAND_FLAG)
	{
		if ((GetWeaponType(oWeapon) == WEAPON_TYPE_NONE) || GetWeaponRanged(oWeapon))
		{
			//	" is not a melee weapon."
			SpeakString(GetName(oWeapon) + GetStringByStrRef(230440));
			return;
		}		
		SetLocalObject(oTarget, "StoredOffHand", oWeapon);	
	}	
	else
	{
		// error calling, return
//		Jug_Debug("error calling HenchSetAIWeapons"); 
	}
	
	ResetWeaponPreference(oTarget, iWeaponType);
	string weaponPrefString = GetTag(oTarget) + "HenchStoredPrefWeapon";
	SetLocalInt(oWeapon, weaponPrefString, iWeaponType);
	SetLocalInt(oTarget, "HenchStoredPrefWeapon", GetLocalInt(oTarget, "HenchStoredPrefWeapon") | iWeaponType);
}


void main(int nType, int nKind, int nTarget)
{
//	 Jug_Debug("gui_cntx_hench_action master " + GetName(GetMaster()) + 
//       " last speaker " + GetName(GetLastSpeaker()) + " self " + GetName(OBJECT_SELF) + " controlled " + GetName(GetControlledCharacter(OBJECT_SELF)));        
//  	 Jug_Debug("gui_cntx_hench_action type " + IntToString(nType) + " kind " +
//        IntToString(nKind) + " target " + IntToString(nTarget));

	object oSpeaker = GetControlledCharacter(OBJECT_SELF);

	switch (nType)
	{
	case HENCH_CNTX_MENU_PC_ATTACK_NEAREST:
//		Jug_Debug(GetName(oSpeaker) + " attack nearest");
		SignalEvent(GetPlayerCurrentTarget(oSpeaker), EventUserDefined(HENCH_EVENT_ATTACK_NEAREST));
		break;
	case HENCH_CNTX_MENU_PC_FOLLOW_MASTER:
//		Jug_Debug(GetName(oSpeaker) + " follow");	
		SignalEvent(GetPlayerCurrentTarget(oSpeaker), EventUserDefined(HENCH_EVENT_FOLLOW_MASTER));
		break;
	case HENCH_CNTX_MENU_PC_GUARD_MASTER:
//		Jug_Debug(GetName(oSpeaker) + " guard");
		SignalEvent(GetPlayerCurrentTarget(oSpeaker), EventUserDefined(HENCH_EVENT_GUARD_MASTER));
		break;
	case HENCH_CNTX_MENU_PC_STAND_GROUND:
//		Jug_Debug(GetName(oSpeaker) + " stand ground");
		SignalEvent(GetPlayerCurrentTarget(oSpeaker), EventUserDefined(HENCH_EVENT_STAND_GROUND));
		break;
	case HENCH_CNTX_MENU_SCOUT:
//		Jug_Debug(GetName(oSpeaker) + " scout");
		if (GetAssociateType(GetPlayerCurrentTarget(oSpeaker)) != ASSOCIATE_TYPE_NONE)
		{
        	AssignCommand(GetPlayerCurrentTarget(oSpeaker), HenchDoScout(oSpeaker));
		}
		else
		{
			//	"[Scouting can only be done by associates, not companions.]"
			SendMessageToPC(oSpeaker, GetStringByStrRef(230436));
		}
		break;
	case HENCH_CNTX_MENU_FOLLOW_TARGET:
		SCHenchSetLeader(oSpeaker, GetPlayerCurrentTarget(oSpeaker));
		break;	
	case HENCH_CNTX_MENU_FOLLOW_ME:
		SCHenchSetLeader(GetPlayerCurrentTarget(oSpeaker), oSpeaker);
		break;			
	case HENCH_CNTX_MENU_FOLLOW_NO_ONE:
		SCHenchSetNoLeader(nKind ? oSpeaker : GetPlayerCurrentTarget(oSpeaker));
		break;
	case HENCH_CNTX_MENU_FOLLOW_RESET:
		SCHenchSetDefaultLeader(nKind ? oSpeaker : GetPlayerCurrentTarget(oSpeaker));
		break;
	case HENCH_CNTX_MENU_FOLLOW_RESET_ALL:
		HenchResetFollowAll();
		break;
	case HENCH_CNTX_MENU_GUARD_TARGET:
		SCHenchSetDefendee(oSpeaker, GetPlayerCurrentTarget(oSpeaker));
		break;	
	case HENCH_CNTX_MENU_GUARD_ME:
		SCHenchSetDefendee(GetPlayerCurrentTarget(oSpeaker), oSpeaker);
		break;			
	case HENCH_CNTX_MENU_GUARD_RESET:
		SCHenchSetDefaultDefendee(nKind ? oSpeaker : GetPlayerCurrentTarget(oSpeaker));
		break;
	case HENCH_CNTX_MENU_GUARD_RESET_ALL:
		HenchResetGuard();
		break;
	case HENCH_CNTX_MENU_FOLLOW_SINGLE:
		 HenchSetAutoSetFollow(oSpeaker, 1);
		break;
	case HENCH_CNTX_MENU_FOLLOW_DOUBLE:
		HenchSetAutoSetFollow(oSpeaker, 2);
		break;
	case HENCH_CNTX_MENU_FOLLOW_NO_ONE_ALL:
		HenchFollowNoOneAll();
		break;
	case HENCH_CNTX_MENU_SET_WEAPON:
		{
			object oTargetObject;
			if (nKind != -1)
			{
				oTargetObject = IntToObject(nKind);
			}
			else
			{
				oTargetObject = oSpeaker;
			}
			HenchSetAIWeapons(oSpeaker, oTargetObject, nTarget);
			SCChangeEquippedWeapons(oSpeaker);
		}
		break;
	case HENCH_CNTX_MENU_RESET_WEAPON:
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_MELEE_FLAG);
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_RANGED_FLAG);
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_SHIELD_FLAG);
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_OFF_HAND_FLAG);
		DeleteLocalInt(oSpeaker, "HenchStoredPrefWeapon");		
		SCChangeEquippedWeapons(oSpeaker);
		break;	


// TODO	case 300:	
	
//		SetScriptHidden(GetPlayerCurrentTarget(oSpeaker), TRUE, FALSE);
// TODO test this	SetIsCompanionPossessionBlocked( object oCreature, int bBlocked );
	
	case HENCH_SAVE_GLOBAL_SETTINGS:
		{
			int nResult;
			// global settings
			nResult = GetGlobalInt("HENCH_GLOBAL_OPTIONS");
			SetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_GLOBAL_OPTIONS", nResult);
			// party settings
    		object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oSpeaker));
    		nResult = GetLocalInt(oPlayerCharacter, "HENCH_PARTY_SETTINGS");
			SetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_PARTY_SETTINGS", nResult);
		}
		break;
	case HENCH_LOAD_GLOBAL_SETTINGS:
		{
			int nResult;
			// global settings
			nResult = GetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_GLOBAL_OPTIONS");
			nResult |= HENCH_OPTION_SET_ONCE;
    		SetGlobalInt("HENCH_GLOBAL_OPTIONS", nResult);
			// party settings
			nResult = GetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_PARTY_SETTINGS");
			nResult |= HENCH_OPTION_SET_ONCE;
    		object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oSpeaker));
    		SetLocalInt(oPlayerCharacter, "HENCH_PARTY_SETTINGS", nResult);
		}
		break;
	case HENCH_RESET_GLOBAL_SETTINGS:
		{
			int nResult;
			// global settings
			SetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_GLOBAL_OPTIONS", 0);
			nResult = HENCH_OPTION_SET_ONCE;
    		SetGlobalInt("HENCH_GLOBAL_OPTIONS", nResult);
			// party settings
			SetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_PARTY_SETTINGS", 0);
			nResult = HENCH_OPTION_SET_ONCE;
    		object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oSpeaker));
    		SetLocalInt(oPlayerCharacter, "HENCH_PARTY_SETTINGS", nResult);
		}
		break;		
	default:
		if (nType < 100)	// check for accidental out of range calls
		{
			if (nKind)
			{
				HenchStartUpCommandAll(nType, nTarget);
			}
		    else
		    {
		        HenchStartUpCommand(nType, nTarget, GetPlayerCurrentTarget(oSpeaker));
			}
		}	
	}
}