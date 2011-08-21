/** @file
* @brief Object and Variables on object functions, CSLDataTable, CSLDataArray and functions for moving variables between objects
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/*! @page CSLDataTableDocs 
* @title CSLDataTable Library Documentation
Array Data Objects, Persistent Storage on objects.
Also deals with issues of 2da Integration Methods.

CSLDataTable

A way of caching an entire set of 2da's in an organized manner, on separate objects so no single object gets overwhelmed, then accessing by index to prevent a lookup. Keeps cache entirely off of module object.

Lot of array features. Designed for larger data sets but not really for searching - the code calling it just needs what is in spellid 23.

Can access by row number from the 2da ( ie spellid 5 will return the correct spell ) or it can be used to iterate all the spells from first to last. The actual data can be preorganized in sorting so this ends up being alphabetical.

Requires the configuration rows be set prior to loading any data or it won't be able to access things properly by index.

Stores the actual objects in a single placeable container as seperate items, which are easy to retrieve, and a reference to them is put on the module. Since items can be save to a mysql, sqlite or bioware DB, this allows the intensive loading routine to be cached after first entry.

For example for spells -

I iterate the spells.2da on module load in small chunks until it's built up the entire list.
Innate Spells Object has all of them, but only real spells
Cleric Spells Object has just the cleric spells, and so forth for each class
Custom Spell books also have spells on them, this can be used in GUI callbacks to remove items from the UI.

Then i save this to the database as an object, or i save all the values to a database. This depends on the PW and if they have NWNX, everything should work in single player though.

For visual effects and appearance, it likewise iterates the entire 2da, in chunks of about 50 rows, and slowly builds up what is needed, the last row loaded helps deal with players when it's not loaded yet. Custom wrapper functions around data objects.

Create the object
/code
object oInnateSpells = CSLDataObjectGet( "InnateSpells", TRUE );
CSLDataTableConfigure( oInnateSpells, "string:SpellName", "int:innatelevel" )
CSLDataTable2daLoad( oInnateSpells, "spells", 25, 12.0f ); // object ref, 2da name, number to load per pass, interval between passes
string sInnateLevel = CSLDataObjectGetById( oInnateSpells, "innatelevel", SPELL_BANE ); // defaults to string gets, data is always stored as correct type via coercian, but allows simple setting and getting since source data is a string usually
string iInnateLevel = CSLDataObjectGetIntById( oInnateSpells, "innatelevel", SPELL_BANE );
/endcode
The appearance object has a working sort, it's input via delimited list to support sorting of visual effects later by prefix
/code
object oAppearanceTable = CSLDataObjectGet( "appearance", TRUE );
CSLDataTableConfigure( oAppearanceTable, "appearance", "LABEL,PREFATCKDIST", "", ",", "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" );
DelayCommand( CSLRandomBetweenFloat( 0.15f, 24.0f ), CSLDataTableLoad2da( oAppearanceTable ) );
/endcode
Push and pop functions work the same way, add in a random pop as well to randomly get a row, retrievals return entire rows data in a string which is delmited )
/code
int CSLDataTablePush( oInnateSpells, SPELL_LEVITATION, "Levitation", "3"); object ref, int desiredid, string fields in a comma separated list ( as strings only ) returns false if id is in use already
string CSLDataTablePop( string delimiter); // returns "Levitation,3" and deletes it completely from the 2da
/endcode

This is used in the module load event to put a lot of work into the first 1-2 minutes of the server loading, which is ok for a PW that does not reboot that often, and also does not seem to affect performance as much as i'd really expect
/code
// first create and configure objects
object oAppearanceTable = CSLDataObjectGet( "Appearance" );
CSLDataTableConfigure( oAppearanceTable, "Appearance", "LABEL,PREFATCKDIST" );

object oAppearanceTable = CSLDataObjectGet( "maneuvers" );
CSLDataTableConfigure( oAppearanceTable, "maneuvers", "Script,ICON,StrRef,Description" );

object oAppearanceTable = CSLDataObjectGet( "baseitems" );
CSLDataTableConfigure( oAppearanceTable, "baseitems", "PrefAttackDist,NumDice,DieToRoll,CritThreat,CritHitMult,FEATImprCrit,FEATWpnFocus,FEATWpnSpec,FEATEpicDevCrit,FEATEpicWpnFocus,FEATEpicWpnSpec,FEATOverWhCrit,FEATWpnOfChoice,FEATGrtrWpnFocus,FEATGrtrWpnSpec,FEATPowerCrit" );

object oAppearanceTable = CSLDataObjectGet( "iprp_feats" );
CSLDataTableConfigure( oAppearanceTable, "iprp_feats", "Label,FeatIndex" );

object oAppearanceTable = CSLDataObjectGet( "ambientsound" );
CSLDataTableConfigure( oAppearanceTable, "ambientsound", "Description,Resource" );

object oAppearanceTable = CSLDataObjectGet( "ambientmusic" );
CSLDataTableConfigure( oAppearanceTable, "ambientmusic", "Description" );

object oAppearanceTable = CSLDataObjectGet( "visualeffects" );
CSLDataTableConfigure( oAppearanceTable, "visualeffects", "Label" );
/endcode

Then repeat with delayed commands and in a loop this to load it, this is a one time deal and the object can be even stored. This is repeated for each object.
/code
CSLDataTableLoadSingleRowFrom2da( oAppearanceTable, iRow );
/endcode

Now you can retrieve it as needed later on
/code
object oAppearanceTable = CSLDataObjectGet( "Appearance" );
string sString = CSLDataTableGetStringByRow( oAppearanceTable, "PREFATCKDIST", 23 )

// or if you want to list all the items in the object use this which also will pull data from the 2da if it's in mid load
int iRow = CSLDataTableGetRowByIndex( oAppearanceTable, 5 );
string sString = CSLDataTableGetStringByRow( oAppearanceTable, "LABEL", iRow )
/code

You can also look at /ref CSLGetSpellDataObject and /ref CSLGetSpellDataName for example implementation with a wrapper, note the oSpellTable is declared in global scope so it only has to retrieve it once per script
You would use this in a thing like the DMFI which lists items 1-30 available in appearance, so the end user could then click on them and change his appearance. Also would be useful for custom spell books.

Note that the above features should be used in moderation and testing, sorting is intensive operation and the index feature should only be used on very small 2da's. It also is intended to work without a database, but that can be hooked up to dataobjects instead of 2da's for better performance and removing the need for sorting.

*/


/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

const int VARIABLE_INVALID_INDEX			= -1;

// Data type
const int CSLDATAARRAY_CYCLE = -2; 
const int CSLDATAARRAY_LENGTH = -1; 
const int CSLDATAARRAY_TYPE_INTEGER = 0;  //Int
const int CSLDATAARRAY_TYPE_FLOAT = 1;  //Float
const int CSLDATAARRAY_TYPE_STRING = 2;  //String
const int CSLDATAARRAY_TYPE_OBJECT = 3;  //Object
const int CSLDATAARRAY_TYPE_LOCATION = 4;  //Location

const string CSL_DATASTORE = "CSL_DATASTORE";

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
//#include "_CSLCore_Messages"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////


object CSLDataObjectGet( string sDataTableName, int iAutoCreate = FALSE );

void CSLGetPreferenceDataObject();
//string CSLGetPreferenceString( string sPreferenceName, string sDefaultValue = "" );
int CSLGetPreferenceInteger( string sPreferenceName, int iDefaultValue = 0 );
//int CSLGetPreferenceSwitch( string sPreferenceName, int bDefaultValue = FALSE);

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


string CSLVarIndex_Prefix( int iType = CSLDATAARRAY_TYPE_INTEGER )
{
	switch(iType)
	{
		case CSLDATAARRAY_TYPE_INTEGER: 
			return "CSLVARINDEX_I_";
			break;
		case CSLDATAARRAY_TYPE_FLOAT: 
			return "CSLVARINDEX_F_";
			break;
		case CSLDATAARRAY_TYPE_STRING: 
			return "CSLVARINDEX_S_";
			break;
		case CSLDATAARRAY_TYPE_OBJECT: 
			return "CSLVARINDEX_O_";
			break;
		case CSLDATAARRAY_TYPE_LOCATION: 
			return "CSLVARINDEX_L_";
			break;
	}
	return "CSLVARINDEX_X_"; // invalid
}


int CSLVarIndex_Count( object oObject, int iType = CSLDATAARRAY_TYPE_INTEGER )
{
	return GetLocalInt(oObject, CSLVarIndex_Prefix( iType )+"COUNT");
}


string CSLVarIndex_VarNameByIndex( object oObject, int iIndex, int iType = CSLDATAARRAY_TYPE_INTEGER )
{
	int iCount = CSLVarIndex_Count(oObject,iType );
	if ( iIndex <= iCount )
	{
		return GetLocalString( oObject, CSLVarIndex_Prefix( iType )+IntToString( iIndex ) );
	}
	return "";
}


// this is for working with random pieces of data, initially designed for integers only
// this is one based, 1 to whatever ( 0 does not exist )
void CSLVarIndex_Register( object oObject, string sVariableName, int iType = CSLDATAARRAY_TYPE_INTEGER )
{
	string sPrefix = CSLVarIndex_Prefix( iType );
	
	int iFound = FindSubString( sVariableName, GetLocalString(oObject, sPrefix+"REGISTERED" ) );
	if ( iFound == -1 )
	{
		int iCount = CSLVarIndex_Count(oObject,iType )+1;
		string sList = CSLNth_Push( GetLocalString(oObject, sPrefix+"REGISTERED"), sVariableName );
		SetLocalString(oObject, sPrefix+"REGISTERED", sList);
		
		SetLocalString( oObject, sPrefix+IntToString(iCount), sVariableName );	
		
		SetLocalInt(oObject, sPrefix+"COUNT", iCount );
	}
}


void CSLVarIndex_UnRegister( object oObject, string sVariableName, int iType = CSLDATAARRAY_TYPE_INTEGER )
{
	string sPrefix = CSLVarIndex_Prefix( iType );
	string sList = GetLocalString(oObject, sPrefix+"REGISTERED" );
	int iFound = FindSubString( sVariableName, sList );
	
	
	if ( iFound != -1 )
	{
		int iCount = CSLVarIndex_Count(oObject,iType );
		int bFound = FALSE;
		int iCurrent;
		for( iCurrent = 1; iCurrent <= iCount; iCurrent++)
		{
			if ( bFound || CSLVarIndex_VarNameByIndex( oObject, iCurrent, iType ) == sVariableName )
			{
				SetLocalString( oObject, "CSLVARINDEX_I_"+IntToString( iCurrent ), "CSLVARINDEX_I_"+IntToString( iCurrent+1 ) );
				bFound == TRUE;
			}
		}
		
		int iOccurance = CSLNth_Find( sList, sVariableName );
		if ( iOccurance > 0 )
		{
			sList = CSLNth_RemoveElement(sList, iOccurance );
			SetLocalString(oObject, sPrefix+"REGISTERED", sList);
		}
		SetLocalInt(oObject, sPrefix+"COUNT", iCount-1 );
	}
}



