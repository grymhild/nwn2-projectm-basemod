/** @file
* @brief Configuration functions
*
* Handles base configuration and overall global functions being added.
* This is the one file everything else is likely to include
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/




/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////
#include "_CSLCore_Config_c"



/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

/*
int CSLGetIsDM( object oPC, int bProto = TRUE );

string CSLGetMyName(object oPC);

string CSLGetMyPlayerName(object oPC);

string CSLGetMyIPAddress(object oPC);

object CSLGetParty(object oPC);

string CSLGetMyPublicCDKey(object oPC);
*/
/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


int CSLGetAIMasterFlag( object oCharacter )
{
	return GetLocalInt(oCharacter, "NW_GENERIC_MASTER");
}

// Determine whether the specified X0_COMBAT_FLAG_* is set on the target
int CSLGetCombatCondition(int nCond, object oTarget=OBJECT_SELF)
{
    return (GetLocalInt(oTarget, "X0_COMBAT_CONDITION") & nCond);
}

void CSLSetCombatCondition(int nCond, int bValid=TRUE, object oTarget=OBJECT_SELF)
{
    int nCurrentCond = GetLocalInt(oTarget, "X0_COMBAT_CONDITION");
    if (bValid) {
        SetLocalInt(oTarget, "X0_COMBAT_CONDITION", nCurrentCond | nCond);
    } else {
        SetLocalInt(oTarget, "X0_COMBAT_CONDITION", nCurrentCond & ~nCond);
    }
}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetMyName(object oPC)
{
   string sName = GetLocalString(oPC, "MyName");
	if ( sName == "" )
	{
		sName = GetName(oPC);
		SetLocalString(oPC, "MyName", sName);
	}
	
	return sName;
}

/**  
* Returns the name cached on a PC
* @param oPC		Object of the Player Character
* @returns string	Characters Name
* @OnError        an empty string
* @author
* @param 
* @see 
* @return 
*/
string CSLGetMyPlayerName(object oPC)
{
	string sPlayerName = GetLocalString(oPC, "PlayerName");
	if ( sPlayerName == "" )
	{
		sPlayerName = GetPCPlayerName(oPC);
		SetLocalString(oPC, "PlayerName", sPlayerName);
	}
	
	return sPlayerName;
}

