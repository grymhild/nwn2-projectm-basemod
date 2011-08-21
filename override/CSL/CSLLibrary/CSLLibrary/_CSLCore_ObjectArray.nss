/** @file
* @brief Object and Variables on object functions, CSLDataTable, CSLDataArray and functions for moving variables between objects
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/





// CSLDataArray
// =================================================================
// Array
// DataTable
// DataList-DataMap DataArray

// 
// Provide simple array functions
// Array is stored as a series of local variables like this:
// DataType_ArrayName_Length => 3 (length of the array)
// DataType_ArrayName_0 => 123 (first element)
// DataType_ArrayName_1 => 456 (second element)
// DataType_ArrayName_2 => 789 (third element)
// Arrays of different data type but same name can coexist
// 
// By Nytir
// =================================================================

/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////


// CSLDataArray 
// Data Prefix/suffix
const string CSLDATAARRAY_PFX_CYCLE = "CYC"; //Cycle Index
const string CSLDATAARRAY_PFX_LENGTH = "LEN"; //Length
const string CSLDATAARRAY_PFX_INTEGER = "I_";  //Int
const string CSLDATAARRAY_PFX_FLOAT = "F_";  //Float
const string CSLDATAARRAY_PFX_STRING = "S_";  //String
const string CSLDATAARRAY_PFX_OBJECT = "O_";  //Object
const string CSLDATAARRAY_PFX_LOCATION = "L_";  //Location




//----------------DMFI Array Functions---------------// <-- planning on merging these so they work similar to the other array functions

//string currentList = "";
//object currentHolder = OBJECT_INVALID;
//int currentCount = 0;
//int currentIndex = -1;


/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

#include "_CSLCore_Config_c"
// need to review these
#include "_CSLCore_Math"
#include "_CSLCore_Strings"
#include "_CSLCore_ObjectVars"
//#include "_CSLCore_Messages"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////



/**  
* Get the preffix for a data type
* @author Nytir
* @param 
* @see 
* @replaces XXXXVarPrefix
* @return 
*/
string CSLDataArray_ElementGetPrefix(int iType)
{
	switch(iType)
	{
		case CSLDATAARRAY_TYPE_INTEGER: return CSLDATAARRAY_PFX_INTEGER;
		case CSLDATAARRAY_TYPE_FLOAT: return CSLDATAARRAY_PFX_FLOAT;
		case CSLDATAARRAY_TYPE_STRING: return CSLDATAARRAY_PFX_STRING;
		case CSLDATAARRAY_TYPE_OBJECT: return CSLDATAARRAY_PFX_OBJECT;
		case CSLDATAARRAY_TYPE_LOCATION: return CSLDATAARRAY_PFX_LOCATION;
	}
	return "";
}


/**  
* Construct a Variable Name using the information provided
* @author Nytir
* @param 
* @see 
* @replaces XXXXVarName
* @return 
*/
string CSLDataArray_GetElementName(string sName, int iType, int iNth)
{
	string sVN = CSLDataArray_ElementGetPrefix(iType) + sName;
	switch( iNth )
	{
		// Meta Data
		case CSLDATAARRAY_CYCLE: sVN += "_"+CSLDATAARRAY_PFX_CYCLE; break; //cycle index
		case CSLDATAARRAY_LENGTH: sVN += "_"+CSLDATAARRAY_PFX_LENGTH; break; //length
		// Elements
		default: sVN += "_"+IntToString(iNth); break; 
	}
	return sVN;
}


// Internal function to get the string for a given
// messages
/*
string DEPRECATE_CSLIndexToString( int index, string list, string sListPrefix  )
{
    return( sListPrefix + list + "." + IntToString(index) );
}
*/


/**  
* Move the element in iNth to iNth + iShf
* Will overwrite the element in destination if exists
* oObj  : Target Object
* sName : Array Name
* iType : Data Type
* iNth    : Index
* iShf  : Shift
* @author Nytir
* @param 
* @see 
* @replaces XXXXElementShift
* @return 
*/
void CSLDataArray_ElementShift(object oObj, string sName, int iType, int iNth, int iShf)
{
	string sID1 = CSLDataArray_GetElementName(sName, iType, iNth);
	string sID2 = CSLDataArray_GetElementName(sName, iType, iNth+iShf);
	// Copy var in sID1 to sID2, then delete sID1
	switch(iType)
	{
		case CSLDATAARRAY_TYPE_INTEGER: 
			SetLocalInt(oObj, sID2, GetLocalInt(oObj, sID1));
			DeleteLocalInt(oObj, sID1);
			break;
		case CSLDATAARRAY_TYPE_FLOAT: 
			SetLocalFloat(oObj, sID2, GetLocalFloat(oObj, sID1));
			DeleteLocalFloat(oObj, sID1);
			break;
		case CSLDATAARRAY_TYPE_STRING: 
			SetLocalString(oObj, sID2, GetLocalString(oObj, sID1));
			DeleteLocalString(oObj, sID1);
			break;
		case CSLDATAARRAY_TYPE_OBJECT: 
			SetLocalObject(oObj, sID2, GetLocalObject(oObj, sID1));
			DeleteLocalObject(oObj, sID1);
			break;
		case CSLDATAARRAY_TYPE_LOCATION: 
			SetLocalLocation(oObj, sID2, GetLocalLocation(oObj, sID1));
			DeleteLocalLocation(oObj, sID1);
			break;
	}
}


