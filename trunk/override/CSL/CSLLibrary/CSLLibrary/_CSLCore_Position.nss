/** @file
* @brief Position related functions
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

// added SC_ to front of x0_i0_Position Constants
const float SC_DISTANCE_TINY = 1.0;
const float SC_DISTANCE_SHORT = 3.0;
const float SC_DISTANCE_MEDIUM = 5.0;
const float SC_DISTANCE_LARGE = 10.0;
const float SC_DISTANCE_HUGE = 20.0;

const float CSL_ACCELERATION_FROM_GRAVITY = 9.81f; // meters per second

const float CSL_FGATHER_RADIUS = 200.0f;

const int CSL_ORIENT_FACE_TARGET			= 1;
const int CSL_ORIENT_FACE_SAME_AS_TARGET 	= 2;


/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
// going to integrate all of this into this library soas to make it no longer needed, also to correct bugs present in how it was done Drammel noticed
//#include "x0_i0_position" 



// Basic includes that are needed, might look at reducing the need for some of these and get it down to strings and math, and perhaps random
#include "_CSLCore_Math"
#include "_CSLCore_Strings"
#include "_CSLCore_Magic_c"
#include "_CSLCore_Config_c"
#include "_CSLCore_Config"

#include "x2_inc_switches"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

float CSLGetZFromObject( object oObject );

/*
// try to do this without any defined
int CSLPCIsClose(object oPC, object oObject, int nDist = 0);

// Location
location CSLGetOffsetLocation(location lLoc, float fX=0.0f, float fY=0.0f, float fZ=0.0f);
location CSLGetDeviatedLocation(location lLoc, int iDvt=10);

string CSLSerializeLocation(location lLocation);
location CSLUnserializeLocation(string sLocation);
*/


/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/************************************************************/
/** @name Facing and Angle Functions
* These allow adjusting the facing direction
********************************************************* @{ */

/**  
* This returns a direction normalized to the range 0.0 - 360.0
* @author
* @param 
* @see 
* @replaces GetNormalizedDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetNormalizedDirection(float fDirection)
{
    float fNewDir = fDirection;
    while (fNewDir >= 360.0)
    {
        fNewDir -= 360.0;
    }
    while (fNewDir < 0.0)
    {
        fNewDir += 360.0;
    }

    return fNewDir;
}

/**  
* This returns the opposite direction (ie, this is the direction you
* would use to set something facing exactly opposite the way of
* something else that's facing in direction fDirection).
* @author
* @param 
* @see 
* @replaces XXXGetOppositeDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetOppositeDirection(float fDirection)
{
    return CSLGetNormalizedDirection(fDirection + 180.0);
}


/**  
* This returns the direction directly to the right. (IE, what
* you would use to make an object turn to the right.)
* @author
* @param 
* @see 
* @replaces GetRightDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetRightDirection(float fDirection)
{
    return CSLGetNormalizedDirection(fDirection - 90.0);
}

/**  
* This returns a direction that's a half-turn to the right
* @author
* @param 
* @see 
* @replaces GetHalfRightDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetHalfRightDirection(float fDirection)
{
    return CSLGetNormalizedDirection(fDirection - 45.0);
}

/**  
* This returns a direction one and a half turns to the right
* @author
* @param 
* @see 
* @replaces GetFarRightDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetFarRightDirection(float fDirection)
{
    return CSLGetNormalizedDirection(fDirection - 135.0);
}

/**  
* This returns a direction a specified angle to the right
* @author
* @param 
* @see 
* @replaces GetCustomRightDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetCustomRightDirection(float fDirection, float fAngle)
{
    return CSLGetNormalizedDirection(fDirection - fAngle);
}

/**  
* This returns the direction directly to the left. (IE, what
* you would use to make an object turn to the left.)
* @author
* @param 
* @see 
* @replaces GetLeftDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetLeftDirection(float fDirection)
{
    return CSLGetNormalizedDirection(fDirection + 90.0);
}

/**  
* This returns a direction that's a half-turn to the left
* @author
* @param 
* @see 
* @replaces GetFarLeftDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetHalfLeftDirection(float fDirection)
{
    return CSLGetNormalizedDirection(fDirection + 45.0);
}

/**  
* This returns a direction one and a half turns to the left
* @author
* @param 
* @see 
* @replaces GetFarLeftDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetFarLeftDirection(float fDirection)
{
    return CSLGetNormalizedDirection(fDirection + 135.0);
}

/**  
* This returns a direction a specified angle to the left
* @author
* @param 
* @see 
* @replaces GetCustomLeftDirection by OEI from i0_x0_position
* @return 
*/
float CSLGetCustomLeftDirection(float fDirection, float fAngle)
{
    return CSLGetNormalizedDirection(fDirection + fAngle);
}

/**  
* This returns the change in X coordinate that should be made to
* cause an object to be fDistance away at fAngle.
* @author
* @param 
* @see 
* @replaces GetChangeInX
* @return 
*/
float CSLGetChangeInX(float fDistance, float fAngle)
{
    return fDistance * cos(fAngle);
}

/**  
* This returns the change in Y coordinate that should be made to
* cause an object to be fDistance away at fAngle.
* @author
* @param 
* @see 
* @replaces GetChangeInY
* @return 
*/
float CSLGetChangeInY(float fDistance, float fAngle)
{
    return fDistance * sin(fAngle);
}

/**  
* Checks if the two facings are within the given total of degrees
* @author
* @param 
* @see 
* @replaces XXXIsDirectionWithinTolerance by OEI from i0_x0_position
* @return 
*/
int CSLIsDirectionWithinTolerance(float fCheckDirection, float fDirection, float fDegreesOfTolerance)
{
    if (fDegreesOfTolerance >= 180.0f)
        return TRUE;


    int iRet = FALSE;
    float fLeftDir = CSLGetNormalizedDirection (fDirection + fDegreesOfTolerance);
    float fRightDir = CSLGetNormalizedDirection(fDirection - fDegreesOfTolerance);

    // is it left of the right most direction?
    // is it right of the left most direction?

    if (fRightDir < fLeftDir) {
        // 0<right<left<360 - andgle doesn't cross 360 boundary
        if ((fCheckDirection > fRightDir) && (fCheckDirection < fLeftDir))
            iRet = TRUE;
    }
    else {
        // 0<left<right<360 - angle crosses 360 boundary
        if ((fCheckDirection > fRightDir) || (fCheckDirection < fLeftDir))
            iRet = TRUE;

    }
    return iRet;
}


//@}

/************************************************************/
/** @name Vector Functions
* Description
********************************************************* @{ */


/**  
* get a random vector within given Magnitude range
* @author
* @param 
* @see 
* @return 
*/
vector CSLGetRandom2DVector(float fMaxMagnitude, float fMinMagnitude=0.0f)
{
	float fMagnitude = CSLRandomBetweenFloat( fMinMagnitude, fMaxMagnitude );
	float fAngle = CSLRandomBetweenFloat( 0.0f, 360.0f);
	
	float x = ( fMagnitude * cos(fAngle) );
	float y = ( fMagnitude * sin(fAngle) );
	return (Vector(x, y));
}

/**  
* Makes a string representation of a vector for use in a string var or in a database
* @author NWNx and Jailiax
* @param 
* @see 
* @return 
*/
string CSLSerializeVector(vector vVector)
{
    return "#X#" + FloatToString(vVector.x) + "#Y#" + FloatToString(vVector.y) +
        "#Z#" + FloatToString(vVector.z) + "#END#";
}

/**  
* Turn a vector into a string. Useful for debugging.
* @author
* @param 
* @see CSLSerializeVector
* @replaces VectorToString by OEI from i0_x0_position
* @return 
*/
string CSLVectorToString(vector vec)
{
    return "(" + FloatToString(vec.x)
        + ", " + FloatToString(vec.y)
        + ", " + FloatToString(vec.z) + ")";
}

/**  
* Retrieves a string representation of a vector for use in a string var or in a database
* @author NWNx and Jailiax
* @param 
* @see 
* @return 
*/
vector CSLUnserializeVector(string sVector)
{
    float fX, fY, fZ;
    int iPos, iCount;
    int iLen = GetStringLength(sVector);

    if (iLen > 0)
    {
        iPos = FindSubString(sVector, "#X#") + 3;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#Y#") + 3;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#Z#") + 3;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sVector, iPos, iCount));
    }

    return Vector(fX, fY, fZ);
}


/**  
* return angle from origin point to Target point (from 0 to 360)
* @author
* @param 
* @see 
* @replaces XXXGetAngle by OEI from i0_x0_position
* @return 
*/
float CSLGetAngle(vector vOrigin, vector vTarget, float fDist)
{
    float fChangeX = vTarget.x - vOrigin.x;
    float fChangeY = vTarget.y - vOrigin.y;

    float fAngle = acos(fChangeX / fDist);
    // acos alway returns 0-180
    if (fChangeY < 0.0f)
    {
        // CSLGetNormalizedDirection doesn't work with negative angles
        fAngle = CSLGetNormalizedDirection(-fAngle + 360.0f);
    }

    return fAngle;
}

/**  
* Compares two vectors to see if they are the same
* @author
* @param 
* @see 
* @replaces CompareVectors by OEI from ginc_math
* @return 
*/
int CSLCompareVectors(vector v1, vector v2)
{
//	PrettyDebug ("v1:"+FloatToString(v1.x)+","+FloatToString(v1.y)+","+FloatToString(v1.z));
//	PrettyDebug ("v2:"+FloatToString(v2.x)+","+FloatToString(v2.y)+","+FloatToString(v2.z));
	if(v1.x != v2.x)
		return FALSE;
	
	else if(v1.y != v2.y)
		return FALSE;
	
	else if(v1.z != v2.z)
		return FALSE;
	
	else return TRUE;
}

/**  
* Compares two vectors X and Y ignoring the Height
* @author
* @param 
* @see 
* @replaces CompareVectors2D by OEI from ginc_math
* @return 
*/
int CSLCompareVectors2D(vector v1, vector v2)
{
//	PrettyDebug ("v1:"+FloatToString(v1.x)+","+FloatToString(v1.y));
//	PrettyDebug ("v2:"+FloatToString(v2.x)+","+FloatToString(v2.y));
	
	if(v1.x != v2.x)
		return FALSE;
	
	else if(v1.y != v2.y)
		return FALSE;
		
	else return TRUE;
}


// author Shazbotian - do i have something similar in effect now - from 2drunks wild magic to support walls of force
// if no intersection between S1 and S2 exist, puts -1 in the Z of the return vector. 
// else, returns the intersection. this function only checks 2D // SegmentIntersectsSegment
vector CSLCompareVectorsIntersect2D(vector vS1Start, vector vS1End, vector vS2Start, vector vS2End)
{
	// coppied this from newsgroups.cryer.info/comp/graphics.algorithms/200603/12/0604283175.html
	vector vDP, vS1, vS2, vReturn;
	float fD, fLA, fLB;

	vDP.x = vS2Start.x - vS1Start.x ;
	vDP.y = vS2Start.y - vS1Start.y ;
	vS1.x = vS1End.x - vS1Start.x;
	vS1.y = vS1End.y - vS1Start.y;
	vS2.x = vS2End.x - vS2Start.x;
	vS2.y = vS2End.y - vS2Start.y;

	fD  =   vS1.y * vS2.x - vS2.y * vS1.x ;
	if(fD == 0.0)
	{
		//object oPC = GetFirstPC();
		//SendMessageToPC(oPC, "Division by zero averted!!");
		vReturn.z = -1.0f;
		return vReturn;
	}
	else
	{
		fLA = ( vS2.x * vDP.y - vS2.y * vDP.x ) / fD ;
		fLB = ( vS1.x * vDP.y - vS1.y * vDP.x ) / fD ;
	}

// if intersection exist   0 <= la  <= 1 and  0 <= lb  <= 1

	if(((fLA >= 0.0f) && (fLA <= 1.0f)) && ((fLB >= 0.0f) && (fLB <= 1.0f))) {
		// interesection
		vReturn.x = vS1Start.x + fLA * vS1.x;
		vReturn.y = vS1Start.y + fLA * vS1.y;
		vReturn.z = 0.0f;
	} else {
		vReturn.z = -1.0f;
	}

	return vReturn;
}


//@}

/************************************************************/
/** @name Locations
* Deals with with locations, and Adjusting or information about them
********************************************************* @{ */


/**  
* Convert a location to a printable string: Area (x,y,z)
* @author Nytir
* @param 
* @see 
* @return 
*/
string CSLFormatLocation(location lLoc)
{
	vector vLoc = GetPositionFromLocation(lLoc);
	string sA   = GetTag(GetAreaFromLocation(lLoc));
	string sX   = CSLFormatFloat(vLoc.x);
	string sY   = CSLFormatFloat(vLoc.y);
	string sZ   = CSLFormatFloat(vLoc.z);
	return sA+" ("+sX+", "+sY+", "+sZ+")";
}






/**  
* Turn a location into a string. Useful for debugging.
* @author
* @param 
* @see 
* @replaces LocationToString by OEI from i0_x0_position
* @return 
*/
string CSLLocationToString(location loc)
{
    return "(" + GetTag(GetAreaFromLocation(loc)) + ")"
        + " " + CSLVectorToString(GetPositionFromLocation(loc))
        + " (" + FloatToString(GetFacingFromLocation(loc)) + ")";
}

/**  
* Get a string from a corresponding location which can be stored in a database and converted back into a location
* @author Jaliax
* @param lLocation Location from which the string is get
* @see 
* @replaces JXLocationToString
* @return a string corresponding to the location
*/
string CSLSerializeLocation(location lLocation)
{
	// this is the SQLLocationToString from NWNX soas to make sure things are standardized
	object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fOrientation = GetFacingFromLocation(lLocation);
    string sReturnValue;

    if (GetIsObjectValid(oArea))
        sReturnValue =
            "#A#" + GetTag(oArea) + "#X#" + FloatToString(vPosition.x) +
            "#Y#" + FloatToString(vPosition.y) + "#Z#" +
            FloatToString(vPosition.z) + "#O#" + FloatToString(fOrientation) + "#END#";

    return sReturnValue;
}

/**  
* Turn an Object's Location into a string. Useful for debugging.
* @author
* @param 
* @see 
* @replaces LocationToString by OEI from i0_x0_position
* @return 
*/
string CSLSerializeObjectLocation( object oCreature )
{
    return CSLSerializeLocation(GetLocation(oCreature) );
}



/**  
* Get a location from a corresponding string
* @author jaliax and NWNx
* @param sLocation a serialized location
* @see 
* @replaces JXStringToLocation, SQLStringToLocation
* @return a loation corresponding to the string
*/
location CSLUnserializeLocation(string sLocation)
{
	location lReturnValue;
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int iPos, iCount;
    int iLen = GetStringLength(sLocation);

    if (iLen > 0)
    {
        iPos = FindSubString(sLocation, "#A#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        oArea = GetObjectByTag(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#X#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#Y#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#Z#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sLocation, iPos, iCount));

        vPosition = Vector(fX, fY, fZ);

        iPos = FindSubString(sLocation, "#O#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fOrientation = StringToFloat(GetSubString(sLocation, iPos, iCount));

        lReturnValue = Location(oArea, vPosition, fOrientation);
    }

    return lReturnValue;
}


/**  
* private function for debugging
* @author
* @param 
* @see 
* @replaces SpeakLocation by OEI from i0_x0_position
* @return 
*/
void CSLSpeakLocation(location lLoc)
{
    SpeakString( CSLLocationToString(lLoc) );
}

/**  
* Private function for debugging
* @author
* @param 
* @see 
* @replaces PrintLocation by OEI from i0_x0_position
* @return 
*/
void CSLPrintLocation(location lLoc)
{
    PrintString(CSLLocationToString(lLoc));
}

//@}

/************************************************************/
/** @name XXXXX
* Description
********************************************************* @{ */

object oScriptRunner; // stored in global scope

/**  
* Retrieves the script runner object, ( blueprint has to be available ) which is used detect things for which you need a creature to test with
* @author
* @param 
* @see 
* @return 
*/
object CSLScriptRunner( location lNewLocation )
{
	if ( !GetIsObjectValid( oScriptRunner ) )
	{
		object oScriptRunner = GetObjectByTag( "c_scriptrunner" );
	}
	
	if ( !GetIsObjectValid( oScriptRunner ) )
	{
		object oScriptRunner = CreateObject(OBJECT_TYPE_CREATURE, "c_scriptrunner", lNewLocation, FALSE, "c_scriptrunner" );
		
		ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectMovementSpeedIncrease(99), oScriptRunner ); // it's already at dm speed, so this should help even more
		ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectMovementSpeedIncrease(99), oScriptRunner );
		ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oScriptRunner );
	}
	else
	{
		AssignCommand(oScriptRunner, ActionJumpToLocation( lNewLocation ) );
	}	
	return oScriptRunner;
}

/**  
* this makes a rabbit that is etheral, ghosted, and cutscene invisible, and immune to all damage, and sets their move rate to be very very fast
* then it makes them run at full magical speed to the new location, where actions are cleared and they have the protections removed
* Makes sure that if they can't get some place legally they cannot circumvent the modules rules
* @author
* @param 
* @see 
* @return 
*/
void CSLRabbitRunner( location lTeleportFrom, location lTeleportTo, float fDuration = 12.0f )
{
	object oRabbit = CSLScriptRunner( lTeleportFrom );
	
	ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectMovementSpeedIncrease(99), oRabbit ); // it's already at dm speed, so this should help even more
	//ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectMovementSpeedIncrease(99), oRabbit );
	ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oRabbit );
	AssignCommand(oRabbit, ActionForceMoveToLocation( lTeleportTo, TRUE ));
}


