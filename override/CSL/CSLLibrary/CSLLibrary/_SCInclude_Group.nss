// ginc_group
/*
	Framework and functions for working with groups of objects (usually creatures)
	
	How to use:
	1. use SCResetGroup() to clear out/delete a group before use to avoid side effects
	2. add creatures to your group using the functions under the label *** Group creation ***
	3. set up formations, noise and events to fire -- under *** Group Formation and Noise setup ***
	4. give group actions -- under *** Group Actions ***
	
	Notes:
	When creating groups, a creature already in a group will not join another.  Some functions have params
	to overide this, but it is not recommended and can have odd side effects.

*/
// ChazM 5/26/05
// ChazM 6/1/05 Changed ObjectGroups to use Globals instead of structs
// ChazM 6/2/05 added SCResetGroup, SCIsGroupEmpty, and SetObject.
// ChazM 6/6/05	now includes ginc_actions, added prototypes, moved constants to top, 
//				added RandomDelta(), RandomFloat(), GetNearbyLocation(), SCGroupAttack(), 
//				SCGroupPlayAnimation(), SCGroupActionWait, modified GetMoveToWP()
// EPF 6/7/05 Added support for a rectangular formation.
// ChazM 6/7/05 Added support for additional formation types with variable sets of params.  
//			Added SCGroupSetBMAFormation(), SCGroupSetCircleFormation(), SCGroupSetRectangleFormation(), SCGroupSetNoise(), 
//			modified SCGroupMoveToWP(), removed GetFormationLocationByIndex().  Added and modified some of the base funcs.
// ChazM 6/7/05 Added support for running in formation, added SCGroupClearAllActions()
// ChazM 6/8/05 modified FactionToGroup(), SCGetBMALocation(), SCGetHuddleLocation(), SCGroupMoveToWP(), added constants, numerous comments
// ChazM 6/15/05 added SCGetPartyGroup(), modified SCResetGroup(), added constants, added comments, added prototypes,
//			modified SCGroupMoveToWP to work better w/ defualts.  added SCGroupActionOrientToTag().
// ChazM 6/16/05 added SCGroupSetLocalString(), SCGroupOnDeathBeginConversation(), SCSetGroupString(), SCGetGroupString(), 
//			modified SCAddToGroup()
// ChazM 6/18/05 added EncounterToGroup(), modified SCAddToGroup()
// ChazM 6/18/05 added SCGroupSetSpawnInCondition(), modified EncounterToGroup()
// ChazM 6/20/05 added SCGroupWander()
// ChazM 6/21/05 added SCSpawnCreaturesInGroupAtWP()
// ChazM 6/27/05 modified SCResetGroup(), renamed bunch of "private" functions and all references, modified SCAddToGroup(), added SCInsertIntoGroup()
//				added some "how to use" comments, modified SCGetPartyGroup()
// ChazM 6/28/05 added DeleteGlobalObject(), modified SCGroupDeleteObjectIndex()
//  			added SCGroupActionForceExit(), SCGroupChangeFaction, SCGroupChangeToStandardFaction
// ChazM 7/1/05 added AddNearestWithTagToGroup(), SCGroupMoveToFormationLocation(), SCGroupActionMoveToObject(), 
//				modified SCGroupMoveToWP()
// ChazM 7/5/05 added SCGetFirstValidInGroupFromCurrent(), modified SCGetNextInGroup() and SCGetFirstInGroup()
// BMA 7/07/05 added SCGroupSetFacingPoint(), modified SCGroupActionOrientToTag()
// ChazM 7/11/05 shortened prefixes/postfixes
// ChazM 7/26/05 Fixed SCSpawnCreaturesInGroupAtWP(), changed FORMATION_NONE constant, added FORMATION_DEFAULT constant
// ChazM 7/26/05 added SCDestroyObjectsInGroup()
// ChazM 7/27/05 added prototype, modified print strings for SCInsertIntoGroup()
// BMA-OEI 7/29/05 added GroupJumpToObject(), MOVE_JUMP_INSTANT
// BMA-OEI 8/06/05 added debug prints to SCSpawnCreaturesInGroupAtWP, SCGroupSetLocalString
// BMA-OEI 8/25/05 added GroupAddXXX, MOVE_FORCE_WALK, MOVE_FORCE_RUN, SCGroupSetImmortal/PlotFlag
// BMA-OEI 8/26/05 added SCGroupSpawnAtLocation,SCGroupForceMoveToLocation 
// BDF-OEI 9/2/05 added SCGroupOnDeathSetLocalInt, SCGroupOnDeathSetLocalFloat, SCGroupOnDeathSetLocalString
// ChazM 9/8/05	added SCGroupActionForceFollowObject()
// ChazM 9/8/05 formatting changes, added SCGroupAddNearestTag(), SCGroupDetermineCombatRound(), SCGroupGoHostile();
//				modified SCGroupAddTag(); fixed FactionToGroup(), AddNearestWithTagToGroup(), SCGroupActionForceFollowObject()
// ChazM 9/12/05 added param bOverridePrevGroup to SCGroupAddMember, SCGroupAddTag, SCGroupAddNearestTag, and SCGroupAddEncounter
//				added SCGroupSetLocalObject(), GroupFollowLeader()
// ChazM 9/13/05 added SCGroupSurrenderToEnemies()
// ChazM 9/14/05 added SCGroupSetLocalInt(), SCGroupSetLocalFloat(), SCGroupStartFollowLeader(), SCGroupStopFollowLeader()
//				SCGroupActionMoveAwayFromObject(), SCGroupSurrenderToEnemies();
//				modified SCGroupActionForceFollowObject(); removed GroupFollowLeader()
// ChazM 9/15/05 added SCGroupMoveToObject(), SCGroupActionCastFakeSpellAtObject(), SendDebugMessage();
//				changed GroupJumpToObject() to SCGroupJumpToWP; modified SCAddToGroup(), FactionToGroup(), EncounterToGroup(), AddNearestWithTagToGroup()
// ChazM 9/15/05 added SCGroupApplyEffectToObject() and SCGroupRemoveEffectOfType()
// ChazM 9/29/05 added 3 new includes, removed SendDebugMessage, moved out GetGlobalObject(), SetGlobalObject(), DeleteGlobalObject() to ginc_vars;
//				RandomDelta(), RandomFloat(), GetNearbyLocation() to ginc_math
// BMA-OEI 10/26/05 added SCGroupSetLineFormation(), SCGetLineLocation(), modified SCGroupForceMoveToLocation(), SCGroupSpawnAtLocation(), SCGroupMoveToFormationLocation()
// BMA-OEI 11/06/05 added SCGroupSignalEvent()
// BMA-OEI 11/21/05 added SCGroupGetNumValidObjects(), SCGetIsGroupValid()
// BMA-OEI 11/29/05 updated SCGroupPlayAnimation() to check min float time
// BMA-OEI 11/29/05 updated SCGroupGetNumValidObjects(), SCGetIsGroupValid() parameter check HP > 0
// BMA-OEI 12/01/05 updated SCGroupGetNumValidObjects(), SCGetIsGroupValid() parameter check IsDead
// EPF 12/5/05 -- Added SCGroupOnDeathSetJournalEntry()
// EPF 1/12/06 -- added SCGroupSetSemicircleFormation and support for a new Semicircle formation.
// EPF 1/13/06 -- Fixed an off-by-one error in SCGroupAddNearestTag().
// EPF 1/30/06 -- missed a spot in the last fix, so SCGroupAddNearestTag was adding one too many.  Fixed.
// EPF 1/30/06 -- SCGroupAddTag() has a completely different off-by-one error.  Fixing.
// DBR 2/01/06 -- Added SCGetGroupName(), for retrieving the group that a creature is in (wrapper function)
// BMA-OEI 2/8/06 -- Added bFadeOut param to GroupOnDeathConversation()
// BMA-OEI 2/14/06 -- Removed bFadeOut param
// EPF 2/18/06 -- Added SCGroupSetScriptHidden().
// BMA-OEI 2/27/06 -- Added SCGroupFleeToExit()
// BMA-OEI 2/27/06 -- Added SCGroupResurrect()
// ChazM 3/16/06 modified SCSpawnCreaturesInGroupAtWP(), modified SCAddToGroup() - no longer marked as old.
// ChazM 4/19/06 Added SCGroupOnDeathExecuteCustomScript()
// BMA-OEI 5/23/06 -- Added SCIncGroupNumKilled(), GetGroupNumKiled(), GROUP_VAR_NUM_KILLED
// BMA-OEI 6/20/06 -- Added GroupSetIsDestroyable()
// BMA-OEI 7/04/06 -- Added SCGetIsGroupDominated()
// BMA-OEI 8/02/06 -- Update SCResetGroup() to check if still in group
// ChazM 9/21/06 -- added nw_i0_generic
// ChazM 5/10/07 -- added param bSetToHostile to SCGroupAttackGroup() and SCGroupAttack()
// ChazM 5/18/07 -- comment changes
// ChazM 5/30/07 -- modified SCGroupDetermineCombatRound() - decoupled DCR
// ChazM 5/30/07 -- GetGroupNumKiled -> SCGetGroupNumKilled.  Some OC module scripts might not compile, but the NCS will remain, so this shouldn't pose a problem.
// ChazM 5/31/07 -- modified SCGroupDetermineCombatRound() - now uses SCAssignDCR() in nw_i0_generic
// ChazM 6/6/07 -- added SCListMembersOfGroup()
// ChazM 6/27/07 -- Added function SCDoMoveType()
// ChazM 6/29/07 -- added fForceMoveTimeout param to SCDoMoveType()

//#include "ginc_actions"
#include "_CSLCore_Magic" // ginc_effect"
//#include "ginc_utility"
//#include "x0_i0_petrify"
//#include "ginc_vars"
#include "_CSLCore_Math"
#include "_CSLCore_Combat"
#include "_CSLCore_Position"
#include "_CSLCore_Visuals"

#include "_SCInclude_Events"

#include "_SCInclude_AI"
#include "_SCInclude_AI_c"
#include "_SCInclude_Waypoints"
//#include "nw_i0_generic"
//#include "x0_i0_spawncond"

//void main() {}

//-------------------------------------------------
// Public constants
//-------------------------------------------------

const int SCORIENT_FACE_TARGET			= 1;
const int SCORIENT_FACE_SAME_AS_TARGET 	= 2;

const int FORMATION_DEFAULT 			= 0;
const int FORMATION_BMA 				= 1;
const int FORMATION_HUDDLE_FACE_IN 		= 2;
const int FORMATION_HUDDLE_FACE_OUT 	= 3;
const int FORMATION_HUDDLE_FACE_FORWARD = 4;
const int FORMATION_RECTANGLE 			= 5;
const int FORMATION_NONE 				= 6;
const int FORMATION_LINE				= 7;
const int FORMATION_SEMICIRCLE_FACE_OUT	= 8;
const int FORMATION_SEMICIRCLE_FACE_IN 	= 9;

const int MOVE_WALK 					= 1;
const int MOVE_RUN 						= 2;
const int MOVE_JUMP 					= 3;
const int MOVE_JUMP_INSTANT 			= 4;
const int MOVE_FORCE_WALK 				= 5;
const int MOVE_FORCE_RUN 				= 6;
										
const int GROUP_LEADER_FIRST 			= -1;
const int GROUP_LEADER_LAST 			= -2;
const int GROUP_LEADER_EXCLUDE 			= -3;

const string PARTY_GROUP_NAME 			= "theParty";

const int TYPE_INT 						= 1;
const int TYPE_FLOAT 					= 2;
const int TYPE_STRING 					= 3;

// Private constants
const string GROUP_VAR_NUM_KILLED		= "NumKilled";
const string OBJ_GROUP_MY_GROUP			= "MyGroup"; // var name stored on objects (so object can identify the group he's in)
const string OBJ_GROUP_PREFIX 			= "_OG";
const string OBJ_GROUP_NUM				= "_Num";
const string OBJ_GROUP_INDEX			= "_Indx";
const string OBJ_GROUP_FORMATION_TYPE 	= "Fmn";
const string OBJ_GROUP_FORMATION_RADIUS = "Rad";
const string OBJ_GROUP_FORMATION_COLS 	= "Col";
const string OBJ_GROUP_FORMATION_SPACING = "Spc";
const string OBJ_GROUP_NOISE_START 		= "StN";
const string OBJ_GROUP_NOISE_FACING 	= "FcN";
const string OBJ_GROUP_NOISE_LOCATION 	= "LcN";

