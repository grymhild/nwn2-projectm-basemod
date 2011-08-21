/** @file
* @brief Include File for Waypoints
*
* Just Enough to Get things working 
* 
*
* @ingroup scinclude

*/

const string RR_WAYPOINT_CONTROLLER 	= "nw_waypoint001"; // Res Ref

const string WW_DAY_POST_PREFIX			= "POST_";
const string WW_NIGHT_POST_PREFIX		= "NIGHT_";
const string WW_WP_PREFIX				= "WP_";
const string WW_WN_PREFIX				= "WN_";
const string WW_NUM						= "NUM";
const string WAYPOINT_CONTROLLER_PREFIX = "WC_";

const string VAR_WC_TAG					= "WC_TAG";
	
// vars on the creature
const string VAR_WP_TAG					= "WP_TAG";				// string tag to use instead of creature tag for initialization
const string VAR_WP_SINGLE_POINT_OVERRIDE = "WP_SINGLE_POINT_OVERRIDE"; // boolean, if true then run normally even if only 1 wp

const string VAR_KICKSTART_REPEAT_COUNT = "N2_KICKSTART_REPEAT_COUNT";	// int counter
const string VAR_FORCE_RESUME 			= "N2_FORCE_RESUME";	// boolean
const string VAR_WWP_CONTROLLER 		= "WWP_CONTROLLER";		// WWP Controller Object
const string VAR_WP_PREVIOUS			= "WP_PREV";			// int
const string VAR_WP_CURRENT				= "WP_CUR";				// int
const string VAR_WP_NEXT				= "WP_NEXT";			// int
const string sWalkwayVarname 			= "NW_WALK_CONDITION";	// bit flags, see below

// If set, the creature's waypoints have been initialized.
const int NW_WALK_FLAG_INITIALIZED		= 0x00000001;

// If set, the creature will walk its waypoints constantly,
// moving on in each OnHeartbeat event. Otherwise,
// it will walk to the next only when triggered by an
// OnPerception event.
const int NW_WALK_FLAG_CONSTANT         = 0x00000002;

// Set when the creature is walking day waypoints.
const int NW_WALK_FLAG_IS_DAY           = 0x00000004;

// Set when the creature is walking back
const int NW_WALK_FLAG_BACKWARDS        = 0x00000008;

// Set to Turn off WWP
const int NW_WALK_FLAG_PAUSED           = 0x00000010;


#include "_CSLCore_Math"
#include "_CSLCore_Objects"
#include "_CSLCore_Visuals"
#include "_CSLCore_Messages"
//#include "_SCInclude_AI_c"
#include "_CSLCore_Reputation"

void SCWalkWayPoints(int bKickStart=FALSE, string sWhoCalled="unknown", int bForcResumeOverride=FALSE);



// Spawn in creature sTemplate at the location of the waypoint with tag sWPTag.
object SpawnObjectAtWP(int nObjectType, string sTemplate, string sWPTag, int bUseAppearAnimation=FALSE, string sNewTag="")
{
	object oObject = OBJECT_INVALID;

	//object oWP = GetWaypointByTag(sWPTag);
	object oWP = GetObjectByTag(sWPTag);
	
	if (GetIsObjectValid(oWP) == TRUE)
	{	
		location lWP = GetLocation(oWP);
		oObject = CreateObject(nObjectType, sTemplate, lWP, bUseAppearAnimation, sNewTag);
		if (!GetIsObjectValid(oObject))
		{
			PrintString ("SpawnObjectAtWP: " + " Failed! " + sTemplate + "@" + sWPTag);
		}
	}
	else
	{
		PrintString ("SpawnObjectAtWP: " + " Waypoint invalid! " + sTemplate + "@" + sWPTag);
	}

	return (oObject);
}