/**  
* pretty expensive, requires the script runner object ( which is reused ) to determine a height at a location
* @author
* @param 
* @see 
* @return 
*/
float CSLGetHeightAtLocation( location lLocation)
{
	object oScriptRunner = CSLScriptRunner( lLocation ); // moves rabbit to locaton
	return CSLGetZFromObject( oScriptRunner );
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
float CSLGetZFromLocation( location lLocation )
{
	// Get the position vector from lLocation.
	vector vPosition = GetPositionFromLocation( lLocation );
	return vPosition.z;
}


/**  
* Gets a nearby location to the original which is the given distance and facing away from the original
* @author
* @param lTarget target location
* @param fDistance max random distance
* @param fFacingNoise angle from 0 to 180, max random change in facing from lTarget
* @param  fMinDistance min random distance
* @see 
* @return location up to fDistance units from lTarget
*/
location CSLGetNearbyLocation(location lTarget, float fDistance, float fFacingNoise=0.0f, float fMinDistance=0.0)
{
    //vector vOld = GetPositionFromLocation(lTarget);
	//float x = CSLRandomDeltaFloat(fDistance);
	//float y = CSLRandomDeltaFloat(fDistance);
    //vector vNew = vOld + Vector(x, y);
	
    vector vOld = GetPositionFromLocation(lTarget);
	vector vNew = vOld + CSLGetRandom2DVector(fDistance, fMinDistance);
	
	float fNewFacing = GetFacingFromLocation(lTarget) + CSLRandomDeltaFloat(fFacingNoise);
	//if (fNewFacing < 0.0f) 
	//	fNewFacing = fNewFacing + 360.0f;
	//else if (fNewFacing > 360.0f) 
	//	fNewFacing = fNewFacing - 360.0f;	
	fNewFacing = CSLGetNormalizedDirection(fNewFacing);
    location lNewLocation = Location (GetAreaFromLocation(lTarget), vNew, fNewFacing);

	// / *
	//	// this wouldn't work as it requires 2 points to define an angle.
	//	float fMagnitude = CSLRandomBetweenFloat(fDistance, fMinDistance);
	//	location lNewLocation = CalcPointAwayFromPoint(lTarget, lTarget, fMagnitude, 180.0f, TRUE);
	// * /	
    return lNewLocation;
}

/**  
* Gets a nearby location to the original which is the given distance and facing away from the original
* @author
* @param lLocation the location you are starting from
* @param fDistancehow far away the new location will be
* @param fAngle the angle difference of the new location - (0.0f=East, 90.0f=North, 180.0f=West, 270.0f=South)
* @param bInvert can be used to invert the direction, i.e. north instead of south etc.
* @param bFaceAngle TRUE if the Target who will go to the new location will face that direction
* @param fAngleToFace if bFaceAngle is false this let you choice the angle the target will be facing
* @see 
* @return location distant fDistance from lLocation
*/
location CSLGetLocationAwayFromLocation(location lLocation, float fDistance, float fAngle, int bInvert, int bFaceAngle, float fAngleToFace)
{
	//Declare variables
	float fHorizontal;
	float fVertical;
	vector vPosition;
	vector vNewPosition;
	object oArea = GetAreaFromLocation(lLocation);
	vector vOldPosition = GetPositionFromLocation(lLocation);
	
	//Calculate the new position depending on the angle
	if(fAngle <= 90.0f)
	{
		fHorizontal = fDistance - (((fAngle/90.0f)*100.0f)*(fDistance/100.0f));
		fVertical = fDistance - fHorizontal;
		if(!bInvert)
			vPosition = Vector(fHorizontal, fVertical);
		else
			vPosition = Vector(-fHorizontal, -fVertical, 0.0f);
	}
	else
	if(fAngle > 90.0f && fAngle <= 180.0f)
	{
		fAngle = fAngle - 90.0f;
		fVertical = fDistance - (((fAngle/90.0f)*100.0f)*(fDistance/100.0f));
		fHorizontal = fDistance - fVertical;
		if(!bInvert)
			vPosition = Vector(-fHorizontal, fVertical);
		else
			vPosition = Vector(fHorizontal, -fVertical, 0.0f);				
	}
	if(fAngle > 180.0f && fAngle <= 270.0f)
	{
		fAngle = fAngle - 180.0f;
		fHorizontal = fDistance - (((fAngle/90.0f)*100.0f)*(fDistance/100.0f));
		fVertical = fDistance - fHorizontal;
		if(!bInvert)
			vPosition = Vector(-fHorizontal, -fVertical);
		else
			vPosition = Vector(fHorizontal, fVertical, 0.0f);				
	}
	if(fAngle > 270.0f)
	{
		fAngle = fAngle - 270.0f;
		fVertical = fDistance - (((fAngle/90.0f)*100.0f)*(fDistance/100.0f));
		fHorizontal = fDistance - fVertical;
		if(!bInvert)
			vPosition = Vector(fHorizontal, -fVertical);
		else
			vPosition = Vector(-fHorizontal, fVertical, 0.0f);				
	}
	
	//Add the old position the the the calculated to create the new one
	vNewPosition = vOldPosition + vPosition;
	
	//If the custom angle is not setted then let the routine take the default
	if(bFaceAngle)
		fAngleToFace = fAngle;
	
	//returns the new location
	location lNewLocation = Location(oArea, vNewPosition, fAngleToFace);
	
	return lNewLocation;				
}


//This returns a random location around oObject. If bExactDistance is true, it returns a random location
//that is exactly fDistance meters away from oObject. If bExactDistance is false, it returns a random location
//within fDistance meters of oObject. NOTE: This does *not* test to see if that location is "safe" or on the walkmesh.
//You should use CalcSafeLocation on the location you receive from this function to do that.
location CSLGetRandomLocationAroundObject(float fDistance, object oObject = OBJECT_SELF, int bExactDistance = TRUE, float fOrientation = 180.0f)
{
	vector vObject = GetPosition(oObject);
	float fAngle = CSLRandomUpToFloat(360.0f);
	if(!bExactDistance)
		fDistance = CSLRandomUpToFloat(fDistance);
	
	float fXVariance = cos(fAngle)*fDistance;
	float fYVariance = sin(fAngle)*fDistance;
						
	vObject.x += fXVariance;
	vObject.y += fYVariance;
	
	location lResult = Location(GetArea(oObject), vObject, fOrientation);
	return lResult;
}


//This returns a random location around oObject. If bExactDistance is true, it returns a random location
//that is exactly fDistance meters away from oObject. If bExactDistance is false, it returns a random location
//within fDistance meters of oObject. NOTE: This does *not* test to see if that location is "safe" or on the walkmesh.
//You should use CalcSafeLocation on the location you receive from this function to do that.
location CSLGetRandomLocationAroundLocation(float fDistance, location lCenterLocation, int bExactDistance = TRUE, float fOrientation = 180.0f)
{
	if (DEBUGGING >= 2) { SendMessageToPC( GetFirstPC(), "lCenterLocation = "+CSLSerializeLocation( lCenterLocation ) ); }
	vector vObject = GetPositionFromLocation(lCenterLocation);
	float fAngle = CSLRandomUpToFloat(360.0f);
	if(!bExactDistance)
		fDistance = CSLRandomUpToFloat(fDistance);
	
	float fXVariance = cos(fAngle)*fDistance;
	float fYVariance = sin(fAngle)*fDistance;
						
	vObject.x += fXVariance;
	vObject.y += fYVariance;
	
	location lResult = Location(GetAreaFromLocation(lCenterLocation), vObject, fOrientation);
	return lResult;
}


/**  
* Get an Offsetted location from lLoc
* @author Nytir
* @param lLoc
* @param fX x offset of original location
* @param fY y offset of original location
* @param fZz offset of original location
* @see 
* @return New Location
*/
location CSLGetOffsetLocation(location lLoc, float fX=0.0f, float fY=0.0f, float fZ=0.0f)
{
	float  fDir  = GetFacingFromLocation(lLoc);
	vector vLoc  = GetPositionFromLocation(lLoc);
	object oArea = GetAreaFromLocation(lLoc);
	vLoc.x += fX;
	vLoc.y += fY;
	vLoc.z += fZ;
	return Location(oArea, vLoc, fDir);
}

/**  
* Get a randomly deviated location
* @author Nytir
* @param lLoc Location
* @param iDvt Deviation
* @see 
* @return New Location
*/
location CSLGetDeviatedLocation(location lLoc, int iDvt=10)
{
	float fX = IntToFloat( iDvt/2 - Random(iDvt+1) ); 
	float fY = IntToFloat( iDvt/2 - Random(iDvt+1) );
	return CSLGetOffsetLocation(lLoc, fX, fY);
}


/**  
* This returns a new vector representing a position that is fDistance
* meters away in the direction fAngle from the original position.
* If a negative coordinate is generated, the absolute value will
* be used instead.
* @author
* @param 
* @see 
* @replaces GetChangedPosition by OEI from i0_x0_position
* @return 
*/
vector CSLGetChangedPosition(vector vOriginal, float fDistance, float fAngle)
{
    vector vChanged;
    vChanged.z = vOriginal.z;
    vChanged.x = vOriginal.x + ( fDistance * cos(fAngle) ); // change in x ( fDistance * cos(fAngle) )
    if (vChanged.x < 0.0)
        vChanged.x = - vChanged.x;
    vChanged.y = vOriginal.y + ( fDistance * sin(fAngle) );  // change in y ( fDistance * sin(fAngle)
    if (vChanged.y < 0.0)
        vChanged.y = - vChanged.y;

    return vChanged;
}



/**  
* Gets new location from a source objects location.
* @author
* @param 
* @see 
* @replaces XXXGenerateNewLocation by OEI from i0_x0_position
* @return 
*/
location CSLGenerateNewLocation(object oTarget, float fDistance, float fAngle, float fOrientation)
{
    object oArea = GetArea(oTarget);
    vector vNewPos = CSLGetChangedPosition(GetPosition(oTarget), fDistance, fAngle);
    return Location(oArea, vNewPos, fOrientation);
}

/**  
* Gets new location from a source location.
* @author
* @param 
* @see 
* @replaces XXXGenerateNewLocationFromLocation by OEI from i0_x0_position
* @return 
*/
location CSLGenerateNewLocationFromLocation(location lTarget, float fDistance, float fAngle, float fOrientation)
{
    object oArea = GetAreaFromLocation(lTarget);
    vector vNewPos = CSLGetChangedPosition(GetPositionFromLocation(lTarget),   fDistance, fAngle);
    return Location(oArea, vNewPos, fOrientation);
}


/**  
* This returns the angle between two locations
* @author
* @param 
* @see 
* @replaces GetAngleBetweenLocations by OEI from i0_x0_position
* @return 
*/
float CSLGetAngleBetweenLocations(location lOne, location lTwo)
{
    vector vPos1 = GetPositionFromLocation(lOne);
    vector vPos2 = GetPositionFromLocation(lTwo);
    float fDist = GetDistanceBetweenLocations(lOne, lTwo);

    float fChangeX = fabs(vPos1.x - vPos2.x);

    float fAngle = acos(fChangeX / fDist);
    return fAngle;
}
/*
float GetRelativeAngleBetweenLocations(location lFrom, location lTo)
{
    vector vPos1 = GetPositionFromLocation(lFrom);
    vector vPos2 = GetPositionFromLocation(lTo);
    //sanity check
    if(GetDistanceBetweenLocations(lFrom, lTo) == 0.0)
        return 0.0;

    float fAngle = acos((vPos2.x - vPos1.x) / GetDistanceBetweenLocations(lFrom, lTo));
    // The above formula only returns values [0, 180], so test for negative y movement
    if((vPos2.y - vPos1.y) < 0.0f)
        fAngle = 360.0f -fAngle;

    return fAngle;
}
*/


// Get the cosine of the angle between the two objects
// is this the same as the above CSLGetAngleBetweenLocations, need to research the results these give
// @replaces SCGetCosAngleBetween
float CSLGetCosAngleBetween(object Loc1, object Loc2)
{
    vector v1 = GetPositionFromLocation(GetLocation(Loc1));
    vector v2 = GetPositionFromLocation(GetLocation(Loc2));
    vector v3 = GetPositionFromLocation(GetLocation(OBJECT_SELF));

    v1.x -= v3.x; v1.y -= v3.y; v1.z -= v3.z;
    v2.x -= v3.x; v2.y -= v3.y; v2.z -= v3.z;

    float dotproduct = v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;

    return dotproduct/(VectorMagnitude(v1)*VectorMagnitude(v2));

}



/**  
* Returns location directly left of the target and facing same direction as the target
* @author
* @param 
* @see 
* @replaces XXXGetLeftLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetLeftLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM )
{
	float fFacing = GetFacing( oTarget );
	float fLeftDir = CSLGetLeftDirection( fFacing );
	return CSLGenerateNewLocation( oTarget, fDistance, fLeftDir, fFacing );
}

/**  
* Returns location directly right of the target and facing same
* direction as the target
* @author
* @param 
* @see 
* @replaces XXXGetRightLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetRightLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
	float fFacing = GetFacing( oTarget );
	float fRightDir = CSLGetRightDirection( fFacing );
	return CSLGenerateNewLocation( oTarget, fDistance, fRightDir, fFacing );
}


/**  
* This returns the location flanking the target to the right
* @author
* @param 
* @see 
* @replaces GetFlankingRightLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetFlankingRightLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleToRightFlank = CSLGetFarRightDirection(fDir);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngleToRightFlank, fDir);
}


/**  
* Returns the location flanking the target to the left
* (slightly behind) and facing same direction as the target.
* (useful for backup)
* @author
* @param 
* @see 
* @replaces GetFlankingLeftLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetFlankingLeftLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleToLeftFlank = CSLGetFarLeftDirection(fDir);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngleToLeftFlank, fDir);
}


/**  
* Returns a location directly ahead of the target and
* facing the target
* @author
* @param 
* @see 
* @replaces XXGetOppositeLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetOppositeLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleOpposite = CSLGetOppositeDirection(fDir);
    return CSLGenerateNewLocation(oTarget,  fDistance, fDir, fAngleOpposite);
}

/**  
* Returns location directly ahead of the target and facing
* same direction as the target
* @author
* @param 
* @see 
* @replaces XXXGetAheadLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetAheadLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    return CSLGenerateNewLocation(oTarget, fDistance,  fDir, fDir);
}

/**  
* Returns location directly behind the target and facing same
* direction as the target (useful for backstabbing attacks)
* @author
* @param 
* @see 
* @replaces XXXGetBehindLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetBehindLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleOpposite = CSLGetOppositeDirection(fDir);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngleOpposite, fDir);
}


/**  
* Returns location to the forward right flank of the target
* and facing the same way as the target
* (useful for guarding)
* @author
* @param 
* @see 
* @replaces GetForwardFlankingRightLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetForwardFlankingRightLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = CSLGetHalfRightDirection(fDir);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngle, fDir);
}


/**  
* Returns location to the forward left flank of the target
* and facing the same way as the target
* (useful for guarding)
* @author
* @param 
* @see 
* @replaces GetForwardFlankingLeftLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetForwardFlankingLeftLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = CSLGetHalfLeftDirection(fDir);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngle, fDir);
}

/**  
* Returns location to the forward right and facing the target.
* (useful for one of two people facing off against the target)
* @author
* @param 
* @see 
* @replaces GetAheadRightLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetAheadRightLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = CSLGetHalfRightDirection(fDir);
    float fFaceAngle = CSLGetOppositeDirection(fAngle);
    return CSLGenerateNewLocation(oTarget,  fDistance, fAngle,  fFaceAngle);
}

/**  
* Returns location to the forward left and facing the target.
* (useful for one of two people facing off against the target)
* @author
* @param 
* @see 
* @replaces GetAheadLeftLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetAheadLeftLocation(object oTarget, float fDistance=SC_DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = CSLGetHalfLeftDirection(fDir);
    float fFaceAngle = CSLGetOppositeDirection(fAngle);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngle, fFaceAngle);
}


/**  
* Returns location just a step to the left
* (Let's do the time warp...)
* @author
* @param 
* @see 
* @replaces GetStepLeftLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetStepLeftLocation(object oTarget, float fDistance=SC_DISTANCE_TINY)
{
    float fDir = GetFacing(oTarget);
    float fAngle = CSLGetLeftDirection(fDir);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngle,  fDir);
}

/**  
* Returns location just a step to the right
* @author
* @param 
* @see 
* @replaces GetStepRightLocation by OEI from i0_x0_position
* @return 
*/
location CSLGetStepRightLocation(object oTarget, float fDistance=SC_DISTANCE_TINY)
{
    float fDir = GetFacing(oTarget);
    float fAngle = CSLGetRightDirection(fDir);
    return CSLGenerateNewLocation(oTarget, fDistance, fAngle, fDir);
}


//@}

/************************************************************/
/** @name Area Functions
* Deals with with areas, and distributing things in an area
********************************************************* @{ */

/**  
* Get random point of an area, can adjust for height.
* @author
* @param 
* @see 
* @return 
*/
location CSLGetRandomSpotInArea(object oArea, int bWithinBorders = FALSE, float fheightAdjust = 0.0f )
{
	// GetIsObjectValid(oArea);
	float fY = 10.0f;
	float fX = 10.0f;
	int iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	if ( iHeight == 0 )
	{
		oArea = GetArea(oArea);
		iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	}
	int iWidth = GetAreaSize( AREA_WIDTH, oArea );
	
	if ( bWithinBorders )
	{
		iHeight -= 16;
		iWidth -= 16;
	}

	float fHeight = Random(iHeight*10)*0.1f;
	float fWidth = Random(iWidth*10)*0.1f;

	if ( bWithinBorders )
	{
		fHeight += 8.0f;
		fWidth += 8.0f;
	}
	

	// convert to meters
	if ( GetIsAreaInterior( oArea ) )
	{
		fY = ( fHeight* 9.0f );
		fX = ( fWidth*9.0f );
	}
	else
	{
		fY =  ( fHeight*10.0f );
		fX =  ( fWidth*10.0f );
	}
	return Location(oArea, Vector(fX, fY, 0.0+fheightAdjust), 0.0f );
}


/**  
* Get the (roughly) center point of an area, can adjust for height.
* @author
* @param 
* @see 
* @return 
*/
location CSLGetCenterPointOfArea(object oArea, float fheightAdjust = 0.0f)
{
	// GetIsObjectValid(oArea);
	
	int iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	if ( iHeight == 0 )
	{
		oArea = GetArea(oArea);
		iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	}
	int iWidth = GetAreaSize( AREA_WIDTH, oArea );
	float fY = 10.0f;
	float fX = 10.0f;

	// convert to meters
	if ( GetIsAreaInterior( oArea ) )
	{
		fY = ( ( (iHeight* 9.0f) / 2) + 0.45f);
		fX = ( ( (iWidth*9.0f) / 2) + 0.45f);
	}
	else
	{
		fY =  ( ( (iHeight*10.0f) / 2) + 0.5f);
		fX =  ( ( (iWidth*10.0f) / 2) + 0.5f);
	}
	return Location(oArea, Vector(fX, fY, 0.0+fheightAdjust), 0.0f );
}

/**  
* Get a random location in a given area based on a given object,
* the specified distance away.
* If no object is given, will use a random object in the area.
* If that is not available, will use the roughly-center point
* of the area.
* If distance is <= to 0.0, a random distance will be used.
* @author
* @param 
* @see 
* @return 
*/
location CSLGetRandomLocation( object oArea, object oSource=OBJECT_INVALID, float fDist=0.0f )
{
	location lStart;
	
	if ( GetIsObjectValid( oSource ) == FALSE )
	{
		lStart = CSLGetCenterPointOfArea( oArea );
	}
	else
	{
		lStart = GetLocation( oSource );
	}
	
	// BMA-OEI 7/13/06 float precision
	if ( fDist <= 0.001f )
	{
		fDist = IntToFloat( Random( FloatToInt( SC_DISTANCE_HUGE - SC_DISTANCE_TINY ) * 10 ) ) / 10;
	}	
	
	float fAngle = IntToFloat( Random( 360 ) );
	float fOrient = IntToFloat( Random( 360 ) );
	location lRandLoc = CSLGenerateNewLocationFromLocation( lStart, fDist, fAngle, fOrient );
	
	return ( lRandLoc );
	
//    if (fDist == 0.0) {
//        int iRoll = Random(3);
//        switch (iRoll) {
//        case 0:
//            fDist = SC_DISTANCE_MEDIUM; break;
//        case 1:
 //           fDist = SC_DISTANCE_LARGE; break;
 //       case 2:
 //           fDist = SC_DISTANCE_HUGE; break;
 //       }
 //   }
//
//    fAngle = IntToFloat(Random(140) + 40);

}

/**  
* Get a position related to a grid laid over an area relative to the walkmesh, used to iterate over an area.
* @author
* @param 
* @see 
* @return 
*/
location CSLGetLocationByTileCoordinate(object oArea, int iTileX, int iTileY, float fheightAdjust = 0.0f )
{
	// Make sure it's valid
	int iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	if ( iHeight == 0 )
	{
		oArea = GetArea(oArea);
		iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	}
	int iWidth = GetAreaSize( AREA_WIDTH, oArea );
	
	// Make sure it's in bounds
	iTileX = CSLGetMin( iHeight, iTileX );
	iTileY = CSLGetMin( iWidth, iTileY );
	
	float fY = 10.0f;
	float fX = 10.0f;

	// convert to meters
	if ( GetIsAreaInterior( oArea ) )
	{
		fY = ( iTileX * 9.0f + 0.45f );
		fX = ( iTileY * 9.0f + 0.45f );
	}
	else
	{
		fY =  ( iTileX * 10.0f + 0.5f );
		fX =  ( iTileY * 10.0f + 0.5f );
	}
	
	location lFinalLocation = Location(oArea, Vector(fX, fY, 0.0), 0.0f );
	float fZ = CSLGetHeightAtLocation( lFinalLocation );
	
	//if ( fheightAdjust != 0.0f )
	//{
	//	return CSLGetOffsetLocation( lFinalLocation, 0.0f, 0.0f, fheightAdjust );
	//}
	
	return Location(oArea, Vector(fX, fY, fZ+fheightAdjust), 0.0f );;
}

/**  
* Get a position related to a grid laid over an area all at the given height, used to iterate over an area.
* @author
* @param 
* @see 
* @return 
*/
location CSLGetLocationByTileCoordinateFixed(object oArea, int iTileX, int iTileY, float fheight = 0.0f )
{
	// Make sure it's valid
	int iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	if ( iHeight == 0 )
	{
		oArea = GetArea(oArea);
		iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	}
	int iWidth = GetAreaSize( AREA_WIDTH, oArea );
	
	// Make sure it's in bounds
	iTileX = CSLGetMin( iHeight, iTileX );
	iTileY = CSLGetMin( iWidth, iTileY );
	
	float fY = 10.0f;
	float fX = 10.0f;

	// convert to meters
	if ( GetIsAreaInterior( oArea ) )
	{
		fY = ( iTileX * 9.0f + 0.45f );
		fX = ( iTileY * 9.0f + 0.45f );
	}
	else
	{
		fY =  ( iTileX * 10.0f + 0.5f );
		fX =  ( iTileY * 10.0f + 0.5f );
	}
	
	return Location(oArea, Vector(fX, fY, fheight), 0.0f );
	//float fZ = CSLGetHeightAtLocation( lFinalLocation );
	
	//if ( fheightAdjust != 0.0f )
	//{
	//	return CSLGetOffsetLocation( lFinalLocation, 0.0f, 0.0f, fheightAdjust );
	//}
	
	//return Location(oArea, Vector(fX, fY, fZ+fheightAdjust), 0.0f );;
}


//@}


/************************************************************/
/** @name SubArea Functions
* Deals with with Triggers, AOE's and Encounters related to positioning
********************************************************* @{ */

/**  
* Checks if an object is inside a given trigger or encounter or AOE
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsInsideSubArea( object oTarget, object oSubArea )
{
	vector lPosition = GetPosition( oTarget );
	object oArea = GetArea( oTarget );
	
	object oTestSubarea = GetFirstSubArea( oArea, lPosition );
	while(GetIsObjectValid(oTestSubarea))
	{
		if ( oTestSubarea == oSubArea )
		{
			return TRUE;
		}
		oTestSubarea = GetNextSubArea(oArea);
	}
	
	return FALSE;
}


/**  
* Moves a creature out of an object, includes ability to repeat the order until they comply
* @author
* @param 
* @see 
* @return 
*/
void CSLMoveOutOfObject( object oTarget, object oSubArea, int iAttempts = 1 )
{
	if ( CSLGetIsInsideSubArea( oTarget, oSubArea ) )
	{
		AssignCommand( oTarget, ClearAllActions() );
		AssignCommand(oTarget, SetFacingPoint( GetPosition(oSubArea))); // fix the walking sideways issue
		location lTarget = CSLGetBehindLocation(oTarget, SC_DISTANCE_TINY);
		DelayCommand( 0.25f, AssignCommand(oTarget, JumpToLocation(lTarget)));
		
		if ( iAttempts > 0 )
		{
			iAttempts--;
			DelayCommand( 0.5f, CSLMoveOutOfObject( oTarget, oSubArea, iAttempts ) );
		}
	}
}


// Move to target if distance with oTrg > fDis
// Return true if within desired distance
// oAct : Actor
// oTrg : Target
// iRun : Run or walk
// fDis : How close to Target
int CSLMoveToObject(object oAct, object oTrg, int iRun=TRUE, float fDis=3.0f)
{
	if( GetDistanceBetween(oAct, oTrg) > fDis ){
		AssignCommand(oAct, ActionMoveToObject(oTrg, iRun));
		return FALSE;
	}
	return TRUE;
}

// Move to target if distance with oTrg > fDis
// Return true if within desired distance
// oAct : Actor
// sTag : Tag of target
// iRun : Run or walk
// fDis : How close to Target
int CSLMoveToObjectWithTag(object oAct, string sTag, int iRun=TRUE, float fDis=3.0f)
{
	object oTrg = GetNearestObjectByTag(sTag, oAct);
	return CSLMoveToObject(oAct, oTrg, iRun, fDis);
}




//void ActionOrientToTag(string sTag, int iOrientation = CSL_ORIENT_FACE_TARGET)
void CSLActionOrientToTag(string sTag, int iOrientation = CSL_ORIENT_FACE_TARGET )
{
	object oTrg = GetWaypointByTag(sTag);
	if (!GetIsObjectValid(oTrg))
	{
		object oTrg = GetNearestObjectByTag(sTag);
		if (!GetIsObjectValid(oTrg))
		{
			oTrg = GetObjectByTag(sTag);	// search module
		}
	}
	
	
	switch (iOrientation)
	{
		case CSL_ORIENT_FACE_TARGET:
		    //ActionDoCommand(SetFacingPoint( GetPositionFromLocation(GetLocation(oTarget))));
		    ActionDoCommand(SetFacingPoint(GetPosition(oTrg)));
			break;
				
		case CSL_ORIENT_FACE_SAME_AS_TARGET:
			ActionDoCommand(SetFacing(GetFacing(oTrg)));
			break;
	}
	
    ActionWait(0.5f);  // need time to change facing
	
	//return CSLMoveToObject(oAct, oTrg, iRun, fDis);
}







// Count Objects with sTag in target's area
// sTag : Tag
// oTrg : Target
int CSLCountNearbyObjectWithTag(string sTag, object oTrg=OBJECT_SELF)
{
	int    iN   = 1;
	object oObj = GetNearestObjectByTag(sTag, oTrg, iN);
	while( GetIsObjectValid(oObj) )
	{
		iN ++;
		oObj = GetNearestObjectByTag(sTag, oTrg, iN);
	}
	return (iN - 1);
}

/**  
* Gets a random object in the specified shape
* @author
* @param 
* @see 
* @return 
*/
object CSLGetRandomObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0])
{
	int nCount = 0;
	object oTarget;
	oTarget = GetFirstObjectInShape(nShape, fSize, lTarget, bLineOfSight, nObjectFilter, vOrigin);
	while(GetIsObjectValid(oTarget))
	{
			nCount++;
			oTarget = GetNextObjectInShape(nShape, fSize, lTarget, bLineOfSight, nObjectFilter, vOrigin);
	}
	
