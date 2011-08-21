#include "_CSLCore_Position"
#include "_CSLCore_Strings"

// Name     : NWNX include
// Purpose  : Functions for querying NWNX status and installed plugins
// Author   : Ingmar Stieger (Papillon)
// Modified : 04/29/2007
// Copyright: This file is licensed under the terms of the
//            GNU GENERAL PUBLIC LICENSE (GPL) Version 2
/**/


// Name     : NWNX SQL include
// Purpose  : Scripting functions for NWNX SQL plugins
// Author   : Ingmar Stieger (Papillon)
// Modified : 09/12/2006
// Copyright: This file is licensed under the terms of the
//            GNU GENERAL PUBLIC LICENSE (GPL) Version 2
//            Based on aps_include by Ingmar Stieger, Adam Colon, Josh Simon

/************************************/
/* Constants                        */
/************************************/

const int CSLSQL_ERROR = 0;
const int CSLSQL_SUCCESS = 1;

const string timeSpacer = "                                               ";

/************************************/
/* Function prototypes              */
/************************************/
string CSLNWNX_SQLGetData(int iCol);

/*
string CSLNWNX_SQLEncodeSpecialChars(string sString);
int CSLNWNX_SQLGetDataInt(int iCol);
void CSLNWNX_SQLExecDirect(string sSQL);
int CSLNWNX_SQLFetch(string mode = " ");

int CSLNWNX_SQLGetAffectedRows();
void CSLSetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0, string sTable = "pwdata");
string CSLGetPersistentString(object oObject, string sVarName, string sTable = "pwdata");
void CSLSetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration = 0, string sTable = "pwdata");
int CSLGetPersistentInt(object oObject, string sVarName, string sTable = "pwdata");
void CSLSetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration = 0, string sTable = "pwdata");
float CSLGetPersistentFloat(object oObject, string sVarName, string sTable = "pwdata");
void CSLSetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration = 0, string sTable = "pwdata");
location CSLGetPersistentLocation(object oObject, string sVarname, string sTable = "pwdata");
void CSLSetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration = 0, string sTable = "pwdata");
vector CSLGetPersistentVector(object oObject, string sVarName, string sTable = "pwdata");
void CSLSetPersistentObject(object oOwner, string sVarName, object oObject2, int iExpiration = 0, string sTable = "pwobjdata");
object CSLGetPersistentObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID, string sTable = "pwobjdata");
void CSLDeletePersistentVariable(object oObject, string sVarName, string sTable = "pwdata");
void CSLNWNXStartTimer(object oObject, string sName);
string CSLNWNXStopTimer(object oObject, string sName);
string CSLNWNXQueryTimer(object oObject, string sName);
*/

/************************************/
/* Implementation                   */
/************************************/

/**  
* return TRUE if NWNX is installed
* @author Ingmar Stieger (Papillon)
* @see 
* @replaces XXXNWNXInstalled
* @return 
*/
int CSLNWNX_Installed()
{
    return NWNXGetInt("NWNX", "INSTALLED", "", 0);
}

/**  
* return number of registered plugins / function classes
* @author Ingmar Stieger (Papillon)
* @see 
* @replaces XXXNWNXGetPluginCount
* @return 
*/
int CSLNWNX_GetPluginCount()
{
    return NWNXGetInt("NWNX", "GET PLUGIN COUNT", "", 0);    
}

/**  
* return function class specified by parameter nPlugin
* @author Ingmar Stieger (Papillon)
* @param nPlugin
* @see 
* @replaces XXXNWNXGetPluginClass
* @return 
*/
string CSLNWNX_GetPluginClass(int nPlugin)
{
    return NWNXGetString("NWNX", "GET PLUGIN CLASS", "", nPlugin);
}

/**  
* 
* @author Ingmar Stieger (Papillon)
* @param sClass
* @see 
* @replaces XXXNWNXGetPluginSubClass
* @return 
*/
string CSLNWNX_GetPluginSubClass(string sClass)
{
	//SetLocalString(GetModule(), "NWNX!" + sClass + "!GET_SUBCLASS", sSpacer);
	//return(GetLocalString(GetModule(), "NWNX!" + sClass + "!GET_SUBCLASS"));
    
    return NWNXGetString(sClass, "GET SUBCLASS", "", 0);
}

