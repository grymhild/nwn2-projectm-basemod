/** @file
* @brief Object function core library
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

//#include "_CSLCore_Config_c"
// need to review these
//#include "_CSLCore_Math"
//#include "_CSLCore_Strings"


/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/**  
* Wrapper for CreateObject.
* @author
* @param 
* @see 
* @replaces XXXWrapperCreateObject
* @return 
*/
void CSLWrapperCreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="")
{
	CreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag);
}


// returns number destroyed
int CSLDestroyAllWithTag(string sTag, int bThisAreaOnly=FALSE, object oThisArea = OBJECT_SELF)
{
	int i = 0;
	object oObject = GetObjectByTag(sTag, i);
	oThisArea = GetArea(oThisArea);

	while (GetIsObjectValid(oObject))
	{
		if (bThisAreaOnly && (GetArea(oObject) != oThisArea))
			break;
			
		DestroyObject(oObject);
		oObject = GetObjectByTag(sTag, ++i);
	}
	return (i);
}	


int CSLGetNumberOfObjects(string sTag, int bThisAreaOnly=FALSE, object oThisArea = OBJECT_SELF )
{
	int i = 0;
	object oObject = GetObjectByTag(sTag, i);
	oThisArea = GetArea(oThisArea);
	
	while (GetIsObjectValid(oObject))
	{
		if (bThisAreaOnly && (GetArea(oObject) != oThisArea))
			break;
		oObject = GetObjectByTag(sTag, ++i);
	}
	return (i);
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Create Creature at a waypoint
// sRef : ResRef
// oWP  : Object (preferably Waypoint)
// sTag : new tag for the Creature
object CSLCreateCreature(string sRef, object oWP, string sTag="")
{
	int      iTyp = OBJECT_TYPE_CREATURE;
	location lLoc = GetLocation(oWP);
	return CreateObject(iTyp, sRef, lLoc, FALSE, sTag);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Create Placable at a waypoint
// sRef : ResRef
// oWP  : Object (preferably Waypoint)
// sTag : new tag for the Placable
object CSLCreatePlacable(string sRef, object oWP, string sTag="")
{
	int      iTyp = OBJECT_TYPE_PLACEABLE;
	location lLoc = GetLocation(oWP);
	return CreateObject(iTyp, sRef, lLoc, FALSE, sTag);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Create Placed Effect at a waypoint
// sRef : ResRef
// oWP  : Object (preferably Waypoint)
// sTag : new tag for the Placed Effect
object CSLCreatePlacedEffect(string sRef, object oWP, string sTag="")
{
	int      iTyp = OBJECT_TYPE_PLACED_EFFECT;
	location lLoc = GetLocation(oWP);
	return CreateObject(iTyp, sRef, lLoc, FALSE, sTag);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Create Store at a waypoint
// sRef : ResRef
// oWP  : Object (preferably Waypoint)
// sTag : new tag for the Store
object CSLCreateStore(string sRef, object oWP, string sTag="")
{
	int      iTyp = OBJECT_TYPE_STORE;
	location lLoc = GetLocation(oWP);
	return CreateObject(iTyp, sRef, lLoc, FALSE, sTag);
}



int CSLGetNumberOfObjectsInArea(string sTag, object oThisArea = OBJECT_SELF)
{
	return (CSLGetNumberOfObjects(sTag, TRUE, oThisArea));
/*	int i = 1;
	object oTarget = GetNearestObjectByTag(sTag, OBJECT_SELF, i);
	while (GetIsObjectValid(oTarget))
	{
		oTarget = GetNearestObjectByTag(sTag, OBJECT_SELF, ++i);
	}
	return (--i);
*/
}

/* this is actually not being used by anything */
/*
object CSLGetRandomObjectInArea(string sTag, object oThisArea = OBJECT_SELF)		
{
	int iNumObjects = CSLGetNumberOfObjectsInArea(sTag, oThisArea);
	int iRandomIndex = Random(iNumObjects) + 1;
	return (GetNearestObjectByTag(sTag, oThisArea, iRandomIndex));
}
*/






// returns the combined object types of any of the following:
// not case sensitive
//                C = creature
//                I = item
//                T = trigger
//                D = door
//                A = area of effect
//                W = waypoint
//                P = placeable
//                S = store
//                E = encounter
//				  L = light
//                V = visual effect
//                ALL = everything

int CSLGetObjectTypes(string sType)
{
    sType = GetStringUpperCase(sType);
    int iObjectType = 0;

    if (FindSubString(sType, "ALL") != -1)
        iObjectType = OBJECT_TYPE_ALL;
    else
    {
        iObjectType |= (FindSubString(sType, "C")==-1)?0:OBJECT_TYPE_CREATURE;
        iObjectType |= (FindSubString(sType, "I")==-1)?0:OBJECT_TYPE_ITEM;
        iObjectType |= (FindSubString(sType, "T")==-1)?0:OBJECT_TYPE_TRIGGER;
        iObjectType |= (FindSubString(sType, "D")==-1)?0:OBJECT_TYPE_DOOR;
        iObjectType |= (FindSubString(sType, "A")==-1)?0:OBJECT_TYPE_AREA_OF_EFFECT;
        iObjectType |= (FindSubString(sType, "W")==-1)?0:OBJECT_TYPE_WAYPOINT;
        iObjectType |= (FindSubString(sType, "P")==-1)?0:OBJECT_TYPE_PLACEABLE;
        iObjectType |= (FindSubString(sType, "S")==-1)?0:OBJECT_TYPE_STORE;
        iObjectType |= (FindSubString(sType, "E")==-1)?0:OBJECT_TYPE_ENCOUNTER;
		iObjectType |= (FindSubString(sType, "V")==-1)?0:OBJECT_TYPE_PLACED_EFFECT;
		iObjectType |= (FindSubString(sType, "L")==-1)?0:OBJECT_TYPE_LIGHT;
    }

    return iObjectType;
}



// Given a varname, value, and PC, sets the variable on 
// all members of the PC's party. 
// For objects.
void CSLSetLocalObjectOnFaction(object oPC, string sVarname, object value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalObject(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalObject(oPC, sVarname, value);
}






void DestroyPlaceables(object oTarget)
{
	SetPlotFlag(oTarget,FALSE);
	DestroyObject(oTarget,0.1,TRUE);
}