	if ( nCount == 0)
	{
		return OBJECT_INVALID;
	}
	else if ( nCount == 1)
	{
		return oTarget; // still should be valid
	}
	else if ( nCount > 1) // more than one, pick a random one
	{
		int iRandom = Random(nCount)+1;
		
		nCount = 0;
		oTarget = GetFirstObjectInShape(nShape, fSize, lTarget, bLineOfSight, nObjectFilter, vOrigin);
		while( GetIsObjectValid(oTarget))
		{
			nCount++;
			if ( iRandom == nCount)
			{
				return oTarget;
			}
			oTarget = GetNextObjectInShape(nShape, fSize, lTarget, bLineOfSight, nObjectFilter, vOrigin);
		}
	}
	return oTarget; // should never hit this, but just in case.
}

//@}

/************************************************************/
/** @name Object ( Creature ) Position Functions
* Deals with with a creatures location, height, or relative location
********************************************************* @{ */

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
float CSLGetZFromObject( object oObject )
{
	// Get the position vector from lLocation.
	vector vPosition = GetPositionFromLocation(GetLocation( oObject ));
	return vPosition.z;
}



/**  
* Is the other object within the given range as well as alive
* @author
* @param 
* @see 
* @return 
*/
int CSLPCIsClose(object oPC, object oObject, int nDist = 0)
{
	if ( oObject==OBJECT_INVALID || oPC==OBJECT_INVALID) return FALSE; // LOGGED OUT?
	if ( GetCurrentHitPoints(oPC) < 1 ) return FALSE; // DEAD MEAT
	if (GetArea(oObject)==GetArea(oPC)) { // SAME AREA, CHECK DISTANCE
		if (nDist==0) return TRUE; // NO DISTANCE, THEY ARE CLOSE ENOUGH
		return (GetDistanceBetween(oObject, oPC) < IntToFloat(nDist));
	}
	return FALSE;
}

/**  
* Is the other object within the given range, ignores if they are dead
* @author
* @param 
* @see 
* @return 
*/
int CSLIsClose(object oPC, object oObject, float fDist = 0.0)
{
	if ( oObject==OBJECT_INVALID || oPC==OBJECT_INVALID) return FALSE; // LOGGED OUT?
	if (GetArea(oObject)==GetArea(oPC)) // SAME AREA
	{ 
		if (fDist==0.0) // NO DISTANCE, THEY ARE CLOSE ENOUGH
		{
			return TRUE; 
		}
		if ( GetDistanceBetween(oObject, oPC) < fDist )
		{
			return TRUE;
		}
	}
	return FALSE;
}


/**  
* This returns the angle between two locations
* @author
* @param 
* @see 
* @replaces GetAngleBetweenObjects by OEI from i0_x0_position
* @return 
*/
float CSLGetAngleBetweenObjects(object oBegin, object oEnd)
{
    vector vPos1 = GetPosition(oBegin);
    vector vPos2 = GetPosition(oEnd);
    float fDist = GetDistanceBetween(oBegin, oEnd);

    return (CSLGetAngle(vPos1, vPos2, fDist));
}


/**  
* Turns the object to face the specified object
* @author
* @param 
* @see 
* @replaces XXXTurnToFaceObject by OEI from i0_x0_position
* @return 
*/
void CSLTurnToFaceObject(object oObjectToFace, object oTarget=OBJECT_SELF)
{
    AssignCommand(oTarget,  SetFacingPoint( GetPosition(oObjectToFace)));
}





/**  
* see if I am faicing within fDegrees of Object
* @author
* @param 
* @see 
* @replaces XXXIsFacingWithin by OEI from i0_x0_position
* @return 
*/
int CSLIsFacingWithin(float fDegrees, object oObject, object oSource = OBJECT_SELF )
{
    int iRet;
    // return direction in degrees.
    float fDirectionOfFacing = GetFacing(oSource);

    float fDirectionOfObject = CSLGetAngleBetweenObjects(oSource, oObject);

    // float fDelta = CSLGetNormalizedDirection(fDirectionOfFacing - fDirectionOfObject);

    iRet = CSLIsDirectionWithinTolerance(fDirectionOfObject, fDirectionOfFacing, fDegrees);
    return (iRet);
}


/**  
* Is the placeable within view?
* Need to check if there is another way to do this, the perception range, and if two objects can see each other i think can be done now
* @author
* @param oViewObj placeable to look for
* @param fAngle degrees to look to the right.  Full view Arc is twice this.
* @param fMaxDistance No way to get percetption range, so a distance is needed
* @see 
* @replaces IsPlaceableInView by OEI from i0_x0_position
* @return 
*/
int CSLIsPlaceableInView(object oViewObj, float fAngle=75.0f, float fMaxDistance = SC_DISTANCE_LARGE, object oSource = OBJECT_SELF)
{
    // is the object valid?
    if (!GetIsObjectValid(oViewObj))
    {
        return FALSE;
	}
    // is the object within range of seeing?
    if (GetDistanceToObject(oViewObj) > fMaxDistance)
    {
        return FALSE;
    }
    // * if really close, line of sight, is irrelevant, if this check is removed it gets very annoying because the player can block line of sight
    if (GetDistanceToObject(oViewObj) < 6.0)
    {
         return TRUE;
	}
    // am I facing the object?
    if (! CSLIsFacingWithin(fAngle, oViewObj, oSource ) )
    {
        return FALSE;
	}
    // is the object in my line of sight
    // presumed that this is the most expensive function and thus done last
    return LineOfSightObject(OBJECT_SELF, oViewObj);
}


//Pausanias: Is Object in the line of sight of the seer
int CSLGetIsInLineOfSight(object oTarget,object oSeer=OBJECT_SELF)
{
    // * if really close, line of sight, is irrelevant, if this check is removed it gets very annoying because the player can block line of sight
    if (GetDistanceBetween(oTarget, oSeer) < 6.0)
    {
        return TRUE;
    }

    return LineOfSightObject(oSeer, oTarget);

}


/**  
* Is the creature within view?
* @author
* @param oViewObj creature to look for
* @param fAngle degrees to look to the right.  Full view Arc is twice this.
* @see 
* @replaces IsCreatureInView by OEI from i0_x0_position
* @return 
*/
int CSLIsCreatureInView(object oViewObj, float fAngle=75.0f, object oSource=OBJECT_SELF )
{
    // is the object valid?
    if (!GetIsObjectValid(oViewObj) || !GetIsObjectValid(oSource) )
    {
        return FALSE;
	}
    // can I see the object?
    // this should take into account Line of sight and
    // distance based on percetption range
    if (!GetObjectSeen(oViewObj, oSource ))
    { 
        return FALSE;
	}
	
    // am I facing the object?
    if (!CSLIsFacingWithin(fAngle, oViewObj, oSource ))
    {
        return FALSE;
	}
    return TRUE;
}


/**  
* Returns the angle between two targets
* @author
* @param oFirst is the point of reference on whom the angle is deduced
* @param oSecond
* @see 
* @replaces GetAngleBetweenTargets which i think is an OEI function
* @return 
*/
float CSLGetAngleBetweenTargets(object oFirst, object oSecond)
{
	vector vFirst = GetPosition(oFirst);
	vector vSecond = GetPosition(oSecond);
	vector vSpace = vSecond - vFirst;
	
	return VectorToAngle(vSpace);
}

/**  
* Gets a location in front of the oPC at the given height
* @author
* @param 
* @see 
* @return 
*/
location CSLGetLocationAboveAndInFrontOf(object oPC, float fDist, float fHeight)
{
   object oTarget = (oPC);
   vector vPosition = GetPosition(oTarget);
   float fOrientation = GetFacing(oTarget);
   vector vNewPos = AngleToVector(fOrientation);
   float vZ = vPosition.z + fHeight;
   float vX = vPosition.x + fDist * vNewPos.x;
   float vY = vPosition.y + fDist * vNewPos.y;
   vNewPos = Vector(vX, vY, vZ);
   return Location(GetArea(oTarget), vNewPos, fOrientation);
}