// returns true if 2 values need to be swapped
int CSLVarIndex_Compare( object oObject, int iIndex1, int iIndex2, int iType = CSLDATAARRAY_TYPE_INTEGER )
{
	int iCount = CSLVarIndex_Count(oObject,iType );
	if ( iIndex2 > iCount ||  iIndex2 <= iIndex1 )
	{
		return FALSE;
	}
	
	string sPrefix = CSLVarIndex_Prefix( iType );
	
	string sPreviousVar = sPrefix+IntToString( iIndex1 );
	string sCurrentVar = sPrefix+IntToString( iIndex2 );
	
	
	
	if ( iType == CSLDATAARRAY_TYPE_INTEGER )
	{
		int iPrevious = GetLocalInt( oObject, GetLocalString( oObject, sPreviousVar ) );
		int iCurrent = GetLocalInt( oObject, GetLocalString( oObject, sCurrentVar ) );
		if ( iPrevious < iCurrent )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	else if ( iType == CSLDATAARRAY_TYPE_FLOAT )
	{ 
		float fPrevious = GetLocalFloat( oObject, GetLocalString( oObject, sPreviousVar ) );
		float fCurrent = GetLocalFloat( oObject, GetLocalString( oObject, sCurrentVar ) );
		if ( fPrevious < fCurrent )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}			
	}
	else if ( iType == CSLDATAARRAY_TYPE_STRING )
	{
		string sPrevious = GetLocalString( oObject, GetLocalString( oObject, sPreviousVar ) );
		string sCurrent = GetLocalString( oObject, GetLocalString( oObject, sCurrentVar ) );
		if ( StringCompare( sPrevious,sCurrent, FALSE ) > 0 )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}	
	}
	/*
	else if ( iType == CSLDATAARRAY_TYPE_OBJECT )
	{
		return FALSE;		
	}
	else if ( iType == CSLDATAARRAY_TYPE_LOCATION )
	{
		return FALSE;
	}
	*/
	
	return FALSE;
}



void CSLVarIndex_Sort( object oObject, int iType = CSLDATAARRAY_TYPE_INTEGER )
{
	int iCount = CSLVarIndex_Count(oObject,iType );
	if ( iCount < 2 )
	{
		return;
	} 
	int iCurrent, iPrevious;
	string sCurrent, sPrevious;
	int bSwappedValue = FALSE;
	string sPrefix = CSLVarIndex_Prefix( iType );
	
	for( iCurrent = 2; iCurrent <= iCount; iCurrent++)
	{
		if ( CSLVarIndex_Compare(oObject,iCurrent-1, iCurrent, iType) )
		{
			SetLocalString( oObject, sPrefix+IntToString( iCurrent-1 ), CSLVarIndex_VarNameByIndex( oObject, iCurrent, iType ) );
			SetLocalString( oObject, sPrefix+IntToString( iCurrent ), CSLVarIndex_VarNameByIndex( oObject, iCurrent-1, iType ) );
			bSwappedValue = TRUE;
		}
	}
	if ( bSwappedValue )
	{
		CSLVarIndex_Sort( oObject, iType );
	}
}





string CSLPrintVariables( object oTarget )
{
	string sMessage = "";
	int count = GetVariableCount(oTarget);
	if ( count > 0)
	{
		int x;
		for (x = 0; x < count; x++)
		{
		
			sMessage += GetVariableName(oTarget, x);
			int iType = GetVariableType(oTarget, x);
			if ( iType == VARIABLE_TYPE_DWORD )
			{
				object oCurrent = GetVariableValueObject( oTarget, x );
				sMessage += ":Object:"+ObjectToString(oCurrent)+":"+GetName(oCurrent);
			}
			else if ( iType == VARIABLE_TYPE_INT )
			{
				sMessage += ":Integer:"+IntToString(GetVariableValueInt( oTarget, x ));
			}
			else if ( iType == VARIABLE_TYPE_FLOAT )
			{
				sMessage += ":Float:"+CSLFormatFloat(GetVariableValueFloat( oTarget, x ),3);
			}
			else if ( iType == VARIABLE_TYPE_STRING )
			{
				sMessage += ":String:"+GetVariableValueString( oTarget, x );
			}
			else if ( iType == VARIABLE_TYPE_LOCATION )
			{
				location lLocation = GetVariableValueLocation( oTarget, x );
				object oArea = GetAreaFromLocation(lLocation);
				sMessage += ":Location:";
				if (GetIsObjectValid(oArea))
				{
					vector vPosition = GetPositionFromLocation(lLocation);
					float fOrientation = GetFacingFromLocation(lLocation);
					sMessage += "Area:" + GetTag(oArea) + " X:" + FloatToString(vPosition.x) + " Y:" + FloatToString(vPosition.y) + " Z:" + FloatToString(vPosition.z) + " Facing:" + FloatToString(fOrientation);
				}
				else
				{
					sMessage += "Invalid";
            	}
			}
			sMessage += "\n";
		}
	}
	return sMessage;
}


/**  
* Reverse lookup to get the current index of a given variable name
* @author
* @param 
* @see 
* @return 
*/
// Ritorna VARIABLE_INVALID_INDEX le la variabile non è presente su oTarget
// written by caos as part of dm inventory system, integrating
int CSLGetVariableIndex (object oTarget, string sVarName, int VarType) {

	int iVarIndex = 0;
	int iVariableType = GetVariableType(oTarget, iVarIndex);
		
	while (iVariableType != VARIABLE_TYPE_NONE) {
	
		if (GetVariableName(oTarget, iVarIndex) == sVarName
			&& iVariableType == VarType) {
			return iVarIndex;
		}

		iVariableType = GetVariableType(oTarget, ++iVarIndex);
	}
	
	return VARIABLE_INVALID_INDEX;
}


/**  
* Copy local variables from oSource to oTarget, optional sStartsWith parameter limits to those variables that start with the given string
* @author
* @param 
* @see 
* @return 
*/
void CSLCopyLocalVariables(object oSource, object oTarget, string sStartsWith = "")
{
    int iCount = GetVariableCount( oSource );
    int iIndex;
    
    string sNameOfVariable;
    
    for (iIndex = 0; iIndex < iCount; iIndex++) 
	{
		sNameOfVariable = GetVariableName(oSource, iIndex);
		if ( sStartsWith == "" || GetStringLeft(sNameOfVariable, GetStringLength(sStartsWith))==sStartsWith )
		{
			switch( GetVariableType(oSource, iIndex) )
			{
				case VARIABLE_TYPE_INT: 
					SetLocalInt(oTarget, sNameOfVariable, GetLocalInt(oSource, sNameOfVariable));
					break;
				case VARIABLE_TYPE_STRING: 
					SetLocalString(oTarget, sNameOfVariable, GetLocalString(oSource, sNameOfVariable));
					break;
				case VARIABLE_TYPE_DWORD: 
					SetLocalObject(oTarget, sNameOfVariable, GetLocalObject(oSource, sNameOfVariable));
					break;
				case VARIABLE_TYPE_FLOAT: 
					SetLocalFloat(oTarget, sNameOfVariable, GetLocalFloat(oSource, sNameOfVariable));
					break;
				case VARIABLE_TYPE_LOCATION:
					 SetLocalLocation(oTarget, sNameOfVariable, GetLocalLocation(oSource, sNameOfVariable));
					 break;
			}
        }
    }
}


/**  
* Move local variables from oSource to oTarget, optional sStartsWith parameter limits to those variables that start with the given string
* @author
* @param 
* @see 
* @return 
*/
void CSLMoveLocalVariables(object oSource, object oTarget, string sStartsWith = "")
{
    int iCount = GetVariableCount( oSource );
    int iIndex;
    
    string sNameOfVariable;
    
    for (iIndex = 0; iIndex < iCount; iIndex++) 
	{
		sNameOfVariable = GetVariableName(oSource, iIndex);
		if ( sStartsWith == "" || GetStringLeft(sNameOfVariable, GetStringLength(sStartsWith))==sStartsWith )
		{
			switch( GetVariableType(oSource, iIndex) )
			{
				case VARIABLE_TYPE_INT: 
					SetLocalInt(oTarget, sNameOfVariable, GetLocalInt(oSource, sNameOfVariable));
					DeleteLocalInt(oSource, sNameOfVariable);
					break;
				case VARIABLE_TYPE_STRING: 
					SetLocalString(oTarget, sNameOfVariable, GetLocalString(oSource, sNameOfVariable));
					DeleteLocalString(oSource, sNameOfVariable);
					break;
				case VARIABLE_TYPE_DWORD: 
					SetLocalObject(oTarget, sNameOfVariable, GetLocalObject(oSource, sNameOfVariable));
					DeleteLocalObject(oSource, sNameOfVariable);
					break;
				case VARIABLE_TYPE_FLOAT: 
					SetLocalFloat(oTarget, sNameOfVariable, GetLocalFloat(oSource, sNameOfVariable));
					DeleteLocalFloat(oSource, sNameOfVariable);
					break;
				case VARIABLE_TYPE_LOCATION:
					SetLocalLocation(oTarget, sNameOfVariable, GetLocalLocation(oSource, sNameOfVariable));
					DeleteLocalLocation(oSource, sNameOfVariable);
					break;
			}
        }
    }
}



/**  
* Deletes all the variables on an object, optional sStartsWith parameter limits to those variables that start with the given string
* @author
* @param 
* @see 
* @return 
*/
void CSLDeleteLocalVariables( object oTarget, string sStartsWith = "" )
{
	int iCount = GetVariableCount( oTarget );
    int iIndex;
    
    string sNameOfVariable;
    
    for (iIndex = 0; iIndex < iCount; iIndex++) 
	{
        sNameOfVariable = GetVariableName(oTarget, iIndex);
        if ( sStartsWith == "" || GetStringLeft(sNameOfVariable, GetStringLength(sStartsWith))==sStartsWith )
        {
			switch( GetVariableType(oTarget, iIndex) )
			{
				case VARIABLE_TYPE_INT: 
					DeleteLocalInt(oTarget, sNameOfVariable);
					break;
				case VARIABLE_TYPE_STRING: 
					DeleteLocalString(oTarget, sNameOfVariable);
					break;
				case VARIABLE_TYPE_DWORD: 
					DeleteLocalObject(oTarget, sNameOfVariable);
					break;
				case VARIABLE_TYPE_FLOAT: 
					DeleteLocalFloat(oTarget, sNameOfVariable);
					break;
				case VARIABLE_TYPE_LOCATION:
					DeleteLocalLocation(oTarget, sNameOfVariable);
					break;
			}
        }
    }
}


/**  
* @author
* @param 
* @see 
* @return 
*/
object CSLCoreDataPointGet( )
{
	object oModule = GetModule();
	object oCoreDataPoint = GetLocalObject( oModule, "CSL_COREDATAPOINT" );
	if( !GetIsObjectValid(oCoreDataPoint) )
	{
		// 
		location lBackstagePoint;
		object oBackStagePoint = GetWaypointByTag("WP_Backstage");
		if( GetIsObjectValid(oBackStagePoint) )
		{
			lBackstagePoint = GetLocation(oBackStagePoint);
		}
		else
		{
			lBackstagePoint = GetStartingLocation();
		}
			// GetWaypointByTag GetObjectByTag
		oCoreDataPoint = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", lBackstagePoint, FALSE, "CSL_COREDATAPOINT"); 
		if( !GetIsObjectValid(oCoreDataPoint) )
		{
			SendMessageToPC( GetFirstPC(), "CSL_COREDATAPOINT could not be created" );
		}
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oCoreDataPoint, TRUE);
		//SetEventHandler(oCoreDataPoint, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_ENVIRO_HEARTBEAT_SCRIPT);
		SetLocalObject(oModule, "CSL_COREDATAPOINT", oCoreDataPoint);
		