// spawns creature at each wp with specified tag
int SpawnObjectsAtWPs(int nObjectType, string sTemplate, string sWPTag, int bUseAppearAnimation = FALSE, string sNewTag="", int bThisAreaOnly=TRUE)
{
	int i = 0;
	object oTargetWP = GetObjectByTag(sWPTag, i);
	location lTargetWP;
	object oThisArea = GetArea(OBJECT_SELF);
	while (GetIsObjectValid(oTargetWP))
	{
		if (bThisAreaOnly && (GetArea(oTargetWP) != oThisArea))
			continue;
			
		lTargetWP = GetLocation(oTargetWP);
		CreateObject(nObjectType, sTemplate, lTargetWP, bUseAppearAnimation, sNewTag);
		i++;
		oTargetWP = GetObjectByTag(sWPTag,i);
	}
	//PrintString ("SpawnObjectsAtWPs: Created " + IntToString(i) + " of resref " + sTemplate);
	return(i);
}	

// Spawn in creature sTemplate at the location of the waypoint with tag sWPTag.
object SpawnCreatureAtWP(string sTemplate, string sWPTag, int bUseAppearAnimation = FALSE, string sNewTag="")
{
	return(SpawnObjectAtWP(OBJECT_TYPE_CREATURE, sTemplate, sWPTag, bUseAppearAnimation, sNewTag));
}
	
// Spawn in placeable sTemplate at the location of the waypoint with tag sWPTag.
object SpawnPlaceableAtWP(string sTemplate, string sWPTag, int bUseAppearAnimation = FALSE, string sNewTag="")
{
	return(SpawnObjectAtWP(OBJECT_TYPE_PLACEABLE, sTemplate, sWPTag, bUseAppearAnimation, sNewTag));
}



// spawns creature at each wp with specified tag
int SpawnCreaturesAtWPs(string sTemplate, string sWPTag, int bUseAppearAnimation=FALSE, string sNewTag="", int bThisAreaOnly=TRUE)
{
	return(SpawnObjectsAtWPs(OBJECT_TYPE_CREATURE, sTemplate, sWPTag, bUseAppearAnimation, sNewTag, bThisAreaOnly));
}

// spawns placeable at each wp with specified tag
int SpawnPlaceablesAtWPs(string sTemplate, string sWPTag, int bUseAppearAnimation = FALSE, string sNewTag="", int bThisAreaOnly=TRUE)
{
	return(SpawnObjectsAtWPs(OBJECT_TYPE_PLACEABLE, sTemplate, sWPTag, bUseAppearAnimation, sNewTag, bThisAreaOnly));
}





// Check for a waypoint marked NW_HOME in the area; if it
// exists, mark it as the caller's home waypoint.
void SCSetCreatureHomeWaypoint()
{
    object oHome = GetNearestObjectByTag("NW_HOME");
    if (GetIsObjectValid(oHome)) {
        CSLSetAnimationCondition(CSL_ANIM_FLAG_HAS_HOME);
        SetLocalObject(OBJECT_SELF, "NW_ANIM_HOME", oHome);
    }
}

// Get a creature's home waypoint; returns OBJECT_INVALID if none set.
object SCGetCreatureHomeWaypoint()
{
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_HAS_HOME)) {
        return GetLocalObject(OBJECT_SELF, "NW_ANIM_HOME");
    }
    return OBJECT_INVALID;
}





void SCSetHangOutSpot(string sRMRosterName, string sHangOutWPTag)
{
	string sVarName = sRMRosterName + "HangOut";
	SetGlobalString(sVarName, sHangOutWPTag);
}

string SCGetHangOutSpot(string sRMRosterName)
{
	string sVarName = sRMRosterName + "HangOut";
	string sHangOutWPTag = GetGlobalString(sVarName);
	return (sHangOutWPTag);
}


object SCGetHangoutObject(string sRMRosterName)
{
	object oHangOut;
	// is current hang out spot to be found in this module?
	string sHangOutWPTag = SCGetHangOutSpot(sRMRosterName);
	if (sHangOutWPTag != "")
	{
		//PrettyDebug(" - sHangOutWPTag =" + sHangOutWPTag);
		oHangOut = GetObjectByTag(sHangOutWPTag);
	}		
	return (oHangOut);
}