/**  
* Delete the Nth element
* oObj  : Target Object
* sName : Array Name
* iType : Data Type
* iNth    : Index
* @author Nytir
* @param 
* @see 
* @replaces XXXXElementDelete
* @return 
*/
void CSLDataArray_ElementDelete(object oObj, string sName, int iType, int iNth)
{
	string sID  = CSLDataArray_GetElementName(sName, iType, iNth);
	if( iNth < 0 )
	{
		// Delete Meta Data
		DeleteLocalInt(oObj, sID);
	}
	else
	{
		// Delete Elements
		switch(iType)
		{
			case CSLDATAARRAY_TYPE_INTEGER: DeleteLocalInt(oObj, sID); break;
			case CSLDATAARRAY_TYPE_FLOAT: DeleteLocalFloat(oObj, sID); break;
			case CSLDATAARRAY_TYPE_STRING: DeleteLocalString(oObj, sID); break;
			case CSLDATAARRAY_TYPE_OBJECT: DeleteLocalObject(oObj, sID); break;
			case CSLDATAARRAY_TYPE_LOCATION: DeleteLocalLocation(oObj, sID); break;
		}
	}
}







/**  
* Print the Nth element
* oObj  : Target Object
* sName : Array Name
* iType : Data Type
* iNth    : Index
* @author Nytir
* @param 
* @see 
* @replaces XXXXElementPrint
* @return 
*/
void CSLDataArray_ElementPrint(object oObj, string sName, int iType, int iNth)
{
	string sID = CSLDataArray_GetElementName(sName, iType, iNth);
	string sMS = sID+" => ";
	if( iNth < 0 )
	{
		// Meta Data
		sMS += IntToString(GetLocalInt(oObj, sID));
	}
	else
	{
		// Elements
		switch(iType)
		{
			case CSLDATAARRAY_TYPE_INTEGER: sMS += IntToString(GetLocalInt(oObj, sID)); break;
			case CSLDATAARRAY_TYPE_FLOAT: sMS += CSLFormatFloat(GetLocalFloat(oObj, sID)); break;
			case CSLDATAARRAY_TYPE_STRING: sMS += GetLocalString(oObj, sID); break;
			case CSLDATAARRAY_TYPE_OBJECT: sMS += GetTag(GetLocalObject(oObj, sID)); break;
			case CSLDATAARRAY_TYPE_LOCATION: 
				location lLoc = GetLocalLocation(oObj, sID);
				vector vLoc = GetPositionFromLocation(lLoc);
				sMS += GetTag(GetAreaFromLocation(lLoc))+" ("+CSLFormatFloat(vLoc.x)+", "+CSLFormatFloat(vLoc.y)+", "+CSLFormatFloat(vLoc.z)+")";
				break;
		}
	}
	SendMessageToPC(GetFirstPC(FALSE), sMS);
}


/**  
* Get the Array Length 
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayLengthGet
* @return 
*/
int CSLDataArray_GetLength(object oObj, string sName, int iType)
{
	return GetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_LENGTH));
}




/*
// Returns the number of items in the specified list.
// used in messages, dmfi and seed_faq
int DEPRECATE_CSLGetElementCount( string list, string sListPrefix, object holder = OBJECT_SELF )
{
    return( GetLocalInt( holder, sListPrefix + list ) );
}
*/

/**  
* Set the Array Length 
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayLengthSet
* @return 
*/
void CSLDataArray_SetLength(object oObj, string sName, int iType, int iLen)
{
	SetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_LENGTH), iLen);
}


/**  
* Update the Array Length
* iN : the index of the element just added/changed
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayLengthUpdate
* @return 
*/
void CSLDataArray_UpdateLength(object oObj, string sName, int iType, int iN)
{
	if( CSLDataArray_GetLength(oObj, sName, iType) <= iN )
	{
		CSLDataArray_SetLength(oObj, sName, iType, (iN+1));
	}
}


/**  
* Shifts the indexes of the array by iShf starting at N
* oObj   : Target Object
* sName  : Array Name
* iType  : Data Type
* iN     : Starting Index
* iShf : Shift
* 
* e.g. Array => 0:a, 1:b, 2:c, 3:d
* CSLDataArray_Shift(oObj,sName,iType,0, 1) => 0: , 1:a, 2:b, 3:c, 4:d
* CSLDataArray_Shift(oObj,sName,iType,0,-1) => 0:b, 1:c, 2:d
* CSLDataArray_Shift(oObj,sName,iType,2, 1) => 0:a, 1:b, 2: , 3:c, 5:d
* CSLDataArray_Shift(oObj,sName,iType,2,-1) => 0:a, 1:b, 2:d
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayShift
* @return 
*/
void CSLDataArray_Shift(object oObj, string sName, int iType, int iN, int iShf)
{
	int iS = iN;
	int iE = CSLDataArray_GetLength(oObj, sName, iType);
	CSLDataArray_SetLength(oObj, sName, iType, iE + iShf);
	if( iShf > 0 )
	{
		do
		{
			iE --;
			CSLDataArray_ElementShift(oObj, sName, iType, iE, iShf);
		}
		while( iS < iE );
	}
	if( iShf < 0 )
	{
		iS -= iShf;
		while( iS < iE )
		{
			CSLDataArray_ElementShift(oObj, sName, iType, iS, iShf);
			iS ++;
		}
	}
}


