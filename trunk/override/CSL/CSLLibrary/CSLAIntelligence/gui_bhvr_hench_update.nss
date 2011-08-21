//::///////////////////////////////////////////////
//:: Behavior Screen - Update 
//:: gui_bhvr_update.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 03/29/06
//:://////////////////////////////////////////////
// ChazM 4/26/06 - changed to use inc file
// ChazM 11/9/06 - Examined Creature update


#include "_SCInclude_AI"

const int ADJUSTED_UPDATE_REFRESH_RATE = 6;

void main(int iExamined, int iNotFirstTime, int iObjectID)
{
//	Jug_Debug("gui_bhvr_hench_update " + IntToString(iNotFirstTime));	
	string sScreen;
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	
	if (iExamined == 0) // looking at our own character sheet
	{
		oTargetObject = oPlayerObject;
		sScreen = "SCREEN_CHARACTER";
	}
	else 	// looking at an examined character sheet
	{
		oTargetObject = GetPlayerCreatureExamineTarget(oPlayerObject);
		sScreen = "SCREEN_CREATUREEXAMINE";
	}
	int iTargetObjectID = ObjectToInt(oTargetObject);
	if (!iNotFirstTime || (iObjectID != iTargetObjectID) || (iNotFirstTime >= ADJUSTED_UPDATE_REFRESH_RATE))
	{
//		Jug_Debug("gui_bhvr_hench_update doing screen refresh");
		SCGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
		SCHenchGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen, !iNotFirstTime);		
		iNotFirstTime = 1;
		SetLocalGUIVariable(oPlayerObject, sScreen, 21, IntToString(iTargetObjectID));
	}
	else
	{
		iNotFirstTime++;
	}	
	SetLocalGUIVariable(oPlayerObject, sScreen, 20, IntToString(iNotFirstTime));
}