const float DEFAULT_SPACING				= 1.8f;

const float fSCGATHER_RADIUS = 200.0f;
const string SCVAR_GLOBAL_GATHER_PARTY = "bGATHER_PARTY_TRAN";
const string SCVAR_GLOBAL_NX2_TRANSITIONS = "bNX2_TRANSITIONS";

//-------------------------------------------------
// Public function Prototypes
//-------------------------------------------------

void SCGroupAddFaction(string sGroupName, object oFactionMember, int nLeaderPos=GROUP_LEADER_FIRST, int bOverridePrevGroup=FALSE);
void SCGroupSpawnAtLocation(string sGroupName, string sTemplate, location lLocation, int nNum);
void SCGroupSetBMAFormation(string sGroupName, float fSpacing=DEFAULT_SPACING);	// a staggered marching formation
void SCGroupMoveToFormationLocation(string sGroupName, location lDestination, int iMoveType=MOVE_WALK);	// locomote a group to a specified location (formation and noise should be set first)
void SCGroupSetLocalString (string sGroupName, string sVarName, string sValue);
void SCGroupSetSpawnInCondition(string sGroupName, int nCondition, int bValid=TRUE);
object SCGroupGetObjectIndex(string sGroupName, int iIndex);
int SCGroupGetNumObjects(string sGroupName);
object SCGetFirstInGroup(string sGroupName);
object SCGetNextInGroup(string sGroupName);

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

//-------------------------------------------------
// Helper functions

void SCListMembersOfGroup(string sGroupName)
{
	//PrettyDebug("Number of objects in Group " + sGroupName + ": " + IntToString(SCGroupGetNumObjects(sGroupName)));
	//PrettyDebug("Members of Group " + sGroupName + ": ");
	object oMember = SCGetFirstInGroup(sGroupName);
	int nCount = 0;

	while (GetIsObjectValid(oMember) == TRUE)
	{
		nCount++;
		//PrettyDebug(" Member " + IntToString(nCount) + ": " + GetName(oMember) + " tag: " + GetTag(oMember));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

location SCGetWPLocation(string sWayPoint)
{
	object oWaypoint = GetWaypointByTag(sWayPoint);
 	return (GetLocation(oWaypoint));
}

// Returns number of valid objects in a group
int SCGroupGetNumValidObjects(string sGroupName, int bIsDead = FALSE)
{
	int nCount = 0;
	int nPossible = SCGroupGetNumObjects(sGroupName);
	object oMember;
	int nHP;

	int i;
	for (i=0; i<=nPossible; i++)
	{
		oMember = SCGroupGetObjectIndex(sGroupName, i);
		
		if (GetIsObjectValid(oMember) == TRUE)
		{
			if (bIsDead == TRUE)
			{
				if (GetIsDead(oMember) == FALSE)
				{
					nCount = nCount + 1;
				}
			}
			else
			{
				nCount = nCount + 1;
			}
		}	
	}

	return (nCount);
}

// Returns true if at least one group member reference is valid
// If bNotDying is TRUE, only check members that are HP>0
int	SCGetIsGroupValid(string sGroupName, int bNotDying = FALSE)
{
	int nPossible = SCGroupGetNumObjects(sGroupName);

	object oMember;

	int i;
	for (i = 0; i <= nPossible; i++)
	{
		oMember = SCGroupGetObjectIndex(sGroupName, i);
		
		if (GetIsObjectValid(oMember) == TRUE)
		{
			if (bNotDying == FALSE)
			{
				return (TRUE);
			}
			else
			{
				if (GetIsDead(oMember) == FALSE)
				{
					return (TRUE);
				}
			}
		}
	}
	
	return (FALSE);
}

//Retrieves the group a creature is in
//returns the string of the group name, or "" if creature is not in a group
//		NOTE: may be some problem with creatures who were formerly in a group having the residual variable
string SCGetGroupName(object oMember)
{
	return GetLocalString(oMember,OBJ_GROUP_MY_GROUP);	
}

// Return TRUE, if all remaining members are dominated
int SCGetIsGroupDominated( string sGroupName )
{
	int nMax = SCGroupGetNumObjects( sGroupName );
	
	object oGM;
	int i;
	for ( i = 0; i <= nMax; i++ )
	{
		oGM = SCGroupGetObjectIndex( sGroupName, i );
		
		// If member is valid, alive, and not dominated
		if ( ( GetIsObjectValid(oGM) == TRUE ) &&
			 ( GetIsDead(oGM) == FALSE ) &&
			 ( CSLGetHasEffectType(oGM, EFFECT_TYPE_DOMINATED) == FALSE ) )
		{
			return ( FALSE );
		}
	}

	return ( TRUE );
}

//---------------------------------------------------------------
// Group Objects

object SCGroupGetObjectIndex(string sGroupName, int iIndex)
{
	string sThisObj = OBJ_GROUP_PREFIX + sGroupName + IntToString(iIndex);
	return (GetLocalObject(GetModule(),sThisObj));
}

void SCGroupSetObjectIndex(string sGroupName, int iIndex, object oObject)
{
	string sThisObj = OBJ_GROUP_PREFIX + sGroupName + IntToString(iIndex);
	SetLocalObject (GetModule(),sThisObj, oObject);
}

void SCGroupDeleteObjectIndex(string sGroupName, int iIndex)
{
	string sThisObj = OBJ_GROUP_PREFIX + sGroupName + IntToString(iIndex);
	DeleteLocalObject (GetModule(),sThisObj);
}


//---------------------------------------------------------------
// Group INTs

int SCGetGroupInt(string sGroupName, string sVarName)
{
	string sThisInt = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	return (GetGlobalInt(sThisInt));
}

void SCSetGroupInt(string sGroupName, string sVarName, int iValue)
{
	string sThisInt = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	SetGlobalInt(sThisInt, iValue);
}

void SCDeleteGroupInt(string sGroupName, string sVarName)
{
	string sThisInt = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	SetGlobalInt(sThisInt, 0);
}

//---------------------------------------------------------------
// Group FLOATs

float SCGetGroupFloat(string sGroupName, string sVarName)
{
	string sThisVar = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	return (GetGlobalFloat(sThisVar));
}

void SCSetGroupFloat(string sGroupName, string sVarName, float fValue)
{
	string sThisVar = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	SetGlobalFloat(sThisVar, fValue);
}

void SCDeleteGroupFloat(string sGroupName, string sVarName)
{
	string sThisVar = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	SetGlobalFloat(sThisVar, 0.0f);
}

//---------------------------------------------------------------
// Group Strings

string SCGetGroupString(string sGroupName, string sVarName)
{
	string sThisVar = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	return (GetGlobalString(sThisVar));
}

void SCSetGroupString(string sGroupName, string sVarName, string sValue)
{
	string sThisVar = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	SetGlobalString(sThisVar, sValue);
}


//---------------------------------------------------------------
// Group Objects

object SCGetGroupObject(string sGroupName, string sVarName)
{
	string sThisVar = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	return (GetLocalObject(GetModule(),sThisVar));
}

void SCSetGroupObject(string sGroupName, string sVarName, object oValue)
{
	string sThisVar = OBJ_GROUP_PREFIX + sGroupName + sVarName;
	SetLocalObject(GetModule(), sThisVar, oValue);
}


// returns current index
int SCGroupGetCurrentIndex(string sGroupName)
{
	return (SCGetGroupInt(sGroupName, OBJ_GROUP_INDEX));
}

void SCGroupSetCurrentIndex(string sGroupName, int iIndex)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_INDEX, iIndex);
}

// returns number of objects currently stored
int SCGroupGetNumObjects(string sGroupName)
{
	return (SCGetGroupInt(sGroupName, OBJ_GROUP_NUM));
}

void SCGroupSetNumObjects(string sGroupName, int iNumObjects)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_NUM, iNumObjects);
}


// return current object
object SCGroupGetCurrentObject(string sGroupName)
{
	return (SCGroupGetObjectIndex(sGroupName, SCGroupGetCurrentIndex(sGroupName)));
}

// increments index if possible
int SCGroupIncrementIndex(string sGroupName)
{
	int iCurrentIndex = SCGroupGetCurrentIndex(sGroupName);
	int iNumObjects = SCGroupGetNumObjects(sGroupName);

	if (iCurrentIndex >= iNumObjects)
	{
		return (0);
	}

	iCurrentIndex = iCurrentIndex + 1;
	SCGroupSetCurrentIndex(sGroupName, iCurrentIndex);

	PrintString("IncrementIndex: iCurrentIndex = " + IntToString (iCurrentIndex));
	return (iCurrentIndex);
}
	
// return first valid object in group starting w/ current.
// if no more in group, return OBJECT_INVALID
object SCGetFirstValidInGroupFromCurrent(string sGroupName)
{
	object oCurrent = SCGroupGetCurrentObject(sGroupName);
	// keep incrementing until we get valid object or reach end of list.
	while (!GetIsObjectValid(oCurrent))
	{
		if (!SCGroupIncrementIndex(sGroupName))
			return (OBJECT_INVALID);

		oCurrent = SCGroupGetCurrentObject(sGroupName);
	}
	return oCurrent;

}	

// resets index and returns first object
object SCGetFirstInGroup(string sGroupName)
{
	SCGroupSetCurrentIndex(sGroupName, 1);
	return (SCGetFirstValidInGroupFromCurrent(sGroupName));
	//return SCGroupGetCurrentObject(sGroupName);
}

// increments index to next valid object and returns current object
object SCGetNextInGroup(string sGroupName)
{
	if (!SCGroupIncrementIndex(sGroupName))
		return (OBJECT_INVALID);

	return (SCGetFirstValidInGroupFromCurrent(sGroupName));

}

// bOverridePrevGroup - add someone already in another group?
int SCInsertIntoGroup(string sGroupName, object oObject, int bOverridePrevGroup = FALSE)
{
	if (!GetIsObjectValid(oObject)) {
		PrintString ("ginc_group: SCInsertIntoGroup - failed - invalid object!");
		return 0;
	}
	// if not ok to override, then check if already in group.
	if (!bOverridePrevGroup)
	{
		if (GetLocalString(oObject, OBJ_GROUP_MY_GROUP) != ""){
			PrintString ("ginc_group: SCInsertIntoGroup - failed - " + GetName(oObject) + " already in another group");
			return 0;
		}
	}
	// track num object?			
	int iNumObjects = SCGroupGetNumObjects(sGroupName);
	iNumObjects = iNumObjects + 1;	
	SCGroupSetNumObjects (sGroupName, iNumObjects);
	PrintString("SCInsertIntoGroup - iNumObjects: " + IntToString(iNumObjects));

	// assign object				
	SCGroupSetObjectIndex(sGroupName, iNumObjects, oObject);

	// let object know what group he is in.
	SetLocalString(oObject, OBJ_GROUP_MY_GROUP, sGroupName);

	return (iNumObjects);
}


//-------------------------------------------------
// Functions that do things with Groups
//-------------------------------------------------

// Determine starting positions for "U6" formation columns: 2,3,4,5,6 indices
//  2 3		
// 5 4 6
vector SCGetBMAFormationStartPosition(vector vPosition, int nIndex, float fSpacing, float fFacing)
{
	int nCase = nIndex % 5;	// determine starting position if index > 6
	
	if ((nIndex == 0) || (nIndex == 1))
	{
		nCase = 4;
	}
	
	vector vNewPosition = vPosition;
	switch (nCase)
	{
		case 0: // column 1 (left most)
			vNewPosition = CSLGetChangedPosition(vPosition, fSpacing * 2, fFacing + 180.0);
			break;

		case 2: // column 2 (left)
			fSpacing = sqrt(pow(fSpacing, 2.0) * 2); 
			vNewPosition = CSLGetChangedPosition(vPosition, fSpacing, fFacing + 225.0);
			break;

		case 4: // column 3 (center)
			fSpacing = sqrt(pow(fSpacing, 2.0) * 2) * 2;
			vNewPosition = CSLGetChangedPosition(vPosition, fSpacing, fFacing + 225.0);
			break;

		case 3: // column 4 (right)
			fSpacing = sqrt(pow(fSpacing, 2.0) * 2);
			vNewPosition = CSLGetChangedPosition(vPosition, fSpacing, fFacing + 135.0);
			break;

		case 1: // column 5 (right most)
			fSpacing = sqrt(pow(fSpacing, 2.0) * 2) * 2; 
			vNewPosition = CSLGetChangedPosition(vPosition, fSpacing, fFacing + 135.0);
			break;
	}
	
	return vNewPosition;
}