/**  
* Predicts the time required a creature to reach a given point
* @author PRC
* @todo double check the math in NWN2
* @param 
* @see 
* @return 
*/
float CSLGetTimeToCloseDistance(float fMeters, object oPC, int bIsRunning = FALSE)
{
     float fTime = 0.0;
     float fSpeed = 0.0;

     int iMoveRate = GetMovementRate(oPC);

     switch(iMoveRate)
     {
          case 0:
               fSpeed = 2.0;
               break;
          case 1:
               fSpeed = 0.0;
               break;
          case 2:
               fSpeed = 0.75;
               break;
          case 3:
               fSpeed = 1.25;
               break;
          case 4:
               fSpeed = 1.75;
               break;
          case 5:
               fSpeed = 2.25;
               break;
          case 6:
               fSpeed = 2.75;
               break;
          case 7:
               fSpeed = 2.0;  // could change to creature default in the appearance.2da.
               break;
          case 8:
               fSpeed = 5.50;
               break;
     }

     // movement speed doubled if running
     if(bIsRunning) fSpeed *= 2.0;
	/* need to fix these
     // other effects that can change movement speed
     if( CSLGetHasEffectType(oPC, EFFECT_TYPE_HASTE ) ) fSpeed *= 2.0;
     if( CSLGetHasEffectType(oPC, EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ) ) fSpeed *= 2.0;

     if( CSLGetHasEffectType(oPC, EFFECT_TYPE_SLOW ) ) fSpeed /= 2.0;
     if( CSLGetHasEffectType(oPC, EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ) ) fSpeed /= 2.0;
	*/
     if( GetHasFeat(FEAT_BARBARIAN_ENDURANCE, oPC) ) fSpeed *= 1.1; // 10% gain
     if( GetHasFeat(FEAT_MONK_ENDURANCE, oPC) )
     {
          float fBonus = 0.1 * (GetLevelByClass(CLASS_TYPE_MONK, oPC) / 3 );
          if (fBonus > 0.90) fBonus = 0.9;

          fBonus += 1.0;
          fSpeed *= fBonus;
     }

     // final calculation
     fTime = fMeters / fSpeed;

     return fTime;
}


/**  
* Determines a random location around the target
* for a miss effect for beams, etc.
* @author Karl Nickels (Syrus Greycloak)
* @param 
* @see 
* @replaces GetMissLocation
* @return 
*/
location CSLGetMissLocation(object oTarget)
{
    int iRandom = d6();
    location lNewLoc;

    switch(iRandom) {
        case 1:
            lNewLoc = CSLGetForwardFlankingRightLocation(oTarget);
            break;
        case 2:
            lNewLoc = CSLGetFlankingRightLocation(oTarget);
            break;
        case 3:
            lNewLoc = CSLGetBehindLocation(oTarget);
            break;
        case 4:
            lNewLoc = CSLGetFlankingLeftLocation(oTarget);
            break;
        case 5:
            lNewLoc = CSLGetForwardFlankingLeftLocation(oTarget);
            break;
        case 6:
            lNewLoc = CSLGetAheadLocation(oTarget);
            break;
    }

    return lNewLoc;
}

//@}

/************************************************************/
/** @name Teleportation and Jumping
* Functions to deal with jumping, being thrown, transposed, moved, and forcibly relocated
********************************************************* @{ */


/**  
* Checks if the target can teleport, based on the anchor spell effect or character state vars
* @author
* @param 
* @see 
* @return 
*/
int CSLGetCanTeleport( object oTarget = OBJECT_SELF)
{
	if ( GetHasSpellEffect( SPELL_DIMENSIONAL_ANCHOR, oTarget ) ) { return FALSE; }
	if ( GetLocalInt( oTarget, "CSL_CHARSTATE" ) & BIT31 ) { return FALSE; } // CSL_CHARSTATE_ANCHORED
	
	return TRUE;
}

/* Code from the PRC
int GetCanTeleport(object oCreature, location lTarget, int bMovesCreature = FALSE, int bInform = FALSE, int bPublic = FALSE)
{
    int bReturn = TRUE;
    // First, check global switch to turn off teleporting
    if(CSLGetPreferenceSwitch(PRC_DISABLE_TELEPORTATION))
        bReturn = FALSE;

    // If the creature would be actually moved around, do some extra tests
    if(bMovesCreature)
    {
        // Check area-specific variables
        object oSourceArea = GetArea(oCreature);
        object oTargetArea = GetAreaFromLocation(lTarget);
        // Teleportation is between areas
        if(oSourceArea != oTargetArea)
        {
            // Check forbiddance variable on the current area
            if(GetLocalInt(oSourceArea, PRC_DISABLE_TELEPORTATION_IN_AREA) & PRC_DISABLE_TELEPORTATION_FROM_AREA)
                bReturn = FALSE;
            // Check forbiddance variable on the target area
            if(GetLocalInt(oTargetArea, PRC_DISABLE_TELEPORTATION_IN_AREA) & PRC_DISABLE_TELEPORTATION_TO_AREA)
                bReturn = FALSE;
        }
        // Teleportation within an area
        else if(GetLocalInt(oSourceArea, PRC_DISABLE_TELEPORTATION_IN_AREA) & PRC_DISABLE_TELEPORTATION_WITHIN_AREA)
            bReturn = FALSE;
    }


    // Check forbiddance variable on the creature
    if(GetLocalInt(oCreature, PRC_DISABLE_CREATURE_TELEPORT))
        bReturn = FALSE;

    // Tell the creature about failure, if necessary
    if(bInform & !bReturn)
    {
        // "Something prevents your extra-dimensional movement!"
        FloatingTextStrRefOnCreature(16825298, oCreature, bPublic);
    }

    return bReturn;
}
*/


/**  
* Checks if the target can ethereal, based on the anchor spell effect or character state vars
* @author
* @param 
* @see 
* @return 
*/
int CSLGetCanEthereal( object oTarget = OBJECT_SELF)
{
	if ( GetHasSpellEffect( SPELL_DIMENSIONAL_ANCHOR, oTarget ) ) { return FALSE; }
	if ( GetLocalInt( oTarget, "CSL_CHARSTATE" ) & BIT31 ) { return FALSE; } // CSL_CHARSTATE_ANCHORED
	return TRUE;
}


/**  
* This actually moves the target to the given new location,
* and makes them face the correct way once they get there.
* @author
* @param 
* @see 
* @replaces MoveToNewLocation by OEI from i0_x0_position
* @return 
*/
void CSLMoveToNewLocation(location lNewLocation, object oTarget=OBJECT_SELF)
{
    AssignCommand(oTarget, ActionMoveToLocation(lNewLocation));
    AssignCommand(oTarget, ActionDoCommand( SetFacing(GetFacingFromLocation(lNewLocation))));
}











/**  
* Find nearest exit to target (either door or trigger or 
* (failing those) waypoint).
* @author OEI
* @param 
* @see 
* @replaces XXXXGetNearestExit
* @return 
*/
object CSLGetNearestExit(object oTarget=OBJECT_SELF)
{
    object oCurArea = GetArea(oTarget);

    object oNearDoor = GetNearestObject(OBJECT_TYPE_DOOR, oTarget);
    if (GetArea(oNearDoor) != oCurArea)
        oNearDoor = OBJECT_INVALID;

    // Find nearest area transition trigger
    int nTrig = 1;
    object oNearTrig = GetNearestObject(OBJECT_TYPE_TRIGGER, oTarget);
    while (GetIsObjectValid(oNearTrig) 
           && GetArea(oNearTrig) == oCurArea 
           && !GetIsObjectValid(GetTransitionTarget(oNearTrig))) 
    {
        nTrig++;
        oNearTrig = GetNearestObject(OBJECT_TYPE_TRIGGER, oTarget, nTrig);
    }
    if (GetArea(oNearTrig) != oCurArea)
        oNearTrig = OBJECT_INVALID;

    float fMaxDist = 10000.0;
    float fDoorDist = fMaxDist;
    float fTrigDist = fMaxDist;

    if (GetIsObjectValid(oNearDoor)) {
        fDoorDist = GetDistanceBetween(oNearDoor, oTarget);
    }
    if (GetIsObjectValid(oNearTrig)) {
        fTrigDist = GetDistanceBetween(oNearTrig, oTarget);
    }

    if (fTrigDist < fDoorDist)
        return oNearTrig;

    if (fDoorDist < fTrigDist || fDoorDist < fMaxDist)
        return oNearDoor;

    // No door/area transition -- use waypoint as a backup exit
    return GetNearestObject(OBJECT_TYPE_WAYPOINT, oTarget);
}

/**  
* Private function: find the best exit of the desired type.
* @author OEI
* @param 
* @see 
* @replaces XXXXGetBestExitByType
* @return 
*/
object CSLGetBestExitByType(object oTarget=OBJECT_SELF, object oTargetArea=OBJECT_INVALID, int nObjType=OBJECT_TYPE_DOOR)
{
    object oCurrentArea = GetArea(oTarget);
    int nDoor = 1;

    object oDoor = GetNearestObject(nObjType, oTarget);
    object oNearestDoor = oDoor;
    object oDestArea = OBJECT_INVALID;

    object oBestDoor = OBJECT_INVALID;
    object oBestDestArea = OBJECT_INVALID;

    while (GetIsObjectValid(oDoor) && GetArea(oDoor) == oCurrentArea) {
        oDestArea = GetArea(GetTransitionTarget(oDoor));

        // If we find a door that leads to the target
        // area, use it
        if (oDestArea == oTargetArea) {
            return oDoor;
        }

        // If we find a door that leads to a different area,
        // that might be good if we haven't already found one
        // that leads to the desired area, or a closer door
        // that leads to a different area.
        if (oDestArea != oCurrentArea && !GetIsObjectValid(oBestDoor)) {
            oBestDoor = oDoor;
        }

        // try the next door
        nDoor++;
        oDoor = GetNearestObject(nObjType, oTarget, nDoor);
    }
    
    // If we found a door that leads to a different area, 
    // return that one. 
    if (GetIsObjectValid(oBestDoor)) 
        return oBestDoor;
    
    // Otherwise, return the nearest, if it's in this area.
    if (GetArea(oNearestDoor) == oCurrentArea)
        return oNearestDoor;

    return OBJECT_INVALID;
}


/**  
* Find best exit based on desired target area
* @author OEI
* @param 
* @see 
* @replaces XXXXGetBestExit
* @return 
*/
object CSLGetBestExit(object oTarget=OBJECT_SELF, object oTargetArea=OBJECT_INVALID)
{
    if (!GetIsObjectValid(oTargetArea))
        return CSLGetNearestExit(oTarget);

    // Try and find a door
    object oBestDoor = CSLGetBestExitByType(oTarget, 
                                         oTargetArea, 
                                         OBJECT_TYPE_DOOR);

    if (GetIsObjectValid(oBestDoor)) {
        if (GetTransitionTarget(oBestDoor) == oTargetArea) {
            return oBestDoor;
        }
    }

    // Try and find a trigger
    object oBestTrigger = CSLGetBestExitByType(oTarget, 
                                            oTargetArea, 
                                            OBJECT_TYPE_TRIGGER);
    if (GetIsObjectValid(oBestTrigger)) {
        if (GetTransitionTarget(oBestTrigger) == oTargetArea) {
            return oBestTrigger;
        }
    }

    if (GetIsObjectValid(oBestDoor))
        return oBestDoor;

    if (GetIsObjectValid(oBestTrigger))
        return oBestTrigger;

    return CSLGetNearestExit(oTarget);
        
}

/**  
* Target goes to specified location intelligently. See
* CSLTravelToObject for description.
* @author OEI
* @param 
* @see 
* @replaces XXXXTravelToLocation
* @return 
*/
void CSLTravelToLocation(location lDest, object oTarget=OBJECT_SELF, int bRun=FALSE, float fDelay=10.0)
{
    object oDestArea = GetAreaFromLocation(lDest);
    if (oDestArea == GetArea(oTarget)) {
        AssignCommand(oTarget,
                      ActionForceMoveToLocation(lDest, bRun, fDelay));
    } else {
        object oBestExit = CSLGetBestExit(oTarget, oDestArea);
        AssignCommand(oTarget,
                      ActionForceMoveToObject(oBestExit, bRun, 1.0, fDelay));
        int nObjType = GetObjectType(oBestExit);
        if (nObjType == OBJECT_TYPE_DOOR) {
            AssignCommand(oTarget, ActionOpenDoor(oBestExit));
        }
        AssignCommand(oTarget,
                      ActionJumpToLocation(lDest));
    }
    AssignCommand(oTarget, DelayCommand(fDelay, ClearAllActions()));
    AssignCommand(oTarget, DelayCommand(fDelay, JumpToLocation(lDest)));
}


/**  
* Target goes to specified destination object intelligently.
* If location is in same area, walk (or run) there.
* If location is in different area, walk (or run) to
*     nearest waypoint or door, then jump.
* If either of these fail, jump after a timeout.
* @author OEI
* @param 
* @see 
* @replaces XXXXTravelToObject
* @return 
*/
void CSLTravelToObject(object oDest, object oTarget=OBJECT_SELF, int bRun=FALSE, float fDelay=10.0)
{
    CSLTravelToLocation(GetLocation(oDest), oTarget, bRun, fDelay);
}

/**  
* Transport a player and his/her associates to a location.
* This does NOT transport the rest of the player's party,
* only their henchman, summoned, dominated, etc.
* @author OEI
* @param 
* @see 
* @replaces XXXXTransportToLocation
* @return 
*/
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

/**  
* Transport a player and his/her associates to a waypoint.
* This does NOT transport the rest of the player's party,
* only their henchman, summoned, dominated, etc.
* @author OEI
* @param 
* @see 
* @replaces XXXXTransportToWaypoint
* @return 
*/
void CSLTransportToWaypoint(object oPC, object oWaypoint)
{
    if (!GetIsObjectValid(oWaypoint)) {
        return;
    }
    CSLTransportToLocation(oPC, GetLocation(oWaypoint));
}

/**  
* Transport an entire party with all associates to a location.
* @author OEI
* @param 
* @see 
* @replaces XXXX
* @return 
*/
void CSLTransportAllToLocation(object oPC, location oLoc)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        CSLTransportToLocation(oPartyMem, oLoc);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    CSLTransportToLocation(oPC, oLoc);
}

/**  
* Transport an entire party with all associates to a waypoint.
* @author OEI
* @param 
* @see 
* @replaces XXXXTransportAllToWaypoint
* @return 
*/
void CSLTransportAllToWaypoint(object oPC, object oWaypoint)
{
    if (!GetIsObjectValid(oWaypoint)) {
        return;
    }
    CSLTransportAllToLocation(oPC, GetLocation(oWaypoint));
}


	
/**  
* Function to clear actions on an object and jump to a waypoint/object
* @author OEI
* @param 
* @see 
* @replaces XXXXClearActionsAndJumpToTag
* @return 
*/
void CSLClearActionsAndJumpToTag(string sObject, string sWaypoint)
{
	object oObject = GetObjectByTag(sObject);
	object oWaypoint = GetObjectByTag(sWaypoint);

	AssignCommand(oObject, ClearAllActions());
	AssignCommand(oObject, JumpToObject(oWaypoint));
}

/**  
* Function to clear actions to an object and move to a waypoint/object
* @author OEI
* @param 
* @see 
* @replaces XXXXClearActionsAndMoveToTag
* @return 
*/
void CSLClearActionsAndMoveToTag(string sObject, string sWaypoint, int bRun = FALSE, float fRange = 1.0f)
{
	object oObject = GetObjectByTag(sObject);
	object oWaypoint = GetObjectByTag(sWaypoint);

	AssignCommand(oObject, ClearAllActions());
	AssignCommand(oObject, ActionMoveToObject(oWaypoint, bRun, fRange));
}	



/**  
* This function does a check of all obstacles // triggers, AOEs, and double checks the teleported location is a safe target location
* if blocked it returns the original location, if the location lTeleportFrom != lTeleportTo, the calling script can know the porting was blocked
* if something is blocking, i would assume that
* any triggers between the two points get tripped like they were walked over
* @author
* @param 
* @see 
* @return 
*/
location CSLTeleportationBeam( location lTeleportFrom, location lTeleportTo, int bLineOfSight=FALSE, int bTriggerEncounters=FALSE, object oCaster = OBJECT_SELF  )//object oCaster = OBJECT_SELF )
{
	
	if ( bLineOfSight && !LineOfSightVector(  GetPositionFromLocation( lTeleportFrom ), GetPositionFromLocation( lTeleportTo ) ) )
	{
		return lTeleportFrom;
	}
	
	
	object oObject; // this is the various items in the shape
	
	oObject = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTeleportTo, TRUE, OBJECT_TYPE_ENCOUNTER , GetPositionFromLocation( lTeleportFrom ) );
	while (GetIsObjectValid(oObject))
	{
		//Get the next object in the cylinder
		//SendMessageToPC( GetFirstPC(), "Processing "+GetTag(oObject) );
		if ( bTriggerEncounters && GetObjectType( oObject ) == OBJECT_TYPE_ENCOUNTER  )  // && GetEncounterActive( oObject )
		{
			SendMessageToPC( GetFirstPC(), "We Have an encounter");
			SetEncounterActive(TRUE, oObject); // should this be set to true????
			TriggerEncounter(oObject, oCaster, ENCOUNTER_CALC_FROM_FACTION, -1.0f);
			//TriggerEncounter(oObject, oCaster, 0, 0.0);
		}
		
		if ( GetLocalInt( oObject, "BLOCK_TELEPORT") ) // anything can block a teleport that has this set
		{
			return CalcSafeLocation( oCaster, GetLocation( oObject ), 10.0f, TRUE, FALSE ); // intercepted
		}
		
		oObject = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTeleportTo, TRUE,  OBJECT_TYPE_ENCOUNTER, GetPositionFromLocation( lTeleportFrom ) );
		
	}
	
	return CalcSafeLocation( oCaster, lTeleportTo, 10.0f, TRUE, FALSE );
}