// get waypoint we are currently en route to
int SCGetNextWaypoint()
{
    return (GetLocalInt(OBJECT_SELF, VAR_WP_NEXT));
}


// return creature's current wwp controller
object SCGetWWPController(object oCreature=OBJECT_SELF)
{
	object oWWPController = GetLocalObject(oCreature, VAR_WWP_CONTROLLER);
	//PrettyDebug("SC GetWWPController() - Tag = " + GetTag(oWWP Controller)); 
	return (oWWPController);
}



// Get Current WP Prefix 
string SCGetWPPrefix(object oCreature = OBJECT_SELF)
{
    string sPrefix = WW_WP_PREFIX;

    if ( CSLGetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER", CSL_FLAG_DAY_NIGHT_POSTING ) && !GetIsDay())
    {
    	sPrefix = WW_WN_PREFIX;
	}
	return(sPrefix);
}


// Retrieves specified WP object for oCreature's WWP Controller
object SCGetWaypointByNum(int iWayPoint, string sPrefix=WW_WP_PREFIX, object oCreature=OBJECT_SELF)
{
	object oWWPController = SCGetWWPController(oCreature);
    object oRet = GetLocalObject(oWWPController, SCGetWPPrefix() + IntToString(iWayPoint));
    return (oRet);
}




	


// Get the number of the nearest of the creature's current
// set of waypoints (respecting day/night).
int SCGetNearestWalkWayPoint(object oCreature=OBJECT_SELF)
{
	object oWWPController = SCGetWWPController(oCreature);

    string sPrefix = SCGetWPPrefix();
    int nNumPoints = GetLocalInt(oWWPController, sPrefix + WW_NUM);

	if (nNumPoints < 1) 
		return -1;
    int i;
    int nNearest = -1;
    float fDist = 1000000.0;

    object oTmp;
    float fTmpDist;
    for (i=1; i <= nNumPoints; i++) 
	{
        oTmp = GetLocalObject(oWWPController, sPrefix + IntToString(i));
        fTmpDist = GetDistanceBetween(oTmp, oCreature);
        if (fTmpDist >= 0.0 && fTmpDist < fDist) 
		{
            nNearest = i;
            fDist = fTmpDist;
        }
    }
    return nNearest;
}



// normally we use the tag of the creature, but this can be overridden by using local string "WP_TAG"
// returns tag to use for purpose of initializing waypoints.
string SCGetWPTag(object oCreature=OBJECT_SELF)
{
	string sWPTag = GetLocalString(oCreature, VAR_WP_TAG);
	if (sWPTag == "")
		sWPTag = GetTag(oCreature);

	return (sWPTag);
}



// Get whether the specified SC WalkWayPoints condition is set
int SCGetWalkCondition(int nCondition, object oCreature=OBJECT_SELF)
{
    return (GetLocalInt(oCreature, sWalkwayVarname) & nCondition);
}

// Set a given SC WalkWayPoints condition
void SCSetWalkCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF)
{
	CSLSetLocalIntBitState(oCreature, "NW_WALK_CONDITION", nCondition, bValid ); 

	/*
	int nCurrentCond = GetLocalInt(oCreature, "NW_WALK_CONDITION");
	if (bValid)
	{
		// the bit that is true will be set to true in the result
		SetLocalInt(oCreature, sWalkwayVarname, nCurrentCond | nCondition);
	}
	else
	{
		// take complement of conditon and "and" it with current conditions which means
		// everything preserved except the bit passed in which will be set to 0
		SetLocalInt(oCreature, "NW_WALK_CONDITION", nCurrentCond & ~nCondition);
    	}
	*/
}