		SetFirstName(oCoreDataPoint, "CoreDataPoint");
		SetLastName(oCoreDataPoint, "");
	}
	return oCoreDataPoint;
}


/**  
* @author
* @param 
* @see CSLDataTableDocs
* @return 
*/
// int StoreCampaignObject(string sCampaignName, string sVarName, object oObject, object oPlayer=OBJECT_INVALID);
//object RetrieveCampaignObject(string sCampaignName, string sVarName, location locLocation, object oOwner = OBJECT_INVALID, object oPlayer=OBJECT_INVALID);
void CSLDataObjectStore( string sDataTableName )
{
	object oDataTable = CSLDataObjectGet( sDataTableName );
	if ( GetIsObjectValid( oDataTable ) )
	{
		StoreCampaignObject( CSL_DATASTORE, "DATATABLE_"+GetStringUpperCase( sDataTableName ), oDataTable );
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * Removes a given object from the Database storage
void CSLDataObjectUnStore( string sDataTableName )
{
	DeleteCampaignVariable(CSL_DATASTORE, "DATATABLE_"+GetStringUpperCase( sDataTableName ) );
}



string CSLDataTableGetColumnType( object oDataTable, string sColumnName )
{
	int iColumn = GetLocalInt(oDataTable, "DATATABLE_FIELDROW_"+GetStringUpperCase(sColumnName) );
	if ( iColumn == 0 )
	{
		return "invalid";
	}
	return GetLocalString(oDataTable, "DATATABLE_FIELDTYPE_"+IntToString( iColumn ) );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
object CSLDataObjectGet( string sDataTableName, int iAutoCreate = FALSE )
{
	object oCoreDataPoint = CSLCoreDataPointGet();
	object oDataTable = GetLocalObject( oCoreDataPoint, "DATATABLE_"+GetStringUpperCase( sDataTableName ) );
	//object oDataTable = GetItemPossessedBy(oCoreDataPoint, "DATATABLE_"+GetStringUpperCase( sDataTableName ));
	
	//object oDataTable = GetWaypointByTag( "DATATABLE_"+GetStringUpperCase( sDataTableName ) ); // prefix the waypoint name to ensure i don't have conflicts
	if( !GetIsObjectValid(oDataTable) && iAutoCreate ) // does not exist, lets create it if that is set
	{
		//SendMessageToPC( GetFirstPC(), "Creating "+"DATATABLE_"+GetStringUpperCase( sDataTableName ));
		// SendMessageToPC( GetFirstPC(), "Loading module data now...");
		if (DEBUGGING >= 8) { SendMessageToPC(GetFirstPC(), "Creating object "+sDataTableName ); }
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		//if (DEBUGGING >= 8) { CSLDebug("CSLEnviroGetControl creating heartbeat object", GetFirstPC() ); }
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		// oDataTable = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation( oCoreDataPoint ), FALSE, "DATATABLE_"+GetStringUpperCase( sDataTableName ) ); 
		oDataTable = CreateItemOnObject("csldataobject", oCoreDataPoint, 1, "DATATABLE_"+GetStringUpperCase( sDataTableName ), FALSE);
		
		if ( !GetIsObjectValid(oDataTable ) )
		{
			SendMessageToPC( GetFirstPC(), "Failed to Make "+"DATATABLE_"+GetStringUpperCase( sDataTableName )+" Due to invalid object.");
		}
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oDataTable, TRUE);
		// SetEventHandler(oSD, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_SUMMONS_HEARTBEAT_SCRIPT); re-enable this later
		SetLocalObject( oCoreDataPoint, "DATATABLE_"+GetStringUpperCase( sDataTableName ), oDataTable);
		
		SetFirstName(oDataTable, sDataTableName);
		
		SetLocalString(oDataTable, "DATATABLE_NAME", sDataTableName);
		
		// create 10 dummy variables, when i get an object count, it should then relate to the number of rows, these will store useful information about the object
		// This can vary for various reasons
		
		// data is stored by id number correlating to a 2da file
		// it also can be iterated by position, blank 2da rows are not imported

		//SetLastName(oSD, "DataTable");
	}
	return oDataTable;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// run this once up front, have a command to force a reload/check of the related 2da that can be done via chat command
int CSLDataTableCheck( string sDataTableName ) // quick check for existance, note that it is generally better to just get it, but this is a wrapper
{
	object oDataTable = GetWaypointByTag( "DATATABLE_"+GetStringUpperCase( sDataTableName ) ); // prefix the waypoint name to ensure i don't have conflicts
	if( !GetIsObjectValid(oDataTable) )
	{		
		return FALSE;
	}
	return TRUE;	
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLDataTableCount( object oDataTable ) // gets the total number of rows
{
	if( GetIsObjectValid(oDataTable) && GetLocalInt(oDataTable, "DATATABLE_CONFIGURED") )
	{		
		int iTotalFields = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
		int iStartingRow = GetLocalInt(oDataTable, "DATATABLE_STARTINGROW" );
		int iVariableCount = GetVariableCount( oDataTable );
		if ( iTotalFields > 0 )
		{
			return ( iVariableCount - ( iStartingRow - 1 ) ) / iTotalFields ;
		}
	}
	return -1;	
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLDataTableVersion( object oDataTable ) // gets the total number of rows
{
	if( GetIsObjectValid(oDataTable)  )
	{		
		return GetLocalInt(oDataTable, "DATATABLE_VERSION");
	}
	return -1;	
}

/**  
* Configures a data table
* @author
* @param 
* @param sOnLoadedScript Script to run after data is fully loaded AND all the data is fully sorted if it needs to be sorted.
* @see 
* @return 
*/
// * sets up the columns and datatypes for the DataTable, akin to create table
int CSLDataTableConfigure( object oDataTable, string s2daName, string sFields, string sFieldType = "", string sFieldDelimiter = ",", string sSortList = "", string sSortField = "", string sOnLoadedScript = "" ) // and so forth for how ever many possible fields
{
	if ( GetLocalInt(oDataTable, "DATATABLE_CONFIGURED" ) )
	{
		return FALSE;
	}
	
	// do configuration things here
	SetLocalInt(oDataTable, "DATATABLE_VERSION", CSLGetPreferenceInteger( "DataObjectVersion", -1 ) ); 
	SetLocalInt(oDataTable, "DATATABLE_CONFIGURED", TRUE ); 
	SetLocalInt(oDataTable, "DATATABLE_SERIAL", 0 );
	SetLocalString(oDataTable, "DATATABLE_SOURCEDATANAME", s2daName ); // 2
	if ( sOnLoadedScript != "" )
	{
		SetLocalString(oDataTable, "DATATABLE_ONLOADEDSCRIPT", sOnLoadedScript ); // 2
	}
	SetLocalInt(oDataTable, "DATATABLE_FULLYLOADED", FALSE ); //3 used in lazy load to indicate if its done or not
	SetLocalInt(oDataTable, "DATATABLE_FULLYSORTED", FALSE );
	//SetLocalInt(oDataTable, "DATATABLE_TOTALROWS", 0 ); //4
	SetLocalInt(oDataTable, "DATATABLE_LASTROWLOADED", -1 ); // this is the last active row in the 2da
	SetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED", -1 ); // this is the last row processed in the 2da
	SetLocalInt(oDataTable, "DATATABLE_CURRENTROW", -1 ); // Pointer to the current row
	SetLocalInt(oDataTable, "DATATABLE_CURRENTID", -1 ); //8 Pointer to the current id
	//SetLocalString(oDataTable, "DATATABLE_FIELDTYPES", "0" ); //9 string holding the data types in the fields
	
	
	int iPosition = 0;
	int iCurrentColumn = 0;
	string sCurrent;
	string sRest = sFields+sFieldDelimiter;
	
	iPosition = FindSubString( sRest, sFieldDelimiter );
	while ( iPosition != -1 )
	{
		sCurrent = GetStringLeft(sRest, iPosition );
		sRest = GetStringRight(sRest, GetStringLength(sRest)-(iPosition+1) );
		if ( sCurrent != "" && GetLocalInt(oDataTable, "DATATABLE_FIELDROW_"+GetStringUpperCase(sCurrent)) == 0 ) // second condition blocks duplicate column names 
		{
			iCurrentColumn++;
			SetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ), sCurrent );
			SetLocalInt(oDataTable, "DATATABLE_FIELDROW_"+GetStringUpperCase(sCurrent), iCurrentColumn );
			if ( iCurrentColumn == 1 )
			{
				SetLocalString(oDataTable, "DATATABLE_ROWNAMEFIELD", sCurrent );
				SetLocalString(oDataTable, "DATATABLE_ROWSORTFIELD", sCurrent ); // default so we always have one
				
			}
			if ( sSortField != "" && GetStringUpperCase(sSortField) == GetStringUpperCase(sCurrent) )
			{
				SetLocalString(oDataTable, "DATATABLE_ROWSORTFIELD", sCurrent );
			}
			
		}
		// now get the next set
		iPosition = FindSubString( sRest, sFieldDelimiter );
	}
	SetLocalInt(oDataTable, "DATATABLE_FIELDS", iCurrentColumn ); //6 This is used to determine where a variable should be, (numbervariables-10)/comlums is number of rows, usually it's a single variable

	// now deal with field types
	//iPosition = 0;
	iCurrentColumn = 0;
	//sCurrent = "";
	sRest = sFieldType+sFieldDelimiter;
	string sIndexField,sIndexField2,sIndexField3,sIndexField4, sResult = "";
	int bIndexFieldisResref,bIndexFieldisResref2,bIndexFieldisResref3,bIndexFieldisResref4 = FALSE;
	iPosition = FindSubString( sRest, sFieldDelimiter );
	while ( iPosition != -1 )
	{
		sCurrent = GetStringLeft(sRest, iPosition );
		sRest = GetStringRight(sRest, GetStringLength(sRest)-(iPosition+1) );
		if ( sCurrent != "" )
		{
			iCurrentColumn++;
			SetLocalString(oDataTable, "DATATABLE_FIELDTYPE_"+IntToString( iCurrentColumn ), GetStringLowerCase(sCurrent) );
			if ( GetStringLowerCase(sCurrent) == "index" )
			{
				if ( sIndexField == "" )
				{
					sIndexField = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
				}
				else if ( sIndexField2 == "" )
				{
					sIndexField2 = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
					//SendMessageToPC( GetFirstPC(), "Setting Index2 to "+sIndexField2+" ");
				}
				else if ( sIndexField3 == "" )
				{
					sIndexField3 = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
					//SendMessageToPC( GetFirstPC(), "Setting Index3 to "+sIndexField3+" ");
				}
				else if ( sIndexField4 == "" )
				{
					sIndexField4 = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
					//SendMessageToPC( GetFirstPC(), "Setting Index4 to "+sIndexField4+" ");
				}
				
			}
			else if ( GetStringLowerCase(sCurrent) == "indexref"  )
			{
				if ( sIndexField == "" )
				{
					sIndexField = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
					//SendMessageToPC( GetFirstPC(), "Setting Index to "+sIndexField+" ");
					bIndexFieldisResref = TRUE;
				}
				else if ( sIndexField2 == "" )
				{
					sIndexField2 = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
					//SendMessageToPC( GetFirstPC(), "Setting Index2 to "+sIndexField2+" ");
					bIndexFieldisResref2 = TRUE;
				}
				else if ( sIndexField3 == "" )
				{
					sIndexField3 = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
					bIndexFieldisResref3 = TRUE;
					//SendMessageToPC( GetFirstPC(), "Setting Index3 to "+sIndexField3+" ");
				}
				else if ( sIndexField4 == "" )
				{
					sIndexField4 = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( iCurrentColumn ) );
					//SendMessageToPC( GetFirstPC(), "Setting Index4 to "+sIndexField4+" ");
					bIndexFieldisResref4 = TRUE;
				}
			}
		}
		// now get the next set
		iPosition = FindSubString( sRest, sFieldDelimiter );
	}
	
	// note only a small 2da will use the index parameter, soas to prevent timeout, this lets it do a lookup prior to loading the actual 2da of a single column
	if ( sIndexField != "" )
	{
		//SendMessageToPC( GetFirstPC(), "Indexing on "+sIndexField );
		int iRow;
		string sString;
		int iMaxRows = GetNum2DARows( s2daName );
		for (iRow = 0; iRow <= iMaxRows; iRow++) 
		{
			sString = Get2DAString(s2daName, sIndexField, iRow  );
			//SendMessageToPC( GetFirstPC(), IntToString(iRow)+" gives me "+sString );
			if ( sString != "" )
			{
				// is it an integer
				if ( bIndexFieldisResref == TRUE && IntToString( StringToInt(sString) ) == sString )
				{
					sResult=GetStringByStrRef(StringToInt(sString));
					if ( sResult != "" )
					{
						sString = sResult;
					}
				}
				
				SetLocalString(oDataTable, "INDEX_"+GetStringUpperCase( sString ), IntToString(iRow) );
			}
			
			if (sIndexField2 != "")
			{
				sString = Get2DAString(s2daName, sIndexField2, iRow  );
				//SendMessageToPC( GetFirstPC(), IntToString(iRow)+" gives me "+sString );
				if ( sString != "" )
				{
					// is it an integer
					if ( bIndexFieldisResref2 == TRUE && IntToString( StringToInt(sString) ) == sString )
					{
						sResult=GetStringByStrRef(StringToInt(sString));
						if ( sResult != "" )
						{
							sString = sResult;
						}
					}
					
					SetLocalString(oDataTable, "INDEX_"+GetStringUpperCase( sString ), IntToString(iRow) );
				}
				if (sIndexField3 != "")
				{
					sString = Get2DAString(s2daName, sIndexField3, iRow  );
					//SendMessageToPC( GetFirstPC(), IntToString(iRow)+" gives me "+sString );
					if ( sString != "" )
					{
						// is it an integer
						if ( bIndexFieldisResref3 == TRUE && IntToString( StringToInt(sString) ) == sString )
						{
							sResult=GetStringByStrRef(StringToInt(sString));
							if ( sResult != "" )
							{
								sString = sResult;
							}
						}
						
						SetLocalString(oDataTable, "INDEX_"+GetStringUpperCase( sString ), IntToString(iRow) );
					}
					if (sIndexField4 != "")
					{
						sString = Get2DAString(s2daName, sIndexField4, iRow  );
						//SendMessageToPC( GetFirstPC(), IntToString(iRow)+" gives me "+sString );
						if ( sString != "" )
						{
							// is it an integer
							if ( bIndexFieldisResref4 == TRUE && IntToString( StringToInt(sString) ) == sString )
							{
								sResult=GetStringByStrRef(StringToInt(sString));
								if ( sResult != "" )
								{
									sString = sResult;
								}
							}
							
							SetLocalString(oDataTable, "INDEX_"+GetStringUpperCase( sString ), IntToString(iRow) );
						}
					}
				}
			}
		}
	}
	
	//SendMessageToPC( GetFirstPC(), "sSortList="+sSortList );
	if ( sSortList != "" )
	{
		//SendMessageToPC( GetFirstPC(), "Presorting "+sSortList );
		SetLocalString(oDataTable, "DATATABLE_SORTLIST", sSortList );
		if ( sSortList == "alphabetical" )
		{
			sSortList = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,~";
		}
		
		sSortList = GetStringUpperCase( sSortList )+sFieldDelimiter; // make it all uppercase so i only have to make it capitalized just this once
		iPosition = FindSubString( sSortList, sFieldDelimiter );
		while ( iPosition != -1 )
		{
			sCurrent = GetStringLeft(sSortList, iPosition );
			sSortList = GetStringRight(sSortList, GetStringLength(sSortList)-(iPosition+1) );
			if ( sCurrent != "" )
			{
				// SendMessageToPC( GetFirstPC(), "Presorting "+sCurrent );
				SetLocalInt(oDataTable, "DATATABLE_SORTSTART_"+sCurrent, -1 );
				SetLocalInt(oDataTable, "DATATABLE_SORTQUANTITY_"+sCurrent, -1 );
			}
			// now get the next set
			iPosition = FindSubString( sSortList, sFieldDelimiter );
		}
	}
	
	SetLocalInt(oDataTable, "DATATABLE_STARTINGROW", GetVariableCount( oDataTable )+1 ); // 0 // is this zero based ???

	return TRUE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLDataObjectGetIsLoaded(object oDataTable)
{
	return GetLocalInt(oDataTable, "DATATABLE_FULLYLOADED" );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLDataObjectGetIsSorted(object oDataTable)
{
	return GetLocalInt(oDataTable, "DATATABLE_FULLYSORTED" );
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// * this function deletes all items in a given row, but recreates the given row effectively sorting it's physical location
void CSLDataTableMoveRowToEnd2da( object oDataTable, int iRow )
{
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	int x;
	string sColumnName;
	string sFieldName;
	string sValue;
	
	for (x = 1; x <= iTotalColumns; x++) 
	{
		sColumnName = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( x ) );
		sFieldName = "D_"+IntToString( iRow )+"_"+GetStringUpperCase(sColumnName);
		sValue = GetLocalString(oDataTable, sFieldName );
		DeleteLocalString( oDataTable, sFieldName );
		SetLocalString(oDataTable, sFieldName, sValue);
	}
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLDataTableLoadSingleRowFrom2da( object oDataTable, int iRow )
{
	string s2daName = GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" );
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	int x;
	string sColumnName;
	string sColumnType;
	string sString;
	string sResult;
	string sStringLower;
	
	if ( iRow > GetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED" ) )
	{
		SetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED", iRow );
	}
	
	for (x = 1; x <= iTotalColumns; x++) 
	{
		sColumnName = GetLocalString(oDataTable, "DATATABLE_FIELDNAME_"+IntToString( x ) );
		sColumnType = GetLocalString(oDataTable, "DATATABLE_FIELDTYPE_"+IntToString( x ) );
		sString = Get2DAString(s2daName, sColumnName, iRow );
		
		
		
		if ( x == 1 ) // first column is the label or name of row column, we can just bail out if it is found to be blank
		{
			if ( Get2DAString(s2daName, "REMOVED", iRow ) == "1" )
			{
				return; // lot of them have this as the limiter
			}
		
			// skip over blank rows, we don't want to store junk that is not needed or being used, will deal with a lot of blank garbage rows
			if ( sString == "" ) { return; } // just don't try
			sStringLower = GetStringLowerCase(sString);
			if ( sStringLower == "void" ) { return; } // just don't try
			if ( sStringLower == "padding" ) { return; } // just don't try
			if (GetStringLeft(sStringLower, 4) == "del_" ) { return; } // just don't try
			if (GetStringLeft(sStringLower, 7) == "hidden_" ) { return; } // just don't try
			if (GetStringLeft(sStringLower, 4) == "hid_" ) { return; } // just don't try
			if (GetStringLeft(sStringLower, 8) == "padding_" ) { return; } // just don't try
			if (GetStringRight(sStringLower, 8) == "_removed" ) { return; } // just don't try
			if (GetStringRight(sStringLower, 7) == "_remove" ) { return; } // just don't try
		}
		
		if ( sColumnType == "tlkref" || sColumnType == "indexref" )
		{
			// is it an integer
			if ( IntToString( StringToInt(sString) ) == sString )
			{
				sResult=GetStringByStrRef(StringToInt(sString));
				if ( sResult != "" )
				{
					sString = CSLRemoveAllTags(sResult); // don't store any color information, if that is needed its likely larger fields which should not need it to begin with
				}
			}
		}
		SetLocalString(oDataTable, "D_"+IntToString( iRow )+"_"+GetStringUpperCase(sColumnName), sString);
	}
	
	if ( iRow > GetLocalInt(oDataTable, "DATATABLE_LASTROWLOADED" ) )
	{
		SetLocalInt(oDataTable, "DATATABLE_LASTROWLOADED", iRow );
	}

}





/**  
* @author
* @param 
* @see 
* @return 
*/
// this is more often how this is going to be accessed
string CSLDataTableGetStringByRow( object oDataTable, string sColumnName, int iRow )
{
	string sValue = GetLocalString(oDataTable, "D_"+IntToString( iRow )+"_"+GetStringUpperCase(sColumnName) );
	
	if ( sValue == "" ) // if it's not loaded yet, go ahead and use values from the 2da, note this only handles columns that should be in the table to begin with
	{
		if ( iRow > GetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED" ) || GetLocalInt(oDataTable, "DATATABLE_FIELDROW_"+GetStringUpperCase(sColumnName) ) == 0 )
		{
			string s2daName = GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" );
			if ( s2daName != "" )
			{
				sValue = Get2DAString(s2daName, sColumnName, iRow);
				
				// handle tlkrefs now
				if ( sValue != "" && CSLGetIsNumber(sValue) && CSLDataTableGetColumnType( oDataTable, sColumnName ) == "tlkref" )
				{
					string sResult=GetStringByStrRef(StringToInt(sValue));
					if ( sResult != "" )
					{
						sValue = sResult;
					}
				}
			}
		}
	}
	return sValue;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLDataTableGetStringFromNameColumn( object oDataTable, int iRow )
{
	string sColumnName = GetLocalString(oDataTable, "DATATABLE_ROWNAMEFIELD");
	return GetLocalString(oDataTable, "D_"+IntToString( iRow )+"_"+GetStringUpperCase(sColumnName) );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLDataTableGetStringFromSortColumn( object oDataTable, int iRow )
{
	string sColumnName = GetLocalString(oDataTable, "DATATABLE_ROWSORTFIELD");
	return GetLocalString(oDataTable, "D_"+IntToString( iRow )+"_"+GetStringUpperCase(sColumnName) );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// this is going to be for listing the names for things like DMFI interfaces, so you will have items 1-10
string CSLDataTableGetStringByIndex( object oDataTable, string sColumnName, int iIndex )
{
	int iColumnNumber = GetLocalInt(oDataTable, "DATATABLE_FIELDROW_"+GetStringUpperCase(sColumnName) ); // one based
	int iStartingRow = GetLocalInt(oDataTable, "DATATABLE_STARTINGROW" );
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	int iVarPosition = iStartingRow + ( iTotalColumns * iIndex ) + ( iColumnNumber-1 );
	//SendMessageToPC( GetFirstPC(),GetVariableName( oDataTable, iVarPosition )+" has a value of "+GetVariableValueString( oDataTable, iVarPosition ) );

	//SendMessageToPC( GetFirstPC(),"iStartingRow="+IntToString(iStartingRow)+" + ( iTotalColumns="+IntToString(iTotalColumns)+" * iIndex="+IntToString(iIndex)+" ) + ( iColumnNumber="+IntToString(iColumnNumber)+" -1 )" );
		// use this for debugging comments since it's likely to be off by a row or two initially GetVariableName(oDataTable, iVarPosition);
	return GetVariableValueString( oDataTable, iVarPosition );
	
	// return GetLocalString(oDataTable, "D_"+IntToString( iRow )+"_"+sColumnName );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// does a reverse lookup, soas to get the original data row based on a value in a row
int CSLDataTableGetRowByValue( object oDataTable, string sValue )
{
	string sRow = GetLocalString(oDataTable, "INDEX_"+GetStringUpperCase( sValue ) );
	if ( sRow == "" )
	{
		return -1;
	}
	return StringToInt(sRow);
}




/**  
* @author
* @param 
* @see 
* @return 
*/
// this gets the serial number/2da row for a given row of data in the table
int CSLDataTableGetRowByIndex( object oDataTable, int iIndex )
{
	int iStartingRow = GetLocalInt(oDataTable, "DATATABLE_STARTINGROW" );
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	int iVarPosition = iStartingRow + ( iTotalColumns * iIndex );
	//int iTotalItems = CSLDataTableCount( oDataTable );
	//if ( iIndex >= iTotalItems )
	//{
	//	return -1;
	//}
	
	// use this for debugging comments since it's likely to be off by a row or two initially 
	string sVariableRow = GetVariableName(oDataTable, iVarPosition);
	
	//SendMessageToPC( GetFirstPC(), "sVariableRow = "+sVariableRow+" and will go to index "+CSLNth_GetNthElement( sVariableRow, 2, "_") );
	if ( sVariableRow == "" )
	{
		return -1;
	}
	sVariableRow = CSLNth_GetNthElement( sVariableRow, 2, "_");
	
	if ( sVariableRow == "" )
	{
		return -1;
	}
	
	return StringToInt( sVariableRow );
	//return GetVariableValueString( oDataTable, iVarPosition );
	
	// return GetLocalString(oDataTable, "D_"+IntToString( iRow )+"_"+sColumnName );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLDataTableSetupSortIndexData( object oDataTable, string sDelimiter = "," , int nCurrent = -1, int iCurrentQuantity = -1, string sMatch = "", string sMatchList = "", int bLetterMatch = FALSE )
{
	// defaulting to everything being uppercase here, it's usually lowercase but this way i can have the variable names all uppercase
	int iNumberProcessed = 0; // used to finish after we've done all the 2da rows
	int iTotalItems = CSLDataTableCount( oDataTable );
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	int iMaxRowsToProcess = 100;
	
	
	
	string sTableName = GetStringUpperCase( GetLocalString(oDataTable, "DATATABLE_NAME") );
	
	if ( nCurrent == -1 ) // this is first pass
	{
		iCurrentQuantity = 0;
		nCurrent = 0;
		sMatchList = GetStringUpperCase( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) )+sDelimiter;
		if ( sMatchList == "ALPHABETICAL," )
		{
			sMatchList = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,~";
			bLetterMatch = TRUE;
		}
		sMatch = ""; // this won't match anything
		
		// SendMessageToPC(  GetFirstPC(), "Initializing CSLDataTableSetupSortIndexData object "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" sMatchList="+sMatchList );
	}
	
	//else
	//{
	//	SendMessageToPC(  GetFirstPC(), "Repeating" );
	//}
	int iRow;
	string sString;
	//sMatchList = CSLStringAfter(sMatchList,sDelimiter);
	//SetLocalInt(oDataTable, "DATATABLE_SORTSTART_"+sMatch, 0 );
	//SendMessageToPC(  GetFirstPC(), "CSLDataTableSetupSortIndexData on s2daName= "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" prefix="+sMatchList  );
	while ( nCurrent <= iTotalItems && sMatchList != "" )
	{
		iRow = CSLDataTableGetRowByIndex( oDataTable, nCurrent );
		sString = GetStringUpperCase( CSLRemoveAllTags( CSLDataTableGetStringFromSortColumn( oDataTable, iRow ) ) );
		if ( bLetterMatch && CSLAlphabeticalSortConstant(sString) == CSL_LETTER_NA )
		{
			sString = "~"+sString; // push them to the back
		}
		
		if ( sMatch != "" && GetStringLeft(sString, GetStringLength(sMatch) )== sMatch )
		{
			iCurrentQuantity++;
			SetLocalInt(oDataTable, "DATATABLE_SORTQUANTITY_"+sMatch, iCurrentQuantity );
			//SendMessageToPC( GetFirstPC(), "Doing "+sMatch+" which has "+"DATATABLE_SORTQUANTITY_"+sMatch+"="+IntToString(GetLocalInt(oDataTable, "DATATABLE_SORTQUANTITY_"+sMatch))+" members and starts on "+ "DATATABLE_SORTSTART_"+sMatch+"="+IntToString(GetLocalInt(oDataTable, "DATATABLE_SORTSTART_"+sMatch) ) );
			
		}
		else
		{
			do
			{
				sMatch = CSLStringBefore(sMatchList,sDelimiter);
				sMatchList = CSLStringAfter(sMatchList,sDelimiter);
				//if ( sTableName == "FEAT" )
				//{
					//SendMessageToPC(  GetFirstPC(), "Getting new sMatch "+sMatch+" to match "+sString );
					//SendMessageToPC( GetFirstPC(), "Doing sortchange "+sMatch+" which has "+"DATATABLE_SORTQUANTITY_"+sMatch+"="+IntToString(GetLocalInt(oDataTable, "DATATABLE_SORTQUANTITY_"+sMatch))+" members and starts on "+ "DATATABLE_SORTSTART_"+sMatch+"="+IntToString(GetLocalInt(oDataTable, "DATATABLE_SORTQUANTITY_"+sMatch) ) );

				//}
			}
			while ( sMatch != "" && GetStringLeft(sString, GetStringLength(sMatch) ) != sMatch );
			iCurrentQuantity = 1;
			SetLocalInt(oDataTable, "DATATABLE_SORTQUANTITY_"+sMatch, iCurrentQuantity );
			SetLocalInt(oDataTable, "DATATABLE_SORTSTART_"+sMatch, nCurrent );
			//if ( sTableName == "FEAT" )
			//{
			//	SendMessageToPC( GetFirstPC(), "Doing sortchange "+sMatch+" which has "+"DATATABLE_SORTQUANTITY_"+sMatch+"="+IntToString(GetLocalInt(oDataTable, "DATATABLE_SORTQUANTITY_"+sMatch))+" members and starts on "+ "DATATABLE_SORTSTART_"+sMatch+"="+IntToString(GetLocalInt(oDataTable, "DATATABLE_SORTSTART_"+sMatch) ) );
			//}

		}
		nCurrent++;
		iNumberProcessed++;
		if ( iNumberProcessed > iMaxRowsToProcess )
		{
			DelayCommand(CSLRandomBetweenFloat(0.15f,0.25f),CSLDataTableSetupSortIndexData( oDataTable, sDelimiter, nCurrent, iCurrentQuantity, sMatch, sMatchList, bLetterMatch ) );
			return;
		}
	}
	
	if (DEBUGGING >= 3) { SendMessageToPC(GetFirstPC(),"CSLDataTableSetupSortIndexData finished "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" ) ); }
	//SendMessageToPC(  GetFirstPC(), "Finished Sorting "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )  );
	SetLocalInt(oDataTable, "DATATABLE_FULLYSORTED", TRUE );
	
	//if ( GetStringUpperCase( CSLGetPreferenceString( "DataObjectLoadOption", "OFF" ) ) == "CACHE" )
	//{
		// always store it
		CSLDataObjectStore( GetLocalString(oDataTable, "DATATABLE_NAME") );
	//}
		
		
	string sOnLoadedScript = GetLocalString(oDataTable, "DATATABLE_ONLOADEDSCRIPT" );
	if ( sOnLoadedScript != "" )
	{
		DelayCommand(CSLRandomBetweenFloat(0.15f,0.25f), ExecuteScript( sOnLoadedScript, GetModule() ) );
	}
	/*
	object oCurrentPC = GetFirstPC();
	while (GetIsObjectValid(oCurrentPC))
	{
		SetGUIObjectHidden( oCurrentPC, SCREEN_DM_CSLTABLELIST, "FILTER_PANE", FALSE );
		oCurrentPC = GetNextPC();
	}
	*/
	
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * takes all rows of the given prefix and sorts them to the end of the table -- will this cause TMI on larger tables??? last 3 parameters allow extended processing
void CSLDataTableSortByPrefix( object oDataTable, string sMatchList = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z", string sDelimiter = ",", int iStartRow = 0, string sMatch = "", int iRepetition = 0, int iTotalProcessed = 0 )
{
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	int iNumberProcessed = 0; // used to finish after we've done all the 2da rows
	int iTotalItems = CSLDataTableCount( oDataTable );
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	int iMaxRowsToProcess = 100/iTotalColumns;
	int nCurrent = iStartRow;
	//int iTotalProcessed = nCurrent;
	int iRow;
	string sString;
	if ( iStartRow == 0 )
	{
		sMatch = CSLStringBefore(sMatchList,sDelimiter);
		sMatchList = CSLStringAfter(sMatchList,sDelimiter);
	}
	//SendMessageToPC(  GetFirstPC(), "CSLDataTableSortByPrefix s2daName= "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" prefix="+sMatchList  );
	if (DEBUGGING >= 8) { SendMessageToPC(GetFirstPC(),"CSLDataTableSortByPrefix object "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" completed rows starting at "+IntToString(iStartRow)+" with repetition "+IntToString(iRepetition)+" sMatchList="+sMatchList ); }
	while ( iTotalProcessed < iTotalItems  ) // && nCurrent <= iNumberProcessed
	{
		iTotalProcessed++;
		iRow = CSLDataTableGetRowByIndex( oDataTable, nCurrent );
		sString = CSLRemoveAllTags( CSLDataTableGetStringFromSortColumn( oDataTable, iRow ) );
		if (GetStringLowerCase(GetStringLeft(sString, GetStringLength(sMatch)))==GetStringLowerCase(sMatch))
		{
			CSLDataTableMoveRowToEnd2da( oDataTable, iRow ); // we don't increment since it's actually being moved
			iNumberProcessed++;
			//iTotalSorted++;
		}
		else
		{
			nCurrent++;
			iNumberProcessed++;
		}
		if ( iNumberProcessed > iMaxRowsToProcess)
		{
			iRepetition++;
			DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortByPrefix( oDataTable, sMatchList, sDelimiter, nCurrent, sMatch, iRepetition, iTotalProcessed  ) );
			return;
		}
	}
	
	if ( sMatchList != "" )
	{
		DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortByPrefix( oDataTable, sMatchList, sDelimiter ) );
		return;
	}
	else
	{
		// all done so cache the actual value
		DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSetupSortIndexData( oDataTable ) );
	}
}

void CSLDataTableApplySortOrder( object oDataTable, object oSortingHat, int iStartingRow = 0 )
{
	//DEBUGGING = 5;
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	string sTableName = GetStringUpperCase( GetLocalString(oDataTable, "DATATABLE_NAME") );
	//int iTotalItems = CSLDataTableCount( oDataTable )+1;
	
	int iTotalItems = GetLocalInt( oSortingHat, sTableName+"-MAXVALUE" );
	
	if ( iTotalItems > 0 )
	{
		if (DEBUGGING >= 4) { SendMessageToPC(GetFirstPC(),"CSLDataTableApplySortOrder object "+sTableName+" completed rows starting at "+IntToString(iStartingRow) ); }
		
		int iNumberProcessed, iCurrent;
		int bSwappedValue = FALSE;
		string sCurrent;
		
		int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
		int iMaxRowsToProcess = 80/iTotalColumns;
		
		for ( iCurrent = iStartingRow; iCurrent <= iTotalItems; iCurrent++) // was <= but should not be, it's zero based
		{
			iNumberProcessed++;
			
			sCurrent = CSLStringAfter( GetLocalString( oSortingHat, sTableName+"-"+IntToString( iCurrent ) ), "|" ); // get the rows involved
			DeleteLocalString( oSortingHat, sTableName+"-"+IntToString(iCurrent) ); // clean up after ourselves
			if ( sCurrent != "" ) // make sure we got a real value so we don't abuse row zero
			{
				//if ( sTableName == "FEAT" )
				//{
				//	SendMessageToPC(GetFirstPC(),"CSLDataTableApplySortOrder CSLDataTableMoveRowToEnd2da "+sTableName+" doing row "+sCurrent+" "+GetLocalString( oSortingHat, sTableName+"-"+IntToString( iCurrent ) ) );
				//}
				CSLDataTableMoveRowToEnd2da( oDataTable, StringToInt( sCurrent ) );
			}
			///else
			//{
			//	if (DEBUGGING >= 3) { SendMessageToPC(GetFirstPC(),"CSLDataTableApplySortOrder "+sTableName+" invalid row "+IntToString(iCurrent)+" doing row "+sCurrent ); }
			//}
			
			if ( iNumberProcessed > iMaxRowsToProcess ) // more involved operation, tune this to taste
			{
				// do this in passes to ensure we don't tax server nor do we end up hitting a TMI
				DelayCommand(CSLRandomBetweenFloat(0.15f, fLoadInterval),CSLDataTableApplySortOrder( oDataTable, oSortingHat, iCurrent ) );
				return;
			}
		}
	}
	else
	{
		if (DEBUGGING >= 3) { SendMessageToPC(GetFirstPC(),"CSLDataTableApplySortOrder "+sTableName+" no items" ); }
	}
	
	// must be all done, lets finish this up now
	DeleteLocalInt( oSortingHat, sTableName+"-MAXVALUE" );
	DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSetupSortIndexData( oDataTable ) );
}


void CSLDataTableSortHatElements( object oDataTable, object oSortingHat, int iStartingRow = 0, int iIteration = 0 )
{
	//DEBUGGING = 5;
	string sTableName = GetStringUpperCase( GetLocalString(oDataTable, "DATATABLE_NAME") );
	int iTotalItems = GetLocalInt( oSortingHat, sTableName+"-MAXVALUE" );
	if (DEBUGGING >= 4) { SendMessageToPC(GetFirstPC(),"CSLDataTableSortHatElements object "+sTableName+" completed rows starting at "+IntToString(iStartingRow)+" iIteration="+IntToString(iIteration) ); }
	
	int iNumberProcessed, iCurrent;
	int bSwappedValue = FALSE;
	string sPrevious, sCurrent;
	
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	for ( iCurrent = iStartingRow; iCurrent <= iTotalItems; iCurrent++) 
	{
		iNumberProcessed++;
		if ( iCurrent > 0 ) // skip the first row
		{
			sPrevious = GetLocalString( oSortingHat, sTableName+"-"+IntToString( iCurrent-1 ) );
			sCurrent = GetLocalString( oSortingHat, sTableName+"-"+IntToString( iCurrent ) );
			
			// sPrevious != "" && sCurrent != "" && 
			
			if ( StringCompare( sPrevious,sCurrent, FALSE ) > 0 ) // did not seem to work with a simple "as is" truth test until i added the " > 0 "
			{
				// do a swap
				//if ( iIteration > 40 )
				//{
				//	if (DEBUGGING >= 4) { SendMessageToPC(GetFirstPC(),"Swapping sCurrent="+sCurrent+" with sPrevious="+sPrevious ); }
				//
				//}
				SetLocalString( oSortingHat, sTableName+"-"+IntToString( iCurrent-1 ), sCurrent );
				SetLocalString( oSortingHat, sTableName+"-"+IntToString( iCurrent ), sPrevious );
				bSwappedValue = TRUE;
			}
			
			if ( iNumberProcessed > 250 ) // 320 pretty light weight iteration each time so should not be too bad, tune this to taste
			{
				// do this in passes to ensure we don't tax server nor do we end up hitting a TMI
				DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortHatElements( oDataTable, oSortingHat, iCurrent, iIteration ) );
				return;
			}
		}
	}
	
	
	//int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	
	// This clamps down iterations on the sorting because it does not have to be perfectly sorted until it's clean, it's already sorted by first letter and it trys to keep all the sorting so it never takes longer than a given amount of time
	// want small tables to tend to fully sort, while large tables are just too expensive to do 60+ iterations which is needed to fully sort them
	int iMaxIterations = 32; //iTotalItems/20;
	if ( iTotalItems > 2500 )
	{
		iMaxIterations = 15;
	}
	else if ( iTotalItems > 2000 )
	{
		iMaxIterations = 20;
	}
	else if ( iTotalItems > 1500 )
	{
		iMaxIterations = 25;
	}
	else if ( iTotalItems > 1000 )
	{
		iMaxIterations = 30;
	}	
	
	// iIteration < 20 && (iTotalItems/20)
	
	if ( bSwappedValue &&   iIteration < iMaxIterations ) // don't bother fully sorting, the list is already sort by first letter
	{
		iIteration++;
		// we are not clean yet so go ahead and go ahead and do another pass
		DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortHatElements( oDataTable, oSortingHat, 0, iIteration ) );
		return;
	}
	
	// everything should be sorted, lets copy it back to the original object
	CSLDataTableApplySortOrder( oDataTable, oSortingHat );
}


// * takes all rows of the given prefix and sorts them to the end of the table -- will this cause TMI on larger tables??? last 3 parameters allow extended processing
void CSLDataTableStartSortingHat( object oDataTable, object oSortingHat, int iStartingRow = 0, string sMatch = "", string sMatchList = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,~", string sDelimiter = "," )
{
	//DEBUGGING = 5;
	string sTableName = GetStringUpperCase( GetLocalString(oDataTable, "DATATABLE_NAME") );
	int iTotalItems = CSLDataTableCount( oDataTable )+5;
	if (DEBUGGING >= 5) { SendMessageToPC(GetFirstPC(),"CSLDataTableStartSortingHat object "+sTableName+" completed rows starting at "+IntToString(iStartingRow) ); }
	
	int iNumberProcessed, iCurrent, iRow, iAccumulatedRow;
	string sValue;
	
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	if ( iStartingRow == 0 )
	{
		sMatch = CSLStringBefore(sMatchList,sDelimiter);
		sMatchList = CSLStringAfter(sMatchList,sDelimiter);
	}
	
	// do this if sort is not prefixes but "alphabetical" as a string
	// 1 copy all items to the sorting hat
	for ( iCurrent = iStartingRow; iCurrent <= iTotalItems; iCurrent++) 
	{
		
		iRow = CSLDataTableGetRowByIndex( oDataTable, iCurrent );
		if ( iRow > -1 )
		{
			sValue = CSLRemoveAllTags( CSLDataTableGetStringFromSortColumn( oDataTable, iRow ) ); // make sure we only deal with the raw values without color tags
			
			
			
			
			if ( CSLAlphabeticalSortConstant(sValue) == CSL_LETTER_NA || sValue == "" )
			{
				sValue = "~"+sValue;
				// if (DEBUGGING >= 4) { SendMessageToPC(GetFirstPC(),"CSLDataTableStartSortingHat object "+sTableName+" sValue="+sValue ); }
		
			}
			
			//
			if ( GetStringLowerCase( GetStringLeft(sValue, GetStringLength(sMatch)) ) == GetStringLowerCase(sMatch) ) 
			{
				//iAccumulatedRow++;
				iAccumulatedRow = CSLIncrementLocalInt( oSortingHat, sTableName+"-MAXVALUE" ); // this is going to be 1 based
				SetLocalString( oSortingHat, sTableName+"-"+IntToString( iAccumulatedRow ), sValue+"|"+IntToString(iRow) );
				
				//if ( sTableName == "FEAT" )
				//{
				//	SendMessageToPC(GetFirstPC(),"CSLDataTableStartSortingHat object "+sTableName+" iRow="+IntToString( iRow )+" sValue="+sValue+" iAccumulatedRow="+IntToString(iAccumulatedRow)+" SortConstant="+IntToString( CSLAlphabeticalSortConstant(sValue) ) );	
				//}
				
			}
			
			
			//if ( sTableName == "FEAT" )
			//{
			//	SendMessageToPC(GetFirstPC(),"CSLDataTableStartSortingHat object "+sTableName+" iRow="+IntToString( iRow )+" sValue="+sValue+" iAccumulatedRow="+IntToString(iAccumulatedRow)+" SortConstant="+IntToString( CSLAlphabeticalSortConstant(sValue) ) );	
			//}
			
		}
		//else
		//{
		//	if ( sTableName == "FEAT" )
		//	{
		//		SendMessageToPC(GetFirstPC(),"CSLDataTableStartSortingHat skipped "+sTableName+" iRow="+IntToString( iRow )+" sValue="+sValue+" SortConstant="+IntToString( CSLAlphabeticalSortConstant(sValue) ) );	
		//	}
		//}
		iNumberProcessed++;
		if ( iNumberProcessed > 175 ) // pretty light weight iteration each time so should not be too bad, tune this to taste
		{
			// do this in passes to ensure we don't tax server nor do we end up hitting a TMI
			DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableStartSortingHat( oDataTable, oSortingHat, iCurrent, sMatch, sMatchList ) );
			return;
		}
	}
	
	if ( sMatchList != "" ) // pretty light weight iteration each time so should not be too bad, tune this to taste
	{
		// do this in passes to ensure we don't tax server nor do we end up hitting a TMI
		DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableStartSortingHat( oDataTable, oSortingHat, 0, sMatch, sMatchList ) );
		return;
	}
	
	// now we have it copied over, so we can trigger a new scrpt
	
	CSLDataTableSortHatElements( oDataTable, oSortingHat );
}



/**  
* @author
* @param 
* @see 
* @return 
*/
object CSLDataObjectRetrieve( string sDataTableName )
{
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	object oCoreDataPoint = CSLCoreDataPointGet();
	object oDataTable = RetrieveCampaignObject(CSL_DATASTORE, "DATATABLE_"+GetStringUpperCase( sDataTableName ), GetLocation(oCoreDataPoint), oCoreDataPoint );
	if (DEBUGGING >= 8) { SendMessageToPC(GetFirstPC(), "Retrieving object "+sDataTableName ); }
	if ( GetIsObjectValid( oDataTable ) )
	{
		int iVersion = CSLDataTableVersion( oDataTable );
		int iCurrentVersion = CSLGetPreferenceInteger( "DataObjectVersion", -1 );
		
		int iLanguageVersion = GetLocalInt(oDataTable, "DATATABLE_LANGVERSION");
		if ( iLanguageVersion > 0 ) // we are using language instead which keeps version on first row of 2da
		{
			string s2daName = GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" );
			
			if ( Get2DAString(s2daName, "Key", 0 ) == "<VERSION>" )
			{
				iVersion = iLanguageVersion;
				iCurrentVersion = StringToInt( Get2DAString(s2daName, "Value", 0 ) );
			}
		}
		
		if ( iVersion > 0 && iVersion == CSLGetPreferenceInteger( "DataObjectVersion", -1 ) )
		{
			SetLocalObject( oCoreDataPoint, "DATATABLE_"+GetStringUpperCase( sDataTableName ), oDataTable);
			SetPlotFlag(oDataTable, TRUE);
			
			if ( !GetLocalInt(oDataTable, "DATATABLE_FULLYSORTED" ) && GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) != "" )
			{
				if ( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) == "alphabetical" )
				{
					DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableStartSortingHat( oDataTable, CSLDataObjectGet( "SortingHat", TRUE ) ) );
				}
				else if ( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) != "" )
				{
					DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortByPrefix( oDataTable, GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) ) );
				}
			}
			else
			{
				string sOnLoadedScript = GetLocalString(oDataTable, "DATATABLE_ONLOADEDSCRIPT" );
				if ( sOnLoadedScript != "" )
				{
					DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval), ExecuteScript( sOnLoadedScript, GetModule() ) );
				}
			}
			
			return oDataTable;
		}
		else
		{
			SetTag(oDataTable, "DELETE");
			DestroyObject(oDataTable, 0.0f, FALSE);
		}
	}
	return OBJECT_INVALID;
	
}


	
	// name the vars per the following
	// sourceobjectname - iteration -> value is value to sort | original rownumber
	
	// 2 
	// swap values on the sorting hat if they are not in proper order, iterate a few times until its accurate, use binarys sort code
	
	// 3 based on this duplicate values which are now sorted into accurate physical order, as they are copied delete them from the sorting hat
	
	// allow the above to keep track of stage so it can loop in and out as it hits tmi processing caps, and so it never affects performance
	
	
	
	/*
	int iNumberProcessed = 0; // used to finish after we've done all the 2da rows
	int iTotalItems = CSLDataTableCount( oDataTable );
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	int iMaxRowsToProcess = 200/iTotalColumns;
	int nCurrent = iStartRow;
	int iTotalProcessed = nCurrent;
	int iRow;
	string sString;
	if ( iStartRow == 0 )
	{
		sMatch = CSLStringBefore(sMatchList,sDelimiter);
		sMatchList = CSLStringAfter(sMatchList,sDelimiter);
	}
	//SendMessageToPC(  GetFirstPC(), "CSLDataTableSortByPrefix s2daName= "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" prefix="+sMatchList  );
	if (DEBUGGING >= 8) { SendMessageToPC(GetFirstPC(),"CSLDataTableSortByPrefix object "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" completed rows starting at "+IntToString(iStartRow)+" with repetition "+IntToString(iRepetition)+" sMatchList="+sMatchList ); }
	while ( iTotalProcessed <= iTotalItems  ) // && nCurrent <= iNumberProcessed
	{
		iTotalProcessed++;
		iRow = CSLDataTableGetRowByIndex( oDataTable, nCurrent );
		sString = CSLDataTableGetStringFromSortColumn( oDataTable, iRow );
		if (GetStringLowerCase(GetStringLeft(sString, GetStringLength(sMatch)))==GetStringLowerCase(sMatch))
		{
			CSLDataTableMoveRowToEnd2da( oDataTable, iRow ); // we don't increment since it's actually being moved
			iNumberProcessed++;
		}
		else
		{
			nCurrent++;
			iNumberProcessed++;
		}
		if ( iNumberProcessed > iMaxRowsToProcess )
		{
			iRepetition++;
			DelayCommand(CSLRandomBetweenFloat(0.15f,0.25f),CSLDataTableSortByPrefix( oDataTable, sMatchList, sDelimiter, nCurrent, sMatch, iRepetition ) );
			return;
		}
	}
	
	if ( sMatchList != "" )
	{
		DelayCommand(CSLRandomBetweenFloat(0.15f,0.25f),CSLDataTableSortByPrefix( oDataTable, sMatchList, sDelimiter ) );
		return;
	}
	else
	{
		// all done so cache the actual value
		DelayCommand(CSLRandomBetweenFloat(0.15f,0.25f),CSLDataTableSetupSortIndexData( oDataTable ) );
	}
	*/