/**  
* Displays transposition VFX. on teleports
* @author
* @param 
* @see 
* @return 
*/
void CSLTransposeVFX(object o1, object o2)
{
    // Apply vfx to the creatures moving.
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_X);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o1);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o2);
}


/**  
* Transposes the 2 creatures.
* @author Syrus Greycloak
* @param 
* @see 
* @return 
*/
void CSLTranspose(object oCaster, object oTarget)
{
    // Get the locations of the 2 creatures to swap, keeping the facings
    // the same.
    location lCaster = GetLocation(oCaster); //Location(GetArea(o1), GetPosition(o1), GetFacing(o2));
    location lTarget = GetLocation(oTarget); //Location(GetArea(o2), GetPosition(o2), GetFacing(o1));

    // Make sure both creatures are capable of being teleported
    //if(!(GetCanTeleport(o1, loc2, TRUE) && GetCanTeleport(o2, loc1, TRUE)))
    //   return;

    // Swap the creatures.
    AssignCommand(oTarget, ClearAllActions());
	AssignCommand(oCaster, ClearAllActions());
    
    AssignCommand(oCaster, JumpToLocation(lTarget));
    AssignCommand(oTarget, JumpToLocation(lCaster));
    DelayCommand(0.1, CSLTransposeVFX(oCaster, oTarget));
	
	AssignCommand(oTarget, ClearAllActions());
	AssignCommand(oCaster, ClearAllActions());
}

/**  
* Teleports to a given location
* @author
* @param 
* @see 
* @return 
*/
void CSLTeleportToLocation( object oPC, location lTeleportTo, int iVisual = VFX_HIT_SPELL_CONJURATION )
{
	AssignCommand(oPC, ClearAllActions() );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( iVisual ), lTeleportTo);
	AssignCommand(oPC,JumpToLocation(lTeleportTo));
}


/**  
* Create an hurl effect that jump oTarget far fDistance from where he is
* This routine checks the position of oTarget respect to origin location to determine
* the direction of the hurl.
* @author
* @param 
* @see 
* @return 
*/
void CSLHurlTargetFromLocation(location lOrigin, object oTarget, float fDistance )
{
	location lHurlLocation;
	location lTargetLocation = GetLocation(oTarget);
	
	
	//float fAngleOfTarget = CSLGetAngleBetweenTargets(oHurler, oTarget);
	float fAngleOfTarget = VectorToAngle( GetPosition(oTarget) - GetPositionFromLocation(lOrigin) );
	
	float fAngleToFace = GetFacingFromLocation(lOrigin);
	
	//if(fAngleToFace == -999.0f)
	//{
	//	lHurlLocation = CSLGetLocationAwayFromLocation(lTargetLocation, fDistance, fAngleOfTarget );
	//}
	//else
	//{
		lHurlLocation = CSLGetLocationAwayFromLocation(lTargetLocation, fDistance, fAngleOfTarget, FALSE, FALSE, fAngleToFace);
	//}
	
	AssignCommand(oTarget, ClearAllActions());	
	AssignCommand(oTarget, ActionJumpToLocation(lHurlLocation));
}



/**  
* Create an hurl effect that jump oTarget far fDistance from the oHurler
* This routine checks the position of oTarget respect to origin oHurler to determine
* the direction of the hurl.
* @author
* @param 
* @see 
* @return 
*/
void CSLHurlTarget(object oHurler, object oTarget, float fDistance, float fAngleToFace)
{
	location lHurlLocation;
	location lTargetLocation = GetLocation(oTarget);
	float fAngleOfTarget = CSLGetAngleBetweenTargets(oHurler, oTarget);
	
	//if(fAngleToFace == -999.0f)
	//{
	//	lHurlLocation = CSLGetLocationAwayFromLocation(lTargetLocation, fDistance, fAngleOfTarget );
	//}
	//else
	//{
		lHurlLocation = CSLGetLocationAwayFromLocation(lTargetLocation, fDistance, fAngleOfTarget, FALSE, FALSE, fAngleToFace);
	//}
	
	AssignCommand(oTarget, ClearAllActions());	
	AssignCommand(oTarget, ActionJumpToLocation(lHurlLocation));
}


//@}




/************************************************************/
/** @name Last Position
* Deals with with a creatures last position, to detect movement and the like
********************************************************* @{ */

/**  
* Set oCreature as having a location recorded on herself
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
/*
void CSLSetHasLocationRecorded(object oCreature)
{
	SetLocalInt(oCreature, "NW_HAS_LOCATION_RECORDED", TRUE);
}
*/

/**  
* Returns if oCreature has a location recorded on herself
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
int CSLGetHasLocationRecorded(object oCreature)
{
	return GetLocalInt(oCreature, "NW_HAS_LOCATION_RECORDED");
}


/**  
* Set oCreature has not having a location recorded on herself
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
/*
void SetHasNoLocationRecorded(object oCreature)
{
	DeleteLocalInt(oCreature, "NW_HAS_LOCATION_RECORDED");
}
*/

/**  
* Set oCreature has having a delayed erase of the recorded location
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
/*
void SetHasDelayedLocationErase(object oCreature)
{
	SetLocalInt(oCreature, "NW_HAS_DELAY_COMMAND_DELETE_REC_LOCATION", TRUE);
}
*/

/**  
* Returns if oCreature has already a delayed erase of the recorded location
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
/*
int GetHasDelayedLocationErase(object oCreature)
{
	return 	GetLocalInt(oCreature, "NW_HAS_DELAY_COMMAND_DELETE_REC_LOCATION");
}
*/

/**  
* Reset the status of oCreature having a delayed erase of the recorded location
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
/*
void CSLResetHasDelayedLocationErase(object oCreature)
{
	DeleteLocalInt(oCreature, "NW_HAS_DELAY_COMMAND_DELETE_REC_LOCATION");
}
*/

/**  1 usage in CSLSetLastLocationOfCreature
* Remove the last recorded location of oCreature
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
/*
void CSLDeleteLastLocationOfCreature(object oCreature, string sLocationVar = "NW_CREATURE_LAST_KNOWN_LOCATION")
{
	SetHasNoLocationRecorded(oCreature);
	DeleteLocalLocation(oCreature, sLocationVar);
}
*/

/**  
* compares position to the last time this function was run to detect if the player has moved
* note that this can be run more than once in the same round which means the second time it is run, it will seem as if there is less motion or no motion
* if this is an issue, like this is run from a AOE heartbeat to make the HB end if caster moves, use a different variable
* i might extend this by actually comparing the two locations to get the amount of movement ( as integer, so when using assuming 0 is not movement, and > 0 equal movement for later
* @author
* @param 
* @see 
* @return 
*/
int CSLCompareLastPosition( object oPC, string sLocationVar = "LASTLOC" )
{
	string sLocNow  = CSLSerializeLocation( GetLocation(oPC) );
	string sLocLast = GetLocalString(oPC, sLocationVar);
	if (sLocLast != sLocNow) // THEY MOVED SAVE THE NEW LOCATION
	{
		SetLocalString(oPC, sLocationVar, sLocNow);
		SetLocalInt(oPC, "LASTLOCCNT", 0);
		return TRUE;
	}
	return FALSE;
}

/**  1 usage can delete this
* Set the last recorded location of oCreature
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
/*
void CSLSetLastLocationOfCreature(object oCreature, location lLocation, int bTemporary, float fDuration, string sLocationVar = "NW_CREATURE_LAST_KNOWN_LOCATION")
{
	CSLSetHasLocationRecorded(oCreature);
	SetLocalLocation(oCreature, sLocationVar, lLocation);
	
	if(bTemporary == TRUE && !GetHasDelayedLocationErase(oCreature))
	{
		SetHasDelayedLocationErase(oCreature);
		DelayCommand(fDuration, CSLDeleteLastLocationOfCreature(oCreature));
		DelayCommand(fDuration, CSLResetHasDelayedLocationErase(oCreature));
	}
}
*/


/**  
* Get the last recorded location of oCreature
* @todo need to look at this, i am pretty sure i am already doing this via the checked has moved code
* @author Drammel and others ( Tome of Battle )
* @param 
* @see 
* @return 
*/
location CSLGetLastLocationOfCreature(object oCreature, string sLocationVar = "LASTLOC" )
{
	return GetLocalLocation(oCreature, sLocationVar);
}



/**  
* Returns if oTarget has moved
* Use this in conjunction with SetLastCreatureLocation to record the movement
* @author
* @param 
* @see 
* @return 
*/
int CSLGetHasMoved(object oTarget, string sLocationVar = "LASTLOC" )
{
	if(!CSLGetHasLocationRecorded(oTarget)) return FALSE;
	location lTargetLocation = GetLocation(oTarget);
	location lLastTargetLocation = CSLGetLastLocationOfCreature(oTarget, sLocationVar);

	if( GetDistanceBetweenLocations(lTargetLocation, lLastTargetLocation) > 1.0f )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


/**  
* Checks the location of oTarget when the function is called and CSLGetLastLocationOfCreature
* and returns the distance between the two as a float
* @author
* @param oTarget The object whose movement we're checking.
* @see 
* @return 
*/
float CSLGetDistanceMoved(object oTarget, string sLocationVar = "LASTLOC" )
{
	location lLastTargetLocation = CSLGetLastLocationOfCreature(oTarget, sLocationVar);
	location lCurrent = GetLocation(oTarget);
	float fDistanceBetween = GetDistanceBetweenLocations(lLastTargetLocation, lCurrent);	

	return fDistanceBetween;
}





/**  
* Determines if oPC has line of effect to lTarget.
* This function will return false for anything that makes GetIsLocationValid
* return false.  In fact, this function checks the validity of every location
* between oPC and lTarget in small increments.
* @author
* @param oPC Object which serves as the source of the line of effect test.
* @param lTarget The location we're determining if oPC blocked to or not.
* @param bTriggers When set to TRUE also checks for triggers and returns FALSE if the function detects one in the line of effect.
* @see 
* @replaces LineOfEffect by OEI
* @return 
*/
int CSLLineOfEffect (object oPC, location lTarget, int bTriggers = FALSE)
{
	object oArea = GetArea(oPC);
	object oSubArea;
	location lPC = GetLocation(oPC);
	vector vPC = GetPosition(oPC);
	vector vTarget = GetPositionFromLocation(lTarget);
	float fMax = GetDistanceBetweenLocations(lPC, lTarget);
	float fDest = CSLGetAngle(vPC, vTarget, fMax);
	float fIncrement = FeetToMeters(0.1f);
	float fDistance;
	location lTest;
	vector vTest;
	int nReturn;

	nReturn = TRUE;
	fDistance = fIncrement;

	while (fDistance <= fMax)
	{
		lTest = CSLGenerateNewLocation(oPC, fDistance, fDest, fDest);

		if (!GetIsLocationValid(lTest))
		{
			nReturn = FALSE;
			break;
		}

		if (bTriggers == TRUE)
		{
			vTest = GetPositionFromLocation(lTest);
			oSubArea = GetFirstSubArea(oArea, vTest);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER) //Sometimes there is area overlap.
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);
		}

		fDistance += fIncrement;
	}

	return nReturn;
}

//@}



/* Evaluate if any of these are of any value

vector CSLGetChangedPosition(vector vOriginal, float fDistance, float fAngle)
{
    vector vChanged;
    vChanged.z = vOriginal.z;
    vChanged.x = vOriginal.x + CSLGetChangeInX(fDistance, fAngle);
    if (vChanged.x < 0.0)
        vChanged.x = - vChanged.x;
    vChanged.y = vOriginal.y + CSLGetChangeInY(fDistance, fAngle);
    if (vChanged.y < 0.0)
        vChanged.y = - vChanged.y;

    return vChanged;
}

	oTmp = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oTmp))
    {
        if (vTmp.x > fXMax)
            fXMax = vTmp.x;
        if (vTmp.x < fXMin)
            fXMin = vTmp.x;
        if (vTmp.y > fYMax)
            fYMax = vTmp.y;
        if (vTmp.y < fYMin)
            fYMin = vTmp.y;
        oTmp = GetNextObjectInArea(oArea);
    }


//Returns if oTarget is in fRange of oCreature
int CSLGetIsInMeleeRange(object oTarget, object oCreature)
{
	float fRange = GetMeleeRangeBySize(oTarget);
	float fSelfRange = GetMeleeRangeBySize(oCreature);
	if(fSelfRange > fRange) fRange = fSelfRange; 
		
	if(GetDistanceBetween(oCreature, oTarget) <= fRange)
		return TRUE;
	else
		return FALSE;
}


*/