// returns the number of waypoints for creature's walkwaypoint controller, according to the current time of day
int SCGetNumWaypoints(object oCreature=OBJECT_SELF)
{
	object oWWPController = SCGetWWPController(oCreature);
	int iNumWaypoints = GetLocalInt(oWWPController, SCGetWPPrefix() + WW_NUM);
    return (iNumWaypoints);
}


// Get a waypoint number suffix, padded if necessary
string SCGetWaypointSuffix(int i)
{
    if (i < 10) {
        return "0" + IntToString(i);
    }
    return IntToString(i);
}


// look up all the walk way points for this controller.
// since we are creating the waypoint controller at the same location as the creture to
// walk it, we can use either for the location for GetNearest
void SCLookUpWalkWayPointsSet(object oWWPController, string sPrefix, string sPost)
{
    // check if the module enables area transitions for walkwaypoints
    int bCrossAreas = GetLocalInt(GetModule(),"X2_SWITCH_CROSSAREA_WALKWAYPOINTS");
					
    string sTag = sPrefix + GetLocalString(oWWPController, VAR_WC_TAG) + "_"; // sPrefix will be "WP_" or "WN_"

    int nNth=1;
    object oWay;

    if (!bCrossAreas)
    {
        oWay = GetNearestObjectByTag(sTag + SCGetWaypointSuffix(nNth));
    }
    else
    {
       oWay = GetObjectByTag(sTag + SCGetWaypointSuffix(nNth));
    }

	// if no valid waypoints then look for a post.
    if (!GetIsObjectValid(oWay)) {
        if (!bCrossAreas)
        {
            oWay = GetNearestObjectByTag(sPost + SCGetWPTag());
        }
        else
        {
            oWay = GetObjectByTag(sPost + SCGetWPTag());
        }
        if (GetIsObjectValid(oWay)) {
            // no waypoints but a post
            SetLocalInt(oWWPController, sPrefix + WW_NUM, 1);
            SetLocalObject(oWWPController, sPrefix + "1", oWay);
        } else {
            // no waypoints or post
            SetLocalInt(oWWPController, sPrefix +WW_NUM, -1);
        }
    } 
	else 
	{
        // look up and store all the waypoints
        while (GetIsObjectValid(oWay)) 
		{
            SetLocalObject(oWWPController, sPrefix + IntToString(nNth), oWay);
            nNth++;
            if (!bCrossAreas)
            {
                oWay = GetNearestObjectByTag(sTag + SCGetWaypointSuffix(nNth));
            }
            else
            {
                oWay = GetObjectByTag(sTag + SCGetWaypointSuffix(nNth));
            }
        }
        nNth--;
        SetLocalInt(oWWPController, sPrefix + WW_NUM, nNth);
    }
}