/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLDataTableLoad2da( object oDataTable )
{
	string s2daName = GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" );
	
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	int iMaxRows = GetNum2DARows( s2daName );
	if ( iMaxRows == 0 ) { return; }
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	if ( iTotalColumns == 0 ) { return; }
	int iMaxRowsToProcess = 300/iTotalColumns; // lowers how much it handles based on how many columns are being done at a single time
	int iLastRowProcessed = GetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED" );
	int iRow;
	
	
	if ( iMaxRows > iLastRowProcessed )
	{
		int iStartingRow = iLastRowProcessed+1;
		int iEndingRow = CSLGetMin( iStartingRow + iMaxRowsToProcess, iMaxRows ); // make sure it's limited to real rows
		
		//SendMessageToPC( GetFirstPC(), "CSLDataTableLoad2da s2daName= "+s2daName+" starting row= "+IntToString(iStartingRow)+" to row "+IntToString( iEndingRow )  );
		
		for (iRow = iStartingRow; iRow <= iEndingRow; iRow++) 
		{
			CSLDataTableLoadSingleRowFrom2da( oDataTable, iRow );
		}
		
		iLastRowProcessed = GetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED" ); // get it again, it might be done by now
		if ( iMaxRows > iLastRowProcessed )
		{
			if (DEBUGGING >= 8) { SendMessageToPC(GetFirstPC(),"Loading object "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" rows at "+IntToString(iLastRowProcessed) ); }
			DelayCommand( CSLRandomBetweenFloat(0.15f,fLoadInterval), CSLDataTableLoad2da( oDataTable ) );
			return;
		}
	}
	if (DEBUGGING >= 8) { SendMessageToPC(GetFirstPC(),"Loading object "+GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" )+" completed rows at "+IntToString(iLastRowProcessed) ); }
	//SendMessageToPC(  GetFirstPC(), "CSLDataTableLoad2da s2daName= "+s2daName+" finished "  );
	
	if ( iMaxRows <= iLastRowProcessed )
	{
		SetLocalInt(oDataTable, "DATATABLE_FULLYLOADED", TRUE );
		
		// go ahead and store it
		//if ( GetStringUpperCase( CSLGetPreferenceString( "DataObjectLoadOption", "OFF" ) ) == "CACHE" )
		//{
			// always store it
			CSLDataObjectStore( GetLocalString(oDataTable, "DATATABLE_NAME") );
		//}
		
		if ( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) == "alphabetical" )
		{
			DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableStartSortingHat( oDataTable, CSLDataObjectGet( "SortingHat", TRUE ) ) );
		}
		else if ( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) != "" )
		{
			DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortByPrefix( oDataTable, GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) ) );
		}
		else
		{
			string sOnLoadedScript = GetLocalString(oDataTable, "DATATABLE_ONLOADEDSCRIPT" );
			if ( sOnLoadedScript != "" )
			{
				DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval), ExecuteScript( sOnLoadedScript, GetModule() ) );
			}
		}
	}
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLDataTableLoadAreas( object oDataTable )
{
	int iRow = -1;
	
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	object oArea = GetFirstArea();
	while ( GetIsObjectValid(oArea) )
	{
		iRow++;
		SetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED", iRow );
		SetLocalInt(oDataTable, "DATATABLE_LASTROWLOADED", iRow );
		
		SetLocalString(oDataTable, "D_"+IntToString( iRow )+"_NAME", GetName( oArea ) );
		SetLocalString(oDataTable, "D_"+IntToString( iRow )+"_OBJECTID", ObjectToString(oArea) );
		// need to make sure fields added match
		
		oArea = GetNextArea();
	}
	/*
	string s2daName = GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" );
	
	
	
	int iMaxRows = GetNum2DARows( s2daName );
	if ( iMaxRows == 0 ) { return; }
	int iTotalColumns = GetLocalInt(oDataTable, "DATATABLE_FIELDS" );
	if ( iTotalColumns == 0 ) { return; }
	int iMaxRowsToProcess = 500/iTotalColumns; // lowers how much it handles based on how many columns are being done at a single time
	int iLastRowProcessed = GetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED" );
	int iRow;
	if ( iMaxRows > iLastRowProcessed )
	{
		int iStartingRow = iLastRowProcessed+1;
		int iEndingRow = CSLGetMin( iStartingRow + iMaxRowsToProcess, iMaxRows ); // make sure it's limited to real rows
		
		//SendMessageToPC( GetFirstPC(), "CSLDataTableLoad2da s2daName= "+s2daName+" starting row= "+IntToString(iStartingRow)+" to row "+IntToString( iEndingRow )  );
		
		for (iRow = iStartingRow; iRow <= iEndingRow; iRow++) 
		{
			CSLDataTableLoadSingleRowFrom2da( oDataTable, iRow );
		}
		
		iLastRowProcessed = GetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED" ); // get it again, it might be done by now
		if ( iMaxRows > iLastRowProcessed )
		{
			DelayCommand( CSLRandomBetweenFloat( 0.15f, 3.0f ), CSLDataTableLoad2da( oDataTable ) );
			return;
		}
	}
	
	//SendMessageToPC(  GetFirstPC(), "CSLDataTableLoad2da s2daName= "+s2daName+" finished "  );
	
	if ( iMaxRows <= iLastRowProcessed )
	{
		SetLocalInt(oDataTable, "DATATABLE_FULLYLOADED", TRUE );
		
		if ( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) != "" )
		{
			 DelayCommand(CSLRandomBetweenFloat(0.15f,0.25f),CSLDataTableSortByPrefix( oDataTable, GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) ) );
		}
	}
	*/
	
	if ( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) != "" )
	{
		 DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortByPrefix( oDataTable, GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) ) );
	}
}