//////////////////NWSCRIPT.nss Functions, for reference just for completeness ///////////////////////////////////
/*
The following is in nwscript
// Convert fFeet into a number of meters.
float FeetToMeters(float fFeet);

// Convert fYards into a number of meters.
float YardsToMeters(float fYards);

// Get the position vector from lLocation.
vector GetPositionFromLocation(location lLocation);

// Get the area's object ID from lLocation.
object GetAreaFromLocation(location lLocation);

// Get the orientation value from lLocation.
float GetFacingFromLocation(location lLocation);

// Get the creature nearest to lLocation, subject to all the criteria specified.
// - nFirstCriteriaType: CREATURE_TYPE_*
// - nFirstCriteriaValue:
//   -> CLASS_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_CLASS
//   -> SPELL_* if nFirstCriteriaType was CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT
//      or CREATURE_TYPE_HAS_SPELL_EFFECT
//   -> CREATURE_ALIVE_TRUE or CREATURE_ALIVE_FALSE if nFirstCriteriaType was CREATURE_TYPE_IS_ALIVE
//      Or use CREATURE_ALIVE_BOTH to search both DEAD or ALIVE
//      Default search considers creatures that are alive ONLY!
//   -> PERCEPTION_* if nFirstCriteriaType was CREATURE_TYPE_PERCEPTION
//   -> PLAYER_CHAR_IS_PC or PLAYER_CHAR_NOT_PC if nFirstCriteriaType was
//      CREATURE_TYPE_PLAYER_CHAR
//   -> RACIAL_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_RACIAL_TYPE
//   -> REPUTATION_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_REPUTATION
//   -> CREATURE_SCRIPTHIDDEN_* if nFirstCriteriaType was CREATURE_TYPE_SCRIPTHIDDEN
//   For example, to get the nearest PC, use
//   (CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC)
// - lLocation: We're trying to find the creature of the specified type that is
//   nearest to lLocation
// - nNth: We don't have to find the first nearest: we can find the Nth nearest....
// - nSecondCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nSecondCriteriaValue: This is used in the same way as nFirstCriteriaValue
//   to further specify the type of creature that we are looking for.
// - nThirdCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nThirdCriteriaValue: This is used in the same way as nFirstCriteriaValue to
//   further specify the type of creature that we are looking for.
// * Return value on error: OBJECT_INVALID
object GetNearestCreatureToLocation(int nFirstCriteriaType, int nFirstCriteriaValue,  location lLocation, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1 );

// Get the Nth object nearest to oTarget that is of the specified type.
// - nObjectType: OBJECT_TYPE_*
// - oTarget
// - nNth
// * Return value on error: OBJECT_INVALID
object GetNearestObject(int nObjectType=OBJECT_TYPE_ALL, object oTarget=OBJECT_SELF, int nNth=1);

// Get the nNth object nearest to lLocation that is of the specified type.
// - nObjectType: OBJECT_TYPE_*
// - lLocation
// - nNth
// * Return value on error: OBJECT_INVALID
object GetNearestObjectToLocation(int nObjectType, location lLocation, int nNth=1);

// Get the nth Object nearest to oTarget that has sTag as its tag.
// * Return value on error: OBJECT_INVALID
object GetNearestObjectByTag(string sTag, object oTarget=OBJECT_SELF, int nNth=1);

// Jump to lDestination.  The action is added to the TOP of the action queue.
void JumpToLocation(location lDestination);

// Jump to oToJumpTo (the action is added to the top of the action queue).
void JumpToObject(object oToJumpTo, int nWalkStraightLineToPoint=1);


// Returns whether or not there is a direct line of sight
// between the two objects. (Not blocked by any geometry).
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
int LineOfSightObject( object oSource, object oTarget );

// Returns whether or not there is a direct line of sight
// between the two vectors. (Not blocked by any geometry).
//
// This function must be run on a valid object in the area
// it will not work on the module or area.
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
int LineOfSightVector( vector vSource, vector vTarget );

// Is this creature in the given subarea? (trigger, area of effect object, etc..)
// This function will tell you if the creature has triggered an onEnter event,
// not if it is physically within the space of the subarea
int GetIsInSubArea(object oCreature, object oSubArea=OBJECT_SELF);

///////////////////////////////////////////////////////////////////////////////
// CalcPointAwayFromPoint
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/10/06
// Description: This will create a new point directly away from a starting 
//              point
// Arguments:
//  lPoint              - The point you are starting from
//  lAwayFromPoint      - The point you want to generate a new location away from
//  fDistance           - How far away you want the new point to be. This can
//                          be a negative value. (i.e. to generate a point nearer
//                          or even past the away point
//  fAngularVariance    - This will add some randomness to the position of the
//                        new point. Values are in degrees, from 0 to 180
//  bComputeDistFromStart - If TRUE, then the new point is fDistance away from
//                          lPoint. If FALSE, then it is fDistance away from 
//                          lAwayFromPoint.
// Returns: A location away from lAwayFromPoint based on the position of 
//          lPoint. Note that if there is an error, lPoint is returned
///////////////////////////////////////////////////////////////////////////////
location CalcPointAwayFromPoint( location lPoint, location lAwayFromPoint, float fDistance, float fAngularVariance, int bComputeDistFromStart );

///////////////////////////////////////////////////////////////////////////////
// CalcSafeLocation
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/10/06
// Description: This will attempt to find a position that oCreature can stand in
// Arguments:
//  oCreature       - The creature to generate a safe location for
//  lTestPosition   - The position that you want to generate a safe location near
//  fSearchRadius   - How far away from lTestPosition to carry out the search
//  bWalkStraighLineRequired - If TRUE, then this will only return a position that
//                              can be pathed directly to by oCreature
//  bIgnoreTestPosition - If TRUE, then lTestPosition won't be considered 
//                        as one of the possible nearby search locations
// Returns: A location that oCreature can stand in. If no location is found, 
//          then it returns the creature's current location. 
///////////////////////////////////////////////////////////////////////////////
location CalcSafeLocation( object oCreature, location lTestPosition, float fSearchRadius, int bWalkStraighLineRequired, int bIgnoreTestPosition );

// TWH - OEI 6/28/2006
// This script function allows you to set a LookAt target via script -- it's
// mainly to fix cutscene lookat 'bugs', while it does add a nice bonus feature
// oObject is the object to set weapon visibility on
// vTarget is the place you want the creature object to look
// nType is reserved for future use
void SetLookAtTarget( object oObject, vector vTarget, int nType=0 );


//RWT-OEI 03/26/07
//Gets the size of an area.
// - nAreaDimension: The dimension you are querying. 
//   AREA_HEIGHT or AREA_WIDTH
// - oArea: The area you wish to get the size of. If
//          a non-area is passed in, will get the size
//          of the area that the object is in. If
//          no object is specified, will use the calling
//          object to look up the area
// Returns the number of the tiles that the area is wide/height
//      If it is unable to find the area, returns 0. 
int GetAreaSize( int nAreaDimension, object oArea=OBJECT_INVALID ); 


//RWT-OEI 04/17/08
//Given an area ID and a position in that area, returns the first sub-area that is found at that position.
//SubAreas are triggers, AoEEffectObjects, and Encounters.
//Use with GetNextSubArea() to iterate over all the sub-areas at this position.
// oArea = The area to search
// vPosition = The position to evaluate for sub areas.
object GetFirstSubArea( object oArea, vector vPosition );

//RWT-OEI 04/17/08
//Given an area ID, returns the next subarea to be found at the position specified when GetFirstSubArea()
//was called. It is necessary to call GetFirstSubArea() before calling this function in order to get
//any results back.
// oArea = The area to return the next SubArea from. 
object GetNextSubArea( object oArea ); 

// JWR-OEI 04/28/08
// returns the collision boolean for an object
int GetCollision(object oTarget);

//JWR-OEI 04/28/08
// sets the collision boolean for an object
// only works for creature type objects
void SetCollision(object oTarget, int bCollision);


// Get the first object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. Line of sight check is done from origin to target object
//   at a height 1m above the ground
//   (This can be used to ensure that spell effects do not go through walls.)
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or".
//   For example, to return only creatures and doors, the value for this
//   parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the
//   origin of the effect(normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetFirstObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Get the next object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. (This can be used to ensure that spell effects do not go
//   through walls.) Line of sight check is done from origin to target object
//   at a height 1m above the ground
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or". For example, to return only creatures and doors, the value for
//   this parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the origin
//   of the effect (normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetNextObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);


// Get the first object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. Line of sight check is done from origin to target object
//   at a height 1m above the ground
//   (This can be used to ensure that spell effects do not go through walls.)
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or".
//   For example, to return only creatures and doors, the value for this
//   parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the
//   origin of the effect(normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
//object GetFirstObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Get the next object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. (This can be used to ensure that spell effects do not go
//   through walls.) Line of sight check is done from origin to target object
//   at a height 1m above the ground
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or". For example, to return only creatures and doors, the value for
//   this parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the origin
//   of the effect (normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
//object GetNextObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Returns whether or not there is a direct line of sight
// between the two objects. (Not blocked by any geometry).
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
//int LineOfSightObject( object oSource, object oTarget );

// Returns whether or not there is a direct line of sight
// between the two vectors. (Not blocked by any geometry).
//
// This function must be run on a valid object in the area
// it will not work on the module or area.
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
//int LineOfSightVector( vector vSource, vector vTarget );


// //eRay = EffectNWN2SpecialEffectFile("sp_fire_ray", OBJECT_INVALID, GetPosition(oTarget)+Vector(5.0, 0.0, 0.0));


// location Location(object oArea, vector vPosition, float fOrientation);

// Get the position vector from lLocation.
//vector GetPositionFromLocation(location lLocation);

// Get the area's object ID from lLocation.
//object GetAreaFromLocation(location lLocation);

// Get the orientation value from lLocation.
//float GetFacingFromLocation(location lLocation);

// Get the distance between lLocationA and lLocationB.
//float GetDistanceBetweenLocations(location lLocationA, location lLocationB);

// Jump to lDestination.  The action is added to the TOP of the action queue.
//void JumpToLocation(location lDestination);

// Causes the action subject to move away from lMoveAwayFrom.
//void ActionMoveAwayFromLocation(location lMoveAwayFrom, int bRun=FALSE, float fMoveAwayRange=40.0f);

// Force the action subject to move to lDestination.
//void ActionForceMoveToLocation(location lDestination, int bRun=FALSE, float fTimeout=30.0f);


// Create a Disappear/Appear effect.
// The object will "fly away" for the duration of the effect and will reappear
// at lLocation.
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
//effect EffectDisappearAppear(location lLocation, int nAnimation=1);



///////////////////////////////////////////////////////////////////////////////
// CalcPointAwayFromPoint
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/10/06
// Description: This will create a new point directly away from a starting 
//              point
// Arguments:
//  lPoint              - The point you are starting from
//  lAwayFromPoint      - The point you want to generate a new location away from
//  fDistance           - How far away you want the new point to be. This can
//                          be a negative value. (i.e. to generate a point nearer
//                          or even past the away point
//  fAngularVariance    - This will add some randomness to the position of the
//                        new point. Values are in degrees, from 0 to 180
//  bComputeDistFromStart - If TRUE, then the new point is fDistance away from
//                          lPoint. If FALSE, then it is fDistance away from 
//                          lAwayFromPoint.
// Returns: A location away from lAwayFromPoint based on the position of 
//          lPoint. Note that if there is an error, lPoint is returned
///////////////////////////////////////////////////////////////////////////////
//location CalcPointAwayFromPoint( location lPoint, location lAwayFromPoint, float fDistance, float fAngularVariance, int bComputeDistFromStart );


///////////////////////////////////////////////////////////////////////////////
// CalcSafeLocation
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/10/06
// Description: This will attempt to find a position that oCreature can stand in
// Arguments:
//  oCreature       - The creature to generate a safe location for
//  lTestPosition   - The position that you want to generate a safe location near
//  fSearchRadius   - How far away from lTestPosition to carry out the search
//  bWalkStraighLineRequired - If TRUE, then this will only return a position that
//                              can be pathed directly to by oCreature
//  bIgnoreTestPosition - If TRUE, then lTestPosition won't be considered 
//                        as one of the possible nearby search locations
// Returns: A location that oCreature can stand in. If no location is found, 
//          then it returns the creature's current location. 
///////////////////////////////////////////////////////////////////////////////
//location CalcSafeLocation( object oCreature, location lTestPosition, float fSearchRadius, int bWalkStraighLineRequired, int bIgnoreTestPosition );


// Create a Disappear effect to make the object "fly away" and then destroy
// itself.
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
//effect EffectDisappear(int nAnimation=1);

// Brock H. - OEI 04/21/06
// This will calculate the length of time it will take for a projectile to 
// to travel between the locations. If you specify PROJECTILE_PATH_TYPE_SPELL
// and a valid spell ID, it will look up the spell's projectile path type from 
// the Spell 2DA
//float GetProjectileTravelTime( location lSource, location lTarget, int nProjectilePathType, int nSpellID=-1 );

// Create an Appear effect to make the object "fly in".
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
//effect EffectAppear(int nAnimation=1);


// The action subject will move to lDestination.
// - lDestination: The object will move to this location.  If the location is
//   invalid or a path cannot be found to it, the command does nothing.
// - bRun: If this is TRUE, the action subject will run rather than walk
// * No return value, but if an error occurs the log file will contain
//   "MoveToPoint failed."
//void ActionMoveToLocation(location lDestination, int bRun=FALSE);

// Creates a cutscene ghost effect, this will allow creatures
// to pathfind through other creatures without bumping into them
// for the duration of the effect.
//effect EffectCutsceneGhost();

//int    OBJECT_TYPE_CREATURE         = 1;
//int    OBJECT_TYPE_ITEM             = 2;
//int    OBJECT_TYPE_TRIGGER          = 4;
//int    OBJECT_TYPE_DOOR             = 8;
//int    OBJECT_TYPE_AREA_OF_EFFECT   = 16;
//int    OBJECT_TYPE_WAYPOINT         = 32;
//int    OBJECT_TYPE_PLACEABLE        = 64;
//int    OBJECT_TYPE_STORE            = 128;
//int    OBJECT_TYPE_ENCOUNTER		= 256;
//int    OBJECT_TYPE_LIGHT            = 512;
//int    OBJECT_TYPE_PLACED_EFFECT    = 1024;
//int    OBJECT_TYPE_ALL              = 32767;
//int    OBJECT_TYPE_INVALID          = 32767;


//CMM-OEI 11/16/05
//Trigger an encounter
// - oObject: The object ID of the encounter to trigger.
// - oPlayer: The player to treat as the one who triggered the encounter.
// - iCRFlag: This parameter does nothing at this time (Wasn't fully implemented)
// - fCR: If this is -1.0, calculate the appropriate CR for the encounter based
//        on the players in the triggering faction that are nearby.
//        If anything other than -1.0, indicates the CR override that should
//        be used when triggering the encounter. 
//void TriggerEncounter(object oEncounter, object oPlayer, int iCRFlag, float fCR);

// vPosition = The position to evaluate for sub areas.
object GetFirstSubArea( object oArea, vector vPosition );

//RWT-OEI 04/17/08
//Given an area ID, returns the next subarea to be found at the position specified when GetFirstSubArea()
//was called. It is necessary to call GetFirstSubArea() before calling this function in order to get
//any results back.
// oArea = The area to return the next SubArea from.
object GetNextSubArea( object oArea );

// object GetObjectByTag(string sTag, int nNth=0);
// object GetNearestObjectByTag(string sTag, object oTarget=OBJECT_SELF, int nNth=1);


*/




float CSLDeg2Rad( float fAngle )
{
	return  fAngle*(PI/180.0f);
}

float CSLRad2Deg( float fAngle )
{
	return fAngle*(180.0f/PI);
}

// approximates distance of flight, the goal here is to get an estimate since it's not accounting for drag, nor the uneven terrain
float CSLProjectileDistanceTraveled( float fAngle, float fVelocity, float fInitialHeight )
{
	float fRadiansTheta = CSLDeg2Rad( fAngle );
	return fAngle*cos(fRadiansTheta)/CSL_ACCELERATION_FROM_GRAVITY*(fAngle*sin(fRadiansTheta)+sqrt(((fAngle*sin(fRadiansTheta))*(fAngle*sin(fRadiansTheta))+2*CSL_ACCELERATION_FROM_GRAVITY*fInitialHeight)));
}

// approximates time of flight, the goal here is to get an estimate since it's not accounting for drag, nor the uneven terrain
float CSLProjectileTimeofFlight( float fAngle, float fVelocity, float fDistanceTraveled )
{
	return fDistanceTraveled/(fVelocity*cos(CSLDeg2Rad( fAngle )));
}

// used to get distance at a given height, does not account for drag
float CSLProjectileHeightAtDistance( float fAngle, float fVelocity, float fInitialHeight, float fDistanceTraveled )
{
	float fRadiansTheta = CSLDeg2Rad( fAngle );
	// use original height  (fInitialHeight) added to the equation result soas to get the height at the given distance
	return fInitialHeight + fDistanceTraveled * tan(fRadiansTheta) - (CSL_ACCELERATION_FROM_GRAVITY * fDistanceTraveled ) / (2 * fVelocity * cos(fRadiansTheta));
}




/**  
* The angle a projectile will be adjusted based on wind, only an approximate
* @author based on googled formula, may or may not be useful
* @param fWindRelativeAngle angle of wind off trajectory path
* @param fWindSpeed wind speed in kph
* @param fVelocity muzzle velocity in meters per second
* @param fTimeOfFlight time of flight in seconds
* @param fRange range in meters 
* @return degrees original angle is adjusted
*/
float CSLProjectileWindDrift( float fWindRelativeAngle, float fWindSpeed, float fVelocity, float fTimeOfFlight, float fRange)
{
	// Wind drift = (s x sin(a)) x (t - (v/r) )
	return (fWindSpeed * sin(fWindRelativeAngle)) * (fTimeOfFlight - (fVelocity/fRange));

}

/*
float vyt(float v,float fAngle,float t)
{
	return v*sin(CSLDeg2Rad(fAngle))-CSL_ACCELERATION_FROM_GRAVITY*t;
}
float yt(float v,float fAngle,float t)
{
	return v*sin(CSLDeg2Rad(fAngle))*t-.5*CSL_ACCELERATION_FROM_GRAVITY*t*t;
}
float vxf(float v,float a)
{
	return v*cos(CSLDeg2Rad(fAngle));
}
float trad(float v,float y)
{
	return sqrt(v*v/(CSL_ACCELERATION_FROM_GRAVITY*CSL_ACCELERATION_FROM_GRAVITY)-2*y/CSL_ACCELERATION_FROM_GRAVITY);
}
*/

location CSLPlotProjectile( location lCannonLoc, float fElapsedTime = 0.0f, float fCannonVelocity = 50.0f, float fLaunchAngle = 45.0f )
{
	vector vProjectilePosition; // this determines the projectiles position
	vector vCannonPosition = GetPositionFromLocation( lCannonLoc );
	float fCannonFacing = GetFacingFromLocation( lCannonLoc );
	object oArea = GetAreaFromLocation( lCannonLoc );
	
	// float fCannonVelocity; // = v0
	//float fLaunchAngle; // = a;
	//float fElapsedTime; // = t;
	//float fVvelocityVX; // = vx;
	//float fDistanceX; // = x;
	//float fVvelocityVY; // = vy;
	//float fPositionY; // = y;
	

	float fVvelocityVD = fCannonVelocity*cos(CSLDeg2Rad(fLaunchAngle)); // xY
	float fDistance = ( fCannonVelocity*cos(CSLDeg2Rad(fLaunchAngle)) )*fElapsedTime; // x
	float fVvelocityVZ = fCannonVelocity*sin(CSLDeg2Rad(fLaunchAngle))-CSL_ACCELERATION_FROM_GRAVITY*fElapsedTime; // vY
	float fPositionZ = fCannonVelocity*sin(CSLDeg2Rad(fLaunchAngle))*fElapsedTime-0.5f*CSL_ACCELERATION_FROM_GRAVITY*fElapsedTime*fElapsedTime; // or Y
	
	
    vProjectilePosition.z = vCannonPosition.z + fPositionZ;
    vProjectilePosition.x = vCannonPosition.x + ( fDistance * cos(fCannonFacing) ); // change in x ( fDistance * cos(fAngle) )
    if (vProjectilePosition.x < 0.0f)
        vProjectilePosition.x = - vProjectilePosition.x;
    vProjectilePosition.y = vCannonPosition.y + ( fDistance * sin(fCannonFacing) );  // change in y ( fDistance * sin(fAngle)
    if (vProjectilePosition.y < 0.0f)
        vProjectilePosition.y = - vProjectilePosition.y;

	return Location(oArea, vProjectilePosition, fCannonFacing);

}