// Determine location for "U6" formation:
//       1        fSpacing = distance between each row
//      2 3       first member of faction should jump to lToJumpTo
//     5 4 6      but does that 
//      7 8  etc.
location SCGetBMALocation(location lToJumpTo, int nIndex, float fSpacing)
{
	PrintString("SCGetBMALocation(" + IntToString(nIndex));
	object oArea = GetAreaFromLocation(lToJumpTo);
	vector vPosition = GetPositionFromLocation(lToJumpTo);
	float fFacing = GetFacingFromLocation(lToJumpTo);

	int nOffset = (nIndex - 2) / 5; // round to floor, determines row offset for indices > 6

	if (nIndex >= 2)
	{
		vPosition = SCGetBMAFormationStartPosition(vPosition, nIndex, fSpacing, fFacing);
		
		// Pushes the location back per row (indicies 7,8,9, etc.)
		if (nOffset >= 0)
		{
			vPosition = CSLGetChangedPosition(vPosition, IntToFloat(nOffset) * fSpacing * 2, fFacing + 180.0);
		}
	}

	location lNewLocation = Location(oArea, vPosition, fFacing);
	
	return lNewLocation;
}


location SCGetRectangleLocation(location lDestination, int nMemberIndex, int nColumns, float fSpacing)
{
	object oArea = GetAreaFromLocation(lDestination);
	vector vPosition = GetPositionFromLocation(lDestination);
	float fFacing = GetFacingFromLocation(lDestination);
	int nRow, nCol;
	nMemberIndex -= 1;	//Convert to 0-indexing for the math we're doing below

	nCol = (nMemberIndex % nColumns);
	
	//No divide by 0!
	if(nColumns == 0) 
	{
		nColumns = 1;
		PrintString("Error: Invalid parameter value for nColumns in rectangle formation");
	}
	nRow = nMemberIndex / nColumns;

	if(nCol != 0)
	{
		vPosition = CSLGetChangedPosition(vPosition, fSpacing * nCol, fFacing - 90.f);
	}
	if(nRow != 0)
	{
		vPosition = CSLGetChangedPosition(vPosition, fSpacing * nRow, fFacing + 180.f);
	}

	location lNewLocation = Location(oArea, vPosition, fFacing);

	return lNewLocation;
}


location SCGetHuddleLocation(location lDestination, int iMemberIndex, int iNumObjects, float fRadius=10.0f, int iFaceType=FORMATION_HUDDLE_FACE_IN)
{
	//avoid divide-by-0 errors
	if(iNumObjects == 0) 
		iNumObjects = 1;
	iMemberIndex -= 1;	//Convert to 0-indexing so first in group goes direction of waypoint.

	float fIncrement;

	if(iFaceType == FORMATION_SEMICIRCLE_FACE_OUT || iFaceType == FORMATION_SEMICIRCLE_FACE_IN)
	{
		if(iNumObjects == 1) iNumObjects == 2;	//hack fix for divide-by-0
		fIncrement = 180.f / IntToFloat(iNumObjects - 1);
	}
	else
	{
		fIncrement = 360.f / IntToFloat(iNumObjects);
	}

	float fAngle = fIncrement * iMemberIndex;

	//for a semicircle, it matters at what angle the semicircle begins.  We will use the 
	//base location's facing value (usually a waypoint), and start the semicircle 90 degrees
	//prior, so the midpoint on the semicircle arc is in the direction the waypoint points.
	if(iFaceType == FORMATION_SEMICIRCLE_FACE_OUT || iFaceType == FORMATION_SEMICIRCLE_FACE_IN)
	{
		fAngle += GetFacingFromLocation(lDestination) - 90.f;
		
	}

	// location lRet = SCGetHuddleLocation(lDestination, fAngle, fRadius);
	object oArea = GetAreaFromLocation(lDestination);
    float fFacing;
    vector vPos = fRadius * AngleToVector(fAngle); // create vector starting on origin
	switch (iFaceType)
	{
		case FORMATION_HUDDLE_FACE_IN:
		case FORMATION_SEMICIRCLE_FACE_IN:
    		fFacing = VectorToAngle(-1.0 * vPos);
			break;

		case FORMATION_HUDDLE_FACE_OUT:
		case FORMATION_SEMICIRCLE_FACE_OUT:
    		fFacing = VectorToAngle(vPos);
			break;

		case FORMATION_HUDDLE_FACE_FORWARD:
    		fFacing = GetFacingFromLocation(lDestination);
			break;

		default:
    		fFacing = VectorToAngle(-1.0 * vPos);
			break;
	}

    vector vCenter = GetPositionFromLocation(lDestination);
    vPos = vPos + vCenter;	// move vector to offset

    return Location(oArea, vPos, fFacing);
}

// Get new line location from center of row
// 6 4 2 0 1 3 5
location SCGetLineLocation(location lDestination, int iMemberIndex, float fSpacing)
{
	object oNewArea = GetAreaFromLocation(lDestination);
	vector vNewPosition = GetPositionFromLocation(lDestination);
	float fNewFacing = GetFacingFromLocation(lDestination);

	// if leader then use target destination
	if (iMemberIndex <= 0)
		return lDestination;

	int bOddIndex = (iMemberIndex % 2);

	if (bOddIndex == TRUE)
	{
		// if odd add right
		vNewPosition = CSLGetChangedPosition(vNewPosition, ((iMemberIndex + 1) / 2) * fSpacing, fNewFacing - 90.0f);
	} 
	else
	{
		// if even add left
		vNewPosition = CSLGetChangedPosition(vNewPosition, ((iMemberIndex + 1) / 2) * fSpacing, fNewFacing + 90.0f);
	}

	return Location(oNewArea, vNewPosition, fNewFacing);
}


//-------------------------------------------------
// Group Base Functions
//-------------------------------------------------


// removes everything from the group, resets all the group's vars to init values of 0, 
// and removes local string indicating group from all objects in group
void SCResetGroup(string sGroupName)
{
	int i;
	int iNumObjects = SCGroupGetNumObjects(sGroupName);
	string sThisObj;
	object oObject;

	// set objects to invalid
	for (i=1; i <= iNumObjects; i++)
	{
		oObject = SCGroupGetObjectIndex(sGroupName, i);
		if ( GetIsObjectValid(oObject) )
		{	
			if ( SCGetGroupName(oObject) == sGroupName )
			{
				DeleteLocalString( oObject, OBJ_GROUP_MY_GROUP );
			}
		}
		SCGroupDeleteObjectIndex(sGroupName, i);
	}
	SCGroupSetNumObjects(sGroupName, 0);
	SCGroupSetCurrentIndex(sGroupName, 0);
	
	// clear out noise
	SCDeleteGroupFloat(sGroupName, OBJ_GROUP_NOISE_START);
	SCDeleteGroupFloat(sGroupName, OBJ_GROUP_NOISE_FACING);
	SCDeleteGroupFloat(sGroupName, OBJ_GROUP_NOISE_LOCATION);

	// clear out formation info
	SCDeleteGroupFloat(sGroupName, OBJ_GROUP_FORMATION_RADIUS);
	SCDeleteGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING);
	SCDeleteGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE);
	SCDeleteGroupInt(sGroupName, OBJ_GROUP_FORMATION_COLS);
}

int SCIsGroupEmpty(string sGroupName)
{
	int iRet = FALSE;
	if (SCGroupGetNumObjects(sGroupName) == 0)
		iRet = TRUE;
	return (iRet);
}

//---------------------------------------------------------------
// Group creation		
//---------------------------------------------------------------

// Make party a group using all standard stuff
// This will put all party members in party group even if they are currently in another group.
string SCGetPartyGroup(object oPC)	
{	
	string sGroupName = PARTY_GROUP_NAME;
	SCResetGroup(sGroupName);
	//FactionToGroup(oPC, sGroupName, GROUP_LEADER_FIRST, TRUE);
	SCGroupAddFaction(sGroupName, oPC, GROUP_LEADER_FIRST, TRUE);
	SCGroupSetBMAFormation(sGroupName);
	return (sGroupName);
}
	
// Add creature to group sGroupName
void SCGroupAddMember(string sGroupName, object oMember, int bOverridePrevGroup=FALSE)
{
	SCInsertIntoGroup(sGroupName, oMember, bOverridePrevGroup);
}

// Add creatures with factions matching oFactionMember to group sGroupName
void SCGroupAddFaction(string sGroupName, object oFactionMember, int nLeaderPos=GROUP_LEADER_FIRST, int bOverridePrevGroup=FALSE)
{
	object oLeader = GetFactionLeader(oFactionMember);
	if (!GetIsObjectValid(oLeader))
	{
		oLeader = oFactionMember;
	}

	object oMember = GetFirstFactionMember(oFactionMember, FALSE);

	if (nLeaderPos == GROUP_LEADER_FIRST)	// add Leader first
	{
		SCInsertIntoGroup(sGroupName, oLeader, bOverridePrevGroup);
	}

	while (GetIsObjectValid(oMember))
	{
		if (oMember != oLeader)				// skip Leader
		{
			SCInsertIntoGroup(sGroupName, oMember, bOverridePrevGroup);
		}
		oMember = GetNextFactionMember(oFactionMember, FALSE);
	}

	if (nLeaderPos == GROUP_LEADER_LAST)	// add Leader last
	{
		SCInsertIntoGroup(sGroupName, oLeader, bOverridePrevGroup);
	}	
}

// Add up to iMax creatures with tag sTag to group sGroupName
void SCGroupAddTag(string sGroupName, string sTag, int iMax=20, int bOverridePrevGroup=FALSE)
{
	int iCount = 0;
	object oMember = GetObjectByTag(sTag, iCount);
	while (GetIsObjectValid(oMember) && (iCount < iMax))
	{
		SCInsertIntoGroup(sGroupName, oMember, bOverridePrevGroup);
		iCount++;
		oMember = GetObjectByTag(sTag, iCount);
	}
}

// Add up to iMax creatures with tag sTag to group sGroupName
void SCGroupAddNearestTag(string sGroupName, string sTag, object oTarget = OBJECT_SELF, int iMax=20, int bOverridePrevGroup=FALSE)
{
	int iCount = 0;

	//the + 1 is because GetNearestObjectByTag is 1-indexed, rather than 0-indexed like GetObjectByTag(). -EPF
	object oMember = GetNearestObjectByTag(sTag, oTarget, iCount + 1);
	while (GetIsObjectValid(oMember) && (iCount < iMax))
	{
		SCInsertIntoGroup(sGroupName, oMember, bOverridePrevGroup);
		iCount++;
		oMember = GetNearestObjectByTag(sTag, oTarget, iCount + 1);
	}
}


// Add encounter spawned creatures to group sGroupName
// bWander 0 - no wander
//			1 - wander
//			2 - don't set (ude default - currently wander)
void SCGroupAddEncounter(string sGroupName, int bWander=2, int bOverridePrevGroup=FALSE)
{
	//SpawnScriptDebugger();
	//PrettyDebug("Examining all the creatures in the area");
	object oMember = GetFirstObjectInArea();
	//int iIsEncounter;
	//int iIsValid = GetIsObjectValid(oMember);
	//PrettyDebug("First Obj oin area : " + GetTag(oMember) + " and valid: " + IntToString(iIsValid));
	while (GetIsObjectValid(oMember))
	{
		if (GetObjectType(oMember) == OBJECT_TYPE_CREATURE)
		{
			//iIsEncounter = GetIsEncounterCreature(oMember);
			//PrettyDebug(GetName(oMember) + " encounter status is : " + IntToString(iIsEncounter));
			if (GetIsEncounterCreature(oMember))
			{
				SCInsertIntoGroup(sGroupName, oMember, bOverridePrevGroup);	// adds 
			}
		}
		oMember = GetNextObjectInArea();
	}
	if (bWander != 2)
	{
		SCGroupSetSpawnInCondition(sGroupName, CSL_FLAG_AMBIENT_ANIMATIONS, bWander);
	}
}

