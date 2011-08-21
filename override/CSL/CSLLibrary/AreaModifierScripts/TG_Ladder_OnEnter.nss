/*
This is a basic trigger to allow climbing ladders.

The ladder has an onuse event which this is put in. The variable is put on the ladder placeable with
the name of "TG_LADDER_WP", this contains the tag of a waypoint. Clicking use moves the character
 directly to the way point. Ideally the waypoint is at the top of the ladder.
*/
//#include "_CSLCore_Environment"

void main()
{
	object oPC =  GetEnteringObject();
	object oLadder = OBJECT_SELF;
	string sWaypointName = GetLocalString( oLadder, "TG_LADDER_WP");
	string sMessage = GetLocalString( oLadder, "TG_LADDER_MESSAGE");
	object oWayPoint = GetObjectByTag( sWaypointName );
	
	//SpeakString("Taking character to "+sWaypointName);
	if ( GetIsObjectValid( oWayPoint ) )
	{
		location lWaypoint = GetLocation( oWayPoint );
		lWaypoint = CalcSafeLocation( oPC, lWaypoint, 10.0f, FALSE, FALSE );
		AssignCommand(oPC, JumpToLocation(lWaypoint));
		if ( sMessage != "" )
		{
			SendMessageToPC( oPC, sMessage );
		}
		
		object oPM = GetFirstFactionMember( oPC, FALSE );
		while ( GetIsObjectValid( oPM ) == TRUE )
		{
			if ( GetMaster( oPM ) == oPC && GetDistanceBetween(oPM, oPC) < RADIUS_SIZE_ASTRONOMIC )
			{
				AssignCommand( oPM, ClearAllActions() );
				AssignCommand( oPM, ActionForceMoveToLocation(GetLocation(oLadder), TRUE, 60.0f));
				
				if ( GetIsPlaceableObjectActionPossible(oLadder, PLACEABLE_ACTION_USE) )
				{
					AssignCommand(	oPM, ActionInteractObject(oLadder)); // assuming this gets the pets to use the placeable
					//AssignCommand(	oPM, ActionDoCommand(ExecuteScript("TG_Ladder_OnUse", oPM)));
				}
			}
			oPM = GetNextFactionMember( oPC, FALSE );
		}
	}
}


/*
void CSLTransportToLocation(object oPC, location oLoc)
{
    // Jump the PC
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToLocation(oLoc));

    // Not a PC, so has no associates
    if (!GetIsPC(oPC))
        return;

    // Get all the possible associates of this PC
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC);
    object oDomin = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
    object oFamil = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    object oAnimalComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);

    // Jump any associates
    if (GetIsObjectValid(oHench)) {
        AssignCommand(oHench, ClearAllActions());
        AssignCommand(oHench, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oDomin)) {
        AssignCommand(oDomin, ClearAllActions());
        AssignCommand(oDomin, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oFamil)) {
        AssignCommand(oFamil, ClearAllActions());
        AssignCommand(oFamil, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oSummon)) {
        AssignCommand(oSummon, ClearAllActions());
        AssignCommand(oSummon, JumpToLocation(oLoc));
    }
    if (GetIsObjectValid(oAnimalComp)) {
        AssignCommand(oAnimalComp, ClearAllActions());
        AssignCommand(oAnimalComp, JumpToLocation(oLoc));
    }
}
*/