// Look up the Waypoint Controllers waypoints and store them (on the Waypoint Controller).
void SCLookUpWalkWayPoints(object oWWPController)
{

	SCLookUpWalkWayPointsSet(oWWPController, WW_WP_PREFIX, WW_DAY_POST_PREFIX);

	if( !CSLGetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER",CSL_FLAG_DAY_NIGHT_POSTING)) 
	{
	    // no night-time waypoints: set number of night time waypoints to -1
	    SetLocalInt(oWWPController, WW_WN_PREFIX + WW_NUM, -1); // WW_WN_PREFIX + WW_NUM = "WN_NUM"
	} 
	else 
	{
		SCLookUpWalkWayPointsSet(oWWPController, WW_WN_PREFIX, WW_NIGHT_POST_PREFIX);
	}
}

// Create a WWP Controller (presumably a requested one did not exist)
// The following variables will be set up on the WWP Controller:
// Waypoint variables:
//      WP_NUM     	: number of day waypoints
//      WN_NUM     	: number of night waypoints
//      WP_#, WN_# 	: the waypoint objects
//		WC_TAG		: string - base tag (for use in creating the script name)
object SCCreateWWPController(string sWalkWayPointsTag)
{
	// we need unique tag for locating waypoints controllers: "WC_<tag>"
	string sWaypointControllerTag = WAYPOINT_CONTROLLER_PREFIX + sWalkWayPointsTag;
	object oWWPController = CreateObject(OBJECT_TYPE_WAYPOINT, RR_WAYPOINT_CONTROLLER, GetLocation(OBJECT_SELF), FALSE, sWaypointControllerTag);
	SetLocalString(oWWPController, VAR_WC_TAG, sWalkWayPointsTag);
	SCLookUpWalkWayPoints(oWWPController);
	//PrettyDebug("SC CreateWWPController(" + sWalkWayPointsTag + ") - WP_NUM = " + IntToString(GetLocalInt(oWWPController, "WP_NUM")));
	
	return (oWWPController);
}


// Changes the waypoint set this creature will walk
// returns the waypoint controller object found or created.
// sWalkWayPointsTag is the tag of the creature the waypoints are designed for, i.e. no prefix or suffix
object SCSetWWPController(string sWalkWayPointsTag, object oCreature=OBJECT_SELF)
{
	//PrettyDebug("SC SetWWPController() - Start"); 

	// find the Waypoint Controller Object
	string sWWPControllerTag = WAYPOINT_CONTROLLER_PREFIX + sWalkWayPointsTag;
	object oWWPController = GetWaypointByTag(sWWPControllerTag);

	// if doesn't exist then create it.
	if (!GetIsObjectValid(oWWPController))
	{
		oWWPController = SCCreateWWPController(sWalkWayPointsTag);
	}
	// store the Waypoint Controller object (and associated tag) on the creature
	SetLocalObject(oCreature, VAR_WWP_CONTROLLER, oWWPController);
	SetLocalString(oCreature, VAR_WP_TAG, sWalkWayPointsTag);

	// if creature's controller has waypoints, then set walk flag and find nearest in set.
	int iNumWaypoints = SCGetNumWaypoints(oCreature);
	if (iNumWaypoints > 0)
	{
		// Make sure walk flag gets set so that hearbeat will fire.
		// (Won't be set if there is no waypoint set when creature spawns)
		SCSetWalkCondition(NW_WALK_FLAG_CONSTANT);
		
		// default next to closest wp.
	    SetLocalInt(oCreature, VAR_WP_NEXT, SCGetNearestWalkWayPoint(oCreature));
	}	

	//PrettyDebug("SC SetWWPController() - Tag = " + GetTag(oWWPController)); 
	return (oWWPController);
}


// Initialize WWP Controller.  This will set object to use the WWP controller with tag "WC_<Creature TAG>"
object SCInitWWPController(object oCreature=OBJECT_SELF)
{	
    SCSetWalkCondition(NW_WALK_FLAG_INITIALIZED, TRUE, oCreature);
	string sWPTag = SCGetWPTag(oCreature);
	object oWWPController = SCSetWWPController(sWPTag, oCreature);

	// Use appropriate skills, only once
	// * GZ: 2003-09-03 - ActionUseSkill never worked, added the new action mode stuff
	if(CSLGetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER",CSL_FLAG_STEALTH)) {
	    SetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH,TRUE);
	}
	
	// * GZ: 2003-09-03 - ActionUseSkill never worked, added the new action mode stuff
	if(CSLGetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER",CSL_FLAG_SEARCH)){
	    SetActionMode(OBJECT_SELF,ACTION_MODE_DETECT,TRUE);
	}
	return (oWWPController);
}


// returns the number of waypoints for creature's walkwaypoint controller, according to specific prefix (WW_WP_PREFIX or WW_WN_PREFIX)
int SCGetNumWaypointsByPrefix(string sPrefix=WW_WP_PREFIX, object oCreature=OBJECT_SELF)
{
	object oWWPController = SCGetWWPController(oCreature);
    return (GetLocalInt(oWWPController, sPrefix + WW_NUM));
}