// Note this will only properly place creatures in formation if the group was previously empty.
void SCGroupSpawnAtWaypoint(string sGroupName, string sTemplate, string sWaypoint, int nNum)
{
	object oPC = GetObjectByTag(sWaypoint);
	location lLoc = GetLocation(oPC);
	SCGroupSpawnAtLocation(sGroupName, sTemplate, lLoc, nNum);
}

// Spawn in iNum sTemplate's into a group using formation & noise at lLocation
// Note this will only properly place creatures in formation if the group was previously empty.
void SCGroupSpawnAtLocation(string sGroupName, string sTemplate, location lLocation, int nNum)
{
	object oMember;
	location lDestination;
	int nCount;

	float fFacingNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_FACING);
	float fLocationNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_LOCATION);	

	int nFormation = SCGetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE);
	int nFormCols = SCGetGroupInt(sGroupName, OBJ_GROUP_FORMATION_COLS);
	float fFormSpacing = SCGetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING);

	for (nCount = 1; nCount <= nNum; nCount++)
	{
		switch (nFormation)
		{
			case FORMATION_NONE:
				lDestination = lLocation;
				break;
			case FORMATION_HUDDLE_FACE_IN:
			case FORMATION_HUDDLE_FACE_OUT:
			case FORMATION_HUDDLE_FACE_FORWARD:
				lDestination = SCGetHuddleLocation(lLocation, nCount, nNum, fFormSpacing, nFormation);
				break;
			case FORMATION_RECTANGLE:
				lDestination = SCGetRectangleLocation(lLocation, nCount, nFormCols, fFormSpacing);
				break;
			case FORMATION_BMA:
				lDestination = SCGetBMALocation(lLocation, nCount, fFormSpacing);
				break;
			case FORMATION_LINE:
				// 0-based index
				lDestination = SCGetLineLocation(lLocation, nCount - 1, fFormSpacing);
				break;
			case FORMATION_SEMICIRCLE_FACE_IN:
			case FORMATION_SEMICIRCLE_FACE_OUT:
				lDestination = SCGetHuddleLocation(lLocation, nCount, nNum, fFormSpacing, nFormation);
				break;
			default:
				lDestination = lLocation;
				break;
		}
		lDestination = CSLGetNearbyLocation(lDestination, fLocationNoise, fFacingNoise);
		oMember = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lDestination);
		SCGroupAddMember(sGroupName, oMember);
	}
}

// *** old versions
// add a new a creature to a group (fails if object is already in another group)
int SCAddToGroup(string sGroupName, object oObject)
{
	//OldFunctionMessage("SCAddToGroup", "SCGroupAddMember");
	return (SCInsertIntoGroup(sGroupName, oObject, FALSE));
}

// adds all members of a faction to the specified Group
/*
void FactionToGroup(object oFactionMember, string sGroupName, int iLeaderPos=GROUP_LEADER_FIRST, int bOverridePrevGroup = FALSE)
{
	OldFunctionMessage("FactionToGroup", "SCGroupAddFaction");
	SCGroupAddFaction(sGroupName, oFactionMember, iLeaderPos, bOverridePrevGroup);
}
*/

// add all encounter creatures in area to specified group
// bWander 0 - no wander
//			1 - wander
//			2 - don't set (ude default - currently wander)
/*
void EncounterToGroup(string sGroupName, int bWander=2)
{
	OldFunctionMessage("EncounterToGroup", "SCGroupAddEncounter");
	SCGroupAddEncounter(sGroupName, bWander);
}
*/

// spawn creatures in - in BMA formation - and add them to a group
// if there are creatures already in the group, the new ones will be tacked on to the end and placed 
// in formation accordingly.
void SCSpawnCreaturesInGroupAtWP(int iNum, string sTemplate, string sGroupName, string sWayPoint="SPAWN_POINT")
{
	int i;
	object oCreature; 
	location lThisDest;
	location lDestination = SCGetWPLocation(sWayPoint);
	int iIndex;

	for (i=1; i<=iNum; i++)
	{
		iIndex = SCGroupGetNumObjects(sGroupName)+1; // SCGroupGetCurrentIndex(sGroupName) + 1;
		lThisDest = SCGetBMALocation(lDestination, iIndex, DEFAULT_SPACING);
		oCreature = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lThisDest); //, bUseAppearAnimation, sNewTag);
		//SCAddToGroup(sGroupName, oCreature);
		SCInsertIntoGroup(sGroupName, oCreature, FALSE);
	}

	return;
}

// adds all in the area w/ tag to a group up to specified max.	
/*
void AddNearestWithTagToGroup(string sGroupName, string sTag, int iMax=20)
{
	OldFunctionMessage("AddNearestWithTagToGroup", "SCGroupAddNearestTag");
	SCGroupAddNearestTag(sGroupName, sTag, OBJECT_SELF, iMax);
}
*/


//--------------------------------------------------
// Formations
//--------------------------------------------------

// Use single base destination for group, does NOT ignore noise	
void SCGroupSetNoFormation(string sGroupName)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE, FORMATION_NONE);
}

// Creates a standard party group formations:
//       1        fSpacing = distance between each row
//      2 3       
//     5 4 6       
//      7 8  etc.
void SCGroupSetBMAFormation(string sGroupName, float fSpacing=1.8f)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE, FORMATION_BMA);
	SCSetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING, fSpacing); // to be implemented
}

// creates a circle, fRadius out from the waypoint.  First in group will go in direction of waypoints arrow.
// int iFormation 	- Formation to use
// float fRadius	- radius for huddles
void SCGroupSetCircleFormation(string sGroupName, int iFacing=FORMATION_HUDDLE_FACE_IN , float fRadius=5.0f)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE, iFacing);
	SCSetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING, fRadius);
}

// Just like SCGroupSetCircleFormation, but we only cover the first half of the circle.
void SCGroupSetSemicircleFormation(string sGroupName, int nFacing = FORMATION_SEMICIRCLE_FACE_OUT, float fRadius = 5.f)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE, nFacing);
	SCSetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING, fRadius);
}

// Create standard single row formation, leader in middle
// 6 4 2 0 1 3 5
void SCGroupSetLineFormation(string sGroupName, float fSpacing=DEFAULT_SPACING)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE, FORMATION_LINE);
	SCSetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING, fSpacing);
}


// creates a rectangle with creatures facing direction of waypoint.  Waypoint indicates top left most 
// corner of the rectangle.	
// float fSpacing - spacing in units between creatures.  There are 10 units in a single tile square
// int nColumns - number of columns to form.
void SCGroupSetRectangleFormation(string sGroupName, float fSpacing=1.8f, int nColumns=2)
{
	SCSetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE, FORMATION_RECTANGLE);
	SCSetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING, fSpacing);
	SCSetGroupInt(sGroupName, OBJ_GROUP_FORMATION_COLS, nColumns);
}

// Sets the noise to be used with formations to make them less synchronized.
// fStartNoise		- delay in start time for creatures to move
// fFacingNoise		- max degrees to turn from facing
// fLocationNoise	- max x and y units to deviate from location
void SCGroupSetNoise(string sGroupName, float fStartNoise=1.0f, float fFacingNoise=10.0f, float fLocationNoise=1.0f)
{
	SCSetGroupFloat(sGroupName, OBJ_GROUP_NOISE_START, fStartNoise);
	SCSetGroupFloat(sGroupName, OBJ_GROUP_NOISE_FACING, fFacingNoise);
	SCSetGroupFloat(sGroupName, OBJ_GROUP_NOISE_LOCATION, fLocationNoise);
}

//------------------------
// Group On Death
//------------------------

// When group dies, start a conversation.  Works with gg_death_talk
// Do not add to a group after calling this (as the object's death script will not get assigned).	
// Only 1 of the GroupOnDeath functions can be applied per group - a previous GroupOnDeath function will be "overwritten" when a new one is applied.
void SCGroupOnDeathBeginConversation(string sGroupName, string sTalkerTag, string sConversation)
{
	// set groups death script
	SCGroupSetLocalString (sGroupName, "DeathScript", "gg_death_talk");

	// set vars for later use
	SCSetGroupString(sGroupName, "TalkerTag", sTalkerTag);
	SCSetGroupString(sGroupName, "Conversation", sConversation);
	
	// reset num killed (in case group name was used before)
	SCSetGroupInt(sGroupName, "NumKilled", 0);
}


// When group dies, set a Local Int on the specified target.  Works with gg_death_l_var
// Do not add to a group after calling this (as the object's death script will not get assigned).	
// Only 1 of the GroupOnDeath functions can be applied per group - a previous GroupOnDeath function will be "overwritten" when a new one is applied.
void SCGroupOnDeathSetLocalInt( string sGroupName, object oTargetObject, string sVariableName, int nNewValue )
{
	// set groups death script
	SCGroupSetLocalString ( sGroupName, "DeathScript", "gg_death_l_var" );

	// set vars for later use
	SCSetGroupObject( sGroupName, "TargetObject", oTargetObject );
	SCSetGroupString( sGroupName, "VarName", sVariableName );
	SCSetGroupInt( sGroupName, "VarValue", nNewValue );
	SCSetGroupInt( sGroupName, "VarType", TYPE_INT );
	
	// reset num killed (in case group name was used before)
	SCSetGroupInt( sGroupName, "NumKilled", 0 );
}

// When group dies, set a Local Float on the specified target.  Works with gg_death_l_var
// do not add to a group after calling this (as the object's death script will not get assigned).	
// Only 1 of the GroupOnDeath functions can be applied per group - a previous GroupOnDeath function will be "overwritten" when a new one is applied.
void SCGroupOnDeathSetLocalFloat( string sGroupName, object oTargetObject, string sVariableName, float fNewValue )
{
	// set groups death script
	SCGroupSetLocalString (sGroupName, "DeathScript", "gg_death_l_var" );

	// set vars for later use
	SCSetGroupObject( sGroupName, "TargetObject", oTargetObject );
	SCSetGroupString( sGroupName, "VarName", sVariableName );
	SCSetGroupFloat( sGroupName, "VarValue", fNewValue );
	SCSetGroupInt( sGroupName, "VarType", TYPE_FLOAT );
	
	// reset num killed (in case group name was used before)
	SCSetGroupInt(sGroupName, "NumKilled", 0);
}

// When group dies, set a Local String on the specified target.  Works with gg_death_l_var
// do not add to a group after calling this (as the object's death script will not get assigned).	
// Only 1 of the GroupOnDeath functions can be applied per group - a previous GroupOnDeath function will be "overwritten" when a new one is applied.
void SCGroupOnDeathSetLocalString( string sGroupName, object oTargetObject, string sVariableName, string sNewValue )
{
	// set groups death script
	SCGroupSetLocalString (sGroupName, "DeathScript", "gg_death_l_var" );

	// set vars for later use
	SCSetGroupObject( sGroupName, "TargetObject", oTargetObject );
	SCSetGroupString( sGroupName, "VarName", sVariableName );
	SCSetGroupString( sGroupName, "VarValue", sNewValue );
	SCSetGroupInt( sGroupName, "VarType", TYPE_STRING );
	
	// reset num killed (in case group name was used before)
	SCSetGroupInt(sGroupName, "NumKilled", 0);
}

// When group dies, Add a Journal Quest Entry.  Works with gg_death_journal
// Do not add to a group after calling this (as the object's death script will not get assigned).	
// Only 1 of the GroupOnDeath functions can be applied per group - a previous GroupOnDeath function will be "overwritten" when a new one is applied.
void SCGroupOnDeathSetJournalEntry(string sGroup, string sQuestTag, int nEntry, int bAllowOverride = FALSE)
{
	SCGroupSetLocalString(sGroup, "DeathScript", "gg_death_journal");
	SCSetGroupString(sGroup, "sQuestTag", sQuestTag);
	SCSetGroupInt(sGroup, "nEntry", nEntry);
	SCSetGroupInt(sGroup, "bOverride", bAllowOverride);
}