/**  
* Deletes the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayDelete
* @return 
*/
void CSLDataArray_Delete(object oObj, string sName, int iType)
{
	int iN;
	int iL = CSLDataArray_GetLength(oObj, sName, iType);
	for( iN = CSLDATAARRAY_CYCLE; iN < iL; iN ++ )
	{
		CSLDataArray_ElementDelete(oObj, sName, iType, iN);
	}
}

// Deletes the list and all contents.  Returns the number
// of elements deleted in the process.
// seed files, dm gui functions, messages, faction, arena,  all over the place
/*
int DEPRECATE_CSLDeleteList( string list, string sListPrefix, object holder = OBJECT_SELF )
{
    int count = DEPRECATE_CSLGetElementCount( list, sListPrefix, holder );
    if( count == 0 )
        return( count );

    // Delete all elements
    int i;
    for( i = 0; i < count; i++ )
        {
        string current = DEPRECATE_CSLIndexToString( i, list, sListPrefix );
        DeleteLocalFloat( holder, current );
        DeleteLocalInt( holder, current );
        DeleteLocalLocation( holder, current );
        DeleteLocalObject( holder, current );
        DeleteLocalString( holder, current );
        }

    // Delete the main list info
    DeleteLocalInt( holder, sListPrefix + list );

    return( count );
}
*/

/**  
* Prints the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayPrint
* @return 
*/
void CSLDataArray_Print(object oObj, string sName, int iType)
{
	int iN;
	int iL = CSLDataArray_GetLength(oObj, sName, iType);
	for( iN = CSLDATAARRAY_CYCLE; iN < iL; iN ++ )
	{
		CSLDataArray_ElementPrint(oObj, sName, iType, iN);
	}
}


/**  
* Get Looping Cycle ID, which is the arrays current active pointer, if it hits the max it starts over 
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayCycle
* @return 
*/
int CSLDataArray_Cycle(object oObj, string sName, int iType)
{
	int iC = GetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_CYCLE));
	if( iC >= CSLDataArray_GetLength(oObj, sName, iType) ){ iC = 0; }
	SetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_CYCLE), iC+1);
	return iC;
}


/**  
* Get First ID, which is the arrays current active pointer, if it hits the max it returns -1 
* @author 
* @param 
* @see 
* @replaces 
* @return 
*/
int CSLDataArray_First(object oObj, string sName, int iType)
{
	int iC = 0; //GetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_CYCLE));
	//if( iC >= CSLDataArray_GetLength(oObj, sName, iType) ){ iC = -1; }
	SetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_CYCLE), 0 );
	return iC;
}

/**  
* Get Next ID, which is the arrays current active pointer, if it hits the max it returns -1 
* @author 
* @param 
* @see 
* @replaces 
* @return 
*/
int CSLDataArray_Next(object oObj, string sName, int iType)
{
	int iC = GetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_CYCLE))+1;
	if( iC >= CSLDataArray_GetLength(oObj, sName, iType) )
	{
		iC = -1;
	}
	else
	{
		SetLocalInt(oObj, CSLDataArray_GetElementName(sName, iType, CSLDATAARRAY_CYCLE), iC);
	}
	return iC;
}



/**  
* Checks if the Array Exists
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayDelete XXXarray_exists
* @return 
*/
int CSLDataArray_Exists(object oObj, string sName, int iType)
{
	if(  CSLDataArray_GetLength(oObj, sName, iType) > 0 )
	{
		return TRUE;
	}
	return FALSE;
}

/**  
* Checks if the Array Exists for any type
* @author Nytir
* @param 
* @see 
* @replaces XXXXArrayDelete
* @return 
*/
int CSLDataArray_ExistsEntire(object oObj, string sName)
{
	if(  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_INTEGER) > 0 ) { return TRUE; }
	if(  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_STRING) > 0 ) { return TRUE; }
	if(  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_FLOAT) > 0 ) { return TRUE; }
	if(  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_OBJECT) > 0 ) { return TRUE; }
	if(  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_LOCATION) > 0 ) { return TRUE; }
	return FALSE;
}


/**  
* Get the length of Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayLen XXXarray_get_size
* @return 
*/
int CSLDataArray_LengthEntire(object oObj, string sName)
{
	int iMax = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_INTEGER);
	iMax = CSLGetMax(iMax,  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_FLOAT) );
	iMax = CSLGetMax(iMax,  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_STRING) );
	iMax = CSLGetMax(iMax,  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_OBJECT) );
	iMax = CSLGetMax(iMax,  CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_LOCATION) );
	return iMax;
}

/**  
* Get the length of Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayLen
* @return 
*/
int CSLDataArray_LengthInt(object oObj, string sName)
{
	return CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_INTEGER);
}

/**  
* Get the length of Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayLen
* @return 
*/
int CSLDataArray_LengthFloat(object oObj, string sName)
{
	return CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_FLOAT);
}


/**  
* Get the length of Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayLen xxxGetElementCount
* @return 
*/
int CSLDataArray_LengthString(object oObj, string sName)
{
	return CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_STRING);
}


/**  
* Get the length of Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayLen
* @return 
*/
int CSLDataArray_LengthObject(object oObj, string sName)
{
	return CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_OBJECT);
}