/**  
* 
* @author Ingmar Stieger (Papillon)
* @param sClass
* @see 
* @replaces XXXNWNXGetPluginVersion
* @return 
*/
string CSLNWNX_GetPluginVersion(string sClass)
{
	//SetLocalString(GetModule(), "NWNX!" + sClass + "!GET_VERSION", sSpacer);
	//return(GetLocalString(GetModule(), "NWNX!" + sClass + "!GET_VERSION"));
    return NWNXGetString(sClass, "GET VERSION", "", 0);
}

/**  
* 
* @author Ingmar Stieger (Papillon)
* @param sClass
* @see 
* @replaces XXXNWNXGetPluginDescription
* @return 
*/
string CSLNWNX_GetPluginDescription(string sClass)
{
    /*
	int i;
    string sBigSpacer;
	
    // Create placeholder for (possibly) long descriptions
    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
       	sBigSpacer += sSpacer;
    
	SetLocalString(GetModule(), "NWNX!" + sClass + "!GET_DESCRIPTION", sBigSpacer);
	return(GetLocalString(GetModule(), "NWNX!" + sClass + "!GET_DESCRIPTION"));
    */
    return NWNXGetString(sClass, "GET DESCRIPTION", "", 0);
}



/**  
* Replace special characters (like ') in a database compatible way.
* Problems can arise with SQL commands if variables or values have single quotes
* in their names. This function encodes these quotes so the underlying database
* can safely store them.
* @author Ingmar Stieger (Papillon)
* @param sString
* @see 
* @replaces XXXSQLEncodeSpecialChars
* @return 
*/
string CSLNWNX_SQLEncodeSpecialChars(string sString)
{
    return NWNXGetString("SQL", "GET ESCAPE STRING", sString, 0);
}

/**  
* Puts single quotes around a given character, using NWNx escaping functions to deal with quotes in the input string
* @author Brian Meyer
* @param sIn String to be Quoted
* @todo need to rework this, soas to use NWNX on a server, and string functions when not
* @return Quoted and escaped string prepared for use in a database
*/
string CSLInQs( string sIn )
{ // Encodes Special Chars and Encloses a string in Single Quotes
	
	return "'" + CSLNWNX_SQLEncodeSpecialChars( sIn ) + "'";
	//return "'" + CSLNWNX_SQLEncodeSpecialChars(sIn) + "'";
	//return "'" + sIn + "'";
}


/**  
* 
* @author Ingmar Stieger (Papillon)
* @param iCol
* @see 
* @replaces XXXSQLGetDataInt
* @return 
*/
int CSLNWNX_SQLGetDataInt(int iCol)
{
   return StringToInt(CSLNWNX_SQLGetData(iCol));
}

/**  
* Execute statement in sSQL
* @author Ingmar Stieger (Papillon)
* @param sSQL
* @see CSLNWNX_SQLFetch
* @replaces XXXSQLExecDirect
* @return 
*/
void CSLNWNX_SQLExecDirect(string sSQL)
{
    NWNXSetString("SQL", "EXEC", sSQL, 0, "");
}

/**  
* Position cursor on next row of the resultset
* Call this before using CSLNWNX_SQLGetData().
* @author Ingmar Stieger (Papillon)
* @param mode Leave the parameter empty to advance to the next row, Pass "NEXT" as parameter to fetch the first row of the next resultset (for statements that return multiple resultsets)
* @see CSLNWNX_SQLGetData, CSLNWNX_SQLExecDirect
* @replaces XXXSQLFetch
* @return CSLSQL_SUCCESS if there is a row, CSLSQL_ERROR if there are no more rows
*/
int CSLNWNX_SQLFetch(string mode = " ")
{
    return NWNXGetInt("SQL", "FETCH", mode, 0);
}

/**  
* Return value of column iCol in the current row of result set sResultSetName
* Maximum column size: 65KByte
* @author Ingmar Stieger (Papillon)
* @param iCol
* @see CSLNWNX_SQLFetch, CSLNWNX_SQLExecDirect
* @replaces XXXSQLGetData, XXXSQLGetDataText
* @return 
*/
string CSLNWNX_SQLGetData(int iCol)
{
    return NWNXGetString("SQL", "GETDATA", "", iCol - 1);
}


/**  
* Return the number of rows that were affected by the last 
* INSERT, UPDATE, or DELETE operation.
* @author Ingmar Stieger (Papillon)
* @replaces XXXSQLGetAffectedRows
* @return 
*/
int CSLNWNX_SQLGetAffectedRows()
{
    return NWNXGetInt("SQL", "GET AFFECTED ROWS", "", 0);
}