// When group dies, execute a custom script.  Works with gg_death_custom_script
// Do not add to a group after calling this (as the object's death script will not get assigned).	
// Only 1 of the GroupOnDeath functions can be applied per group - a previous GroupOnDeath function will be "overwritten" when a new one is applied.
void SCGroupOnDeathExecuteCustomScript(string sGroupName, string sScriptName)
{
	// set groups death script
	SCGroupSetLocalString ( sGroupName, "DeathScript", "gg_death_custom_script" );

	// set vars for later use
	SCSetGroupString( sGroupName, "CustomScript", sScriptName );
	
	// reset num killed (in case group name was used before)
	SCSetGroupInt( sGroupName, "NumKilled", 0 );
}
	
	
//----------------------------------------------------
// Group Commands

// 
void SCGroupForceMoveToLocation(string sGroupName, location lDestination, int bRun=FALSE, float fTimeout=30.0f)
{
	int nNumMembers = SCGroupGetNumObjects(sGroupName);

	object oMember = SCGetFirstInGroup(sGroupName);
	location lNewDest;

	float fFacingNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_FACING);
	float fLocationNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_LOCATION);	

	int nFormation = SCGetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE);
	int nFormCols = SCGetGroupInt(sGroupName, OBJ_GROUP_FORMATION_COLS);
	float fFormSpacing = SCGetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING);

	int nCount;
	for (nCount = 1; nCount <= nNumMembers; nCount++)
	{
		switch (nFormation)
		{
			case FORMATION_NONE:
				lNewDest = lDestination;
				break;
			case FORMATION_HUDDLE_FACE_IN:
			case FORMATION_HUDDLE_FACE_OUT:
			case FORMATION_HUDDLE_FACE_FORWARD:
				lDestination = SCGetHuddleLocation(lDestination, nCount, nNumMembers, fFormSpacing, nFormation);
				break;
			case FORMATION_RECTANGLE:
				lNewDest = SCGetRectangleLocation(lDestination, nCount, nFormCols, fFormSpacing);
				break;
			case FORMATION_BMA:
				lNewDest = SCGetBMALocation(lDestination, nCount, fFormSpacing);
				break;
			case FORMATION_LINE:
				// 0-based index
				lNewDest = SCGetLineLocation(lDestination, nCount - 1, fFormSpacing);
				break;
			case FORMATION_SEMICIRCLE_FACE_IN:
			case FORMATION_SEMICIRCLE_FACE_OUT:
				lDestination = SCGetHuddleLocation(lDestination, nCount, nNumMembers, fFormSpacing, nFormation);
				break;

			default:
				lNewDest = lDestination;
				break;
		}
		lNewDest = CSLGetNearbyLocation(lNewDest, fLocationNoise, fFacingNoise);
		//CSLMessage_PrettyMessage("ginc_group: force moving " + GetName(oMember));
		AssignCommand(oMember, ActionForceMoveToLocation(lNewDest, bRun, fTimeout));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// locomote a group to a specified waypoint (formation and noise should be set first)
// string sGroupName - name of group to move (created using SCAddToGroup())
// string sWayPoint - Tag of the Base waypoint for the formation
// int iMoveType	- specifies type of locomotion - MOVE_WALK, MOVE_JUMP, etc.
void SCGroupMoveToWP(string sGroupName, string sWayPoint, int iMoveType=MOVE_WALK)
{
	location lDestination = SCGetWPLocation(sWayPoint);
	SCGroupMoveToFormationLocation(sGroupName, lDestination, iMoveType);
}

void SCGroupMoveToObject(string sGroupName, object oTarget, int iMoveType=MOVE_WALK)
{
	location lDestination = GetLocation(oTarget);
	SCGroupMoveToFormationLocation(sGroupName, lDestination, iMoveType);
}

void SCGroupFleeToExit(string sGroupName, string sWaypoint, int iMoveType=MOVE_WALK)
{
	SCGroupMoveToWP(sGroupName, sWaypoint, iMoveType);

	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, ActionDoCommand(DestroyObject(oMember)));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// wrapper for MOVE_JUMP_INSTANT - clear actions and jump to location
void SCGroupJumpToWP(string sGroupName, string sWaypoint)
{
	SCGroupMoveToWP(sGroupName, sWaypoint, MOVE_JUMP_INSTANT);
	//location lDestination = SCGetWPLocation(sWaypoint);
	//SCGroupMoveToFormationLocation(sGroupName, lDestination, MOVE_JUMP_INSTANT);
}


// move to the specified destination in the specified way.
void SCDoMoveType(object oMember, location lThisDest, int iMoveType=MOVE_WALK, float fStartNoise=0.0f, float fForceMoveTimeout=30.0f)
{
	switch (iMoveType)
	{
		case MOVE_WALK:
			AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
			AssignCommand(oMember, ActionMoveToLocation(lThisDest));
			break;

		case MOVE_RUN:
			AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
			AssignCommand(oMember, ActionMoveToLocation(lThisDest, TRUE));
			break;

		case MOVE_JUMP:
			AssignCommand(oMember, ActionJumpToLocation(lThisDest));
			break;

		case MOVE_JUMP_INSTANT:
			AssignCommand(oMember, ClearAllActions());
			AssignCommand(oMember, JumpToLocation(lThisDest));
			break;

		case MOVE_FORCE_WALK:
			AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
			AssignCommand(oMember, ActionForceMoveToLocation(lThisDest, FALSE, fForceMoveTimeout));

		case MOVE_FORCE_RUN:
			AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
			AssignCommand(oMember, ActionForceMoveToLocation(lThisDest, TRUE, fForceMoveTimeout));

		default:
			PrintString("ginc_group: invalid iMoveType case");
			AssignCommand(oMember, ActionMoveToLocation(lThisDest));
			break;
	}
}

// locomote a group to a specified location (formation and noise should be set first)
// string sGroupName - name of group to move (created using SCAddToGroup())
// location lDestination - Base location for the formation
// int iMoveType	- specifies type of locomotion - MOVE_WALK, MOVE_JUMP, etc.
void SCGroupMoveToFormationLocation(string sGroupName, location lDestination, int iMoveType=MOVE_WALK)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	location lThisDest;
	float fFacing;
	int iMemberIndex;
	
	// get stored noise
	float fStartNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_START);
	float fFacingNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_FACING);
	float fLocationNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_LOCATION);

	// get formation vars
	int iFormation 	= SCGetGroupInt(sGroupName, OBJ_GROUP_FORMATION_TYPE);
	int iNumObjects = SCGroupGetNumObjects(sGroupName);
	int iCols		= SCGetGroupInt(sGroupName, OBJ_GROUP_FORMATION_COLS);
	float fSpacing 	= SCGetGroupFloat(sGroupName, OBJ_GROUP_FORMATION_SPACING);

	while (GetIsObjectValid(oMember))
	{
		iMemberIndex = SCGroupGetCurrentIndex(sGroupName);
		//lThisDest = GetFormationLocationByIndex(lDestination, sGroupName, iFormation, fRadius);
		//lThisDest = GetFormationLocationByIndex(lDestination, sGroupName);
		switch (iFormation)
		{
			case FORMATION_NONE:
				lThisDest = lDestination;
				break;
			case FORMATION_HUDDLE_FACE_IN: // do a huddle
			case FORMATION_HUDDLE_FACE_OUT: // do a backward huddle
			case FORMATION_HUDDLE_FACE_FORWARD: // forward moving circle
				lThisDest = SCGetHuddleLocation(lDestination, iMemberIndex, iNumObjects, fSpacing, iFormation);
				break;
			case FORMATION_RECTANGLE:
				lThisDest = SCGetRectangleLocation(lDestination, iMemberIndex, iCols, fSpacing);
				break;
			case FORMATION_BMA:
				lThisDest = SCGetBMALocation(lDestination, iMemberIndex, fSpacing);
				break;
			case FORMATION_LINE:
				// 0-based index what val does iMemberIndex start at?
				lThisDest = SCGetLineLocation(lDestination, iMemberIndex - 1, fSpacing);
				break;
			case FORMATION_SEMICIRCLE_FACE_IN:
			case FORMATION_SEMICIRCLE_FACE_OUT:
				lThisDest = SCGetHuddleLocation(lDestination, iMemberIndex, iNumObjects, fSpacing, iFormation);
				break;
			default:
				lThisDest = SCGetBMALocation(lDestination, iMemberIndex, DEFAULT_SPACING);
				break;
		}
		PrintString("ginc_group: SCGroupMoveToWP() object " + GetName(oMember) + " type " + IntToString(iMoveType));
		lThisDest = CSLGetNearbyLocation(lThisDest, fLocationNoise);
		SCDoMoveType(oMember, lThisDest, iMoveType, fStartNoise);

		/*
		switch (iMoveType)
		{
			case MOVE_WALK:
				AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
				AssignCommand(oMember, ActionMoveToLocation(lThisDest));
				break;

			case MOVE_RUN:
				AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
				AssignCommand(oMember, ActionMoveToLocation(lThisDest, TRUE));
				break;

			case MOVE_JUMP:
				AssignCommand(oMember, ActionJumpToLocation(lThisDest));
				break;

			case MOVE_JUMP_INSTANT:
				AssignCommand(oMember, ClearAllActions());
				AssignCommand(oMember, JumpToLocation(lThisDest));
				break;

			case MOVE_FORCE_WALK:
				AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
				AssignCommand(oMember, ActionForceMoveToLocation(lThisDest));

			case MOVE_FORCE_RUN:
				AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
				AssignCommand(oMember, ActionForceMoveToLocation(lThisDest, TRUE));

			default:
				PrintString("ginc_group: invalid iMoveType case");
				AssignCommand(oMember, ActionMoveToLocation(lThisDest));
				break;
		}
		*/
		// face the same way as the location destination + some noise
		fFacing = CSLGetNormalizedDirection(GetFacingFromLocation(lThisDest) + CSLRandomDeltaFloat(fFacingNoise));
		AssignCommand(oMember, ActionDoCommand(SetFacing(fFacing)));
		AssignCommand(oMember, ActionWait(0.5f)); // wait for facing
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// have group attack target
// string sGroupName - name of group
// object oTarget - target to attack
void SCGroupAttack(string sGroupName, object oTarget, int bSetToHostile=TRUE)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		CSLAttackTarget(oMember, oTarget, bSetToHostile);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// all in group clear their actions
// string sGroupName - name of group
// int nClearCombatState
void SCGroupClearAllActions(string sGroupName, int nClearCombatState = FALSE)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		AssignCommand(oMember, ClearAllActions(nClearCombatState));
		//PrintString (GetName(oMember) + " - Actions Cleared");
		oMember = SCGetNextInGroup(sGroupName);
	}
}


// makes a group play an animation
void SCGroupPlayAnimation(string sGroupName, int nAnimation, float fStartNoise=1.0f, float fSpeedBase=1.0f, float fSpeedRange=1.0f, float fDurationSectondsBase=0.0f, float fDurationSectondsRange=0.0f)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	float fSpeed;
	float fDurationSectonds;

	while (GetIsObjectValid(oMember))
	{
		if (fStartNoise > SC_EPSILON)
			AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));

		fSpeed = fSpeedBase;
		if (fSpeedRange > SC_EPSILON)
			fSpeed = fSpeed + CSLRandomUpToFloat(fStartNoise);

		fDurationSectonds = fDurationSectondsBase;
		if (fDurationSectondsRange > SC_EPSILON)
			fDurationSectonds = fDurationSectonds + CSLRandomUpToFloat(fDurationSectondsRange);

		AssignCommand(oMember, ActionPlayAnimation(nAnimation, fSpeed, fDurationSectonds));

		oMember = SCGetNextInGroup(sGroupName);
	}
}

// all in group wait
void SCGroupActionWait(string sGroupName, float fSeconds=0.0f)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		AssignCommand(oMember, ActionWait(fSeconds));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// causes all in group to change facing
// uses start noise 
void SCGroupActionOrientToTag(string sGroupName, string sTag, int iOrientation=SCORIENT_FACE_TARGET, int bIgnoreWait=FALSE)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	float fStartNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_START);

	while (GetIsObjectValid(oMember))
	{
		if (bIgnoreWait == FALSE) AssignCommand(oMember, ActionWait(CSLRandomUpToFloat(fStartNoise)));
		AssignCommand(oMember, CSLActionOrientToTag(sTag, iOrientation));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupResurrect(string sGroupName, int bIgnoreWait=FALSE)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	float fStartNoise = SCGetGroupFloat(sGroupName, OBJ_GROUP_NOISE_START);
	float fDelay = 0.0f;
	while (GetIsObjectValid(oMember) == TRUE)
	{
		if (bIgnoreWait == FALSE)
		{
			fDelay = CSLRandomUpToFloat(fStartNoise);
		}
		
		AssignCommand(oMember, DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oMember)));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// sets a string on all in the group