object oPreferenceTable;

/*
void CSLDataTableLoadPreferences( object oDataTable )
{
	int iRow = -1;
	
	//object oArea = GetFirstArea();
	//while ( GetIsObjectValid(oArea) )
	//{
		iRow++;
		SetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED", iRow );
		SetLocalInt(oDataTable, "DATATABLE_LASTROWLOADED", iRow );
		
		SetLocalString(oDataTable, "D_"+IntToString( iRow )+"_NAME", "" );
		SetLocalString(oDataTable, "D_"+IntToString( iRow )+"_OBJECTID", "" );
		// need to make sure fields added match
		
		//oArea = GetNextArea();
	//}
	// int CSLDataTableConfigure( object oDataTable, string s2daName, string sFields, string sFieldType = "", string sFieldDelimiter = ",", string sSortList = "" ) // and so forth for how ever many possible fields
	

	
	if ( GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) != "" )
	{
		 DelayCommand(CSLRandomBetweenFloat(0.15f,0.25f),CSLDataTableSortByPrefix( oDataTable, GetLocalString(oDataTable, "DATATABLE_SORTLIST" ) ) );
	}
}
*/



void CSLGetPreferenceDataObject()
{
	if ( !GetIsObjectValid( oPreferenceTable ) )
	{
		oPreferenceTable = CSLDataObjectGet( "preferences");
		if ( !GetIsObjectValid( oPreferenceTable ) )
		{
			oPreferenceTable = CSLDataObjectGet( "preferences", TRUE );
			CSLDataTableConfigure( oPreferenceTable, "cslpreferences", "Key,Value", "index,string" );
			// CSLDataTableLoadPreferences( oPreferenceTable ); 
			CSLDataTableLoad2da( oPreferenceTable );
		}
	}
}