/**  
* Get the length of Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayLen
* @return 
*/
int CSLDataArray_LengthLocation(object oObj, string sName)
{
	return CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_LOCATION);
}

/**  
* Set value of the Nth Element, gaps are padded with null (undeclared)
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArraySet XXXarray_set_int
* @return 
*/
void CSLDataArray_SetInt(object oObj, string sName, int iN, int iValue)
{
	CSLDataArray_UpdateLength(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iN);
	SetLocalInt(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_INTEGER, iN), iValue);
}




// Replaces the int at the specified index.  Returns the old
// int.
// dmfi, messages, propstrip, crafter, factiontool, faq, quest
/*
int DEPRECATE_CSLReplaceIntElement( int index, int value, string list, string sListPrefix, object holder = OBJECT_SELF )
{
    int count = DEPRECATE_CSLGetElementCount( list, sListPrefix, holder );
    if( index >= count )
        {
        PrintString( "Error: (ReplaceIntItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( -1 );
        }

    int original = GetLocalInt( holder, DEPRECATE_CSLIndexToString( index, list, sListPrefix ) );
    SetLocalInt( holder, DEPRECATE_CSLIndexToString( index, list, sListPrefix ), value );

    return( original );
}
*/



/**  
* Set value of the Nth Element, gaps are padded with null (undeclared)
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArraySet XXXarray_set_float
* @return 
*/
void CSLDataArray_SetFloat(object oObj, string sName, int iN, float fValue)
{
	CSLDataArray_UpdateLength(oObj, sName, CSLDATAARRAY_TYPE_FLOAT, iN);
	SetLocalFloat(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_FLOAT, iN), fValue);
}


/**  
* Set value of the Nth Element, gaps are padded with null (undeclared)
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArraySet XXXXarray_set_string
* @return 
*/
void CSLDataArray_SetString(object oObj, string sName, int iN, string sValue)
{
	CSLDataArray_UpdateLength(oObj, sName, CSLDATAARRAY_TYPE_STRING, iN);
	SetLocalString(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_STRING, iN), sValue);
}

// Replaces the string at the specified index.  Returns the old
// string.
// crafter, factiontool
/*
string DEPRECATE_CSLReplaceStringElement( int index, string value, string list, string sListPrefix, object holder = OBJECT_SELF )
{
    int count = DEPRECATE_CSLGetElementCount( list, sListPrefix, holder );
    if( index >= count )
        {
        PrintString( "Error: (ReplaceStringItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( "" );
        }

    string original = GetLocalString( holder, DEPRECATE_CSLIndexToString( index, list, sListPrefix ) );
    SetLocalString( holder, DEPRECATE_CSLIndexToString( index, list, sListPrefix ), value );

    return( original );
}
*/


/**  
* Set value of the Nth Element, gaps are padded with null (undeclared)
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArraySet XXXarray_set_object
* @return 
*/
void CSLDataArray_SetObject(object oObj, string sName, int iN, object oValue)
{
	CSLDataArray_UpdateLength(oObj, sName, CSLDATAARRAY_TYPE_OBJECT, iN);
	SetLocalObject(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_OBJECT, iN), oValue);
}

// Replaces the object at the specified index.  Returns the old
// string.
// messages, factiontool
/*
object DEPRECATE_CSLReplaceObjectElement( int index, object value, string list, string sListPrefix, object holder = OBJECT_SELF )
{
    int count = DEPRECATE_CSLGetElementCount( list, sListPrefix, holder );
    if( index >= count )
        {
        PrintString( "Error: (ReplaceObjectItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( OBJECT_INVALID );
        }

    object original = GetLocalObject( holder, DEPRECATE_CSLIndexToString( index, list, sListPrefix ) );
    SetLocalObject( holder, DEPRECATE_CSLIndexToString( index, list, sListPrefix ), value );

    return( original );
}
*/






/**  
* Set value of the Nth Element, gaps are padded with null (undeclared)
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArraySet
* @return 
*/
void CSLDataArray_SetLocation(object oObj, string sName, int iN, location lValue)
{
	CSLDataArray_UpdateLength(oObj, sName, CSLDATAARRAY_TYPE_LOCATION, iN);
	SetLocalLocation(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_LOCATION, iN), lValue);
}


/**  
* Adds an element at the back of the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayPush
* @return 
*/
int CSLDataArray_PushInt(object oObj, string sName, int iValue)
{
	int iCurrent = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_INTEGER);
	CSLDataArray_SetInt(oObj, sName, iCurrent, iValue );
	return iCurrent;
}

/**  
* Adds an element at the back of the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayPush
* @return 
*/
int CSLDataArray_PushFloat(object oObj, string sName, float fValue)
{
	int iCurrent = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_FLOAT);
	CSLDataArray_SetFloat(oObj, sName, iCurrent, fValue );
	return iCurrent;
}

/**  
* Adds an element at the back of the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayPush, DEPRECATE_CSLAddStringElement
* @return 
*/
int CSLDataArray_PushString(object oObj, string sName, string sValue)
{
	int iCurrent = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_STRING);
	CSLDataArray_SetString(oObj, sName, iCurrent, sValue );
	return iCurrent;
}