/**  
* Plots projectile posistion at a given elapsed time from firing the siegeengine, using the siege engines location and facing to aim the shot using physics with drag and wind effects
* @author based on cannon.c found in "Physics in Motion" David M. Bourg
* @param lCannonLoc This is the base elevation of the cannon which includes the direction aimed and the projectiles starting location
* @param fElapsedTime Incremented time since firing of the cannon, interval can vary to reduce number of times this function needs to be called
* @param fCannonElevation Angle from z-axis (upward) to the cannon. When this angle is zero the cannon is pointing straight up, when it is 90 degrees, the cannon is horizontal
* @param fCannonVelocity Magnitude of muzzle velocity
* @param fCannonLength This is the length of the cannon ( causes projectile starting point to vary as if there is an acutual turret )
* @param fProjectileMass Kilograms weight of projectile
* @param fWindSpeed Speed of the wind kph
* @param fWindDirection Facing the wind is in the given area
* @param fWindForceCoefficient Wind force coefficient
* @param fAirDragCoefficient The density of the air, set to one it reproduces how things act in a vacuum
* @todo Heavy testing since a lot of the math is copying things i don't fully understand yet, hopefully trial and error can get this all in line
* @return  The shell position (displacement) vector
*/
/*
location CSLPlotProjectileXX( location lCannonLoc, float fElapsedTime = 0.0f, float fCannonElevation = 45.0f, float fCannonVelocity = 50.0f, float fCannonLength = 0.5f, float fProjectileMass = 100.0f, float fWindSpeed = 10.0f, float fWindDirection = 90.0f, float fWindForceCoefficient = 10.0f, float fAirDragCoefficient = 30.0f )
{
	vector vCannonPosition = GetPositionFromLocation( lCannonLoc );
	vector vProjectilePosition; // this determines the projectiles position
	float fCannonFacing = GetFacingFromLocation( lCannonLoc );
	object oArea = GetAreaFromLocation( lCannonLoc );
	
	fAirDragCoefficient = CSLGetMaxf( fAirDragCoefficient, 1.0f);
	fCannonLength = CSLGetMaxf( fCannonLength, 0.5f);
	fProjectileMass = CSLGetMaxf( fProjectileMass, 1.0f);
	//if ( fAirDragCoefficient < 1.0f ) // must not be set, so go ahead and make it have a value of at least 1 to avoid divide by zero ( and 1 is basically no drag being in effect )
	//{
	//	fAirDragCoefficient = 1.0f; // no real drag
	//}
	
	float	cosX;
	float	cosZ;
	float	cosY;
	float	xe, ye;
	float	b, Lx, Lz, Ly; // fixed
	float	tx1, tx2, tz1, tz2, ty1, ty2;

	// new local variablels:
	float  sx1pos, sz1pos, vz1pos, sy1pos; // vx1pos, vy1pos
	//DelayCommand( fElapsedTime,SendMessageToPC( GetFirstPC(), "Interval2 "+FloatToString(fElapsedTime)+" "+" fCannonElevation="+FloatToString(fCannonElevation)+" fCannonVelocity="+FloatToString(fCannonVelocity)+" fCannonLength="+FloatToString(fCannonLength)+" fProjectileMass="+FloatToString(fProjectileMass)+" fAirDragCoefficient="+FloatToString(fAirDragCoefficient) ) );
	
	// First calculate the direction cosines for the cannon orientation.
	b = fCannonLength * cos( CSLDeg2Rad(90-fCannonElevation) );  // projection of barrel onto horizontal plane
	Lx = b * cos(CSLDeg2Rad(fCannonFacing));		// x-component of barrel length
	Lz = fCannonLength * cos(CSLDeg2Rad(fCannonElevation));		// y-component of barrel length
	Ly = b * sin(CSLDeg2Rad(fCannonFacing));	// z-component of barrel length

	cosX = Lx/fCannonLength;
	cosZ = Lz/fCannonLength;
	cosY = Ly/fCannonLength;

	// These are the x and y coordinates of the very end of the cannon barrel
	// we'll use these as the initial x and y displacements
	xe =  fCannonLength * cos(CSLDeg2Rad(90-fCannonElevation)) * cos(CSLDeg2Rad(fCannonFacing));
	ye =  fCannonLength * cos(CSLDeg2Rad(90-fCannonElevation)) * sin(CSLDeg2Rad(fCannonFacing));
		
	// Now we can calculate the position vector at this fElapsedTime
	sx1pos =  vCannonPosition.x + xe;
	float vxdrag =  fAirDragCoefficient - ( fCannonVelocity * cosX );
	if ( vxdrag == 0.0f ) // prevent divide by zero
	{
		vxdrag == 0.1f;
	}
		
	sz1pos = vCannonPosition.z + fCannonLength * cos(CSLDeg2Rad(fCannonElevation));
	vz1pos = fCannonVelocity * cosZ;
	float vzdrag =  CSLGetMaxf( fAirDragCoefficient, 1.0f);
	
	
	sy1pos =  vCannonPosition.y + ye;
	float vydrag = fAirDragCoefficient - (fCannonVelocity * cosY);
	if ( vydrag == 0.0f ) // prevent divide by zero
	{
		vydrag == 0.1f;
	}
	vProjectilePosition.x = ( (fProjectileMass/fAirDragCoefficient) * CSLExp(-(fAirDragCoefficient * fElapsedTime)/fProjectileMass) * ((-fWindForceCoefficient * fWindSpeed * cos( CSLDeg2Rad(fWindDirection) ))/vxdrag) - 
		  (fWindForceCoefficient * fWindSpeed * cos(CSLDeg2Rad(fWindDirection)) * fElapsedTime) / fAirDragCoefficient ) - 
		  ( (fProjectileMass/fAirDragCoefficient) * ((-fWindForceCoefficient * fWindSpeed * cos(CSLDeg2Rad(fWindDirection)))/vxdrag) ) + sx1pos;

	vProjectilePosition.z = sz1pos + ( -(vz1pos + (fProjectileMass * CSL_ACCELERATION_FROM_GRAVITY)/fAirDragCoefficient) * (fProjectileMass/fAirDragCoefficient) * CSLExp(-(fAirDragCoefficient*fElapsedTime)/fProjectileMass) - (fProjectileMass * CSL_ACCELERATION_FROM_GRAVITY * fElapsedTime) / vzdrag ) +
		  ( (fProjectileMass/fAirDragCoefficient) * (vz1pos + (fProjectileMass * CSL_ACCELERATION_FROM_GRAVITY)/vzdrag) );

	vProjectilePosition.y = ( (fProjectileMass/fAirDragCoefficient) * CSLExp(-(fAirDragCoefficient * fElapsedTime)/fProjectileMass) * ((-fWindForceCoefficient * fWindSpeed * sin( CSLDeg2Rad(fWindDirection) ))/vydrag) - 
		  (fWindForceCoefficient * fWindSpeed * sin(CSLDeg2Rad(fWindDirection)) * fElapsedTime) / fAirDragCoefficient ) - 
		  ( (fProjectileMass/fAirDragCoefficient) * ((-fWindForceCoefficient * fWindSpeed * sin(CSLDeg2Rad(fWindDirection)))/vydrag) ) + sy1pos;
	
	return Location(oArea, vProjectilePosition, fCannonFacing);
}
*/

// destroy oCreature or despawn oCreature if roster member
// auto sets plot flag and destroyable attribute so non-roster creatures will be destroyed.
void CSLRemoveMyself()
{
	object oCreature = OBJECT_SELF;
	if (GetIsRosterMember(oCreature))
	{	// will always work for a roster member (regardless of plot or destroyable flag)
		DespawnRosterMember(GetRosterNameFromObject(oCreature));
	}		
	else
	{
		SetPlotFlag(oCreature,FALSE);
		SetIsDestroyable(TRUE);
		DestroyObject(oCreature);
	}		
}

// Action wrapper
void CSLActionRemoveMyself()
{
	ActionDoCommand(CSLRemoveMyself());
}




// Check if party is gathered ( alive, not in conversation, and nearby )
int CSLIsPartyGathered( object oPC, float fGatherRadius = CSL_FGATHER_RADIUS )
{
	object oArea = GetArea( oPC );
	
	object oFM = GetFirstFactionMember( oPC, FALSE );
	
	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		// For all members in the area
		if ( GetArea( oFM ) == oArea )
		{
			// if not a summoned creature(this does not include familiars or animal companions)
			if(GetAssociateType(oFM) != ASSOCIATE_TYPE_SUMMONED)
			{
				if( GetGlobalInt( "bNX2_TRANSITIONS" ) )
				{
					//In NX2, we only care about Controlled Characters. This removes the requirement to gather your party for
					//single player, but preserves it so that you don't get yanked out of the middle of gameplay in multiplayer.
					if	( GetIsPC(oFM) )
					{
						//Also, in order to support the new death system, we no longer care whether the character is dead or not.
						if ( IsInConversation(oFM) || GetDistanceBetween( oFM, oPC ) >= fGatherRadius )
						{
							if(IsInConversation(oFM))
								SendMessageToPCByStrRef(oPC, 210771);
						}
					}
				}
				
				else
				{
					if ( ( GetIsDead( oFM ) == TRUE ) || 
						( IsInConversation( oFM ) == TRUE ) ||
					 	( GetDistanceBetween( oFM, oPC ) >= fGatherRadius ) )
					{
						if(IsInConversation(oFM))
						{
							SendMessageToPCByStrRef(oPC, 210771);
						}
						return ( FALSE );
					}
				}
			}
		}
		
		oFM = GetNextFactionMember( oPC, FALSE );
	}

	return ( TRUE );
}

// Complain that party needs to be gathered!
void CSLReportPartyGather(object oPCF)
{
	CloseGUIScreen(oPCF, "SCREEN_MESSAGEBOX_DEFAULT");
	
	DelayCommand(
		0.1,
		DisplayMessageBox(
			oPCF,	// Display a message box for this PC
			161846, // string ref to display
			"", 	// Message to display
			"", 	// Callback for clicking the OK button
			"", 	// Callback for clicking the Cancel button
			FALSE, 	// display the Cancel button
			"SCREEN_MESSAGEBOX_DEFAULT", // Display the tutorial message box	
			-1, 	// OK string ref
			"", 	// OK string
			-1, 	// Cancel string ref
			""  	// Cancel string
		)
	);
}

// Forces oPC's faction to be alive and commandable before sending
// them to oDestination via JumpPartyToArea().
void CSLSinglePartyTransition( object oPC, object oDestination )
{
	effect eRes = EffectResurrection();
	if( GetGlobalInt( "bNX2_TRANSITIONS" ) == FALSE )		//Under NX2's death system, we don't want them to 
	{																//ressurect on transitions.
		// For each party member, revive and set commandable
		object oFM = GetFirstFactionMember( oPC, FALSE );

		while ( GetIsObjectValid( oFM ) == TRUE )
		{
			SetCommandable( TRUE );														
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eRes, oFM );		
			
			oFM = GetNextFactionMember( oPC, FALSE );
		}
	}
	// Transition and trigger FiredFromPartyTransition()
	JumpPartyToArea( oPC, oDestination );	
}
	

// Transition to oTransitionTarget if oPC's party is gathered ( alive, not in conversation, and nearby )
// Otherwise, ask oPC to first gather the party.
void CSLGatherPartyTransition( object oPC, object oTransitionTarget )
{
	if ( ( GetIsPC( oPC ) == FALSE ) ||
		 ( GetIsDead( oPC ) == TRUE ) ||
		 ( IsInConversation( oPC ) == TRUE ) )
	{
		return;
	}
	
	if ( CSLIsPartyGathered( oPC ) == FALSE )
	{
		CSLReportPartyGather( oPC );
		return;
	}
		
	CSLSinglePartyTransition( oPC, oTransitionTarget );	
}



// returns number of dominated that were actually found and removed.
int CSLRemoveDominatedFromPCParty(object oPC)
{
	int nRemoved = 0;
	if ( ( GetIsPC(oPC) == TRUE ) || ( GetFactionEqual(oPC, GetFirstPC()) == TRUE ) )
	{
		object oFM = GetFirstFactionMember( oPC, FALSE );
		while ( GetIsObjectValid(oFM) == TRUE )
		{
			int bRemove = FALSE;
			if ( !GetLocalInt( oFM, "SCSummon" ) )
			{
				
				effect eSearch = GetFirstEffect(oFM);
				while (GetIsEffectValid(eSearch))
				{
					//Check to see if the effect matches a particular type defined below
					if (GetEffectType(eSearch)==EFFECT_TYPE_DOMINATED)
					{
						RemoveEffect(oPC, eSearch);
						bRemove = TRUE;
						eSearch = GetFirstEffect(oFM);
					}
					else
					{
						eSearch = GetNextEffect(oFM);
					}
				}
			}
			nRemoved += bRemove;
			oFM = GetNextFactionMember( oPC, FALSE );
		}
		
		/*
		if ( nRemoved > 0 )
		{
			// Abort transition if domianted effect was found and removed
			return TRUE;
		}
		*/
	}
	return nRemoved;
}


// Standard NWN2 area transition code
// Does not rely on OBJECT_SELF
void CSLStandardAttemptAreaTransition( object oPC, object oDestination, int bIsPartyTranstion )
{
	// BMA-OEI 7/04/06 - Check if in group and using group campaign flag
	if ( GetGlobalInt(CAMPAIGN_SWITCH_REMOVE_DOMINATED_ON_TRANSITION) == TRUE )
	{
		int nRemoved = CSLRemoveDominatedFromPCParty(oPC);
		if ( nRemoved > 0 )
		{
			// Abort transition if domianted effect was found and removed
			return;
		}
			
	}
	// need to make sure the party isn't "Bleeding out"
	// or we kill them.
	if ( GetPartyMembersDyingFlag() )
	{
		object oFM = GetFirstFactionMember( oPC, FALSE );
		while ( GetIsObjectValid( oFM ) == TRUE )
		{
			effect eEffect = GetFirstEffect(oFM);
			while(GetIsEffectValid(eEffect))
			{
				if(GetEffectType(eEffect) == EFFECT_TYPE_HITPOINT_CHANGE_WHEN_DYING)
				{
					if(GetEffectInteger(eEffect, 0) != TRUE)
					{
						effect eDeath = EffectDeath(FALSE,FALSE,TRUE,TRUE);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oFM);
					}
				}
				
				eEffect = GetNextEffect(oFM);
			}
			oFM = GetNextFactionMember( oPC, FALSE );
		}			
	}	
	// k_mod_load.nss campaign setting - override "Gather Party" transition
	// TODO: What if oClicker is NPC?
	if ( GetGlobalInt( "bGATHER_PARTY_TRAN" ) == 1 )
	{
		CSLGatherPartyTransition( oPC, oDestination );
		return;
	}
	

	
	if ( bIsPartyTranstion == TRUE )
	{
		CSLSinglePartyTransition( oPC, oDestination );
	}
	else
	{
		AssignCommand( oPC, JumpToObject( oDestination ) );
	}
}
	//// Create a vector with the specified values for x, y and z
// vector Vector(float x=0.0f, float y=0.0f, float z=0.0f);

// Cause the caller to face vTarget
//RWT-OEI 12/20/04 - If the 2nd parameter is passed as TRUE, then the dialog
//manager will not go trying to adjust the caller for the remainder of the
//dialog. This lock is only in effect for the currently active dialog.
//void SetFacingPoint(vector vTarget, int bLockToThisOrientation = FALSE);

// Convert fAngle to a vector
//vector AngleToVector(float fAngle);

// Convert vVector to an angle
//float VectorToAngle(vector vVector);

// Normalize vVector
//vector VectorNormalize(vector vVector);

// Get the orientation value from lLocation.
//float GetFacingFromLocation(location lLocation);

// Get the position vector from lLocation.
//vector GetPositionFromLocation(location lLocation);

// Get the area's object ID from lLocation.
//object GetAreaFromLocation(location lLocation);
	
	
	
	//location lProjectileLocation =  Location(oArea, fCannonFacing, vProjectilePosition);
	
	/*
	// Check for collision with target
	// Get extents (bounding coordinates) of the target
	tx1 = vTargetPosition.x - fTargetLength/2;
	tx2 = vTargetPosition.x + fTargetLength/2;
	tz1 = vTargetPosition.z - fTargetHeight/2;
	tz2 = vTargetPosition.z + fTargetHeight/2;
	ty1 = vTargetPosition.y - fTargetWidth/2;
	ty2 = vTargetPosition.y + fTargetWidth/2;
	
	// Now check to see if the shell has passed through the target
	// I'm using a rudimentary collision detection scheme here where
	// I simply check to see if the shell's coordinates are within the
	// bounding box of the target.  This works for demo purposes, but
	// a practical problem is that you may miss a collision if for a given
	// time step the shell's change in position is large enough to allow 
	// it to "skip" over the target.
	// A better approach is to look at the previous time step's position data
	// and to check the line from the previous postion to the current position
	// to see if that line intersects the target bounding box.
	if( (vProjectilePosition.x >= tx1 && vProjectilePosition.x <= tx2) &&
		(vProjectilePosition.z >= tz1 && vProjectilePosition.z <= tz2) &&
		(vProjectilePosition.y >= ty1 && vProjectilePosition.y <= ty2) )
		return 1;
	*/
	
	/*
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF), lTarget);
	//;
	
	// Check for collision with ground (horizontal plane)
	if(vProjectilePosition.z <= CSLGetHeightAtLocation( lProjectileLocation ) )
	{
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_HUGE_SMOKEPUFF), lTarget);
		return 2;
	}
	// Cutoff the simulation if it's taking too long
	// This is so the program does not get stuck in the while loop
	if(fElapsedTime>3600)
		return 3;

	return 0;	
	*/
	
	
	
