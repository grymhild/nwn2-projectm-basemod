// ga_set_wwp_controller
/*
	Changes the waypoint set specified creature will walk. 
	This overrides whatever the creature's tag is.
	sWalkWayPointsTag is the tag of the creature the waypoints are designed for, i.e. no prefix or suffix
	Note that walkwaypoints is interrupted by being in a conversation.
	Creature must use a script set that supports WWP to work long-term.
*/
// ChazM 7/9/06
// ChazM 7/9/06 - SCGetNextWalkWayPoint() calls a bunch of other stuff we don't want - used alt method.
// ChazM 8/13/06 - simplified script

#include "_SCInclude_Waypoints"
#include "_CSLCore_Messages"

void UpdateWWPController(string sWalkWayPointsTag)
{
	//SpawnScriptDebugger();
	object oWWPController = SCSetWWPController(sWalkWayPointsTag);

	// This will get creature started now instead of waiting for the hearbeat following the end of the conversation.
	// Note: SCWalkWayPoints() won't do anything if called while creature is in a conversation. (WWP is desinged not to interrupt conversations).
	SCMoveToNextWaypoint(TRUE, TRUE);
}

void main(string sTarget, string sWalkWayPointsTag)
{
	object oTarget = CSLGetTarget(sTarget);
	AssignCommand(oTarget, UpdateWWPController(sWalkWayPointsTag));
}