/**  
* Adds an element at the back of the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayPush, XXDEPRECATE_CSLAddObjectElement
* @return 
*/
int CSLDataArray_PushObject(object oObj, string sName, object oValue)
{
	int iCurrent = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_OBJECT);
	CSLDataArray_SetObject(oObj, sName, iCurrent, oValue );
	return iCurrent;
}


/**  
* Adds an element at the back of the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayPush
* @return 
*/
int CSLDataArray_PushLocation(object oObj, string sName, location lValue)
{
	int iCurrent = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_LOCATION);
	CSLDataArray_SetLocation(oObj, sName, iCurrent, lValue );
	return iCurrent;
}

/**  
* Removes an element from the back of the Array, and returns that element
* @author 
* @param 
* @see 
* @return 
*/
int CSLDataArray_PopInt(object oObj, string sName)
{
	int iLast = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_INTEGER)-1;
	if ( iLast == 0 ) {  return 0; }
	int iValue = GetLocalInt(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_INTEGER, iLast));
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iLast, -1);
	return iValue;
}

/**  
* Removes an element from the back of the Array, and returns that element
* @author 
* @param 
* @see 
* @return 
*/
float CSLDataArray_PopFloat(object oObj, string sName)
{
	int iLast = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_FLOAT)-1;
	if ( iLast == 0 ) {  return 0.0f; }
	float fValue = GetLocalFloat(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_FLOAT, iLast));
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iLast, -1);
	return fValue;
}

/**  
* Removes an element from the back of the Array, and returns that element
* @author 
* @param 
* @see 
* @return 
*/
string CSLDataArray_PopString(object oObj, string sName)
{
	int iLast = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_STRING)-1;
	if ( iLast == 0 ) {  return ""; }
	string sValue = GetLocalString(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_STRING, iLast));
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iLast, -1);
	return sValue;
}


/**  
* Removes an element from the back of the Array, and returns that element
* @author 
* @param 
* @see 
* @return 
*/
object CSLDataArray_PopObject(object oObj, string sName)
{
	int iLast = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_OBJECT)-1;
	if ( iLast == 0 ) {  return OBJECT_INVALID; }
	object oValue = GetLocalObject(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_OBJECT, iLast));
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iLast, -1);
	return oValue;
}


/**  
* Removes an element from the back of the Array, and returns that element
* @author 
* @param 
* @see 
* @return 
*/
location CSLDataArray_PopLocation(object oObj, string sName)
{
	int iLast = CSLDataArray_GetLength(oObj, sName, CSLDATAARRAY_TYPE_LOCATION)-1;
	if ( iLast == 0 ) {  location lValue; return lValue; }
	location lValue = GetLocalLocation(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_LOCATION, iLast));
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iLast, -1);
	return lValue;
}


/**  
* Get the Nth Element 
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayGet XXXarray_get_int
* @return 
*/
int CSLDataArray_GetInt(object oObj, string sName, int iN)
{
	return GetLocalInt(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_INTEGER, iN));
}



/**  
* Get the Nth Element 
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayGet XXXarray_get_float
* @return 
*/
float CSLDataArray_GetFloat(object oObj, string sName, int iN)
{
	return GetLocalFloat(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_FLOAT, iN));
}



/**  
* Get the Nth Element 
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayGet XXXarray_get_string
* @return 
*/
string CSLDataArray_GetString(object oObj, string sName, int iN)
{
	return GetLocalString(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_STRING, iN));
}


/**  
* Get the Nth Element 
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayGet XXXarray_get_object
* @return 
*/
object CSLDataArray_GetObject(object oObj, string sName, int iN)
{
	return GetLocalObject(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_OBJECT, iN));
}


/**  
* Get the Nth Element 
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayGet
* @return 
*/
location CSLDataArray_GetLocation(object oObj, string sName, int iN)
{
	return GetLocalLocation(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_LOCATION, iN));
}


/**  
* Return a random Element's Integer Value from the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayRand
* @return 
*/
int CSLDataArray_RandomInt(object oObj, string sName)
{
	return CSLDataArray_GetInt(oObj, sName, Random(CSLDataArray_LengthInt(oObj, sName)));
}

/**  
* Return a random Element's Float Value from the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayRand
* @return 
*/
float CSLDataArray_RandomFloat(object oObj, string sName)
{
	return CSLDataArray_GetFloat(oObj, sName, Random(CSLDataArray_LengthFloat(oObj, sName)));
}

/**  
* Return a random Element's String Value from the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayRand
* @return 
*/
string CSLDataArray_RandomString(object oObj, string sName)
{
	return CSLDataArray_GetString(oObj, sName, Random(CSLDataArray_LengthString(oObj, sName)));
}

/**  
* Return a random Element's Object Value from the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayRand
* @return 
*/
object CSLDataArray_RandomObject(object oObj, string sName)
{
	return CSLDataArray_GetObject(oObj, sName, Random(CSLDataArray_LengthObject(oObj, sName)));
}

/**  
* Return a random Element's Location Value from the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayRand
* @return 
*/
location CSLDataArray_RandomLocation(object oObj, string sName)
{
	return CSLDataArray_GetLocation(oObj, sName, Random(CSLDataArray_LengthLocation(oObj, sName)));
}