void SCGroupSetLocalString(string sGroupName, string sVarName, string sValue)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		PrintString("ginc_group: SCGroupSetLocalString() group " + sGroupName + " object " + GetName(oMember) + " var " + sVarName + " = " + sValue);
		SetLocalString(oMember, sVarName, sValue);
		oMember = SCGetNextInGroup(sGroupName);
	}
}


// sets an object on all in the group
void SCGroupSetLocalObject (string sGroupName, string sVarName, object oValue)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		//PrintString("ginc_group: SCGroupSetLocalObject() group " + sGroupName + " object " + GetName(oMember) + " var " + sVarName + " = " + GetName(oValue));
		SetLocalObject(oMember, sVarName, oValue);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// sets an object on all in the group
void SCGroupSetLocalInt (string sGroupName, string sVarName, int iValue)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		//PrintString("ginc_group: SCGroupSetLocalObject() group " + sGroupName + " object " + GetName(oMember) + " var " + sVarName + " = " + GetName(oValue));
		SetLocalInt(oMember, sVarName, iValue);
		oMember = SCGetNextInGroup(sGroupName);
	}
}


// sets an object on all in the group
void SCGroupSetLocalFloat (string sGroupName, string sVarName, float fValue)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		//PrintString("ginc_group: SCGroupSetLocalFloat() group " + sGroupName + " object " + GetName(oMember) + " var " + sVarName + " = " + GetName(oValue));
		SetLocalFloat(oMember, sVarName, fValue);
		oMember = SCGetNextInGroup(sGroupName);
	}
}



// sets specified spawn in condition for all in group	
void SCGroupSetSpawnInCondition(string sGroupName, int nCondition, int bValid = TRUE)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
        	CSLSetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER",nCondition, bValid);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// Turns ambient animations flag on/off for all in group
void SCGroupWander(string sGroupName, int bValid = TRUE)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
        	CSLSetLocalIntBitState(OBJECT_SELF, "NW_GENERIC_MASTER",CSL_FLAG_AMBIENT_ANIMATIONS, bValid);
		if (bValid)
		{
			AssignCommand(oMember, ActionRandomWalk() );		
		}
		else
		{
			AssignCommand(oMember, ClearAllActions());
			
		}
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// forces all in group to go to destination and then destroy self.
void SCGroupActionForceExit(string sGroupName, string sWPTag = "WP_EXIT", int bRun=FALSE)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		AssignCommand(oMember, SCActionForceExit(sWPTag, bRun));
		oMember = SCGetNextInGroup(sGroupName);
	}
}



// Changes everyone in group to join faction of given creature
// Note on use: mod should contain an isolated area with a faction pig for 
// each faction in use w/ tag same as faction name.
// (faction pigs have no scripts and thus can be placed peacefully together)
void SCGroupChangeFaction(string sGroupName, string sTargetFactionMember)
{
	object oTargetFactionMember = GetObjectByTag(sTargetFactionMember);
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
 		ChangeFaction(oMember, oTargetFactionMember);
		//PrintString ("Changed to same faction as " + GetName(oTarget));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// Changes everyone in group to join one of the standard factions
// STANDARD_FACTION_COMMONER;
// STANDARD_FACTION_DEFENDER;
// STANDARD_FACTION_HOSTILE;
// STANDARD_FACTION_MERCHANT;
void SCGroupChangeToStandardFaction(string sGroupName, int iFaction)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		ChangeToStandardFaction(oMember, iFaction);
		//PrintString ("Changed to standard faction");
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// does action move to object for all in group
void SCGroupActionMoveToObject(string sGroupName, object oTarget, int bRun = FALSE, float fRange = 1.0f)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		AssignCommand(oMember, ActionMoveToObject( oTarget, bRun, fRange));
		oMember = SCGetNextInGroup(sGroupName);
	}
}


// have group attak targets in another group
// string sAttackerGroupName - name of attacking group
// string sAttackedGroupName - name of attacked group
void SCGroupAttackGroup(string sAttackerGroupName, string sAttackedGroupName, int bSetToHostile=TRUE)
{
	object oMember = SCGetFirstInGroup(sAttackerGroupName);
	object oTarget = SCGetFirstInGroup(sAttackedGroupName);

	while (GetIsObjectValid(oMember))
	{
		CSLAttackTarget(oMember, oTarget, bSetToHostile);
		oMember = SCGetNextInGroup(sAttackerGroupName);
		oTarget = SCGetNextInGroup(sAttackedGroupName);
		if (oTarget == OBJECT_INVALID)
		{
			oTarget = SCGetFirstInGroup(sAttackedGroupName);
		}
	}
}


// assign SetFacingPoint() to each member in group, ignore noise
void SCGroupSetFacingPoint(string sGroupName, vector vPoint)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, SetFacingPoint(vPoint));
		oMember = SCGetNextInGroup(sGroupName);
	}
}


// Destroys all objects in the group
void SCDestroyObjectsInGroup(string sGroupName, float fDelay = 0.0f)
{
	object oMember = SCGetFirstInGroup(sGroupName);

	while (GetIsObjectValid(oMember))
	{
		PrintString("ginc_group: SCDestroyObjectsInGroup() destroying " + GetName(oMember) + " of group " + sGroupName);
		DestroyObject(oMember, fDelay);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupSetImmortal(string sGroupName, int bImmortal)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		SetImmortal(oMember, bImmortal);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupSetPlotFlag(string sGroupName, int bPlotFlag)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		SetPlotFlag(oMember, bPlotFlag);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// use SCGroupClearAllActions() to cancel follow.
// this will cause group to follow leader around for a while - eventually an event will
// clear their actions and they will go do their own thing.
void SCGroupActionForceFollowObject(string sGroupName, object oMaster, float fFollowDistance = 5.0f)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, ActionForceFollowObject(oMaster, fFollowDistance));
		PrintString(GetName(oMember) + " following " + GetName(oMaster));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// Cuases group to follow master
// the prospective followers must use heartbeat script "gb_follow_hb" for the effect to persist.
void SCGroupStartFollowLeader(string sGroupName, object oMaster, float fFollowDistance = 5.0f)
{
		SCGroupSetLocalObject (sGroupName, "Leader", oMaster);
		SCGroupSetLocalFloat (sGroupName, "FollowDistance", fFollowDistance);
		SCGroupActionForceFollowObject(sGroupName, oMaster, fFollowDistance);
}

// cuases group to stop following master
void SCGroupStopFollowLeader(string sGroupName)
{
		SCGroupSetLocalObject (sGroupName, "Leader", OBJECT_INVALID);
		SCGroupClearAllActions(sGroupName);
}


// figure out for selves what to do.
void SCGroupDetermineCombatRound(string sGroupName)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		//AssignCommand(oMember, SCAIDetermineCombatRound());
		//ExecuteScript("gr_dcr", oMember);
		CSLDetermineCombatRound(oMember);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// puts creatures in hostile faction and has them SCAIDetermineCombatRound()
void SCGroupGoHostile(string sGroupName)
{
	SCGroupChangeToStandardFaction(sGroupName, STANDARD_FACTION_HOSTILE);
	SCGroupDetermineCombatRound(sGroupName);
}

// note: testing on 9/14/05 indicates SurrenderToEnemies() is unreliable.
void SCGroupSurrenderToEnemies(string sGroupName)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, SurrenderToEnemies());
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupActionMoveAwayFromObject(string sGroupName, object oFleeFrom, int bRun = FALSE, float fMoveAwayRange = 40.0f)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, ActionMoveAwayFromObject(oFleeFrom, bRun, fMoveAwayRange));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