int CSLPreferencesGetIsLoaded( ) 
{
	CSLGetPreferenceDataObject();
	return CSLDataObjectGetIsLoaded(oPreferenceTable);
	// CSLDataObjectGetIsSorted
}

int CSLGetIsPreferenceDataObjectLoaded()
{
	CSLGetPreferenceDataObject();
	return GetLocalInt(oPreferenceTable, "DATATABLE_FULLYLOADED" );
}

string CSLGetPreferenceString( string sPreferenceName, string sDefaultValue = "" )
{
	CSLGetPreferenceDataObject();
	int iRow = CSLDataTableGetRowByValue( oPreferenceTable, sPreferenceName );
	if ( iRow == -1 )
	{
		SendMessageToPC(GetFirstPC(),"Default");
		return sDefaultValue;
	}
	return CSLDataTableGetStringByRow( oPreferenceTable, "value", iRow );
}


int CSLGetPreferenceInteger( string sPreferenceName, int iDefaultValue = 0 )
{
	CSLGetPreferenceDataObject();
	int iRow = CSLDataTableGetRowByValue( oPreferenceTable, sPreferenceName );
	if ( iRow == -1 )
	{
		return iDefaultValue;
	}
	return StringToInt( CSLDataTableGetStringByRow( oPreferenceTable, "value", iRow ) );
}