/**  
* Start a timer named sName on object oObject 
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sName
* @see CSLNWNXStopTimer
* @replaces XXXStartTimer
* @return 
*/
void CSLNWNXStartTimer(object oObject, string sName)
{
    SetLocalString(oObject, "NWNX!TIME!START!" + sName + ObjectToString(oObject), timeSpacer);
}


/**  
* Stop a timer named sName on object oObject 
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sName)
* @see CSLNWNXStartTimer
* @replaces XXXStopTimer
* @return 
*/
string CSLNWNXStopTimer(object oObject, string sName)
{
    SetLocalString(oObject, "NWNX!TIME!STOP!" + sName + ObjectToString(oObject), timeSpacer);
    return GetLocalString(oObject, "NWNX!TIME!STOP!"  + sName + ObjectToString(oObject));
}


/**  
* Query a timer named sName on object oObject 
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sName
* @see 
* @replaces XXXQueryTimer
* @return 
*/
string CSLNWNXQueryTimer(object oObject, string sName)
{
    SetLocalString(oObject, "NWNX!TIME!QUERY!" + sName + ObjectToString(oObject), timeSpacer);
    return GetLocalString(oObject, "NWNX!TIME!QUERY!" + sName + ObjectToString(oObject));
}



/**  
* Set oObject's persistent string variable sVarName to sValue
* These functions are responsible for transporting the various data types back
* and forth to the database.
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param sValue
* @param iExpiration Number of days the persistent variable should be kept in database (default: 0=forever)
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXSetPersistentString, XXXSetPersistantLocalString
* @return 
*/
void CSLSetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0, string sTable = "pwdata")
{
    if ( CSLNWNX_Installed() )
    {
		string sPlayer;
		string sTag;
	
		if (GetIsPC(oObject))
		{
			sPlayer = CSLNWNX_SQLEncodeSpecialChars(GetPCPlayerName(oObject));
			sTag = CSLNWNX_SQLEncodeSpecialChars(GetName(oObject));
		}
		else
		{
			sPlayer = "~";
			sTag = GetTag(oObject);
		}
	
		sVarName = CSLNWNX_SQLEncodeSpecialChars(sVarName);
		sValue = CSLNWNX_SQLEncodeSpecialChars(sValue);
	
		string sSQL = "SELECT player FROM " + sTable + " WHERE player='" + sPlayer +
			"' AND tag='" + sTag + "' AND name='" + sVarName + "'";
		CSLNWNX_SQLExecDirect(sSQL);
	
		if (CSLNWNX_SQLFetch() == CSLSQL_SUCCESS)
		{
			// row exists
			sSQL = "UPDATE " + sTable + " SET val='" + sValue +
				"',expire=" + IntToString(iExpiration) + " WHERE player='" + sPlayer +
				"' AND tag='" + sTag + "' AND name='" + sVarName + "'";
			CSLNWNX_SQLExecDirect(sSQL);
		}
		else
		{
			// row doesn't exist
			sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
				"('" + sPlayer + "','" + sTag + "','" + sVarName + "','" +
				sValue + "'," + IntToString(iExpiration) + ")";
			CSLNWNX_SQLExecDirect(sSQL);
		}
    }
    else
    {
    	//SetGlobalString(sVarName, sList);
    	SetCampaignString( sTable, sVarName, sValue, oObject);
    }
}


/**  
* Get oObject's persistent string variable sVarName
* Optional parameters:
* @param sTable: Name of the table where variable is stored (default: pwdata)
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @onerror ""
* @replaces XXXGetPersistentString, XXXGetPersistantLocalString
* @return 
*/
string CSLGetPersistentString(object oObject, string sVarName, string sTable = "pwdata")
{
    if ( CSLNWNX_Installed() )
    {
		string sPlayer;
		string sTag;
	
		if (GetIsPC(oObject))
		{
			sPlayer = CSLNWNX_SQLEncodeSpecialChars(GetPCPlayerName(oObject));
			sTag = CSLNWNX_SQLEncodeSpecialChars(GetName(oObject));
		}
		else
		{
			sPlayer = "~";
			sTag = GetTag(oObject);
		}
	
		sVarName = CSLNWNX_SQLEncodeSpecialChars(sVarName);
	
		string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
			"' AND tag='" + sTag + "' AND name='" + sVarName + "'";
		CSLNWNX_SQLExecDirect(sSQL);
	
		if (CSLNWNX_SQLFetch() == CSLSQL_SUCCESS)
			return CSLNWNX_SQLGetData(1);
		else
		{
			return "";
			// If you want to convert your existing persistent data to SQL, this
			// would be the place to do it. The requested variable was not found
			// in the database, you should
			// 1) query it's value using your existing persistence functions
			// 2) save the value to the database using CSLSetPersistentString()
			// 3) return the string value here.
		}
    }
    
    	//SetGlobalString(sVarName, sList);
    return GetCampaignString( sTable, sVarName, oObject);
    
}