// Return whether oCreature is posted (just 1 spot to go).
// Also, if posted then go to that spot.
int SCGetIsPosted(object oCreature=OBJECT_SELF)
{
	string sPrefix = SCGetWPPrefix();
	int nPoints = SCGetNumWaypointsByPrefix(sPrefix);
	if ((nPoints == 1) && (GetLocalInt(oCreature, VAR_WP_SINGLE_POINT_OVERRIDE)==FALSE))
	{
		//PrettyDebug(GetName(OBJECT_SELF) + ": only found 1 wp");
		object oWay = SCGetWaypointByNum(1, sPrefix);
    	ActionMoveToObject(oWay);
    	ActionDoCommand(SetFacing(GetFacing(oWay)));
		return (TRUE);
    }
	return (FALSE);
}





// returns whether we need to switch over to day or night waypoint set.
// Modify stuff if we do need to switch.
int SCGetDayNightSwitch(object oCreature=OBJECT_SELF)
{
	int bTimeToSwitch = FALSE;
	if (CSLGetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER",CSL_FLAG_DAY_NIGHT_POSTING)) 
	{
		int bIsWalkingDay = SCGetWalkCondition(NW_WALK_FLAG_IS_DAY, oCreature);

		if ( (bIsWalkingDay && !GetIsDay()) || (!bIsWalkingDay && GetIsDay()) ) 
		{
			//PrettyDebug("Switch to day=" + IntToString(!bIsWalkingDay));

			// time to switch to different set of waypoints
			bTimeToSwitch = TRUE;
			SCSetWalkCondition(NW_WALK_FLAG_IS_DAY, !bIsWalkingDay, oCreature);

			// reset next which will send us off to the nearest wp in other set
			SetLocalInt(oCreature, VAR_WP_NEXT, -1);
		}
	}
	return (bTimeToSwitch);
}


// Determine and return the creature's next waypoint.
// If it has just become day/night, or if this is the first time we're getting a waypoint, we go
// to the nearest waypoint in our new set.
// vars stored on creatures to track their progression through the waypoints
//        WP_PREV    : the last waypoint number
//        WP_CUR     : the current waypoint number
//        WP_NEXT    : the next waypoint number
object SCGetNextWalkWayPoint(object oCreature=OBJECT_SELF)
{
    string sPrefix = SCGetWPPrefix();
	int bDayNightSwitch = SCGetDayNightSwitch();
	int nPoints = SCGetNumWaypointsByPrefix(sPrefix);

    // Get the new current waypoint
	int nPrevWay 	= GetLocalInt(oCreature, VAR_WP_CURRENT);
    int nCurWay 	= GetLocalInt(oCreature, VAR_WP_NEXT);
    int nNextWay	= nCurWay; // this will be incremented or decremented below.

	// save previous waypoint for use in determining other actions.
   	//SetLocalInt(oCreature, VAR_WP_CURRENT, nCurWay);

    // Check to see if this is the first time
    if (nCurWay == -1) {
        nNextWay = SCGetNearestWalkWayPoint(oCreature);
    } else {
        // we're either walking forwards or backwards -- check
        int bGoingBackwards = SCGetWalkCondition(NW_WALK_FLAG_BACKWARDS, oCreature);
        if (bGoingBackwards) {
            nNextWay--;
            if (nNextWay < 1) {
                nNextWay = 2;
                SCSetWalkCondition(NW_WALK_FLAG_BACKWARDS, FALSE, oCreature);
            }
        } else {
            nNextWay++;
            if (nNextWay > nPoints) {
                nNextWay = nNextWay - 2;
                SCSetWalkCondition(NW_WALK_FLAG_BACKWARDS, TRUE, oCreature);
            }
        }
    }

    // update the points
    SetLocalInt(oCreature, VAR_WP_NEXT, nNextWay);
    SetLocalInt(oCreature, VAR_WP_CURRENT, nCurWay);
    SetLocalInt(oCreature, VAR_WP_PREVIOUS, nPrevWay);

	// don't execute scripted waypoints when switching from day to night 
	// as this could cause weirdness.
	if (!bDayNightSwitch)
	{
		// script can update WP_NEXT to override next waypoint location
	    string sScript = sPrefix + GetLocalString(OBJECT_SELF, VAR_WP_TAG);
	    ExecuteScript(sScript, oCreature);
	    nNextWay = GetLocalInt(oCreature, VAR_WP_NEXT); // check in case script changed this value
	}

	// not sure what this is protecting against...
    //if (nNextWay == -1)
	//	return OBJECT_INVALID;

	object oRet = SCGetWaypointByNum(nNextWay, sPrefix);
	//PrettyDebug(GetName(OBJECT_SELF) + ": tag of next wp = " + GetTag(oRet));
    return oRet;
}




// checks that we aren't fighting, talking, or see enemies.
int SCIsOkToWalkWayPoints()
{
    // * don't interrupt current circuit
    object oNearestEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    int bIsEnemyValid = GetIsObjectValid(oNearestEnemy);

    // * if I can see an enemy I should not be trying to walk waypoints
    if (bIsEnemyValid == TRUE)
    {
        if( GetObjectSeen(oNearestEnemy) == TRUE)
        {
            return FALSE;
        }
    }

    if ( ( GetIsObjectValid(GetAttemptedAttackTarget()) || GetIsObjectValid(GetAttemptedSpellTarget()) ) || IsInConversation(OBJECT_SELF))
	{
		//PrettyDebug(GetName(OBJECT_SELF) + "--- aborted SC WalkWayPoints due to convo or fight called by --");
		SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, 100);
        return FALSE;
	}

	return TRUE;
}