float CSLGetPreferenceFloat( string sPreferenceName, float fDefaultValue = 0.0f )
{
	CSLGetPreferenceDataObject();
	int iRow = CSLDataTableGetRowByValue( oPreferenceTable, sPreferenceName );
	if ( iRow == -1 )
	{
		return fDefaultValue;
	}
	return StringToFloat( CSLDataTableGetStringByRow( oPreferenceTable, "value", iRow ) );
}


/*
returns TRUE or FALSE based on a switch value in preferences

The preferences can be setup with "TRUE" or "1" for TRUE, or "FALSE" or "0" or any other values for FALSE

bDefaultValue allows
* @replaces GetPRCSwitch 
*/
int CSLGetPreferenceSwitch( string sPreferenceName, int bDefaultValue = FALSE)
{
	CSLGetPreferenceDataObject();
	int iRow = CSLDataTableGetRowByValue( oPreferenceTable, sPreferenceName );
	if ( iRow == -1 )
	{
		if ( bDefaultValue ) // just a safety to make sure the returned value is boolean
		{
			return TRUE;
		}
		return FALSE;
	}
	
	string sChoice = CSLDataTableGetStringByRow( oPreferenceTable, "value", iRow );
	if ( sChoice == "1" || GetStringUpperCase(sChoice) == "TRUE" )
	{
		return TRUE;
	}
	
	return FALSE;
}