/**  
* Set oObject's persistent integer variable sVarName to iValue
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param iValue
* @param iExpiration Number of days the persistent variable should be kept in database (default: 0=forever)
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXSetPersistentInt, XXXSetPersistantLocalInt
* @return 
*/
void CSLSetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration = 0, string sTable = "pwdata")
{
    CSLSetPersistentString(oObject, sVarName, IntToString(iValue), iExpiration, sTable);
}


/**  
* Get oObject's persistent integer variable sVarName
* @param sTable: Name of the table where variable is stored (default: pwdata)
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXGetPersistentInt , XXXGetPersistantLocalInt
* @return 
* @onerror 0
*/
int CSLGetPersistentInt(object oObject, string sVarName, string sTable = "pwdata")
{
    return StringToInt( CSLGetPersistentString( oObject, sVarName, sTable ) );
}


/**  
* Set oObject's persistent float variable sVarName to fValue
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param fValue
* @param iExpiration Number of days the persistent variable should be kept in database (default: 0=forever)
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXSetPersistentFloat
* @return 
*/
void CSLSetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration = 0, string sTable = "pwdata")
{
    CSLSetPersistentString(oObject, sVarName, FloatToString(fValue), iExpiration, sTable);
}

/**  
* Get oObject's persistent float variable sVarName
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXGetPersistentFloat
* @onerror 0
* @return 
*/
float CSLGetPersistentFloat(object oObject, string sVarName, string sTable = "pwdata")
{
    return StringToFloat( CSLGetPersistentString( oObject, sVarName, sTable ) );
   
}

/**  
* Set oObject's persistent location variable sVarName to lLocation
* Optional parameters:
*   This function converts location to a string for storage in the database. 
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param lLocation
* @param iExpiration Number of days the persistent variable should be kept in database (default: 0=forever)
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXSetPersistentLocation
* @return 
*/
void CSLSetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration = 0, string sTable = "pwdata")
{
    CSLSetPersistentString(oObject, sVarName, CSLSerializeLocation(lLocation), iExpiration, sTable);
}

/** 
* Get oObject's persistent location variable sVarName
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param sTable  Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXGetPersistentLocation
* @onerror 0
* @return
*/
location CSLGetPersistentLocation(object oObject, string sVarName, string sTable = "pwdata")
{
    return CSLUnserializeLocation(CSLGetPersistentString(oObject, sVarName, sTable));
}

/**  
* Set oObject's persistent vector variable sVarName to vVector
*   This function converts vector to a string for storage in the database.
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param vector vVector
* @param iExpiration Number of days the persistent variable should be kept in database (default: 0=forever)
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXSetPersistentVector
* @return 
*/
void CSLSetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration = 0, string sTable = "pwdata")
{
    CSLSetPersistentString(oObject, sVarName, CSLSerializeVector(vVector), iExpiration, sTable);
}

/**  
* Get oObject's persistent vector variable sVarName
* @author Ingmar Stieger (Papillon)
* @param oObject
* @param sVarName
* @param sTable Name of the table where variable should be stored (default: pwdata)
* @see 
* @replaces XXXGetPersistentVector
* @onerror 0
* @return 
*/
vector CSLGetPersistentVector(object oObject, string sVarName, string sTable = "pwdata")
{
    return CSLUnserializeVector(CSLGetPersistentString(oObject, sVarName, sTable));
}