/**  
* Get the First Element's Integer Value from the Array, sets the pointer to the first element
* @author Nytir
* @param 
* @see 
* @replaces 
* @return 
*/
int CSLDataArray_FirstInt(object oObj, string sName)
{
	return CSLDataArray_GetInt(oObj, sName, CSLDataArray_First(oObj, sName, CSLDATAARRAY_TYPE_INTEGER));
}

/**  
* Get the First Element's Float Value from the Array, sets the pointer to the first element
* @author Nytir
* @param 
* @see 
* @replaces 
* @return 
*/
float CSLDataArray_FirstFloat(object oObj, string sName)
{
	return CSLDataArray_GetFloat(oObj, sName, CSLDataArray_First(oObj, sName, CSLDATAARRAY_TYPE_FLOAT));
}

/**  
* Get the First Element's String Value from the Array, sets the pointer to the first element
* @author Nytir
* @param 
* @see 
* @replaces 
* @return 
*/
string CSLDataArray_FirstString(object oObj, string sName)
{
	return CSLDataArray_GetString(oObj, sName, CSLDataArray_First(oObj, sName, CSLDATAARRAY_TYPE_STRING));
}

// Begins a list iteration for string values
// faction, seedfaq
/*
string DEPRECATE_CSLGetFirstStringElement( string list, string sListPrefix, object holder = OBJECT_SELF )
{
    currentCount = DEPRECATE_CSLGetElementCount( list, sListPrefix, holder );
    currentIndex = 0;
    return( GetLocalString( holder, DEPRECATE_CSLIndexToString( currentIndex++, list, sListPrefix ) ) );
}
*/


/**  
* Get the First Element's Object Value from the Array, sets the pointer to the first element
* @author Nytir
* @param 
* @see 
* @replaces 
* @return 
*/
object CSLDataArray_FirstObject(object oObj, string sName)
{
	return CSLDataArray_GetObject(oObj, sName, CSLDataArray_First(oObj, sName, CSLDATAARRAY_TYPE_OBJECT));
}

// Begins a list iteration for object values
// Arena
/*
object DEPRECATE_CSLGetFirstObjectElement( string list, string sListPrefix, object holder = OBJECT_SELF )
{
    currentList = list;
    currentHolder = holder;
    currentCount = DEPRECATE_CSLGetElementCount( list, sListPrefix, holder );
    currentIndex = 0;
    return( GetLocalObject( holder, DEPRECATE_CSLIndexToString( currentIndex++, list, sListPrefix ) ) );
}
*/


/**  
* Get the First Element's Location Value from the Array, sets the pointer to the first element
* @author Nytir
* @param 
* @see 
* @replaces
* @return 
*/
location CSLDataArray_FirstLocation(object oObj, string sName)
{
	return CSLDataArray_GetLocation(oObj, sName, CSLDataArray_First(oObj, sName, CSLDATAARRAY_TYPE_LOCATION));
}



/**  
* Get the Next Element's Integer Value from the Array, sets the pointer to the that element
* @author Nytir
* @param 
* @see 
* @replaces
* @return 
*/
int CSLDataArray_NextInt(object oObj, string sName)
{
	int iElement = CSLDataArray_Next(oObj, sName, CSLDATAARRAY_TYPE_INTEGER);
	if ( iElement >= 0 )
	{
		return CSLDataArray_GetInt(oObj, sName, iElement);
	}
	return 0;
}





/**  
* Get the Next Element's Float Value from the Array, sets the pointer to the that element
* @author Nytir
* @param 
* @see 
* @replaces
* @return 
*/
float CSLDataArray_NextFloat(object oObj, string sName)
{
	int iElement = CSLDataArray_Next(oObj, sName, CSLDATAARRAY_TYPE_FLOAT);
	if ( iElement >= 0 )
	{
		return CSLDataArray_GetFloat(oObj, sName, iElement);
	}
	return 0.0f;
}


/**  
* Get the Next Element's String Value from the Array, sets the pointer to the that element
* @author Nytir
* @param 
* @see 
* @replaces
* @return 
*/
string CSLDataArray_NextString(object oObj, string sName)
{
	int iElement = CSLDataArray_Next(oObj, sName, CSLDATAARRAY_TYPE_STRING);
	if ( iElement >= 0 )
	{
		return CSLDataArray_GetString(oObj, sName, iElement);
	}
	return "";
}

/*
// Returns the next item in a list iteration
// faction, seed_faq
string DEPRECATE_CSLGetNextStringElement( string sListPrefix )
{
    if( currentIndex >= currentCount )
        return( "" );
    return( GetLocalString( currentHolder, DEPRECATE_CSLIndexToString( currentIndex++, currentList, sListPrefix ) ) );
}
*/

/**  
* Get the Next Element's Object Value from the Array, sets the pointer to the that element
* @author Nytir
* @param 
* @see 
* @replaces
* @return 
*/
object CSLDataArray_NextObject(object oObj, string sName)
{
	int iElement = CSLDataArray_Next(oObj, sName, CSLDATAARRAY_TYPE_OBJECT);
	if ( iElement >= 0 )
	{
		return CSLDataArray_GetObject(oObj, sName, iElement);
	}
	return OBJECT_INVALID;
}

/*
// Returns the next item in an object list iteration, uses global var set in DEPRECATE_CSLGetFirstObjectElement to not have it here as well
// arena
object DEPRECATE_CSLGetNextObjectElement( string sListPrefix )
{
    if( currentIndex >= currentCount )
        return( OBJECT_INVALID );
    return( GetLocalObject( currentHolder, DEPRECATE_CSLIndexToString( currentIndex++, currentList, sListPrefix ) ) );
}
*/