/*
// ************************************************
// inc_vectors
// ************************************************
// Author: Clement Poh
// Date: 29/11/06
// Version: 1.02
// Description : Basic 3 dimensional vector library.
// Uses the vectors learnt in late high school 
// and first year uni maths.
//
// If you want anything added to this library,
// please don't hesitate to contact me at any time.
//
// Update History:
// 30/11/06 - Added function: LocAtAngleToLocFacing.
// 01/12/06 - More abstraction: VAtAngleToV.
// 03/12/06 - Added function: DetermineQuadrant.
// 04/12/06 - Changed important Loc functions, changes are in comments
//
// Notes: 
// - The functions don't handle the third dimension
// very thoroughly at all, but it seems to work as
// it is.
// - soh cah and toa return angles not lengths.
// They do not currently work well determining
// quadrants.
// 
// ************************************************
// *** PROTOTYPES
// ************************************************

// ** Vector functions.

// Returns the vector from v1 to v2.
vector AtoB(vector v1, vector v2);

// Returns a vector fDist away from vRef at fAngle.
vector VAtAngleToV(vector vRef, float fDist, float fAngle);

// Returns the projection of v2 onto v1. The vector component of v2
// in the direction of, or along v1.
vector VectorProjection(vector v1, vector v2);

// Finds the scalar projection of v2 onto v1. The length of the vector
// projection of v2 on to v1.
float ScalarProjection(vector v1, vector v2);

// Returns the enclosed angle between two vectors.
float EnclosedAngle(vector v1, vector v2);

// - Returns the scalar triple product of v1, v2 and v3.
// - Defined as |v1 . (v2 x v3)| 
float ScalarTripleProduct(vector v1, vector v2, vector v3);

// - Returns v1 x v2, the resultant vector is perpendicular to both v1 and v2.
vector CrossProduct(vector v1, vector v2);

// Returns the dot product of two vectors.
// - If the vectors are perpendicular, the dot product is zero.
float DotProduct(vector v1, vector v2);

// ** Basic trigonometry

// Determines the quadrant that v1 is relative to vOrigin.
// Returns 0 if is at 0, 90, 180, or 270 degrees to the
// positive x-axis.
int DetermineQuadrant(vector vOrigin, vector v1);

// Returns the adjacent angle, given the length of the hypotenuse and
// opposite side. * returns 0.0 for divide by 0.
float soh(float fOppositeLength, float fHypotenuseLength);

// Returns the adjacent angle, given the length of the hypotenuse and
// adjacent side. * returns 0.0 for divide by 0.
float cah(float fAdjacentLength, float fHypotenuseLength);

// Returns the adjacent angle, given the length of the opposite side
// and the adjacent side. * returns 0.0 for divide by 0.
float toa(float fOppositeLength, float fAdjacentLength);


// ** angles between a point and an axis function.

// Returns the angle between a vector (position) and the positive x-axis.
// from 0.0 to 180.0
float GetXAngle(vector v1);

// Returns the angle between a vector (position) and the positive y-axis.
// from 0.0 to 180.0
float GetYAngle(vector v1);

// Returns the angle between a vector (position) and the positive z-axis.
// from 0.0 to 180.0
float GetZAngle(vector v1);


// ** Functions which deal with locations relative to a Point.

// Returns a location fDist in front of oObj, facing oObj.
location LocInFrontOfObj(object oObj, float fDist = 1.0);

// Returns a location fDist behind oObj, facing oObj.
location LocBehindObj(object oObj, float fDist = 1.0);

// Returns a location fDist on the right side of oObj, facing oOb.
location LocRSideOfObj(object oObj, float fDist = 1.0);

// Returns a location fDist on the left side of oObj, facing oObj.
location LocLSideOfObj(object oObj, float fDist = 1.0);

// Returns a location fDist at angle fAngle around oObj, facing oObj.
// 0 degrees is the facing of the oObj, so 90.0 degrees is left of oObj.
location LocAtAngleToObj(object oObj, float fDist = 1.0, float fAngle = 0.0);

// Returns a location fDist in front of lRef, facing lRef.
location LocInFrontOfLoc(location lRef, float fDist = 1.0);

// Returns a location fDist behind of lRef, facing lRef.
location LocBehindLoc(location lRef, float fDist = 1.0);

// Returns a location fDist to the right of lRef, facing lRef.
location LocRSideOfLoc(location lRef, float fDist = 1.0);

// Returns a location fDist to the left of lRef, facing lRef.
location LocLSideOfLoc(location lRef, float fDist = 1.0);

// Returns a location fDist at angle fAngle around lRef, facing lRef.
// 0 degrees is the facing of the location, so 90.0 degrees is left of lRef.
location LocAtAngleToLoc(location lRef, float fDist = 1.0, float fAngle = 0.0);

// Returns a location fDist at angle fAngle around lRef, facing fFacing.
// 0 degrees is the facing of the location, so 90.0 degrees is left of lRef.
location LocAtAngleToLocFacing(location lRef, float fDist, float fAngle, float fFacing);


// ************************************************
// *** DEFINITIONS
// ************************************************

// Returns the vector from vA to vB.
vector AtoB(vector vA, vector vB) {
	return vB - vA;
}


// Returns a vector fDist away from vRef at fAngle.
vector VAtAngleToV(vector vRef, float fDist, float fAngle) {
	return Vector(vRef.x + fDist*cos(fAngle), vRef.y + fDist*sin(fAngle), vRef.z);
}

// Returns the projection of v2 onto v1. The vector component of v2
// in the direction of, or along v1.
vector VectorProjection(vector v1, vector v2) {
	return (DotProduct(v1, v2) / VectorMagnitude(v1)) * VectorNormalize(v1);
}

// Finds the scalar projection of v2 onto v1. The length of the vector
// projection of v2 on to v1.
float ScalarProjection(vector v1, vector v2) {
	return DotProduct(v1, v2)/VectorMagnitude(v1);
}

// Returns the enclosed angle between two vectors.
float EnclosedAngle(vector v1, vector v2) {
	return acos(DotProduct(v1, v2) / (VectorMagnitude(v1) * VectorMagnitude(v2)));
}

// Returns the scalar triple product of v1, v2 and v3.
// - The scalar triple product is equivalent to the volume of a
// parallelepiped of sides v1, v2 v3.
// - the volume of a tetrahedron is one sixth the volume of the associated
// parallelepiped.
// - If the scalar triple product is 0.0, v1, v2 and v3 are co-planar
float ScalarTripleProduct(vector v1, vector v2, vector v3) {
	return fabs(DotProduct(v1, CrossProduct(v2, v3)));
}

// Returns the cross product of vectors v1 and v2.
// - the magnitude of the cross product is equivalent to the area of a
// parallelogram with sides v1 and v2.
// - the are of triangle made by v1 and v2 is half the area of the associated
// parallelogram.
vector CrossProduct(vector v1, vector v2) {
	return Vector(v1.y * v2.z - v2.y * v1.z, v2.x * v1.z - v1.x * v2.z, v1.x * v2.y - v2.x * v1.y);
}


// Returns the dot product of two vectors.
float DotProduct(vector v1, vector v2) {
	return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z);
}


// ** Angles to the axes functions


// Determines the quadrant that v1 is relative to vOrigin.
// Returns 0 if is at 0, 90, 180, or 270 degrees to the
// positive x-axis.
int DetermineQuadrant(vector vOrigin, vector v1) {
	vector vNew = AtoB(vOrigin, v1);
	if (vNew.x > 0.0 && vNew.y > 0.0) {
		return 1;
	} else if (vNew.x < 0.0 && vNew.y > 0.0) {
		return 2;
	} else if (vNew.x < 0.0 && vNew.y < 0.0) {
		return 3;
	} else if (vNew.x > 0.0 && vNew.y < 0.0) {
		return 4;
	} else {
		return 0;
	}
}

// Returns the adjacent angle, given the length of the hypotenuse and
// opposite side. * returns 0.0 for divide by 0.
float soh(float fOppositeLength, float fHypotenuseLength) {
	if (fHypotenuseLength == 0.0) {
		return 0.0;
	} else {
		return asin(fOppositeLength/fHypotenuseLength);
	}
}

// Returns the adjacent angle, given the length of the hypotenuse and
// adjacent side. * returns 0.0 for divide by 0.
float cah(float fAdjacentLength, float fHypotenuseLength) {
	if (fHypotenuseLength == 0.0) {
		return 0.0;
	} else {
		return acos(fAdjacentLength/fHypotenuseLength);
	}
}

// Returns the adjacent angle, given the length of the opposite side
// and the adjacent side. * returns 0.0 for divide by 0.
float toa(float fOppositeLength, float fAdjacentLength) {
	if (fAdjacentLength == 0.0) {
		return 0.0;
	} else {
		return atan(fOppositeLength/fAdjacentLength);
	}
}

// Returns the angle between a vector (position) and the positive x-axis
float GetXAngle(vector v1) {
	return cah(v1.x, VectorMagnitude(v1));
}

// Returns the angle between a vector (position) and the positive y-axis
float GetYAngle(vector v1) {
	return cah(v1.y, VectorMagnitude(v1));
}

// Returns the angle between a vector (position) and the positive z-axis
float GetZAngle(vector v1) {
	return cah(v1.z, VectorMagnitude(v1));
}


// ** Locations relative to a Point functions

// Returns a location fDist in front of oObj, facing oObj.
location LocInFrontOfObj(object oObj, float fDist) {
	return LocAtAngleToLoc(GetLocation(oObj), fDist, 0.0);
} 

// Returns a location fDist behind oObj, facing oObj.
location LocBehindObj(object oObj, float fDist) {
	return LocAtAngleToLoc(GetLocation(oObj), fDist, 180.0);
} 

// Returns a location fDist to the right of oObj, facing oObj.
location LocRSideOfObj(object oObj, float fDist) {
	return LocAtAngleToLoc(GetLocation(oObj), fDist, -90.0);
}

// Returns a location fDist to the left of oObj, facing oObj.
location LocLSideOfObj(object oObj, float fDist) {		
	return LocAtAngleToLoc(GetLocation(oObj), fDist, 90.0);
}

// Returns a location fDist at angle fAngle around oObj, facing oObj.
// 0 degrees is the facing of oObj, so 90.0 degrees is left of the oObj.
location LocAtAngleToObj(object oObj, float fDist, float fAngle) {
	return LocAtAngleToLoc(GetLocation(oObj), fDist, fAngle);
} 

// Returns a location fDist in front of lRef, facing lRef.
location LocInFrontOfLoc(location lRef, float fDist) {		
	return LocAtAngleToLoc(lRef, fDist, 0.0);
} 

// Returns a location fDist in front of lRef, facing lRef.
location LocBehindLoc(location lRef, float fDist) {		
	return LocAtAngleToLoc(lRef, fDist, 180.0);
} 

// Returns a location fDist in front of lRef, facing lRef.
location LocRSideOfLoc(location lRef, float fDist) {		
	return LocAtAngleToLoc(lRef, fDist, -90.0);
} 

// Returns a location fDist in front of lRef, facing lRef.
location LocLSideOfLoc(location lRef, float fDist) {		
	return LocAtAngleToLoc(lRef, fDist, 90.0);
} 

// Returns a location fDist at angle fAngle around lRef, facing lRef.
// 0 degrees is the facing of the location, so 90.0 degrees is left of the location.
location LocAtAngleToLoc(location lRef, float fDist, float fAngle) {
	float fFacing = GetFacingFromLocation(lRef) + fAngle;
	return LocAtAngleToLocFacing(lRef, fDist, fAngle, fFacing - 180.0);
} 

// Returns a location fDist at angle fAngle around lRef, facing fFacing.
// 0 degrees is the facing of the location, so 90.0 degrees is left of the location.
location LocAtAngleToLocFacing(location lRef, float fDist, float fAngle, float fNew) {
	object oArea = GetAreaFromLocation(lRef);
	vector vRef = GetPositionFromLocation(lRef);
	float fFacing = GetFacingFromLocation(lRef);
	
	vector vNewPos = VAtAngleToV(vRef, fDist, fFacing + fAngle);
	return Location(oArea, vNewPos, fNew);
}
*/


// Given a varname, value, and PC, sets the variable on 
// all members of the PC's party. 
// For locations.
void CSLSetLocalLocationOnFaction(object oPC, string sVarname, location value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalLocation(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalLocation(oPC, sVarname, value);
}


int CSLAutoFollowIsValid( object oFollower, object oTarget)
{
	// remember if there are issues, this is a tool built for dm's to follow a party
	// which has some issues when used by players since that is really just a side effect
	if ( !GetIsObjectValid(oTarget) || !GetIsObjectValid(oFollower) )
	{
		return FALSE;
	}
	
	if ((GetObjectType(oTarget)!=OBJECT_TYPE_CREATURE) || (oTarget==oFollower))
	{
		return FALSE; // you can only follow creatures, and you cannot follow yourself
	}
	
	if ( CSLGetIsDM( oTarget ))
	{
		return TRUE; // dm's are not restricted by this
	}
	
	if ( GetFactionLeader(oTarget) != GetFactionLeader(oFollower) )
	{
		return FALSE;
	}
	
	if ( !GetIsObjectValid(GetArea(oTarget)) || GetArea(oTarget) != GetArea(oFollower) )
	{
		return FALSE;
	}
	
	return TRUE;
}

    
void CSLAutoFollowOff( object oFollower = OBJECT_SELF )
{
	// remember if there are issues, this is a tool built for dm's to follow a party
	// which has some issues when used by players since that is really just a side effect
	
	SetLocalInt(oFollower, "CSL_FOLLOW", FALSE );
	DeleteLocalObject(oFollower, "CSL_FOLLOWOBJECT" );
		
	AssignCommand(oFollower, ClearAllActions(TRUE));
	SendMessageToPC(oFollower, "Turning DMFI Follow Off.");
	
	SetGUIObjectHidden( oFollower, "SCREEN_HOTBAR", "followOn-btn", FALSE ); // shows
	SetGUIObjectDisabled( oFollower, "SCREEN_HOTBAR", "followOn-btn", TRUE ); //disables, it will enable later when it has a target
	SetGUIObjectHidden( oFollower, "SCREEN_HOTBAR", "followOff-btn", TRUE ); // hides
	
}
    
    
void CSLAutoFollow( object oFollower, int iRetries = 0, int iSerial = -1 )
{
	// remember if there are issues, this is a tool built for dm's to follow a party
	// which has some issues when used by players since that is really just a side effect
	
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Follow Start", oPC ); }
	//Purpose: Forces oFollower to follow oTarget
	// Original scripter: Demetrious
	// Last Modified by:  Demetrious 1/19/7
	if ( GetLocalInt(oFollower, "CSL_FOLLOW" ) ) // this is to allow message about turning it off to work
	{
		// this uses the same logic as CSLSerialRepeatCheck, which is a higher level code so can't be used here
		// this is a safety to ensure loops do not run amok even if things are hijacked
		// only last follow will be obeyed
		if ( iSerial == -1 )
		{
			iSerial = CSLGetRandomSerialNumber();
			SetLocalInt(oFollower, "SERIAL_AUTOFOLLOW", iSerial );
		}
		else if ( iSerial != GetLocalInt(oFollower, "SERIAL_AUTOFOLLOW" ) )
		{
			return;
		}
		
		if ( iRetries > 6 ) // tries for 6 rounds, note since the guy is not moving i set it so it delays some
		{
			CSLAutoFollowOff( oFollower );
		}
		
		object oTarget = GetLocalObject(oFollower, "CSL_FOLLOWOBJECT");
	
		if ( CSLAutoFollowIsValid( oFollower, oTarget ) )
		{
			if (GetArea(oFollower)!=GetArea(oTarget)) // repeating this, but logic is teh same as in validity function
			{
				if ( CSLGetIsDM( oTarget ))
				{
					AssignCommand(oFollower,ClearAllActions(TRUE));
					AssignCommand(oFollower,JumpToObject(oTarget)) ;
				}
				else
				{
					// we have an error, lets try a little bit
					iRetries++;
					//AssignCommand(oFollower, ActionForceMoveToObject(oTarget, TRUE, 1.5));
					DelayCommand(6.0, CSLAutoFollow(oFollower, iRetries, iSerial ));
					//CSLAutoFollowOff( oFollower );
					return;
				}
			}
			else if (GetDistanceBetween(oFollower, oTarget) > SC_DISTANCE_LARGE )
			{
				AssignCommand(oFollower, ClearAllActions(TRUE));
				AssignCommand(oFollower, ActionForceMoveToObject(oTarget, TRUE, 1.5));
			}		
			else if ( !GetIsInCombat( oFollower ) && GetDistanceBetween(oFollower, oTarget) > SC_DISTANCE_SHORT ) // prevent some of the clear actions when they are closer
			{ // use Force Follow to smooth out camera
				AssignCommand(oFollower, ClearAllActions(TRUE));
				AssignCommand(oFollower, ActionForceMoveToObject(oTarget, FALSE, 1.5));
			}
			DelayCommand(3.0, CSLAutoFollow(oFollower, iRetries, iSerial ));
		}
	}
	else
	{
		// delay ending it for a little bit ( 18 seconds, target might be in transition or the like
		iRetries++;
		DelayCommand(6.0, CSLAutoFollow(oFollower, iRetries, iSerial ));
		//CSLAutoFollowOff( oFollower );
		return;
	}
}


void CSLAutoFollowOn( object oFollower, object oTarget)
{
	if ((GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) && (oTarget!=oFollower))
	{
		SetLocalInt(oFollower, "CSL_FOLLOW", TRUE );
		SetLocalObject(oFollower, "CSL_FOLLOWOBJECT", oTarget);
		CSLAutoFollow(oFollower);
		SendMessageToPC(oFollower, "DMFI Set to Follow: " + GetName(oTarget) );
		//DisplayGuiScreen(oPC, SCREEN_DMFI_FOLLOWOFF, FALSE, "dmfifollowoff.xml");
		
		SetGUIObjectHidden( oFollower, "SCREEN_HOTBAR", "followOn-btn", TRUE ); // hides
		SetGUIObjectHidden( oFollower, "SCREEN_HOTBAR", "followOff-btn", FALSE ); // shows
		
	}
	else
	{
		SendMessageToPC(oFollower, "DMFI Target must be NPC or PC for this function.");
	}
}


void DoPortal(location lLoc, int nMode)
{
	object oMOD = GetModule();
	effect ePortal1 = EffectNWN2SpecialEffectFile("fx_portal_gen_small");
	effect ePortal2 = EffectNWN2SpecialEffectFile("sp_magic_circle");
	object oPortal,oAntport;
	if (nMode ==1)
	{
		oAntport = GetLocalObject(oMOD,"DMFI_PORTAL_A");
		if (GetIsObjectValid(oAntport))
		{
			DestroyObject(oAntport); DeleteLocalObject(oMOD,"DMFI_PORTAL_A");
		}
		oPortal = CreateObject(OBJECT_TYPE_PLACEABLE,"dmfi_portal",lLoc,FALSE,"dmfi_portal_a");
		SetLocalObject(oMOD,"DMFI_PORTAL_A",oPortal);
		SetLocalInt(oPortal,"DMFI_DESTINATION",1);
	}
	else
	{
		oAntport = GetLocalObject(oMOD,"DMFI_PORTAL_B");
		if (GetIsObjectValid(oAntport))
		{
			DestroyObject(oAntport); DeleteLocalObject(oMOD,"DMFI_PORTAL_b");
		}
		oPortal = CreateObject(OBJECT_TYPE_PLACEABLE,"dmfi_portal",lLoc,FALSE,"dmfi_portal_b");
		SetLocalObject(oMOD,"DMFI_PORTAL_B",oPortal);
		SetLocalInt(oPortal,"DMFI_DESTINATION",0);
	}
	ApplyEffectToObject(2,ePortal2,oPortal);
	ApplyEffectToObject(2,ePortal1,oPortal);
}

void DestroyPortals()
{
	object oMOD = GetModule();
	object oPort1 = GetLocalObject(oMOD,"DMFI_PORTAL_A");
	object oPort2 = GetLocalObject(oMOD,"DMFI_PORTAL_B");
	DestroyObject(oPort1);
	DestroyObject(oPort2);
	DeleteLocalObject(oMOD,"DMFI_PORTAL_A");
	DeleteLocalObject(oMOD,"DMFI_PORTAL_A");
}





void JumpParty(object oTarget,object oDM)
{
	object oPlayer = GetFirstFactionMember(oTarget);
	location lLoc = GetLocation(oDM);
	while (GetIsObjectValid(oPlayer))
	{
		AssignCommand(oPlayer,JumpToLocation(lLoc));	
		oPlayer = GetNextFactionMember(oTarget);
	}
}

void JumpAllPlayers(object oDM)
{
	object oPlayer = GetFirstPC();
	location lLoc = GetLocation(oDM);
	while (GetIsObjectValid(oPlayer))
	{
		AssignCommand(oPlayer,JumpToLocation(lLoc));	
		oPlayer = GetNextPC();
	}
}