/**  
* Set oObject's persistent object with sVarName to sValue
* @bug original does not match prototype exactly on first parameter void CSLSetPersistentObject(object oObject, string sVarName, object oObject2, int iExpiration = 0, string sTable = "pwobjdata");
* possibly a logic error since the parameters here are opposite of those in CSLGetPersistentObject
* @author Ingmar Stieger (Papillon)
* @param oOwner
* @param sVarName
* @param oObject
* @param iExpiration Number of days the persistent variable should be kept in database (default: 0=forever)
* @param sTable Name of the table where variable should be stored (default: pwobjdata)
* @see 
* @replaces XXXSetPersistentObject
* @onerror
* @return 
*/
void CSLSetPersistentObject(object oOwner, string sVarName, object oObject, int iExpiration = 0, string sTable = "pwobjdata")
{
    if ( CSLNWNX_Installed() )
    {
		string sPlayer;
		string sTag;
	
		if (GetIsPC(oOwner))
		{
			sPlayer = CSLNWNX_SQLEncodeSpecialChars(GetPCPlayerName(oOwner));
			sTag = CSLNWNX_SQLEncodeSpecialChars(GetName(oOwner));
		}
		else
		{
			sPlayer = "~";
			sTag = GetTag(oOwner);
		}
		sVarName = CSLNWNX_SQLEncodeSpecialChars(sVarName);
	
		string sSQL = "SELECT player FROM " + sTable + " WHERE player='" + sPlayer +
			"' AND tag='" + sTag + "' AND name='" + sVarName + "'";
		CSLNWNX_SQLExecDirect(sSQL);
	
		if (CSLNWNX_SQLFetch() == CSLSQL_SUCCESS)
		{
			// row exists
			sSQL = "UPDATE " + sTable + " SET val=%s,expire=" + IntToString(iExpiration) +
				" WHERE player='" + sPlayer + "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
			SetLocalString(GetModule(), "NWNX!SQL!SETSCORCOSQL", sSQL);
			StoreCampaignObject ("NWNX", "-", oObject);
		}
		else
		{
			// row doesn't exist
			sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
				"('" + sPlayer + "','" + sTag + "','" + sVarName + "',%s," + IntToString(iExpiration) + ")";
			SetLocalString(GetModule(), "NWNX!SQL!SETSCORCOSQL", sSQL);
			StoreCampaignObject ("NWNX", "-", oObject);
		}
    }
    else
    {
    	//DeleteCampaignVariable( sTable, sVarName, oObject);
    	StoreCampaignObject(sTable, sVarName, oObject, oOwner);
    }
}


/**  
* Get oObject's persistent object sVarName
* @author Ingmar Stieger (Papillon)
* @param oOwner
* @param sVarName
* @param oObject
* @param sTable Name of the table where variable should be stored (default: pwobjdata)
* @see 
* @replaces XXXGetPersistentObject
* @onerror 0
* @return 
*/
object CSLGetPersistentObject(object oOwner, string sVarName, object oObject = OBJECT_INVALID, string sTable = "pwobjdata")
{
    if ( CSLNWNX_Installed() )
    {
		string sPlayer;
		string sTag;
		object oModule;
	
		if (GetIsPC(oOwner))
		{
			sPlayer = CSLNWNX_SQLEncodeSpecialChars(GetPCPlayerName(oOwner));
			sTag = CSLNWNX_SQLEncodeSpecialChars(GetName(oOwner));
		}
		else
		{
			sPlayer = "~";
			sTag = GetTag(oOwner);
		}
		sVarName = CSLNWNX_SQLEncodeSpecialChars(sVarName);
	
		string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
			"' AND tag='" + sTag + "' AND name='" + sVarName + "'";
		SetLocalString(GetModule(), "NWNX!SQL!SETSCORCOSQL", sSQL);
	
		if ( !GetIsObjectValid(oObject) )
		{
			oObject = oOwner;
		}
		return RetrieveCampaignObject ("NWNX", "-", GetLocation(oObject), oObject);
    }
   
    return RetrieveCampaignObject( sTable, sVarName, GetLocation(oObject), oObject, oOwner);
    
}


/**  
* Delete persistent variable sVarName stored on oObject
* @author Ingmar Stieger (Papillon)
* @param oOwner
* @param sVarName
* @param sTable Name of the table where variable is stored (default: pwdata) 
* @see 
* @replaces XXXDeletePersistentVariable , XXXDeletePersistantLocalInt
* @return 
*/
void CSLDeletePersistentVariable(object oOwner, string sVarName, string sTable = "pwdata")
{
    if ( CSLNWNX_Installed() )
    {
		string sPlayer;
		string sTag;
	
		if (GetIsPC(oOwner))
		{
			sPlayer = CSLNWNX_SQLEncodeSpecialChars(GetPCPlayerName(oOwner));
			sTag = CSLNWNX_SQLEncodeSpecialChars(GetName(oOwner));
		}
		else
		{
			sPlayer = "~";
			sTag = GetTag(oOwner);
		}
	
		sVarName = CSLNWNX_SQLEncodeSpecialChars(sVarName);
		string sSQL = "DELETE FROM " + sTable + " WHERE player='" + sPlayer + "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
		CSLNWNX_SQLExecDirect(sSQL);
    }
    else
    {
    	DeleteCampaignVariable( sTable, sVarName, oOwner);
    }
}