// just a stub for later implementation
void CSLSetPreferenceString( string sPreferenceName, string sValue = "", int bAllowAddingNewPrefs = FALSE )
{
	CSLGetPreferenceDataObject();
	int iRow = CSLDataTableGetRowByValue( oPreferenceTable, sPreferenceName );
	
	// forces this to use the 2da only, or to set values already created by the 2da, just until i can make sure adding values can be integrated with the DataObject Index
	bAllowAddingNewPrefs == FALSE;
	
	if ( iRow == -1 && bAllowAddingNewPrefs == FALSE ) // cannot set since is not already in effect
	{
		return;
	}
	
	if ( iRow == -1 )
	{
		// add a new row to the table
		return;
	}
	
	// just set the needed value to the correct row
	
	return;
}

void CSLSetPreferenceInteger( string sPreferenceName, int iValue = 0, int bAllowAddingNewPrefs = FALSE )
{
	CSLSetPreferenceString( sPreferenceName, IntToString(iValue), bAllowAddingNewPrefs );
}

void CSLSetPreferenceSwitch( string sPreferenceName, int bValue = FALSE, int bAllowAddingNewPrefs = FALSE )
{
	if ( bValue ) // just a safety to make sure the returned value is boolean
	{
		CSLSetPreferenceInteger( sPreferenceName, TRUE, bAllowAddingNewPrefs );
	}
	CSLSetPreferenceInteger( sPreferenceName, FALSE, bAllowAddingNewPrefs );
}





// * takes all rows of the given prefix and sorts them to the end of the table -- will this cause TMI on larger tables??? last 3 parameters allow extended processing
void CSLDataTableSetupSpellBook( object oSpellBookTable, string sFieldName, int iStartingRow = 0 )
{
	//DEBUGGING = 5;
	object oSpellsTable = CSLDataObjectGet( "spells" );
	int iTotalItems = CSLDataTableCount( oSpellsTable );
	
	float fLoadInterval = 0.25f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	if ( DEBUGGING > 3 ) { SendMessageToPC( GetFirstPC(), "Loading "+sFieldName+" spellbook data now..."); }
	
	if ( iStartingRow == 0 )
	{
		CSLDataTableConfigure( oSpellBookTable, "spellbook_"+sFieldName, "Name,Level,Rarity", "", ",", "0,1,2,3,4,5,6,7,8,9,10", "Level" ); // , ",", "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
	}
	
	int iCurrent, iRow, iNumberProcessed;
	string sLevel,sName,sRarity, sResult, sMaster;
	
	for ( iCurrent = iStartingRow; iCurrent <= iTotalItems; iCurrent++) // was <= but it should not be like that since zero based
	{
		iRow = CSLDataTableGetRowByIndex( oSpellsTable, iCurrent );
		iNumberProcessed++;
		if ( iRow > -1 )
		{
			sLevel = Get2DAString("spells", sFieldName, iRow );
			sMaster = Get2DAString("spells", "Master", iRow );
			if ( sLevel != "" && sMaster == "" ) // make sure it has a level AND it has nothing in the master column
			{
				sName = Get2DAString("spells", "NAME", iRow );
				
				
				if ( IntToString( StringToInt(sName) ) == sName )
				{
					sResult=GetStringByStrRef(StringToInt(sName));
					if ( sResult != "" )
					{
						sName = CSLRemoveAllTags(sResult); // don't store any color information, if that is needed its likely larger fields which should not need it to begin with
					}
					else
					{
						sName = Get2DAString("spells", "Label", iRow );
					}
				}
				
				sRarity = Get2DAString("spells", "Rarity", iRow ); // this is a new column i am looking at adding to spells.2dato support features around how common spells are
				
				
				//SetLocalInt(oDataTable, "DATATABLE_LASTROWPROCESSED", iRow ); // not really relevant
				//SetLocalInt(oDataTable, "DATATABLE_LASTROWLOADED", iRow );
				
				SetLocalString(oSpellBookTable, "D_"+IntToString( iRow )+"_NAME", sName );
				SetLocalString(oSpellBookTable, "D_"+IntToString( iRow )+"_LEVEL", sLevel );
				SetLocalString(oSpellBookTable, "D_"+IntToString( iRow )+"_RARITY", sRarity );
				
				//iRow++;
				// need to make sure fields added match
			}
		}
		
		if ( iNumberProcessed > 250 ) // pretty light weight iteration each time so should not be too bad, tune this to taste
		{
			// do this in passes to ensure we don't tax server nor do we end up hitting a TMI
			DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSetupSpellBook( oSpellBookTable, sFieldName, iCurrent ) );
			return;
		}
	}
	CSLDataObjectStore( GetLocalString(oSpellBookTable, "DATATABLE_NAME") );
	DelayCommand(CSLRandomBetweenFloat(0.15f,fLoadInterval),CSLDataTableSortByPrefix( oSpellBookTable, "0,1,2,3,4,5,6,7,8,9,10" ) );
}


// * takes all rows of the given prefix and sorts them to the end of the table -- will this cause TMI on larger tables??? last 3 parameters allow extended processing
void CSLDataTableLoadSpellBookItemPropField( int iCurrentRow = -1 )
{
	//DEBUGGING = 5;
	
	if ( DEBUGGING > 5 ) { SendMessageToPC( GetFirstPC(), "Loading Item Property descending from row "+IntToString(iCurrentRow)+"..."); }
	
	object oSpellsTable = CSLDataObjectGet( "spells" );
	
	int iNumberProcessed = 0;
	int iCurrentIPRPRowId;
	string sSpellIndex;
	int iSpellIndex;
	
	string s2daName = "iprp_spells";
	if ( iCurrentRow == -1 )
	{
		iCurrentRow = GetNum2DARows( s2daName );
	}
	
	for ( iCurrentIPRPRowId = iCurrentRow; iCurrentIPRPRowId >= 0; iCurrentIPRPRowId--) // start at the top, as the correct and simplest version tends to come first, which makes the less likely ones likely to be overwritten
	{
		if ( iNumberProcessed > 500 ) // pretty light weight iteration each time so should not be too bad, tune this to taste
		{
			// do this in passes to ensure we don't tax server nor do we end up hitting a TMI
			DelayCommand( CSLRandomBetweenFloat(0.15f,0.25f), CSLDataTableLoadSpellBookItemPropField( iCurrentIPRPRowId ) );
			return;
		}
		
		sSpellIndex = Get2DAString( s2daName, "SpellIndex", iCurrentIPRPRowId );
		iSpellIndex = StringToInt(sSpellIndex);
		if ( sSpellIndex != "" && IntToString( iSpellIndex ) == sSpellIndex )
		{
			if ( GetLocalString(oSpellsTable, "D_"+IntToString( iSpellIndex )+"_NAME" ) != "" )
			{
				SetLocalString(oSpellsTable, "D_"+IntToString( iSpellIndex )+"_IPRPREFERENCE", IntToString(iCurrentIPRPRowId) );
			}
		}
		iNumberProcessed++;
	}
	
	// all done lets save it again
	//if ( GetStringUpperCase( CSLGetPreferenceString( "DataObjectLoadOption", "OFF" ) ) == "CACHE" )
	//{
		// always store it
		CSLDataObjectStore( GetLocalString(oSpellsTable, "DATATABLE_NAME") );
	//}
}
// CSLDataArray Functions