/**  
* Get the Next Element's Location Value from the Array, sets the pointer to the that element
* @author Nytir
* @param 
* @see 
* @replaces
* @return 
*/
location CSLDataArray_NextLocation(object oObj, string sName)
{
	int iElement = CSLDataArray_Next(oObj, sName, CSLDATAARRAY_TYPE_LOCATION);
	location lLoc;
	if ( iElement >= 0 )
	{
		lLoc = CSLDataArray_GetLocation(oObj, sName, iElement);
	}
	return lLoc;
}

/**  
* Cycle the Array, upon reaching the end starts over at the beginning again
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayCycle
* @return 
*/
int CSLDataArray_CycleInt(object oObj, string sName)
{
	return CSLDataArray_GetInt(oObj, sName, CSLDataArray_Cycle(oObj, sName, CSLDATAARRAY_TYPE_INTEGER));
}

/**  
* Cycle the Array, upon reaching the end starts over at the beginning again
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayCycle
* @return 
*/
float CSLDataArray_CycleFloat(object oObj, string sName)
{
	return CSLDataArray_GetFloat(oObj, sName, CSLDataArray_Cycle(oObj, sName, CSLDATAARRAY_TYPE_FLOAT));
}

/**  
* Cycle the Array, upon reaching the end starts over at the beginning again
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayCycle
* @return 
*/
string CSLDataArray_CycleString(object oObj, string sName)
{
	return CSLDataArray_GetString(oObj, sName, CSLDataArray_Cycle(oObj, sName, CSLDATAARRAY_TYPE_STRING));
}


/**  
* Cycle the Array, upon reaching the end starts over at the beginning again
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayCycle
* @return 
*/
object CSLDataArray_CycleObject(object oObj, string sName)
{
	return CSLDataArray_GetObject(oObj, sName, CSLDataArray_Cycle(oObj, sName, CSLDATAARRAY_TYPE_OBJECT));
}


/**  
* Cycle the Array, upon reaching the end starts over at the beginning again
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayCycle
* @return 
*/
location CSLDataArray_CycleLocation(object oObj, string sName)
{
	return CSLDataArray_GetLocation(oObj, sName, CSLDataArray_Cycle(oObj, sName, CSLDATAARRAY_TYPE_LOCATION));
}


/**  
* Find the first occurence of iValue, return -1 if not found
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayFind
* @return  element row number
*/
int CSLDataArray_FindInt(object oObj, string sName, int iValue)
{
	int iN;
	int iL = CSLDataArray_LengthInt(oObj, sName);
	for( iN = 0; iN < iL; iN++ )
	{
		if( CSLDataArray_GetInt(oObj, sName, iN) == iValue ){ return iN; }
	}
	return -1;
}


/**  
* Find the first occurence of iValue, return -1 if not found
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayFind
* @return  element row number
*/
int CSLDataArray_FindFloat(object oObj, string sName, float fValue)
{
	int iN;
	int iL = CSLDataArray_LengthFloat(oObj, sName);
	for( iN = 0; iN < iL; iN++ )
	{
		if( CSLDataArray_GetFloat(oObj, sName, iN) == fValue ){ return iN; }
	}
	return -1;
}


/**  
* Find the first occurence of sValue, return -1 if not found
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayFind
* @return  element row number
*/
int CSLDataArray_FindString(object oObj, string sName, string sValue)
{
	int iN;
	int iL = CSLDataArray_LengthString(oObj, sName);
	for( iN = 0; iN < iL; iN++ )
	{
		if( CSLDataArray_GetString(oObj, sName, iN) == sValue ){ return iN; }
	}
	return -1;
}


/**  
* Find the first occurence of oValue, return -1 if not found
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayFind
* @return  element row number
*/
int CSLDataArray_FindObject(object oObj, string sName, object oValue)
{
	int iN;	
	int iL = CSLDataArray_LengthObject(oObj, sName);
	for( iN = 0; iN < iL; iN++ )
	{
		if( CSLDataArray_GetObject(oObj, sName, iN) == oValue ){ return iN; }
	}
	return -1;
}



/**  
* Find the first occurence of lValue, return -1 if not found
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayFind
* @return element row number
*/
int CSLDataArray_FindLocation(object oObj, string sName, location lValue)
{
	int iN;	
	int iL = CSLDataArray_LengthLocation(oObj, sName);
	for( iN = 0; iN < iL; iN++ )
	{
		if( CSLDataArray_GetLocation(oObj, sName, iN) == lValue ){ return iN; }
	}
	return -1;
}







/**  
* Inserts an element at iN, moving existing and later elements up one
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayInsert
* @return 
*/
void CSLDataArray_InsertInt(object oObj, string sName, int iN, int iValue)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iN, 1);
	SetLocalInt(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_INTEGER, iN), iValue);
}



/**  
* Inserts an element at iN, moving existing and later elements up one
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayInsert
* @return 
*/
void CSLDataArray_InsertFloat(object oObj, string sName, int iN, float fValue)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_FLOAT, iN, 1);
	SetLocalFloat(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_FLOAT, iN), fValue);
}