// everyone in group casts same fake spell
void SCGroupActionCastFakeSpellAtObject(string sGroupName, int nSpell, object oTarget, int nProjectilePathType = PROJECTILE_PATH_TYPE_DEFAULT)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, ActionCastFakeSpellAtObject(nSpell, oTarget, nProjectilePathType));
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupApplyEffectToObject(string sGroupName, int nDurationType, effect eEffect, float fDuration = 0.0f)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		ApplyEffectToObject(nDurationType, eEffect, oMember, fDuration);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupRemoveEffectOfType(string sGroupName, int nEffectType)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		CSLRemoveEffectByType(oMember, nEffectType);			
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupSignalEvent(string sGroupName, event eEvent)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember) == TRUE)
	{
		SignalEvent(oMember, eEvent);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

void SCGroupSetScriptHidden(string sGroupName, int bHidden)
{
	object oMember = SCGetFirstInGroup(sGroupName);
	while (GetIsObjectValid(oMember))
	{
		SetScriptHidden(oMember, bHidden);
		oMember = SCGetNextInGroup(sGroupName);
	}
}

int SCIncGroupNumKilled( string sGroupName )
{
	int nNumKilled = SCGetGroupInt( sGroupName, GROUP_VAR_NUM_KILLED ) + 1;
	SCSetGroupInt( sGroupName, GROUP_VAR_NUM_KILLED, nNumKilled );
	return ( nNumKilled );
}

int SCGetGroupNumKilled( string sGroupName )
{
	int nNumKilled = SCGetGroupInt( sGroupName, GROUP_VAR_NUM_KILLED );
	return ( nNumKilled );
}


const int MAX_COMPANIONS	= 13;

// Sets destroyable status of members in sGroupName
// - bDestroyable: If FALSE, members do not fade out and stick around as corpses.
// - bRaisable: If TRUE, members can be raised via resurrection.
// - bSelectableWhenDead: If TRUE, members are selectable after death.
void GroupSetIsDestroyable( string sGroupName, int bDestroyable, int bRaisable=TRUE, int bSelectableWhenDead=FALSE )
{
	object oGM = SCGetFirstInGroup( sGroupName );
	while ( GetIsObjectValid( oGM ) == TRUE )
	{
		AssignCommand( oGM, SetIsDestroyable( bDestroyable, bRaisable, bSelectableWhenDead ) );
		oGM = SCGetNextInGroup( sGroupName );
	}
}


//Returns the number of henchmen that oMaster has.
int GetNumHenchmen(object oMaster)
{
	int nLoop, nCount=0;
	for (nLoop=1; nLoop<=GetMaxHenchmen()+3; nLoop++)
   	{
   		if (GetIsObjectValid(GetHenchman(oMaster, nLoop)))
      	nCount+=1;
   	}
	return nCount;
}

//Checks to see if a creature is a henchman of another.
// parameters:  checks to see if oHench is a henchman of oMaster
// returns 1 if oHench is a henchman, 0 if not.
int GetIsHenchman(object oMaster, object oHench)
{
    int nMaxHench = GetMaxHenchmen()+6; //just in case a few have been forced
	int i;
	for (i=1;i<nMaxHench;i+=1)				//look for henchman in master's army
		if (oHench==GetHenchman(oMaster,i))
			return 1;
    return 0;
}


//Wrapper function for AddHenchman that adds some extra functionality.
//oHench is added as a henchman of oMaster.
//  - bForce - if set, this will temporarily up the max henchman to allow the henchman in the party (is immediately set back to what it was).
//  - bOverrideBehavior - if set, oHench's event handling scripts will be replaced with some stock henchman ones to get some easy default henchman behavior
//Return Value: 1 on success, 0 on error
// notes - returns 0 if there is no room in party to add henchman, though this is not technically an error
int HenchmanAdd(object oMaster, object oHench, int bForce=0, int bOverrideBehavior=0)
{
	int nMax=GetMaxHenchmen();
	int nCur=GetNumHenchmen(oMaster);

	if (bForce) //if we're forcing the henchman in..
	{
		if (nCur>=nMax)
		{
			SetMaxHenchmen(nCur+1);		
			AddHenchman(oMaster,oHench);
			SetMaxHenchmen(nMax);
		}
		else
			AddHenchman(oMaster,oHench);
	}
	else if (nCur<nMax)
			AddHenchman(oMaster,oHench);
		else
			return 0;			//don't do anything further if there is no more room for henchmen.

	SetLocalObject(oHench,"MY_MASTER_IS",oMaster);	//store for ease of later removal

	if (bOverrideBehavior)
	{
		SetLocalInt(oHench,"STORE_SCRIPT_TRUE",1);//remember that we want to restore the event handlers on henchman leaving the party
		//I want to put this in a for loop so bad it aches.
		//Storing the creatures scripts so that they can be replaced when the henchman is removed.
/*
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_HEARTBEAT),GetEventHandler(oHench,CREATURE_SCRIPT_ON_HEARTBEAT));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_NOTICE),GetEventHandler(oHench,CREATURE_SCRIPT_ON_NOTICE));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_SPELLCASTAT),GetEventHandler(oHench,CREATURE_SCRIPT_ON_SPELLCASTAT));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_MELEE_ATTACKED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_MELEE_ATTACKED));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DAMAGED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DAMAGED));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DISTURBED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DISTURBED));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_END_COMBATROUND),GetEventHandler(oHench,CREATURE_SCRIPT_ON_END_COMBATROUND));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DIALOGUE),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DIALOGUE));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_SPAWN_IN),GetEventHandler(oHench,CREATURE_SCRIPT_ON_SPAWN_IN));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_RESTED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_RESTED));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DEATH),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DEATH));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_USER_DEFINED_EVENT),GetEventHandler(oHench,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT));
		SetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR),GetEventHandler(oHench,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR));
	*/
		SCSaveEventHandlers(oHench);
        SCSetAssociateEventHandlers(oHench);
    /*        
		//Putting in some henchman event handlers.	
		//could also try the x0_ch_hen scripts
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_HEARTBEAT,        "x0_hen_heartbeat");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_NOTICE,           "x0_hen_percep");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPELLCASTAT,      "x2_hen_spell");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_MELEE_ATTACKED,   "x0_hen_attack");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DAMAGED,          "x0_hen_damaged");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DISTURBED,        "x0_hen_disturbed");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_END_COMBATROUND,  "x0_hen_combat");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DIALOGUE,         "x0_hen_conv");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPAWN_IN,         "x0_hen_spawn");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_RESTED,           "nw_ch_aca");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DEATH,            "x2_hen_death");
//		SetEventHandler(oHench,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT,"");
//		SetEventHandler(oHench,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR,"");
    */
		//ExecuteScript("x0_hen_spawn",oHench);
		ExecuteScript(SCRIPT_ASSOC_SPAWN, oHench);
	}
	return 1;
}


//Wrapper function for RemoveHenchman(). Supports added functionality of HenchmanAdd()
// Parameters:
//		-oHench is no longer a Henchman of oMaster
// Return value:
//		1 on success, 0 on failure
int HenchmanRemove(object oMaster, object oHench)
{
	RemoveHenchman(oMaster,oHench);
	DeleteLocalObject(oHench,"MY_MASTER_IS");

	int nScriptsReplaced=GetLocalInt(oHench,"STORE_SCRIPT_TRUE"); //see if we stored the creature's original script set

	if (nScriptsReplaced)
	{
		DeleteLocalInt(oHench,"STORE_SCRIPT_TRUE");
		AssignCommand(oHench,ClearAllActions());//stop following me!
		//Restore the event handling scripts
		SCRestoreEventHandlers(oHench);
	/*
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_HEARTBEAT,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_HEARTBEAT)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_NOTICE,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_NOTICE)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPELLCASTAT,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_SPELLCASTAT)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_MELEE_ATTACKED,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_MELEE_ATTACKED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DAMAGED,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DAMAGED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DISTURBED,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DISTURBED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_END_COMBATROUND,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_END_COMBATROUND)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DIALOGUE,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DIALOGUE)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPAWN_IN,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_SPAWN_IN)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_RESTED,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_RESTED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DEATH,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DEATH)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_USER_DEFINED_EVENT)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR,GetLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR)));
	*/
		//I want to put this in a for loop so bad it aches.
		//cleanup
		SCDeleteSavedEventHandlers(oHench);
	/*
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_HEARTBEAT));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_NOTICE));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_SPELLCASTAT));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_MELEE_ATTACKED));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DAMAGED));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DISTURBED));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_END_COMBATROUND));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DIALOGUE));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_SPAWN_IN));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_RESTED));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_DEATH));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_USER_DEFINED_EVENT));
		DeleteLocalString(oHench,"STORE_SCRIPT_"+IntToString(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR));
	*/	
	}
	return 1;
}

	
// Destroy a henchman
// Note: won't be destroyed if has been set as undestroyable
void DestroyHenchman(object oHenchman)
{
		//PrettyDebug ("Removing " + GetName(oHenchman));
		RemoveHenchman(GetMaster(oHenchman), oHenchman);	
		SetPlotFlag(oHenchman, FALSE);
		DestroyObject(oHenchman);
}

// Destroy all the henchmen of this master	
void DestroyAllHenchmen(object oMaster=OBJECT_SELF)
{
	int i;
	object oHenchman;

	// destroy them backwards to avoid problems w/ removeing henchmen causing re-indexing
	int iNumHenchmen = GetNumHenchmen(oMaster);
	
	for (i = iNumHenchmen; i>=1; i--)
	{
		oHenchman = GetHenchman(oMaster, i);
		//PrettyDebug ("Removing " + GetName(oHenchman));
		//RemoveHenchman(oMaster, oHenchman);	
		//SetPlotFlag(oHenchman, FALSE);
		DelayCommand(0.5f, DestroyHenchman(oHenchman));	// delay destructions so we have time to iterate through party properly
	}
}		

// Destroy every henchman in the entire party	 
void DestroyAllHenchmenInParty(object oPartyMember)	
{
	object oFM = GetFirstFactionMember(oPartyMember, FALSE);
	while(GetIsObjectValid(oFM))
	{
		//PrettyDebug ("Examining " + GetName(oFM) + " for henchmen.");
		DestroyAllHenchmen(oFM);
		oFM = GetNextFactionMember(oPartyMember, FALSE);
	}
}		




// Check if sRosterName is a valid RosterID
int GetIsInRoster(string sRosterName)
{
	string sRosterID = GetFirstRosterMember();
	
	while (sRosterID != "")
	{
		if (sRosterID == sRosterName) 
		{
			return (TRUE);
		}

		sRosterID = GetNextRosterMember();
	}

	return (FALSE);
}

// Add specified companion to roster using either an instance found or else the Template
void AddCompanionToRoster(string sRosterName, string sTagName, string sResRef)
{
	string WP_Prefix = "spawn_";

	object oCompanion 	= GetObjectByTag(sTagName);
	int bInRoster		= GetIsInRoster(sRosterName);

	// check if companion already in roster.
	if (bInRoster)
	{
		// already in roster	
		// shouldn't need to do anything?
	}		
	else
	{
		// not in roster.
		if (GetIsObjectValid(oCompanion))
		{
			
			// instance of companion is in world - add him to roster
			AddRosterMemberByCharacter(sRosterName, oCompanion);
		}
		else
		{
			// Add companion Blueprint instead
				AddRosterMemberByTemplate(sRosterName, sResRef);
		}
	}
}

// adds all companions to the roster
// members in roster must still be added to party	
void AddCompanionsToRoster()
{
	AddCompanionToRoster( "ammon_jerro", "ammon_jerro", "co_ammon_jerro" );
	SetIsRosterMemberCampaignNPC( "ammon_jerro", TRUE );
	AddCompanionToRoster( "bishop", "bishop", "co_bishop" );
	SetIsRosterMemberCampaignNPC( "bishop", TRUE );
	AddCompanionToRoster( "casavir", "casavir", "co_casavir" );
	SetIsRosterMemberCampaignNPC( "casavir", TRUE );
	AddCompanionToRoster( "construct", "construct", "co_construct" );
	SetIsRosterMemberCampaignNPC( "construct", TRUE );
	AddCompanionToRoster( "elanee", "elanee", "co_elanee" );
	SetIsRosterMemberCampaignNPC( "elanee", TRUE );
	AddCompanionToRoster( "grobnar", "grobnar", "co_grobnar" );
	SetIsRosterMemberCampaignNPC( "grobnar", TRUE );
	AddCompanionToRoster( "khelgar", "khelgar", "co_khelgar" );
	SetIsRosterMemberCampaignNPC( "khelgar", TRUE );
	AddCompanionToRoster( "neeshka", "neeshka", "co_neeshka" );
	SetIsRosterMemberCampaignNPC( "neeshka", TRUE );
	AddCompanionToRoster( "qara", "qara", "co_qara" );
	SetIsRosterMemberCampaignNPC( "qara", TRUE );
	AddCompanionToRoster( "sand", "sand", "co_sand" );
	SetIsRosterMemberCampaignNPC( "sand", TRUE );
	AddCompanionToRoster( "shandra", "shandra", "co_shandra" );
	SetIsRosterMemberCampaignNPC( "shandra", TRUE );
	AddCompanionToRoster( "zhjaeve", "zhjaeve", "co_zhjaeve" );
	SetIsRosterMemberCampaignNPC( "zhjaeve", TRUE );
}


// spawn all companions
void SpawnCompanions()
{
	string WP_Prefix = "spawn_";

	if (GetIsObjectValid(GetObjectByTag("ammon_jerro")) == FALSE)
		SpawnCreatureAtWP("co_ammon_jerro", 	WP_Prefix + "ammon_jerro");
	if (GetIsObjectValid(GetObjectByTag("bishop")) == FALSE)
		SpawnCreatureAtWP("co_bishop", 	WP_Prefix + "bishop");
	if (GetIsObjectValid(GetObjectByTag("casavir")) == FALSE)
		SpawnCreatureAtWP("co_casavir", 	WP_Prefix + "casavir");
	if (GetIsObjectValid(GetObjectByTag("construct")) == FALSE)
		SpawnCreatureAtWP("co_construct",	WP_Prefix + "construct");
	if (GetIsObjectValid(GetObjectByTag("elanee")) == FALSE)
		SpawnCreatureAtWP("co_elanee", 	WP_Prefix + "elanee");
	if (GetIsObjectValid(GetObjectByTag("grobnar")) == FALSE)
		SpawnCreatureAtWP("co_grobnar", 	WP_Prefix + "grobnar");	
	if (GetIsObjectValid(GetObjectByTag("khelgar")) == FALSE)
		SpawnCreatureAtWP("co_khelgar", 	WP_Prefix + "khelgar");	
	if (GetIsObjectValid(GetObjectByTag("neeshka")) == FALSE)
		SpawnCreatureAtWP("co_neeshka",	WP_Prefix + "neeshka");	
	if (GetIsObjectValid(GetObjectByTag("qara")) == FALSE)
		SpawnCreatureAtWP("co_qara", 		WP_Prefix + "qara");	
	if (GetIsObjectValid(GetObjectByTag("sand")) == FALSE)
		SpawnCreatureAtWP("co_sand", 		WP_Prefix + "sand");		
	if (GetIsObjectValid(GetObjectByTag("shandra")) == FALSE)
		SpawnCreatureAtWP("co_shandra", 	WP_Prefix + "shandra");
	if (GetIsObjectValid(GetObjectByTag("zhjaeve")) == FALSE)
		SpawnCreatureAtWP("co_zhjaeve", 	WP_Prefix + "zhjaeve");
}

//
string GetCompanionTagByNumber(int nCompanion)
{
	string sCompanionTag = "";

	switch (nCompanion)
	{
		case 1:
			sCompanionTag = "khelgar";
			break;
		case 2:
			sCompanionTag = "neeshka";
			break;
		case 3:
			sCompanionTag = "elanee";
			break;
		case 4:
			sCompanionTag = "qara";
			break;
		case 5:
			sCompanionTag = "sand";
			break;
		case 6:
			sCompanionTag = "grobnar";
			break;
		case 7:
			sCompanionTag = "casavir";
			break;
		case 8:
			sCompanionTag = "bishop";
			break;
		case 9:
			sCompanionTag = "shandra";
			break;
		case 10:
			sCompanionTag = "construct";
			break;
		case 11:
			sCompanionTag = "zhjaeve";
			break;
		case 12:
			sCompanionTag = "ammon_jerro";
			break;
		case 13:
			sCompanionTag = "npc_bevil";
			break;
		default:
			PrintString("ginc_companions-GetCompanionTagByNumber: Invalid companion ID!"); 
			break;
	}
	return sCompanionTag;
}


int GetCompanionNumberByTag(string sCompanionTag )
{
	if ( sCompanionTag == "ammon_jerro" ) { return 12; }
	else if ( sCompanionTag == "bishop" ) { return 8; }
	else if ( sCompanionTag == "casavir" ) { return 7; }
	else if ( sCompanionTag == "construct" ) { return 10; }
	else if ( sCompanionTag == "elanee" ) { return 3; }
	else if ( sCompanionTag == "grobnar" ) { return 6; }
	else if ( sCompanionTag == "khelgar" ) { return 1; }
	else if ( sCompanionTag == "neeshka" ) { return 2; }
	else if ( sCompanionTag == "npc_bevil" ) { return 13; }
	else if ( sCompanionTag == "qara" ) { return 4; }
	else if ( sCompanionTag == "sand" ) { return 5; }
	else if ( sCompanionTag == "shandra" ) { return 9; }
	else if ( sCompanionTag == "zhjaeve" ) { return 11; }
	return -1;
}

/*
// look through all the numbers for this Tag.
int GetCompanionNumberByTag(string sTag)
{
	string sCompareTag;
	int i;
	for (i=1; i<=MAX_COMPANIONS; i++)
	{
		sCompareTag = GetCompanionTagByNumber(i);
		if (sTag == sCompareTag)
			return(i);
	}
	return (0);
}*/

// Used in ga/gc_influence* scripts
string GetCompInfluenceGlobVar( int nCompanion )
{
	return "00_nInfluence" + GetCompanionTagByNumber(nCompanion);
}

void SetInfluence(object oCompanion, int nInfluence)
{
	string sVarInfluence = "00_nInfluence" + GetTag(oCompanion);
	if ( nInfluence < -100 )
	{
		nInfluence = -100;
	}
	else if ( nInfluence > 100 )
	{
		nInfluence = 100;
	}	
	SetGlobalInt( sVarInfluence, nInfluence);
}
// Success should return 0, or remaining number of companions on failure
int RemoveAllCompanions( object oPC , int bDespawn = TRUE)
{
	RemoveRosterMemberFromParty( "ammon_jerro", oPC, bDespawn );
	RemoveRosterMemberFromParty( "bishop", oPC, bDespawn );
	RemoveRosterMemberFromParty( "casavir", oPC, bDespawn );
	RemoveRosterMemberFromParty( "construct", oPC, bDespawn );
	RemoveRosterMemberFromParty( "elanee", oPC, bDespawn );
	RemoveRosterMemberFromParty( "grobnar", oPC, bDespawn );
	RemoveRosterMemberFromParty( "khelgar", oPC, bDespawn );
	RemoveRosterMemberFromParty( "neeshka", oPC, bDespawn );
	RemoveRosterMemberFromParty( "qara", oPC, bDespawn );
	RemoveRosterMemberFromParty( "sand", oPC, bDespawn );
	RemoveRosterMemberFromParty( "shandra", oPC, bDespawn );
	RemoveRosterMemberFromParty( "zhjaeve", oPC, bDespawn );
	
	return GetNumHenchmen( oPC );
}



// Return PC's influence of companion by CompanionID
int GetInfluenceByNumber( int nCompanion )
{
	string sVar = GetCompInfluenceGlobVar( nCompanion );
	int nRet = GetGlobalInt( sVar );
	return ( nRet );	
}

// Set PC's influence of companion to nInfluence ( capped )
void SetInfluenceByNumber( int nCompanion, int nInfluence )
{
	string sVar = GetCompInfluenceGlobVar( nCompanion );
	if ( nInfluence < INFLUENCE_MIN )
		nInfluence = INFLUENCE_MIN;
	else if ( nInfluence > INFLUENCE_MAX )
		nInfluence = INFLUENCE_MAX;
		
	SetGlobalInt( sVar, nInfluence );
	
}

// Increase PC's influence of companion by nInfluence ( capped )
void IncInfluenceByNumber( int nCompanion, int nInfluence )
{
	nInfluence = nInfluence + GetInfluenceByNumber( nCompanion );
	SetInfluenceByNumber( nCompanion, nInfluence );
}


int GetIsRosterNameInParty(object oPC, string sRosterName)
{
    object oCompanion = GetObjectFromRosterName(sRosterName);
	return (GetFactionEqual(oPC, oCompanion));
}

// This function should only be used to check if roster members are in the party
// This function is unfortunately named (generic name for a specific funtion), 
// but is to entrenched to rename.
int IsInParty(string sRosterName)
{
	object oPC = GetFirstPC();
	return (GetIsRosterNameInParty(oPC, sRosterName));
	
/*
	object oFM = GetFirstFactionMember(oPC, FALSE);
    object oCompanion = GetObjectFromRosterName(sRosterName);
    
	while(GetIsObjectValid(oFM))
	{
		if(oFM == oCompanion)
		{
			return 1;
		}
		oFM = GetNextFactionMember(oPC, FALSE);
	}
	return 0;
*/
}

void SetHangOutSpot(string sRMRosterName, string sHangOutWPTag)
{
	string sVarName = sRMRosterName + "HangOut";
	SetGlobalString(sVarName, sHangOutWPTag);
}

string GetHangOutSpot(string sRMRosterName)
{
	string sVarName = sRMRosterName + "HangOut";
	string sHangOutWPTag = GetGlobalString(sVarName);
	return (sHangOutWPTag);
}

object GetHangoutObject(string sRMRosterName)
{
	object oHangOut;
	// is current hang out spot to be found in this module?
	string sHangOutWPTag = GetHangOutSpot(sRMRosterName);
	if (sHangOutWPTag != "")
	{
		//PrettyDebug(" - sHangOutWPTag =" + sHangOutWPTag);
		oHangOut = GetObjectByTag(sHangOutWPTag);
	}		
	return (oHangOut);
}

// 
int GetIsInHangOutArea(string sRosterName)
{
	object oRM = GetObjectFromRosterName(sRosterName);
	if (!GetIsObjectValid(oRM))	
	{ // no roster member instance available
		return FALSE;
	}
	
	// move or despawn RM as needed to go to hangout.
	object oHangOut = GetHangoutObject(sRosterName);
	if (!GetIsObjectValid(oHangOut))	
	{ // hangout is not in this module
		return FALSE;
	} 
	
	return (GetArea(oHangOut) == GetArea(oRM));
}

// Determine if oObject can be possessed by oPossessor (owned char or an unblocked companion)
// Assumes PC faction
int SCGetIsObjectPossessible( object oPossessor, object oObject )
{
	if ( ( GetOwnedCharacter( oPossessor) == oObject ) || ( ( GetIsRosterMember( oObject ) == TRUE ) && ( GetIsCompanionPossessionBlocked( oObject ) == FALSE ) ) )
	{
		return ( TRUE );
	}
	
	return ( FALSE );
}

// Determine if there is at least one object that can be validly possessed by oPartyMember
int SCGetIsPartyPossessible( object oPartyMember=OBJECT_SELF )
{
	object oMember = GetFirstFactionMember( oPartyMember, FALSE );

	while ( GetIsObjectValid( oMember ) == TRUE )
	{
		// If oMember is not dead, not possessed, and possessible by oPartyMember	
		if ( GetIsDead( oMember ) == FALSE )
			if ( GetIsPC( oMember ) == FALSE )
				if ( SCGetIsObjectPossessible( oPartyMember, oMember ) == TRUE )
					return ( TRUE );

		oMember = GetNextFactionMember( oPartyMember, FALSE );
	}

	return ( FALSE );
}


// Get Up after KnockOut
void SCWakeUpCreature( object oCreature )
{
	//RemoveEffects( oCreature );
	ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection(), oCreature );
	ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oCreature );
	
	event eRes = EventSpellCastAt( oCreature, SPELL_RESURRECTION, FALSE );
	SignalEvent( oCreature, eRes );
}


