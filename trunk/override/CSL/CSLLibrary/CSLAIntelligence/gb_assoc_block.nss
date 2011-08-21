//::///////////////////////////////////////////////
//:: On Blocked
//:: gb_assoc_block
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This will cause blocked creatures to open
    or smash down doors depending on int and
    str.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////

#include "_SCInclude_AI"


void main()
{
    object oDoor = GetBlockingDoor();

//    Jug_Debug("******" + GetName(OBJECT_SELF) + " is blocked by " + GetName(oDoor));

    object oRealMaster = CSLGetCurrentMaster();

    if (GetObjectType(oDoor) == OBJECT_TYPE_DOOR && GetIsObjectValid(oRealMaster)
        && !GetLocalInt(OBJECT_SELF, "Scouting") && !SCIsOnOppositeSideOfDoor(oDoor, oRealMaster, OBJECT_SELF))
    {
        ClearAllActions();
        SCClearForceOptions();
        if (GetIsObjectValid(GetLocalObject(OBJECT_SELF, "LastTarget")) || GetLocalInt(OBJECT_SELF, HENCH_LAST_HEARD_OR_SEEN))
        {
            DeleteLocalObject(OBJECT_SELF, "LastTarget");
            SCClearEnemyLocation();
            if (!GetLocalInt(oDoor, "tkDoorWarning"))
            {
 				if (((GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_HENCHMAN) || (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_NONE)))
				{
					//	"Something is on the other side of this door."
                	SpeakStringByStrRef(230438);
				}
                SetLocalInt(oDoor, "tkDoorWarning", TRUE);
            }
        }
		SCHenchFollowLeader();
        return;
    }

    if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) && GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) >= 3)
    {
        DoDoorAction(oDoor, DOOR_ACTION_OPEN);
    }
    else if (GetIsDoorActionPossible(oDoor, DOOR_ACTION_UNLOCK))
    {
        DoDoorAction(oDoor, DOOR_ACTION_UNLOCK);
    }
    else if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) >= 16)
    {
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
    }
}