/**  
* Inserts an element at iN, moving existing and later elements up one
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayInsert
* @return 
*/
void CSLDataArray_InsertString(object oObj, string sName, int iN, string sValue)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_STRING, iN, 1);
	SetLocalString(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_STRING, iN), sValue);
}


/**  
* Inserts an element at iN, moving existing and later elements up one
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayInsert
* @return 
*/
void CSLDataArray_InsertObject(object oObj, string sName, int iN, object oValue)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_OBJECT, iN, 1);
	SetLocalObject(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_OBJECT, iN), oValue);
}




/**  
* Inserts an element at iN, moving existing and later elements up one
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayInsert
* @return 
*/
void CSLDataArray_InsertLocation(object oObj, string sName, int iN, location lValue)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_LOCATION, iN, 1);
	SetLocalLocation(oObj, CSLDataArray_GetElementName(sName, CSLDATAARRAY_TYPE_LOCATION, iN), lValue);
}


/**  
* Removes the element at iN
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayRemove
* @return 
*/
void CSLDataArray_RemoveInt(object oObj, string sName, int iN)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_INTEGER, iN, -1);
}


/**  
* Removes the element at iN
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayRemove
* @return 
*/
void CSLDataArray_RemoveFloat(object oObj, string sName, int iN)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_FLOAT, iN, -1);
}



/**  
* Removes the element at iN
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayRemove
* @return 
*/
void CSLDataArray_RemoveString(object oObj, string sName, int iN)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_STRING, iN, -1);
}





/**  
* Removes the element at iN
* Destroy the Object the element is pointing to if iDestroy
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayRemove
* @return 
*/
void CSLDataArray_RemoveObject(object oObj, string sName, int iN, int iDestroy=FALSE)
{
	if( iDestroy )
	{
		object oTrg = CSLDataArray_GetObject(oObj, sName, iN);
		//CSLMyDebug("Destroy "+GetTag(oTrg));
		DestroyObject(oTrg);
	}
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_OBJECT, iN, -1);
}

/**  
* Removes the element at iN
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayRemove
* @return 
*/
void CSLDataArray_RemoveLocation(object oObj, string sName, int iN)
{
	CSLDataArray_Shift(oObj, sName, CSLDATAARRAY_TYPE_LOCATION, iN, -1);
}

/**  
* Deletes the whole Array account
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayDelete XXXarray_delete
* @return 
*/
void CSLDataArray_DeleteEntire(object oObj, string sName)
{
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_STRING);
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_LOCATION);
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_INTEGER);
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_FLOAT);
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_OBJECT); // note does not destroy objects
}


/**  
* Deletes the whole Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayDelete
* @return 
*/
void CSLDataArray_DeleteInt(object oObj, string sName)
{
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_INTEGER);
}

/**  
* Deletes the whole Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayDelete
* @return 
*/
void CSLDataArray_DeleteFloat(object oObj, string sName)
{
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_FLOAT);
}


/**  
* Deletes the whole Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayDelete
* @return 
*/
void CSLDataArray_DeleteString(object oObj, string sName)
{
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_STRING);
}

/**  
* Deletes the whole Array
* Destroy the Objects the elements are pointing to if iDestroy
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayDelete
* @return 
*/
void CSLDataArray_DeleteObject(object oObj, string sName, int iDestroy=FALSE)
{
	if( iDestroy )
	{
		int iN;
		int iL = CSLDataArray_LengthObject(oObj, sName);
		for( iN = 0; iN < iL; iN++ )
		{
			object oTrg = CSLDataArray_GetObject(oObj, sName, iN);
			//CSLMyDebug("Destroy "+GetTag(oTrg));
			DestroyObject(oTrg);
		}
	}
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_OBJECT);
}

/**  
* Deletes the whole Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayDelete
* @return 
*/
void CSLDataArray_DeleteLocation(object oObj, string sName)
{
	CSLDataArray_Delete(oObj, sName, CSLDATAARRAY_TYPE_LOCATION);
}



/**  
* Prints the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXIntArrayPrint
* @return 
*/
void CSLDataArray_PrintInt(object oObj, string sName)
{
	CSLDataArray_Print(oObj, sName, CSLDATAARRAY_TYPE_INTEGER);
}


/**  
* Prints the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXFloatArrayPrint
* @return 
*/
void CSLDataArray_PrintFloat(object oObj, string sName)
{
	CSLDataArray_Print(oObj, sName, CSLDATAARRAY_TYPE_FLOAT);
}


/**  
* Prints the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXStringArrayPrint
* @return 
*/
void CSLDataArray_PrintString(object oObj, string sName)
{
	CSLDataArray_Print(oObj, sName, CSLDATAARRAY_TYPE_STRING);
}


/**  
* Prints the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXObjectArrayPrint
* @return 
*/
void CSLDataArray_PrintObject(object oObj, string sName)
{
	CSLDataArray_Print(oObj, sName, CSLDATAARRAY_TYPE_OBJECT);
}

/**  
* Prints the Array
* @author Nytir
* @param 
* @see 
* @replaces XXXXLocationArrayPrint
* @return 
*/
void CSLDataArray_PrintLocation(object oObj, string sName)
{
	CSLDataArray_Print(oObj, sName, CSLDATAARRAY_TYPE_LOCATION);
}