// Random audio/visual feedback for knock out
void SCVoiceCryForHelp( object oCreature )
{
	int nCry = d3();
	switch ( nCry )
	{
		case 1:
			nCry = VOICE_CHAT_PAIN1; break;
		case 2:
			nCry = VOICE_CHAT_PAIN2; break;
		default:
			nCry = VOICE_CHAT_PAIN3;
	}
	
	AssignCommand( oCreature, PlayVoiceChat( nCry, oCreature ) );
	AssignCommand( oCreature, SpeakString( GetStringByStrRef( 183382 ), TALKVOLUME_TALK ) );
}

// Determine if it is "safe" for oCreature to wake up
// ( at least one PC or possessible companion alive, party not in combat, and no hostiles nearby )
int SCGetIsSafeToWakeUp( object oCreature=OBJECT_SELF )
{
	int bPartyAlive = FALSE;

	// For each faction member
	object oFM = GetFirstFactionMember( oCreature, FALSE );
	while ( GetIsObjectValid(oFM) == TRUE )
	{
		if ( GetIsDead(oFM) == FALSE )
		{
			if ( ( GetIsOwnedByPlayer(oFM) == TRUE ) ||
				 ( ( GetIsRosterMember(oFM) == TRUE ) && ( GetIsCompanionPossessionBlocked(oFM) == FALSE ) ) )
			{
				if ( GetIsInCombat(oFM) == FALSE )
				{
					// At least one member alive and not in combat
					bPartyAlive = TRUE;
				}
				else
				{
					// "safe" conditions failed
					return ( FALSE );
				}
			}
		}
		
		oFM = GetNextFactionMember( oCreature, FALSE );
	}
	
	// Check if at least one member is alive and not in combat
	if ( bPartyAlive == FALSE )
	{
		return ( FALSE );
	}

	// Nearest valid, living, hostile, non-scripthidden creature
	object oHostile = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCreature, 1 );

	if ( ( GetIsObjectValid( oHostile ) == TRUE ) && 
		 ( LineOfSightObject( oCreature, oHostile ) == TRUE ) && 
		 ( GetDistanceBetween( oCreature, oHostile ) < 15.0f ) )
	{
		return ( FALSE );
	}
	else
	{	
		// It's safe enough
		return ( TRUE );
	}
}

// Recursive function to Wake Up, Show and Hide Death Pop-up
void SCAttemptToWakeUpCreature( object oCreature )
{
	//PrintString( "ginc_death: " + GetName(oCreature) + " executing AttemptToWakeUpCreature()" );	

	// Abort if oCreature is no longer dead
	if ( GetIsDead(oCreature) == FALSE )
	{
		//PrintString( "** ginc_death: " + GetName(oCreature) + " is no longer dead (" + IntToString(GetCurrentHitPoints(oCreature)) + " HP)" );
		CSLRemoveDeathScreens( oCreature );
		return;
	}
	
	// Check if it's safe to wake up
	if ( SCGetIsSafeToWakeUp(oCreature) == TRUE )
	{
		//PrintString( "** ginc_death: " + GetName(oCreature) + " is waking up" );
		SCWakeUpCreature( oCreature );
		CSLRemoveDeathScreens( oCreature );
		return;
	}
	
	// Check if there are any members left for PC to possess
	if ( GetIsPC(oCreature) == TRUE )
	{
		if ( CSLGetIsDeathPopUpDisplayed(oCreature) == FALSE )
		{
			if ( SCGetIsPartyPossessible(oCreature) == FALSE )
			{
				//PrintString( "** ginc_death: " + GetName(oCreature) + "'s party wiped. displaying death screen" );	
				CSLShowProperDeathScreen( oCreature );
			}
		}
	}
	
	// BMA-OEI 8/15/06 -- Knock out feedback
	if ( d6() == 1 )
	{
		//PrintString( "** ginc_death: " + GetName(oCreature) + " cries for help" );
		SCVoiceCryForHelp( oCreature );
	}

	//PrintString( "** ginc_death: " + GetName(oCreature) + " still dead. next AttemptToWakeUpCreature() in 3s" );
	DelayCommand( 3.0f, SCAttemptToWakeUpCreature(oCreature) );
}


// Go unconscious, queue AttemptToWakeUpCreature()
void SCKnockOutCreature( object oCreature )
{
	AssignCommand( oCreature, SetCommandable(TRUE) );
	AssignCommand( oCreature, ClearAllActions(TRUE) );
	AssignCommand( oCreature, DelayCommand( 3.0f, SCAttemptToWakeUpCreature(oCreature) ) );
}