// Does the basic walking actions for SC WalkWayPoints
void SCDoWalkWayPointStandardActions(object oWay, int bKickStart)
{
    if (GetIsObjectValid(oWay) == TRUE)
    {
        SCSetWalkCondition(NW_WALK_FLAG_CONSTANT);
		
        if((bKickStart == TRUE) || (GetLocalInt(OBJECT_SELF,"N2_OVERRIDE_MOVE") == 0))
        {
        	ActionMoveToObject(oWay);
        }

        ActionDoCommand(SCWalkWayPoints(FALSE, "Action Queue"));      
    }
    // GZ: 2003-09-03
    // Since this wasnt implemented and we we don't have time for this either, I
    // added this code to allow builders to react to CSL_FLAG_SLEEPING_AT_NIGHT.
    if(GetIsNight())
    {
        if(CSLGetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER",CSL_FLAG_SLEEPING_AT_NIGHT))
        {
            string sScript = GetLocalString(GetModule(),"X2_S_SLEEP_AT_NIGHT_SCRIPT");
            if (sScript != "")
            {
                ExecuteScript(sScript,OBJECT_SELF);
            }
        }
	}
}


// Move to the next waypoint based on whether we are kickstarting
void SCMoveToNextWaypoint(int bKickStart=FALSE, int bForcResumeOverride=FALSE)
{
    // if paused then do nothing.
    if (SCGetWalkCondition(NW_WALK_FLAG_PAUSED))
        return;


	// if NPC busy doing anything, then don't try to walk.
    int iCurrentAction = GetCurrentAction(OBJECT_SELF);

	// Force resume will interrupt actions such as sitting.  
    int bForceResume = GetLocalInt(OBJECT_SELF, VAR_FORCE_RESUME) || bForcResumeOverride;

    if (bForceResume == TRUE)
    {
		bKickStart = TRUE;
        SetLocalInt(OBJECT_SELF, VAR_FORCE_RESUME, FALSE);
        if ((iCurrentAction != ACTION_SIT) && (iCurrentAction != ACTION_INVALID))
        {
            // we're busy doing some action other than sitting so no need to resume.
            return;
        }
    }
    else 
	{
		if (iCurrentAction != ACTION_INVALID)
        	return;
	
		// only kickstart if we are known to need it or if it's happened three times in a row
		if (bKickStart == TRUE)
		{
			int iKickStartRepeatCount = GetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT) + 1;
			SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, iKickStartRepeatCount);
			if (iKickStartRepeatCount < 3)
				return;
		}
	}

	// we made it, so we no longer need a kickstart
	SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, 0);

    // heartbeat and perceive can add extra calls to walk way points and
    // these can get through even if we are already doing something since
    // some thing like ActionPlayAnimation, SetFacing, etc. don't register as an action
    ClearAllActions();
	
    // Initialize if necessary
    if (!SCGetWalkCondition(NW_WALK_FLAG_INITIALIZED)) {
		// This should only ever be invalid the very first time 
		SCInitWWPController(OBJECT_SELF);
	}


    // Move to the next waypoint
    object oWay;
	if (SCGetIsPosted())
	{
		// if posted just head there
		oWay = OBJECT_INVALID;
	}	
	// Kickstart means we'll head to whatever is currently our next waypoint.
	// otherwise we'll determine a new next waypoint and go there.
    else if (bKickStart)
    {
        oWay = SCGetWaypointByNum(SCGetNextWaypoint(), SCGetWPPrefix()); // where was I going?
        //PrettyDebug("Doing kickstart to " + GetTag(oWay));
    }
    else
	{
        oWay = SCGetNextWalkWayPoint(OBJECT_SELF);
	}
	if (GetIsObjectValid(oWay))
    	SCDoWalkWayPointStandardActions(oWay, bKickStart);
}