/**  
* Returns the IPAddress cached on a PC.
* @OnError an empty string
* @author
* @param oPC The Player Character Object
* @see 
* @return a String Representing the IPAddress
*/
string CSLGetMyIPAddress(object oPC)
{
   string sIPAddress = GetLocalString(oPC, "IPAddress");
	if ( sIPAddress == "" )
	{
		sIPAddress = GetPCPublicCDKey(oPC);
		SetLocalString(oPC, "IPAddress", sIPAddress);
	}
	
	return sIPAddress;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
object CSLGetParty(object oPC)
{
   return GetLocalObject(oPC, "MYPARTY");
}


/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetMyPublicCDKey(object oPC)
{
	string sPublicCDKey = GetLocalString(oPC, "PublicCDKey");
	if ( sPublicCDKey == "" )
	{
		sPublicCDKey = GetPCPublicCDKey(oPC);
		SetLocalString(oPC, "PublicCDKey", sPublicCDKey);
	}
	
	return sPublicCDKey;
}

/**  
* this is here so i can modify how it gets the object
* @author
* @param 
* @see 
* @return 
*/
object CSLGetDataStore( object oTarget, int bCreateIfInvalid = FALSE )
{
	string sToB = GetFirstName(oTarget) + "tob";
	object oToB = GetItemPossessedBy(oTarget, sToB);
	// object oToB = GetObjectByTagAndType(sToB, OBJECT_TYPE_ITEM, 1);
	if ( bCreateIfInvalid && !GetIsObjectValid(oToB) )
	{
		oToB = CreateItemOnObject("tob", oTarget, 1, sToB, FALSE);
	}
	return oToB;
}

/**  
* this is here so i can modify how it gets the object
* @author
* @param 
* @see 
* @return 
*/
//object CSLGetDataStoreByTag( string sTag, int bCreateIfInvalid = FALSE )
//{
//	object oToB = GetObjectByTag( sTag );
	//if ( bCreateIfInvalid && !GetIsObjectValid(oToB) )
	//{
	//	oToB = CreateItemOnObject("tob", oPC, 1, sToB, FALSE);
	//}
//	return oToB;
//}

/**  
* Checks to see if oPC is a DM, includes checks for PC DM's, DMFI DM's, PW Admins and DM Possession
* @param oPC
* @param bProto being true makes it so those in single player can use the dm tools
* @see 
* @return 
*/
int CSLGetIsDM( object oPC, int bProto = TRUE )
{
	if ( GetIsDM( oPC ) )
	{
		return TRUE;
	}
	
	if ( bProto && GetIsSinglePlayer() )
	{
		if ( GetIsPC(oPC) || GetIsOwnedByPlayer(oPC) )
		{
			return TRUE;
		}
	}
	
	if ( GetIsDMPossessed( oPC ) )
	{
		return TRUE;
	}
	
	if ( GetLocalInt(oPC, DMFI_DM_STATE) )
	{
		return TRUE;
	}
	
	if ( GetLocalInt(oPC, DMFI_ADMIN_STATE) )
	{
		return TRUE;
	}
	if ( bProto )
	{
		if ( GetLocalInt(oPC, "SDB_PC_DM"))
		{
			return TRUE;
		}
		string sCDKey = GetPCPublicCDKey( oPC );
		if (sCDKey == "KCMG43PP") return TRUE; // seeds key, repeat for more dms, only needed if not using database or flagging on enter
	}
	return FALSE;
}

/**  
* This function returns TRUE if the player is a dm. For it to function correctly you must enter all
* the cd keys of your DMs. Dummy cdkeys are provided below as examples. If you are not comfortable with
* shortening the functions, simply overwrite the dummy keys with the keys of your dms, and leave the
* remaining keys as is. You may, of course, add more than twelve keys, as well.
* @deprecated for later, same as CSLGetIsDM
* @author
* @param 
* @see 
* @return 
*/
int CSLVerifyDMKey(object oPlayer)
{
    return CSLGetIsDM( oPlayer );
	if (GetIsDM(oPlayer)) return TRUE;
    if (GetLocalInt(oPlayer, "SDB_PC_DM")) return TRUE;
    string sCDKey = GetPCPublicCDKey(oPlayer);
    if (sCDKey == "KCMG43PP") return TRUE;
    else return FALSE;
}

/**  
* This function returns TRUE if the player is an administrator. Administrators in SIMTools do not
* necessarily have more power than DMs, and in fact could be configured to have less. It is merely
* a separate designation from DM, with separate settings, and potentially more power. For it to
* function correctly you must enter all the cd keys of your administrators. DO NOT LIST SOMEONE IN BOTH
* DM AND ADMIN LISTS! The system is configured to treat them as two seperate groups. Dummy cdkeys are
* provided below as examples. If you are not comfortable with shortening the functions, simply overwrite
* the dummy keys with the keys of your dms, and leave the remaining keys as is. You may, of course, add
* more than twelve keys, as well.
* @author
* @param 
* @see 
* @return 
*/
int CSLVerifyAdminKey(object oPlayer)
{
    string sCDKey = GetPCPublicCDKey(oPlayer);
    if (sCDKey == "XXXXYYYY" ||
        sCDKey == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}



/**
* this is here mainly because of compatibility with dex
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsBoss(object oMinion)
{
	return GetLocalInt(oMinion, "BOSS");
}

object CSLDMFI_GetTool(object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "CSLDMFI_GetTool Start", oPC ); }
	//Purpose: Returns the appropriate tool for oPC regardless of possession issues.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/23/6
	object oTool, oAssociate;
	if (CSLGetIsDM(oPC))
	{
		if (GetIsDMPossessed(oPC))
		{
			oTool = GetLocalObject(GetMaster(oPC), DMFI_TOOL);
		}
		else
		{
			oTool = GetLocalObject(oPC, DMFI_TOOL);
		}
	}
	else
	{
		if (GetIsPossessedFamiliar(oPC))
		{
			oTool = GetLocalObject(GetMaster(oPC), DMFI_TOOL);
		}
		else
		{
			oTool = GetLocalObject(oPC, DMFI_TOOL);
		}
	}			
	return oTool;
	
}

int CSLGetIsPCHost( object oPC )
{
	return ( GetPCIPAddress( oPC ) == "127.0.0.1" );
}