// Make the caller walk through their waypoints or go to their post.
// 5/17/05 - modified to exit if paused and to not interrupt if creature is currently doing
// any action detectable by GetCurrentAction()
void SCWalkWayPoints(int bKickStart=FALSE, string sWhoCalled="unknown", int bForcResumeOverride=FALSE)
{
	//PrettyDebug(GetName(OBJECT_SELF) + "--- starting SC WalkWayPoints called by " + sWhoCalled);
	if (!SCIsOkToWalkWayPoints())
		return;
	SCMoveToNextWaypoint(bKickStart, bForcResumeOverride);	
    //PrettyDebug(GetName(OBJECT_SELF) + "---- leaving SC WalkWayPoints called by " + sWhoCalled);
}


object PlaceObjectAtTag( int iObjectType, string sObjectTag, string sDestinationTag, string sObjectResRef )
{
	object oObject = CSLGetTarget( sObjectTag );
	object oDest = CSLGetTarget( sDestinationTag );
	location lDest;

	if ( !GetIsObjectValid(oDest) )
	{
		//ErrorMessage( "Passed invalid destination tag to PlaceObjectAtTag" );
		return OBJECT_INVALID;
	}
	else lDest = GetLocation( oDest );
	
	if ( GetIsObjectValid(oObject) )
	{
		AssignCommand( oObject, JumpToObject(oDest) );
		return oObject;
	}
	else
	{
		if ( sObjectResRef != "" )
		{
			return CreateObject( iObjectType, sObjectResRef, lDest, FALSE, sObjectTag );
		}
		else 
		{
			//ErrorMessage( "Passed invalid object resref to PlaceObjectAtTag" );
			return OBJECT_INVALID;			
		}
	}
	
	return OBJECT_INVALID;
}

object PlaceCreatureAtTag( string sCreatureTag, string sDestinationTag, string sCreatureResRef )
{
	return PlaceObjectAtTag( OBJECT_TYPE_CREATURE, sCreatureTag, sDestinationTag, sCreatureResRef );
}

object PlacePlaceableAtTag( string sPlaceableTag, string sDestinationTag, string sPlaceableResRef )
{
	return PlaceObjectAtTag( OBJECT_TYPE_PLACEABLE, sPlaceableTag, sDestinationTag, sPlaceableResRef );
}

object PlaceItemAtTag( string sItemTag, string sDestinationTag, string sItemResRef )
{
	return PlaceObjectAtTag( OBJECT_TYPE_ITEM, sItemTag, sDestinationTag, sItemResRef );
}