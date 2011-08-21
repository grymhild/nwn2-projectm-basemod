/** @file
* @brief Player related functions to handle experience, stats, skills, leveling and the like
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
// duplicate CSLSetAssociateState
*/





/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

#include "_CSLCore_Nwnx"
#include "_CSLCore_Strings"
#include "_CSLCore_Math"
#include "_CSLCore_Messages"
#include "_CSLCore_Time"
#include "_CSLCore_Magic"
#include "_CSLCore_Position"
#include "_CSLCore_Environment"
#include "_CSLCore_Reputation"
#include "_CSLCore_Items"


// This supports skywings client extension
const int CLIENTEXT_NONE = BIT0; // used to clear settings.
const int CLIENTEXT_PER_AREA_MAP_CONTROLS = BIT1;// Toggles per area negotiation
const int CLIENTEXT_NO_MAP_ENVIRON = BIT2; // The area map should not show environmentals and placeables.
const int CLIENTEXT_NO_MAP_DOORS = BIT3; // The area map should not show doors.
const int CLIENTEXT_NO_MAP_TRAPS = BIT4; // The area map should not show discovered traps.
const int CLIENTEXT_NO_MAP_CREATURES = BIT5; // The area map should not show detected creatures.
const int CLIENTEXT_NO_MAP_PATHING = BIT6; // The area map should not show pathing orders.
const int CLIENTEXT_NO_MAP_BACKGROUND = BIT7; // The area map should not display a detailed background.


const int SPELLDM_INVULN = -56;

// * Chat Attributes/Permissions - this is just getting started
const int CSL_PERM_NONE = BIT0;
const int CSL_PERM_PCLIVING = BIT1;
const int CSL_PERM_PCFREEACTION = BIT2;
const int CSL_PERM_DMONLY = BIT3;
const int CSL_PERM_TELLONLY = BIT4;




// these are always negative, just there for DM effects, and the ranges are such so as to prevent conflicts, but still allow them to be treated like a spellid
const int CSL_CHARMOD_SPELLSTATID = 15000; // +1 to 7
const int CSL_CHARMOD_SPELLHITPOINTSID = 15009; // single value
const int CSL_CHARMOD_SPELLSAVEID = 15010; // +1 to 3
const int CSL_CHARMOD_SPELLATTACKID = 15014; // +0 to 2
const int CSL_CHARMOD_SPELLACID = 15015; // +0 to 4
const int CSL_CHARMOD_SPELLRESISTID = 15020; // single value
const int CSL_CHARMOD_SPELLARCSPELLFAILID = 15030; // single value
const int CSL_CHARMOD_SPELLARMORCHECKPENID = 15031; // single value
const int CSL_CHARMOD_SPELLSKILLID = 15100; // single value

const int CSL_CHARMOD_SPELLDAMAGEID = 16000; // +0 to 2048 and very large values, so it's a bit odd


//const int CSL_CHARMOD_HENCHMODIFIERID = 18050; // +0 to 2048 and very large values, so it's a bit odd


const int DAMAGE_TYPE_VARIED = 3; // invalid constant which makes damage end up changing based on weapon type held
/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////
/*
int CSLIsTester(object oPlayer);
void CSLTestMsg(object oPC, string sMsg);
void CSLFindAoEs(object oArea);
int CSLPCCanEnterArea(object oPC, object oArea=OBJECT_INVALID);
void CSLToggleOnOff(object oObject, int nState=-1);
int CSLStoneCasterInTown(object oPC);
int CSLGetIsInTown(object oPC);
int CSLGetECL(int nSubRace );
void CSLSetLastRest(object oPC, int nTime);
int CSLGetRealLevel(object oPC);
int CSLGetXPByLevel(int iLevel);
object CSLGetKiller(object oKilled);
void CSLSaveParty(object oPC, object oLeader);

void CSLPartySplitDelayed(object oPC, int nSplitGold);
void CSLPartySplit(object oPC, int nSplitGold);



int CSLCountParty(object oPC, int nDist = 0);


// PC and level
int CSLGetLevelAdjustment(object oCreature);
int CSLGetPCAverageLevel();
int CSLGetPCAverageXP();
int CSLGetXPForLevel(int iLv);
void CSLLevelUpCreature(object oPC, int iLv, int iAuto=FALSE);


void CSLAddCompanion(object oPC, string sRef, int iJn=0, int iALv=TRUE);
void CSLSelectParty(object oPC, int iMdt=FALSE, int iPSz=3, string sScr="");
*/


////////////////////////////////////////////////////
////////// Implementation //////////////////////////
////////////////////////////////////////////////////





/**  
* Variable name to mark tasks as having been done
* @author
* @param 
* @see
* @replaces XXXGetDoneFlag
* @return 
*/
string CSLDoneFlag(int iFlag=0)
{
	return( "DoneOnce" + (iFlag==0?"":IntToString(iFlag)));
}

/**  
* Checks to see if Done Flag has been set
* @author
* @param 
* @see
// 
* @replaces XXXIsMarkedAsDone
* @return 
*/
int CSLDoneFlag_IsSet(object oObject=OBJECT_SELF, int iFlag=0)
{
    int iDoneOnce = GetLocalInt(oObject, CSLDoneFlag(iFlag));
	return (iDoneOnce);
}

/**  
* Marks Done Flag as being set, soas to prevent multiple trys
* @author
* @param 
* @see
* @replaces XXXMarkAsDone
* @return 
*/
void CSLDoneFlag_Set(object oObject=OBJECT_SELF, int iFlag=0)
{
	SetLocalInt(oObject, CSLDoneFlag(iFlag), TRUE);
}

/**  
* Marks Done Flag as not being set so player can try again
* @author
* @param 
* @see
* @replaces XXXMarkAsUndone
* @return 
*/
void CSLDoneFlag_UnSet(object oObject=OBJECT_SELF, int iFlag=0)
{
	SetLocalInt(oObject, CSLDoneFlag(iFlag), FALSE);
}






/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLAbilityStatToString(int nAbilityType, int bLong = FALSE)
{
	if (nAbilityType==ABILITY_STRENGTH) return (bLong) ? "Strength"      : "STR";
	if (nAbilityType==ABILITY_DEXTERITY) return (bLong) ? "Dexterity"     : "DEX";
	if (nAbilityType==ABILITY_CONSTITUTION) return (bLong) ? "Consititution" : "CON";
	if (nAbilityType==ABILITY_INTELLIGENCE) return (bLong) ? "Intelligence"  : "INT";
	if (nAbilityType==ABILITY_WISDOM) return (bLong) ? "Wisdom"        : "WIS";
	if (nAbilityType==ABILITY_CHARISMA) return (bLong) ? "Charisma"      : "CHA";
	return "Missing Ability Text";
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetNegativeLevels( object oTarget = OBJECT_SELF)
{
	return CSLGetMax( 0, GetTotalLevels(oTarget, FALSE)-GetTotalLevels(oTarget, TRUE) ); //  
}



void CSLClearAllDialogue(object oPC, object oNPC=OBJECT_SELF)
{
	SetLocalInt(oPC, GetTag(oNPC) + "_ADV", FALSE);
	SetLocalInt(oNPC, "X0_CURRENT_ONE_LINER", FALSE);
	SetLocalInt(oPC, GetTag(oNPC) + "_INTJ_SET", FALSE);
	SetLocalInt(oPC, GetTag(oNPC) + "_INTJ", FALSE);
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Used in OEI Core Functions
// Use to fire the PC's current henchman
void CSLFireHenchman(object oPC, object oHench=OBJECT_SELF)
{
	if ( !GetIsObjectValid(oPC) || !GetIsObjectValid(oHench) )
	{
			//DBG_msg("Invalid PC or henchman!");
			return;
	}
	// * turn off stealth mode
	SetActionMode(oHench, ACTION_MODE_STEALTH, FALSE);
	// If we're firing the henchman after s/he died,
	// clear that first, since we're not really "hired"
	
	
	// "NW_L_HEN_I_DIED"
	//SetBooleaiValue(OBJECT_SELF, "NW_L_HEN_I_DIED", FALSE);
	SetLocalInt(oHench, "NW_L_HEN_I_DIED", FALSE);
	// SCSetDidDie(FALSE, oHench);
	
	SetLocalInt(oPC, GetTag(oHench) + "_GOTKILLED", FALSE); // SCSetKilled(oPC, oHench, FALSE);
	
	

	SetLocalInt(oPC, GetTag(oHench) + "_RESURRECTED", FALSE); // SCSetResurrected(oPC, oHench, FALSE);

	// Now double-check that this is actually our master
	if (!GetIsObjectValid(GetMaster(oHench)) || GetMaster(oHench) != oPC)
	{
			//DBG_msg("SCAIFireHenchman: not hired or this PC isn't her master.");
			return;
	}

	// Remove the henchman ClearAllActions(bClearCombat)
	AssignCommand(oHench, ClearAllActions(FALSE));
	RemoveHenchman(oPC, oHench);

	//Store former henchmen for retrieval in Interlude
	// April 28 2003. This storage only happens in Chapter 1
	string sModTag = GetTag(GetModule());
	if (sModTag == "x0_module1")
	{
		if (GetTag(oHench) == "x0_hen_xan")
		{
			StoreCampaignObject("dbHenchmen", "xp0_hen_xan", oHench);
		}
		else if (GetTag(oHench) == "x0_hen_dor")
		{
			StoreCampaignObject("dbHenchmen", "xp0_hen_dor", oHench);
		}
	}

	//DBG_msg("Removed henchman");
	// Clear everything that was previously set, EXCEPT
	// that the player has hired -- that info we want to
	// keep for the future.

	// Clear this out so if the henchman gets killed while
	// unhired, she won't think this PC is still her master
	
	SetLocalObject(oHench, "X0_LAST_MASTER_TAG", OBJECT_INVALID);
	// Clear dialogue events
	//SCClearAllDialogue(oPC, oHench);
	CSLClearAllDialogue(oPC, oHench);
	// Send the henchman home
	// APril 2003: Cut this. Make them stay where they are.
	// ExecuteScript(sGoHomeScript, oHench);
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLGetCreatureIdentifier( object oPC )
{
	string sCreatureIdentifier = GetLocalString(oPC, "PlayerID" ); // use the player id assigned on player entry so it keeps working like i had it before
	
	if ( sCreatureIdentifier != "" )
	{
		return sCreatureIdentifier;
	}
	
	// unique string to describe said creature and prevent duplicates - this will like vary from system to system
	if (GetIsPC(oPC))
	{
		sCreatureIdentifier = CSLGetLegalCharacterString( GetPCPlayerName(oPC) )+"_"+ CSLGetLegalCharacterString( GetName(oPC) );
	}
	else
	{
		sCreatureIdentifier = "M"+ObjectToString( oPC );
	}
	
	SetLocalString(oPC, "PlayerID",  sCreatureIdentifier  );
	
	// in case this is an NPC	
	return sCreatureIdentifier;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLCheckPermissions( object oSender, int iAttributes = CSL_PERM_NONE, float fSpamDuration = 0.0f  )
{
	
	if ( iAttributes == CSL_PERM_NONE )
	{ 
		return TRUE;
	}
	
	
	//object oSender = CSLGetChatSender();
	
	// object oTarget = CSLGetChatTarget();
	
	
	//int nChannel = CSLGetChatChannel();
	//if ( nChannel == CHAT_MODE_SHOUT ) // block based on channel
	//{
	//	return FALSE;
	//}
	
	
	
	if ( ( iAttributes & CSL_PERM_PCLIVING && GetIsDead( oSender ) ) && !CSLGetIsDM(oSender) )
	{
		return FALSE;
	}
	
	if ( iAttributes & CSL_PERM_DMONLY && !CSLGetIsDM( oSender ) )
	{
		return FALSE;
	}
	
	return TRUE; // it's permitted
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
//* toggles client settings for skywings Client Extender
// * Example usage which hides placeables, doors and traps
// * CSLClientExtProperties( CLIENTEXT_NO_MAP_ENVIRON | CLIENTEXT_NO_MAP_DOORS | CLIENTEXT_NO_MAP_TRAPS );
// * iClientSettings is an integer using the following bit constants CLIENTEXT_NONE, CLIENTEXT_PER_AREA_MAP_CONTROLS, 
// *          CLIENTEXT_NO_MAP_ENVIRON, CLIENTEXT_NO_MAP_DOORS, CLIENTEXT_NO_MAP_TRAPS, CLIENTEXT_NO_MAP_CREATURES, CLIENTEXT_NO_MAP_PATHING
// * oPC is the player object, should be the actual player, defaults to OBJECT_SELF
void CSLClientExtProperties( int iClientSettings = CLIENTEXT_NONE, object oPC = OBJECT_SELF )
{
	if ( GetLocalInt(oPC, "SCLIENTEXTENDER") == TRUE ) // i set this on entry if they are using the client extender
	{
		string sHexString = IntToHexString( iClientSettings ); // * Return value has the format "0x????????" where each ? will be a hex digit
		SendMessageToPC(oPC,"SCliExt10" + GetStringRight( sHexString, 8 ) );
	}
	// sends "SCliExt1000000002" for BIT2, as an example
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// majormajor = (version >> 24) & 0xff; majorminor = (version >> 16) & 0xff; minormajor = (version >>  & 0xff; minorminor = version & 0xff;
void CSLClientExtSetModulePlayerProperties( int iClientSettings = CLIENTEXT_NONE )
{
	SetLocalInt( GetModule(), "SCLIENTEXTENDERPROPS", iClientSettings );
	
	object oTarget = GetFirstPC();
	while (GetIsObjectValid(oTarget)) // LOOP OVER ALL PC'S
	{
		if ( !GetIsDM( oTarget ) )
		{
			CSLClientExtProperties( iClientSettings, oTarget );
		}
		oTarget = GetNextPC();
	}

}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLClientExtSetModuleDMProperties( int iClientSettings = CLIENTEXT_NONE )
{
	SetLocalInt( GetModule(), "SCLIENTEXTENDERPROPSDM", iClientSettings );
	
	object oTarget = GetFirstPC();
	while (GetIsObjectValid(oTarget)) // LOOP OVER ALL PC'S
	{
		if ( GetIsDM( oTarget ) )
		{
			CSLClientExtProperties( iClientSettings, oTarget );
		}
		oTarget = GetNextPC();
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLClientExtStateToString( int iClientSettings )
{
	
	string sDescription = "";
	if (iClientSettings==CLIENTEXT_NONE ) { return "None"; }
	if (iClientSettings & CLIENTEXT_PER_AREA_MAP_CONTROLS ) { sDescription += "PerAreaMap "; } 
	if (iClientSettings & CLIENTEXT_NO_MAP_ENVIRON ) { sDescription += "NoEnviron "; }
	if (iClientSettings & CLIENTEXT_NO_MAP_DOORS )  { sDescription += "NoDoors "; }
	if (iClientSettings & CLIENTEXT_NO_MAP_TRAPS ) { sDescription += "NoTraps "; }
	if (iClientSettings & CLIENTEXT_NO_MAP_CREATURES ) { sDescription += "NoCreatures "; }
	if (iClientSettings & CLIENTEXT_NO_MAP_PATHING )  { sDescription += "NoPathing "; }
	if (iClientSettings & CLIENTEXT_NO_MAP_BACKGROUND )  { sDescription += "NoAreaMap "; }
	return CSLTrim( sDescription );
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLFillInChatBox( string sMessage, object oPC = OBJECT_SELF )
{
	//string sQuote = CSLGetQuote();
	
	if ( GetIsSinglePlayer() )
	{
		DisplayGuiScreen(oPC,"SCREEN_MESSAGE_1", FALSE, "defaultchat.xml");
		//SetGUIObjectText(oDM,"SCREEN_MESSAGE_1","inputbox", -1, "/t "+sQuote"Pain"+sQuote);
		SetGUIObjectText(oPC,"SCREEN_MESSAGE_1","inputbox", -1, sMessage );
		//DisplayGuiScreen(oDM,"SCREEN_MESSAGE_1", FALSE, "defaultchat.xml");
	}
	else
	{
		DisplayGuiScreen(oPC,"SCREEN_MESSAGEMP_1", FALSE, "defaultmpchat1.xml");
		SetGUIObjectText(oPC,"SCREEN_MESSAGEMP_1","inputbox", -1, sMessage );
		///DisplayGuiScreen(oDM,"SCREEN_MESSAGEMP_2", FALSE, "defaultmpchat2.xml");
	}

}



const int KEMO_USE_CAPTURE = 0;
/*
string AreaRename(string sAreaTag)
{
	string sReturn = "";
	if (sAreaTag == "testarea") sReturn = "Test Area";
	if (sAreaTag == "") sReturn = "In Transit";
	return sReturn;
}
*/







				
				
				



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDMHeal( object oTarget, object oDM = OBJECT_SELF, int bMassVersion = FALSE )
{
	if ( GetIsDead( oTarget ) )
	{
		SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget) +" is now resurrected."+"</color>");
	}
	else if ( GetMaxHitPoints(oTarget) > GetCurrentHitPoints(oTarget) )
	{
		SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget) +" is now healed."+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget) +" is already ok."+"</color>");
	}
	
	ApplyEffectToObject(0, EffectResurrection(), oTarget);
	CloseGUIScreen( oTarget, GUI_DEATH );
	CloseGUIScreen(oTarget, GUI_DEATH_HIDDEN);
	CSLEnviroRemoveEffects( oTarget );
	if ( CSLRestore( oTarget ) )
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);
	}
	ApplyEffectToObject(0, EffectHeal(GetMaxHitPoints(oTarget)- GetCurrentHitPoints(oTarget)), oTarget);
	//SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget) +" is now resurrected."+"</color>");
	
	if ( bMassVersion )
	{
		location lTarget = GetLocation( oTarget );
		object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while ( GetIsObjectValid(oAlly) )
		{
			if ( GetIsOwnedByPlayer( oAlly ) || GetIsPC( oAlly ) )
			{
				if ( GetIsDead( oAlly ) )
				{
					SendMessageToPC(oDM, "<color=indianred>" + GetName(oAlly) +" is now resurrected."+"</color>");
				}
				else if ( GetMaxHitPoints(oAlly) > GetCurrentHitPoints(oAlly) )
				{
					SendMessageToPC(oDM, "<color=indianred>" + GetName(oAlly) +" is now healed."+"</color>");
				}
				else
				{
					SendMessageToPC(oDM, "<color=indianred>" + GetName(oAlly) +" is already ok."+"</color>");
				}
				ApplyEffectToObject(0, EffectResurrection(), oAlly);
				CloseGUIScreen( oAlly, GUI_DEATH );
				CloseGUIScreen(oAlly, GUI_DEATH_HIDDEN);
				CSLEnviroRemoveEffects( oAlly );
				if ( CSLRestore( oAlly ) )
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);
				}
				ApplyEffectToObject(0, EffectHeal(GetMaxHitPoints(oAlly)- GetCurrentHitPoints(oAlly)), oAlly);
				
			}
			oAlly = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDMKill( object oTarget, object oDM = OBJECT_SELF, int bMassVersion = FALSE )
{
	if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget)))//this command may not be used on dms or admins
	{
		SetPlotFlag(oTarget, FALSE);
		SetImmortal(oTarget, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath( FALSE, FALSE, TRUE )), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(GetCurrentHitPoints(oTarget))), oTarget);
		
		SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget)+" is now dead."+"</color>");
	}
	
	
	if ( bMassVersion )
	{
		location lTarget = GetLocation( oTarget );
		object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while ( GetIsObjectValid(oAlly) )
		{
			if ( !GetIsOwnedByPlayer( oAlly ) && !GetIsPC( oAlly ) )
			{
				SetPlotFlag(oAlly, FALSE);
				SetImmortal(oAlly, FALSE);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath( FALSE, FALSE, TRUE )), oAlly);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(GetCurrentHitPoints(oAlly))), oAlly);
				SendMessageToPC(oDM, "<color=indianred>" + GetName(oAlly)+" is now dead."+"</color>");
			}
			oAlly = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	
	}

}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLCleanCharacterText( object oPC, string sTag = "" )
{
	string sOrigFirstName = GetFirstName(oPC);
	string sOrigLastName = GetLastName(oPC);
	
	string sFirstName = CSLTrim(CSLGetLegalCharacterString( sOrigFirstName, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "));
	string sLastName = CSLStringBefore(sOrigLastName,"{");
	sLastName = CSLTrim(CSLGetLegalCharacterString( sLastName, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 -")); // {} is mainly for the guild or faction
	
	//string sDescription = CSLGetLegalCharacterString( GetDescription(oPC), "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 -.?!*()';:,/+=~`[]{}"+"\n");
	//sDescription = CSLTrim(sDescription);
	if ( sFirstName == "" && sLastName == "" )
	{
		sFirstName = "Illegal";
		sLastName = "Characters";
	}
	
	if ( sTag != "")
	{
		sLastName += " {"+sTag+"}";
	}
	
	if ( sFirstName != sOrigFirstName )
	{
		SetFirstName( oPC, sFirstName );
	}
	
	if ( sLastName != sOrigLastName )
	{
		SetLastName( oPC, sLastName );
	}
	//SetDescription( oPC, sDescription );
}



//int ACTION_MODE_DETECT                  = 0;
//int ACTION_MODE_STEALTH                 = 1;
//int ACTION_MODE_PARRY                   = 2;
//int ACTION_MODE_POWER_ATTACK            = 3;
//int ACTION_MODE_IMPROVED_POWER_ATTACK   = 4;
//int ACTION_MODE_COUNTERSPELL            = 5;
//int ACTION_MODE_FLURRY_OF_BLOWS         = 6;
//int ACTION_MODE_RAPID_SHOT              = 7;
//int ACTION_MODE_COMBAT_EXPERTISE               = 8;
//int ACTION_MODE_IMPROVED_COMBAT_EXPERTISE      = 9;
//int ACTION_MODE_DEFENSIVE_CAST          = 10;
//int ACTION_MODE_DIRTY_FIGHTING          = 11;
int ACTION_MODE_DEFENSIVE_STANCE          = 12;
int ACTION_MODE_TAUNT        = 13;
int ACTION_MODE_TRACK          = 14;
int ACTION_MODE_INSPIRE_COURAGE          = 15;
int ACTION_MODE_INSPIRE_COMPETENCE          = 16;
int ACTION_MODE_INSPIRE_DEFENSE          = 17;
int ACTION_MODE_INSPIRE_REGENERATION          = 18;
int ACTION_MODE_INSPIRE_TOUGHNESS          = 19;
int ACTION_MODE_INSPIRE_SLOWING          = 20;
int ACTION_MODE_INSPIRE_JARRING          = 21;
//int ACTION_MODE_????          = 22;
int ACTION_MODE_RESCUE          = 23;
//int ACTION_MODE_????       = 24;
//int ACTION_MODE_HELLFIRE_BLAST          = 25;
//int ACTION_MODE_HELLFIRE_SHIELD         = 26;

int ACTION_MODE_SWIMMING         = 27;
int ACTION_MODE_LEVITATING         = 28;
int ACTION_MODE_FLYING         = 29;

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLActionToString( int iAction )
{
	if ( iAction == ACTION_INVALID  ) { return "No Action"; } // 65535
	if ( iAction < 10 )
	{
		if ( iAction == ACTION_MOVETOPOINT  ) { return "Move To Point"; } // 0;
		if ( iAction == ACTION_PICKUPITEM   ) { return "Pickup Item"; } // 1;
		if ( iAction == ACTION_DROPITEM   ) { return "Drop Item"; } // 2;
		if ( iAction == ACTION_ATTACKOBJECT  ) { return "Attack Object"; } // 3;
		if ( iAction == ACTION_CASTSPELL   ) { return "Cast Spell"; } // 4;
		if ( iAction == ACTION_OPENDOOR  ) { return "Open Door"; } // 5;
		if ( iAction == ACTION_CLOSEDOOR  ) { return "Close Door"; } // 6;
		if ( iAction == ACTION_DIALOGOBJECT   ) { return "Dialog Object"; } // 7;
		if ( iAction == ACTION_DISABLETRAP  ) { return "Disable Trap"; } // 8;
		if ( iAction == ACTION_RECOVERTRAP  ) { return "Recover Trap"; } // 9;
	}
	else if ( iAction < 20 )
	{
		if ( iAction == ACTION_FLAGTRAP  ) { return "Flag Trap"; } // 10;
		if ( iAction == ACTION_EXAMINETRAP  ) { return "Examine Trap"; } // 11;
		if ( iAction == ACTION_SETTRAP  ) { return "Set Trap"; } // 12;
		if ( iAction == ACTION_OPENLOCK  ) { return "Open Lock"; } // 13;
		if ( iAction == ACTION_LOCK  ) { return "Lock"; } // 14;
		if ( iAction == ACTION_USEOBJECT  ) { return "Use Object"; } // 15;
		if ( iAction == ACTION_ANIMALEMPATHY  ) { return "Animal Empathy"; } // 16;
		if ( iAction == ACTION_REST  ) { return "Rest"; } // 17;
		if ( iAction == ACTION_TAUNT  ) { return "Taunt"; } // 18;
		if ( iAction == ACTION_ITEMCASTSPELL  ) { return "Item Cast Spell"; } // 19;
	}
	else
	{
		if ( iAction == ACTION_COUNTERSPELL  ) { return "Counter Spell"; } // 31;
		if ( iAction == ACTION_HEAL  ) { return "Heal"; } // 33;
		if ( iAction == ACTION_PICKPOCKET  ) { return "Pick Pocket"; } // 34;
		if ( iAction == ACTION_FOLLOW  ) { return "Follow"; } // 35;
		if ( iAction == ACTION_WAIT  ) { return "Wait"; } // 36;
		if ( iAction == ACTION_SIT  ) { return "Sit"; } // 37;
		if ( iAction == ACTION_SMITEGOOD  ) { return "Smite Good"; } // 40;
		if ( iAction == ACTION_KIDAMAGE  ) { return "Ki Damage"; } // 41;
		if ( iAction == ACTION_RANDOMWALK  ) { return "Random Walk"; } // 42;
	}
	return "Unknown "+IntToString(iAction);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLTargetActionModeToString( object oTarget )
{
		string sMessage = "";
		if ( GetActionMode(oTarget, 0) ) { sMessage += "Detect, "; } // Known
		if ( GetActionMode(oTarget, 1) ) { sMessage += "Stealth, "; } // Known
		if ( GetActionMode(oTarget, 2) ) { sMessage += "Parry, "; } // Known
		if ( GetActionMode(oTarget, 3) ) { sMessage += "Power Attack, "; } // Known
		if ( GetActionMode(oTarget, 4) ) { sMessage += "Improved Power Attack, "; } // Known
		if ( GetActionMode(oTarget, 5) ) { sMessage += "Counter Spell, "; } // Known
		if ( GetActionMode(oTarget, 6) ) { sMessage += "Flurry of Blows, "; } // Known
		if ( GetActionMode(oTarget, 7) ) { sMessage += "Rapid Shot, "; } // Known
		if ( GetActionMode(oTarget, 8) ) { sMessage += "Combat Expertise, "; } // Known
		if ( GetActionMode(oTarget, 9) ) { sMessage += "Improved Combat Expertise, "; } // Known
		if ( GetActionMode(oTarget, 10) ) { sMessage += "Defensive Casting, "; } // Known
		if ( GetActionMode(oTarget, 11) ) { sMessage += "Dirty Fighting, "; } // Known
		if ( GetActionMode(oTarget, 12) ) { sMessage += "Defensive Stance, "; } // need to verify
		if ( GetActionMode(oTarget, 13) ) { sMessage += "Taunt, "; } // need to verify
		if ( GetActionMode(oTarget, 14) ) { sMessage += "Tracking, "; } // Known
		if ( GetActionMode(oTarget, 15) ) { sMessage += "Inspire Courage, "; } // need to verify
		if ( GetActionMode(oTarget, 16) ) { sMessage += "Inspire Competance, "; } // need to verify
		if ( GetActionMode(oTarget, 17) ) { sMessage += "Inspire Defense, "; } // need to verify
		if ( GetActionMode(oTarget, 18) ) { sMessage += "Regeneration, "; } // need to verify
		if ( GetActionMode(oTarget, 19) ) { sMessage += "Tougness, "; } // need to verify
		if ( GetActionMode(oTarget, 20) ) { sMessage += "Slowing, "; } // need to verify
		if ( GetActionMode(oTarget, 21) ) { sMessage += "Jarring, "; } // need to verify
		if ( GetActionMode(oTarget, 22) ) { sMessage += "MISSING 22, "; } // not even a guess
		if ( GetActionMode(oTarget, 23) ) { sMessage += "Rescue, "; } // need to verify
		if ( GetActionMode(oTarget, 24) ) { sMessage += "NightVision, "; }  // need to verify
		if ( GetActionMode(oTarget, 25) ) { sMessage += "Hellfire Blast, "; } // Known
		if ( GetActionMode(oTarget, 26) ) { sMessage += "Hellfire Shield, "; } // Known
		if ( GetActionMode(oTarget, 27) ) { sMessage += "Swimming, "; }  // This i am trying to add
		if ( GetActionMode(oTarget, 28) ) { sMessage += "Levitating, "; }  // This i am trying to add
		if ( GetActionMode(oTarget, 29) ) { sMessage += "Flying, "; }  // This i am trying to add
		if ( GetActionMode(oTarget, 30) ) { sMessage += "MISSING 30, "; }
		if ( GetActionMode(oTarget, 31) ) { sMessage += "MISSING 31, "; }
		
		if ( sMessage != "" )
		{
			return GetStringLeft(sMessage, GetStringLength(sMessage)-2);
		}
		return "";
}

/**  
* Gets the Challenge rating for the target creature, accounting for any overrides
* @author Sea of Dragons
* @param oTarget target monster
* @see CSLSetChallengeRating
* @return Challenge rating
*/
float CSLGetChallengeRating( object oTarget )
{
	float fChallengeRating = GetLocalFloat(oTarget, "CSL_dmset_cr");

	if ( fChallengeRating > 0.0f )
	{
		return CSLGetWithinRangef( fChallengeRating, 0.0f, 100.0f );
	}
	return GetChallengeRating(oTarget);
}

/**  
* Sets the Challenge rating for the target creature, requires usage of a custome XP script whihc uses CSLGetChallengeRating instead of GetChallengeRating
* @author Sea of Dragons
* @param fChallengeRating Challenge rating ranging from 0.0f to 100.0f. Setting to 0.0f will make the creature use the engine challenge rating.
* @see CSLGetChallengeRating
*/
void CSLSetChallengeRating( object oTarget, float fChallengeRating )
{
	SetLocalFloat(oTarget, "CSL_dmset_cr", CSLGetWithinRangef( fChallengeRating, 0.0f, 100.0f ) );
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLGetObjectInfo( object oTarget, string sItemType = "", int iShowVariables = TRUE )
{
	string sMessage;
	string sItemType = "";
	if ( GetIsObjectValid(oTarget) )
	{
		if ( sItemType == "" )
		{
			int iObjectType = GetObjectType(oTarget);
			switch (iObjectType)
			{
				case OBJECT_TYPE_CREATURE:
					sItemType = "Creature";
					break;
				case OBJECT_TYPE_ITEM:
					sItemType = "Item";
					break;
				case OBJECT_TYPE_TRIGGER:
					sItemType = "Trigger";
					break;
				case OBJECT_TYPE_DOOR:
					sItemType = "Door";
					break;
				case OBJECT_TYPE_AREA_OF_EFFECT:
					sItemType = "AOE";
					break;
				case OBJECT_TYPE_WAYPOINT:
					sItemType = "Waypoint";
					break;
				case OBJECT_TYPE_PLACEABLE:
					sItemType = "Placeable";
					break;
				case OBJECT_TYPE_STORE:
					sItemType = "Store";
					break;
				case OBJECT_TYPE_ENCOUNTER:
					sItemType = "Creature";
					break;
				case OBJECT_TYPE_LIGHT:
					sItemType = "Light";
					break;
				case OBJECT_TYPE_PLACED_EFFECT:
					sItemType = "Placed Effect";
					break;
			}	
		}

		sMessage += "Information for "+sItemType+" Name="+GetName(oTarget)+"\n";
		sMessage += "Tag="+GetTag(oTarget)+" Resref="+GetResRef(oTarget)+" Object="+ObjectToString(oTarget)+"\n";
		
		int iEnviroState = GetLocalInt( oTarget, "CSL_ENVIRO" );
		if ( iEnviroState ) 
		{
			sMessage += "Enviro="+CSLEnviroStateToString( iEnviroState );
			
			int iCharStatus = GetLocalInt( oTarget, "CSL_CHARSTATE" );
			sMessage += "Charstate="+CSLEnviroCharStateToString( iCharStatus );
			sMessage += "\n";
		}
		
		int iWeatherState = GetLocalInt( oTarget, "CSL_WEATHERSTATE");
		if ( iWeatherState ) 
		{
			sMessage += "Weather="+CSLWeatherStateToString( iWeatherState );
			sMessage += "\n";
		}
		// CSLEnviroStateToString( int iAreaState )
		
		
		sMessage += "Location "+CSLSerializeLocation(GetLocation( oTarget ))+"\n";
		
		sMessage += "ChallengeRating="+CSLFormatFloat( CSLGetChallengeRating(oTarget) )+"\n";
		
		
		
		sMessage += "Action Modes: "+CSLTargetActionModeToString( oTarget )+"\n";
		int iNumActions = GetNumActions( oTarget );
		sMessage += "Current Action: "+CSLActionToString( GetCurrentAction( oTarget ) );
		if ( iNumActions > 1 )
		{
			sMessage += " of "+IntToString(iNumActions)+"\n";
		}


		/*
		if ( GetActionMode(oTarget, 0) ) { sMessage += " ACTION_MODE_DETECT"; }
		if ( GetActionMode(oTarget, 1) ) { sMessage += " ACTION_MODE_STEALTH"; }
		if ( GetActionMode(oTarget, 2) ) { sMessage += " ACTION_MODE_PARRY"; }
		if ( GetActionMode(oTarget, 3) ) { sMessage += " ACTION_MODE_POWER_ATTACK"; }
		if ( GetActionMode(oTarget, 4) ) { sMessage += " ACTION_MODE_IMPROVED_POWER_ATTACK"; }
		if ( GetActionMode(oTarget, 5) ) { sMessage += " ACTION_MODE_COUNTERSPELL"; }
		if ( GetActionMode(oTarget, 6) ) { sMessage += " ACTION_MODE_FLURRY_OF_BLOWS"; }
		if ( GetActionMode(oTarget, 7) ) { sMessage += " ACTION_MODE_RAPID_SHOT"; }
		if ( GetActionMode(oTarget, 8) ) { sMessage += " ACTION_MODE_COMBAT_EXPERTISE"; }
		if ( GetActionMode(oTarget, 9) ) { sMessage += " ACTION_MODE_IMPROVED_COMBAT_EXPERTISE"; }
		if ( GetActionMode(oTarget, 10) ) { sMessage += " ACTION_MODE_DEFENSIVE_CAST"; }
		if ( GetActionMode(oTarget, 11) ) { sMessage += " ACTION_MODE_DIRTY_FIGHTING"; }
		if ( GetActionMode(oTarget, 12) ) { sMessage += " MISSING 12"; }
		if ( GetActionMode(oTarget, 13) ) { sMessage += " MISSING 13"; }
		if ( GetActionMode(oTarget, 14) ) { sMessage += " TRACKING"; }
		if ( GetActionMode(oTarget, 15) ) { sMessage += " MISSING 15"; }
		if ( GetActionMode(oTarget, 16) ) { sMessage += " MISSING 16"; }
		if ( GetActionMode(oTarget, 17) ) { sMessage += " MISSING 17"; }
		if ( GetActionMode(oTarget, 18) ) { sMessage += " MISSING 18"; }
		if ( GetActionMode(oTarget, 19) ) { sMessage += " MISSING 19"; }
		if ( GetActionMode(oTarget, 20) ) { sMessage += " MISSING 20"; }
		if ( GetActionMode(oTarget, 21) ) { sMessage += " MISSING 21"; }
		if ( GetActionMode(oTarget, 22) ) { sMessage += " MISSING 22"; }
		if ( GetActionMode(oTarget, 23) ) { sMessage += " MISSING 23"; }
		if ( GetActionMode(oTarget, 24) ) { sMessage += " MISSING 24"; }
		if ( GetActionMode(oTarget, 25) ) { sMessage += " ACTION_MODE_HELLFIRE_BLAST"; }
		if ( GetActionMode(oTarget, 26) ) { sMessage += " ACTION_MODE_HELLFIRE_SHIELD"; }
		if ( GetActionMode(oTarget, 27) ) { sMessage += " MISSING 27"; }
		if ( GetActionMode(oTarget, 28) ) { sMessage += " MISSING 28"; }
		if ( GetActionMode(oTarget, 29) ) { sMessage += " MISSING 29"; }
		if ( GetActionMode(oTarget, 30) ) { sMessage += " MISSING 30"; }
		if ( GetActionMode(oTarget, 31) ) { sMessage += " MISSING 31"; }
		*/
		sMessage += "\n";
		
		int count = GetVariableCount(oTarget);
		if ( count > 0 && iShowVariables == TRUE )
		{
			if ( count > 1000 )
			{
				sMessage += "Variables- count: "+IntToString(count)+"\n";
				sMessage += "Showing first 1000 only\n";
				count = 1000; // only show the first 1000 variables
			}
			else
			{
				sMessage += "Variables- count: "+IntToString(count)+"\n";
			}
			int x;
			for (x = 0; x < count; x++)
			{
			
				sMessage += "   "+GetVariableName(oTarget, x);
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
					sMessage += ":Location:"+CSLSerializeLocation(GetVariableValueLocation( oTarget, x ));
				}
				sMessage += "\n";
			}
		}
		else
		{
			sMessage += "  and has no variables.";
		}
	}
	else
	{
		sMessage += "Invalid Object";
	}
	
	return sMessage;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDMPortThere( object oTarget, object oPC = OBJECT_SELF )
{
	if ( GetIsObjectValid(oTarget) )
	{
		SetLocalInt(oPC, "SC_DMPORT", TRUE); // exception to my porting block
		AssignCommand(oPC, JumpToObject(oTarget));
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDMPortHere( object oTarget, object oPC = OBJECT_SELF )
{
	if ( GetIsObjectValid(oTarget) && (!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget))) 
	{
		SetLocalInt(oTarget, "SC_DMPORT", TRUE);
		AssignCommand(oTarget, JumpToObject(oPC)); 
	}
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetAsEnemy( object oTarget, object oPC = OBJECT_SELF, int bDislike = TRUE )
{
	if ( oTarget!=oPC )
	{
		if ( bDislike )
		{
			if ( !CSLGetIsDM(oTarget)  )
			{
				SetPCDislike(oPC, oTarget);
			}
		}
		else
		{
			SetPCLike(oPC, oTarget);
		}
	}
}

/**  
* Wraps examine commands from scripts, soas to allow integrating further features as needed
* @author
* @param 
* @see 
* @return 
*/
void CSLExamine( object oTarget, object oPC = OBJECT_SELF, float fDelay = 0.0f )
{
	SetLocalObject( oPC, "CSL_EXAMINE_TARGET", oTarget);
	DelayCommand(fDelay+1.0f, DeleteLocalObject(oPC, "CSL_EXAMINE_TARGET") );
	DelayCommand(fDelay, AssignCommand(oPC, ActionExamine(oTarget)));
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetDisLike(object oPC, int bThisAreaOnly = FALSE)
{
	object oTarget = GetFirstPC();
	while (GetIsObjectValid(oTarget)) // LOOP OVER ALL PC'S
	{
		int bDoThem = (!CSLGetIsDM(oTarget) && oTarget!=oPC);  // DON'T DO DM'S OR SELF
		if (bThisAreaOnly && bDoThem) bDoThem = (GetArea(oPC)==GetArea(oTarget)); // ONLY HATE ON THIS AREA PLEASE
		if (bDoThem) SetPCDislike(oPC, oTarget);
		oTarget = GetNextPC();
	}
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetRealLevel(object oPC)  // GET REAL LEVEL BASED ON XP CONSIDERS SUBRACES
{
   return FloatToInt(0.5 + sqrt(0.25 + (IntToFloat(GetXP(oPC))/500)));
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetXPByLevel(int iLevel)
{
   return ((iLevel * (iLevel - 1)) / 2) * 1000;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLIsTester(object oPlayer)
{
    string sCDKey = CSLGetMyPublicCDKey(oPlayer);
    if (sCDKey == "KCMG43PP") return TRUE;
    return FALSE;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTestMsg(object oPC, string sMsg)
{
   if (CSLIsTester(oPC)) SendMessageToPC(oPC, sMsg);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetLastRest(object oPC)
{
   return GetLocalInt(oPC, "LASTREST");
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetLastRest(object oPC, int nTime)
{
   SetLocalInt(oPC, "LASTREST", nTime);
}
/*
void CSLSetLastRest(object oPC, int nTime)
{
	SetLocalInt(oPC, "LASTREST", nTime);
}
*/


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLGiveXP(object oReceiver, object oDM, int nXP )
{
	if ( GetIsObjectValid(oReceiver) )
	{
		int iCurrentXP = GetXP(oReceiver);
		
		int iNewXP = CSLGetMax( 1, iCurrentXP + nXP );
		
		SetXP(oReceiver, iNewXP);
		
		if ( iNewXP > iCurrentXP )
		{
			SendMessageToPC(oDM, "<color=red>Giving "+IntToString(iNewXP-iCurrentXP)+" XP to "+GetName(oReceiver) + "."+"</color>");
		}
		else if ( iNewXP < iCurrentXP )
		{
			SendMessageToPC(oDM, "<color=red>Taking "+IntToString(iCurrentXP-iNewXP)+" XP from "+GetName(oReceiver) + "."+"</color>");
		}
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"No Target Selected"+"</color>");
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLGiveLevel(object oReceiver, object oDM, int nLevels, int bByCurrentXP = FALSE)
{
	int iMaxLevels = 60;
	int bIsPlayer = FALSE;
	if ( GetIsPC( oReceiver ) || GetIsOwnedByPlayer(oReceiver) )
	{
		iMaxLevels = 30;
		bIsPlayer = TRUE;
	}
	
	if ( GetIsObjectValid(oReceiver) )
	{
		int iHD;
		if ( bByCurrentXP == TRUE )
		{
			iHD = CSLGetRealLevel(oReceiver);
		}
		else
		{
			iHD = GetHitDice(oReceiver);
		}
		if (iHD <= iMaxLevels)
		{
			int nTargetLevel = CSLGetWithinRange( iHD+nLevels, 1, iMaxLevels );
			
			int nTargetXP = (( nTargetLevel * ( nTargetLevel - 1 )) / 2 * 1000 );
			SetXP(oReceiver, nTargetXP);
			string sLevel = "levels";
			if (nLevels==1) sLevel = "level";
			if ( !bIsPlayer )
			{
				LevelUpHenchman(oReceiver,CLASS_TYPE_INVALID,TRUE);
			}
			SendMessageToPC(oDM, "<color=indianred>"+"You have given "+IntToString(nLevels)+" "+sLevel+" to "+GetName(oReceiver) + "."+"</color>");
		}
		else
		{
			SendMessageToPC(oDM, "<color=indianred>"+GetName(oReceiver)+" is already level 30!"+"</color>");
		}
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"No Target Selected"+"</color>");
	}
}

/**  
* Check for XP
* @author PRC
* @param 
* @see 
* @replaces XXXGetHasXPToSpend
* @return 
*/
int CSLGetHasXPToSpend(object oPC, int nCost)
{
    // To be TRUE, make sure that oPC wouldn't lose a level by spending nCost.
    int nHitDice = GetHitDice(oPC);
    int nHitDiceXP = (500 * nHitDice * (nHitDice - 1)); // simplification of the sum
    //get current XP    
    int nXP = GetXP(oPC);
    if(!nXP)
        nXP = GetLocalInt(oPC, "NPC_XP");
    //the test    
    if (nXP >= (nHitDiceXP + nCost))
        return TRUE;
    return FALSE;
}

/**  
* Spend XP
* @author PRC
* @param 
* @see 
* @replaces XXXSpendXP
* @return 
*/
void CSLSpendXP(object oPC, int nCost)
{
    if (nCost > 0)
    {
        if(GetXP(oPC))
            SetXP(oPC, GetXP(oPC) - nCost);
        else if(GetLocalInt(oPC, "NPC_XP"))
            SetLocalInt(oPC, "NPC_XP", GetLocalInt(oPC, "NPC_XP")-nCost);
    }
}

/**  
* Check for GP
* @author PRC
* @param 
* @see 
* @replaces XXXGetHasGPToSpend
* @return 
*/
int CSLGetHasGPToSpend(object oPC, int nCost)
{
    //if its a NPC, get master
    while(!GetIsPC(oPC)
        && GetIsObjectValid(GetMaster(oPC)))
    {
        oPC = GetMaster(oPC);
    }    
    //test if it has gold
    if(GetIsPC(oPC))
    {
        int nGold = GetGold(oPC);
        //has enough gold
        if(nGold >= nCost)
            return TRUE;
        //does not have enough gold    
        return FALSE;
    }
    //NPC in NPC faction
    //cannot posses gold
    return FALSE;
}

/**  
* Spend GP
* @author PRC
* @param 
* @see 
* @replaces XXXSpendGP
* @return 
*/
void CSLSpendGP(object oPC, int nCost)
{
    if (nCost > 0)
    {
        //if its a NPC, get master
        while(!GetIsPC(oPC)
            && GetIsObjectValid(GetMaster(oPC)))
        {
            oPC = GetMaster(oPC);
        }
        TakeGoldFromCreature(nCost, oPC, TRUE);
    }
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTakeLevel(object oLoser, object oDM, int nLevels, int bByCurrentXP = FALSE)
{
	if ( GetIsObjectValid(oLoser) )
	{
		int iHD;
		if ( bByCurrentXP == TRUE )
		{
			iHD = CSLGetRealLevel(oLoser);
		}
		else
		{
			iHD = GetHitDice(oLoser);
		}
		int nTargetLevel = CSLGetWithinRange( iHD-nLevels, 1, 30);
		int nTargetXP = (( nTargetLevel * ( nTargetLevel - 1 )) / 2 * 1000 );
		SetXP(oLoser, nTargetXP);
		string sLevel = "levels";
		if (nLevels==1) sLevel = "level";
		SendMessageToPC(oDM, "<color=indianred>"+"You have removed "+IntToString(nLevels)+" "+sLevel+" from "+GetName(oLoser) + "."+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"No Target Selected"+"</color>");
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLOpenUrl( string sUrl, object oPlayer = OBJECT_SELF )
{
	DisplayGuiScreen( oPlayer, "SCREEN_WINDOWEDMODE", TRUE, "_cslwindowedmode.xml");
	DisplayGuiScreen( oPlayer, "SCREEN_OPENURL", TRUE, "_CSLOpenURL.xml");
	SetLocalGUIVariable( oPlayer, "SCREEN_OPENURL", 1, sUrl );
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Counts the Number of Players in the Party that are in the same area as the PC with optional Max Distance to PC
int CSLCountParty(object oPC, int nDist = 0)
{
	object oParty = GetFirstFactionMember(oPC);
	int nCnt = 0;
	while (GetIsObjectValid(oParty))
	{
		if ( CSLPCIsClose(oPC, oParty, nDist))
		{
			nCnt++;
		}
		oParty = GetNextFactionMember(oPC);
	}
	return nCnt;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// * SHOULD RETURN OBJECT_INVALID IS PC IS NOT IN A PARTY, OTHERWISE RETURNS PARTY LEADER UNLESS THAT IS THE PC THEN IT JUST RETURNS A RANDOM PARTY MEMBER
object CSLGetPartyMember(object oPC)
{ 
	object oLeader = GetFactionLeader(oPC);
	if (oLeader==oPC)
	{ // FOUND SELF
		oLeader = GetFirstFactionMember(oPC); // CHECK THE FIRST MEMBER
		if (oLeader==oPC)
		{
			oLeader = GetNextFactionMember(oPC); // DANG IT FOUND SELF AGAIN, GET THE NEXT AND THAT SHOULD BE IT!
		}
	}
	return oLeader;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLPartySplitDelayed(object oPC, int nSplitGold)
{
   int nCount = 0;
   object oParty = GetFirstFactionMember(oPC, TRUE);
   while (GetIsObjectValid(oParty)) {
      nCount++;
      oParty = GetNextFactionMember(oPC, TRUE);
   }
   int nShare = nSplitGold / nCount;
   oParty = GetFirstFactionMember(oPC, TRUE);
   while (GetIsObjectValid(oParty)) {
      GiveGoldToCreature(oParty, nShare);
      if (oPC==oParty) SendMessageToPC(oParty, "You split " + IntToString(nSplitGold) + " gold amoung " + IntToString(nCount) + CSLAddS(" party member", nCount) + ". Your share was " + IntToString(nShare) + ".");
      else SendMessageToPC(oParty, GetFirstName(oPC) + " has split party gold. Your share was " + IntToString(nShare) + ".");
      oParty = GetNextFactionMember(oPC, TRUE);
   }
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLPartySplit(object oPC, int nSplitGold)
{
   if (nSplitGold<100) {
      SendMessageToPC(oPC, "You must specify how much gold to split with your Party (100 gold minimum).");
      return;
   }
   int nGold = GetGold(oPC);
   if (nSplitGold > nGold) {
      SendMessageToPC(oPC, "You do not have that much gold to split with your Party.");
      return;
   }
   TakeGoldFromCreature(nSplitGold, oPC); // PC LOSES ALL THE GOLD, GETS SOME BACK IN DELAY
   DelayCommand(0.5f, CSLPartySplitDelayed(oPC, nSplitGold));
}






/*
deprecated and put into heartbeat on minute event
void CSLServerRebootTimer(string sSEID, int bRestart = FALSE)
{
   string sMsg = "Server Session #" + sSEID;
   int nRemain;
   int iHours = 4;
   object oPC;
   object oModule = GetModule();

   if (bRestart)
   {
      CSLNWNX_SQLExecDirect("select (3-date_format(now(), '%h') % "+IntToString(iHours)+") * 60-date_format(now(), '%i')"); // REBOOT EVERY 3 HOURS AT 3,6,9,12
      if (CSLNWNX_SQLFetch()) bRestart = CSLNWNX_SQLGetDataInt(1);
      if (bRestart < 60) bRestart += 180;
      nRemain = bRestart;
      SetLocalInt(oModule, "SERVER_MAX_UPTIME", bRestart);
   } else {
      int nUpTime = CSLIncrementLocalInt(oModule, "SERVER_CURRENT_UPTIME", 1);
      nRemain = GetLocalInt(oModule, "SERVER_MAX_UPTIME") - nUpTime;
   }
   if (nRemain==0)
   {
      oPC = GetFirstPC();
      while (oPC!=OBJECT_INVALID)
      {
         DelayCommand(3.0, BootPC(oPC));
         oPC = GetNextPC();
      }
      DelayCommand(4.0, NWNXSetString("SYSTEM", "RESET", "", 0, ""));
      sMsg += " is over. Thank you! Come again.";
   }
   else if (nRemain==1)
   {
		oPC = GetFirstPC();
		while (oPC!=OBJECT_INVALID)
		{
			DelayCommand(48.0, CSLMsgBox(oPC, sMsg + " will end in 15 seconds. You will be booted before the reset. This is normal."));
			oPC = GetNextPC();
		}
		sMsg += " will end in 1 minute.";
		
		// this handles king of the circle mini game
		ExecuteScript("TG_KingCircle_OnCircleEnd", GetModule() );
      
   }
   else if ((nRemain % 15)==0) // 15 min notices
   {
      sMsg += " will restart in " + CSLHoursMinutes(nRemain) + ".";
     CSLShoutMsg(GetLocalString(GetModule(), "SERVERMSG"));
   } else {
      sMsg = "";
   }
   if (sMsg!="") CSLShoutMsg(sMsg);
   DelayCommand(60.0f, CSLServerRebootTimer(sSEID));
}
*/

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLGetServerRemainingUpTime()
{
    int nMaxUptime = GetLocalInt(GetModule(), "SC_SERVER_MAX_UPTIME");
    if ( nMaxUptime < 1 )
    {
    	return "";
    }
    int nUpTime = GetLocalInt(GetModule(), "CSL_CURRENT_ROUND")/10;
     // - nUpTime;
    return CSLHoursMinutes(nMaxUptime-nUpTime);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLGetServerUpTime()
{
    return CSLHoursMinutes(GetLocalInt(GetModule(), "CSL_CURRENT_ROUND")/10);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLFindAoEs(object oArea)
{
	object oAoE=GetFirstObjectInArea(oArea);
	int iNumAoE=GetLocalInt(oArea,"NumAoE");
	int i=1;
	while (i<=iNumAoE)
	{
		DeleteLocalObject(oArea, "Silence"+IntToString(i));
		i++;
	}
	iNumAoE=0;
	while (GetIsObjectValid(oAoE))
	{
		if (GetObjectType(oAoE)==OBJECT_TYPE_AREA_OF_EFFECT)
		{
			if (GetLocalInt(oAoE,"ImSilence"))
			{
				iNumAoE++;
				SetLocalObject(oArea, "Silence"+IntToString(iNumAoE), oAoE);					
			}
		}
		oAoE=GetNextObjectInArea(oArea);
	}
	SetLocalInt(oArea,"NumAoE",iNumAoE);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLPCCanEnterArea(object oPC, object oArea=OBJECT_INVALID)
{
   if (oArea==OBJECT_INVALID) oArea = GetArea(oPC);
   if (oArea==OBJECT_INVALID) return FALSE;
  
   
   int nDMPort = GetLocalInt(oPC, "SC_DMPORT");
   if (nDMPort)
   {
		SetLocalInt(oPC, "SC_DMPORT", FALSE);
		return TRUE;
   }
   
   int nMax = GetLocalInt(oArea, "MAXLEVEL");
   // SendMessageToPC(oPC, GetName( oArea )+" is Level Restricted "+IntToString( nMax )  );
   if (!nMax) return TRUE;
   //int iLevel = GetLocalInt(oPC, "START_LEVEL");
   //if (!iLevel) 
   int iLevel = GetHitDice(oPC); //CSLIncrementLocalInt(oPC, "START_LEVEL", GetHitDice(oPC));
   return (iLevel<=nMax);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLToggleOnOff(object oObject, int nState=-1)
{
   if (nState==-1) nState = GetLocalInt(oObject, "ON_OFF") ? 0 : 1; // IF ON, RETURN OFF
   string sVisual = GetLocalString(oObject, "ON_OFF_VISUAL");
   if (nState)
   {
      PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
      SetLocalInt(oObject,"ON_OFF", 1);
     if (sVisual!="")
     {
         effect eLight = EffectNWN2SpecialEffectFile(sVisual); //EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oObject);
      }
   }
   else
   {
      PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
      DeleteLocalInt(oObject,"ON_OFF");
     if (sVisual!="") CSLRemoveEffectByCreator(oObject, oObject);
   }
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetOnOff(object oObject)
{
   return GetLocalInt(oObject, "ON_OFF");
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSuperCharge(object oPC)
{
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageShield(100, DAMAGE_BONUS_40, DAMAGE_TYPE_MAGICAL), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_MAGICAL), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_ACID), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_COLD), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_ELECTRICAL), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints(GetMaxHitPoints(oPC)), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectMovementSpeedIncrease(300), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectConcealment(100), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectInvisibility(INVISIBILITY_TYPE_IMPROVED), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectImmunity(IMMUNITY_TYPE_DEATH), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_STRENGTH, 6), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_DEXTERITY, 6), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_CONSTITUTION, 6), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 6), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_WISDOM, 6), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_CHARISMA, 6), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_LORE, 50), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(10), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectRegenerate(10, 6.0), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHaste(), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectModifyAttacks(5), oPC);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsInTown(object oPC)
{
	return GetLocalInt(GetArea(oPC), "TOWN");
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLStoneCasterInTown(object oPC)
{
   if ( CSLGetIsInTown(oPC) )
   {
      effect ePet = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SPELL_FLESH_TO_STONE), EffectCutsceneImmobilize());// EffectPetrify());
      ePet = ExtraordinaryEffect( ePet );
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePet, oPC, 30.0);
      FloatingTextStringOnCreature(CSLGetSpellDataName(GetSpellId()) + " is illegal to cast in town.", oPC, TRUE);
      return TRUE;
   }
   return FALSE;
}


// Get the effective character level Race adjustment
int CSLGetRaceECL(object oTarget)
{
	int iSubRace = GetSubRace(oTarget);
	//int iRet = StringToInt(Get2DAString("RacialSubTypes", "ECL", iSubRace));
	// PrettyDebug ("This character has an ECL of " + IntToString(iRet));
	return CSLGetRaceDataECL(iSubRace);
}

// Get the effective character level Race adjustment
int CSLGetRaceECLCap(object oTarget)
{
	int iSubRace = GetSubRace(oTarget);
	//int iRet = StringToInt(Get2DAString("RacialSubTypes", "ECL", iSubRace));
	// PrettyDebug ("This character has an ECL of " + IntToString(iRet));
	return CSLGetRaceDataECLCap(iSubRace);
}

// Get the effective character level (all class levels added up + Race ECL
int CSLGetECLHitDice(object oTarget, int bIncludeNegativeLevels)
{
	int nTotalLevels = GetHitDice( oTarget ); // total levels, not including negative level or ECL
	int iSubRace = GetSubRace(oTarget);
	nTotalLevels += CSLGetRaceDataECLCap(iSubRace)+CSLGetRaceDataECL(iSubRace);
	return nTotalLevels;
}


/**  
* @deprecate
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetECL(int nSubRace )
{
	return CSLGetRaceDataECLCap(nSubRace);
	
	/*
	switch (nSubRace)
	{
		case RACIAL_SUBTYPE_AASIMAR:
		case RACIAL_SUBTYPE_AIR_GENASI:
		case RACIAL_SUBTYPE_AIR_MEPHLING_ROF:
		case RACIAL_SUBTYPE_ASABI_ROF:
		case RACIAL_SUBTYPE_AZERBLOOD_ROF:
		case RACIAL_SUBTYPE_BLADELING_ROF:
		case RACIAL_SUBTYPE_BUGBEAR_ROF:
		case RACIAL_SUBTYPE_CELADRIN_ROF:
		case RACIAL_SUBTYPE_CHAOND_ROF:
		case RACIAL_SUBTYPE_DROW:
		case RACIAL_SUBTYPE_EARTH_GENASI:
		case RACIAL_SUBTYPE_EARTH_MEPHLING_ROF:
		case RACIAL_SUBTYPE_ELDBLOT_ROF:
		case RACIAL_SUBTYPE_FIRE_MEPHLING_ROF:
		case RACIAL_SUBTYPE_FJELLBLOT_ROF:
		case RACIAL_SUBTYPE_FOREST_GNOME_ROF:
		case RACIAL_SUBTYPE_FROSTBLOT_ROF:
		case RACIAL_SUBTYPE_GNOLL_ROF:
		case RACIAL_SUBTYPE_GRAYORC:
		case RACIAL_SUBTYPE_GRAY_DWARF:
		case RACIAL_SUBTYPE_HALF_OGRE_ROF:
		case RACIAL_SUBTYPE_HOBGOBLIN_ROF:
		case RACIAL_SUBTYPE_JANNLING_ROF:
		case RACIAL_SUBTYPE_LIZARDFOLK_ROF:
		case RACIAL_SUBTYPE_MORTIF_ROF:
		case RACIAL_SUBTYPE_OGRILLON_ROF:
		case RACIAL_SUBTYPE_TAER_ROF:
		case RACIAL_SUBTYPE_TAINTED_ONE_ROF:
		case RACIAL_SUBTYPE_TAKEBLOT_ROF:
		case RACIAL_SUBTYPE_TIEFLING:
		case RACIAL_SUBTYPE_ULDRA_ROF:
		case RACIAL_SUBTYPE_UNDA_ROF:
		case RACIAL_SUBTYPE_VARCOLACI_ROF:
		case RACIAL_SUBTYPE_WATER_MEPHLING_ROF:
		case RACIAL_SUBTYPE_WECHSELBALG_ROF:
		case RACIAL_SUBTYPE_WOOD_GENASI_ROF:
		case RACIAL_SUBTYPE_ZENYTHRI_ROF:
			return 1;

		case RACIAL_SUBTYPE_ARCTIC_DWARF_ROF:
		case RACIAL_SUBTYPE_BOOGIN_ROF:
		case RACIAL_SUBTYPE_DERRO_ROF:
		case RACIAL_SUBTYPE_DRAGONKIN_ROF:
		case RACIAL_SUBTYPE_FEYRI_ROF:
		case RACIAL_SUBTYPE_FOMORIAN_ROF:
		case RACIAL_SUBTYPE_GITHZERAI:
		case RACIAL_SUBTYPE_GLOAMING_ROF:
		case RACIAL_SUBTYPE_ICE_SPIRE_OGRE_ROF:
		case RACIAL_SUBTYPE_ODONTI_ROF:
		case RACIAL_SUBTYPE_OGRE_ROF:
		case RACIAL_SUBTYPE_OROG_ROF:
		case RACIAL_SUBTYPE_SPRIGGAN_ROF:
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
		case RACIAL_SUBTYPE_VERBEEG_ROF:
		case RACIAL_SUBTYPE_VOADKYN_ROF:
		case RACIAL_SUBTYPE_WORG_ROF:
		case RACIAL_SUBTYPE_YUANTI:
		case RACIAL_SUBTYPE_MINOTAUR:
			return 2;
		
		case RACIAL_SUBTYPE_FIRBOLG_ROF:
		case RACIAL_SUBTYPE_FLAMEBROTHER_ROF:
		case RACIAL_SUBTYPE_KHAASTA_ROF:
		case RACIAL_SUBTYPE_SIND_ROF:
		case RACIAL_SUBTYPE_SYLPH_ROF:
		case RACIAL_SUBTYPE_TANARUKK_ROF:
			return 3;
			
		case RACIAL_SUBTYPE_ALU_FIEND_ROF:
		case RACIAL_SUBTYPE_BROWNIE_ROF:
		case RACIAL_SUBTYPE_CAMBION_ROF:
		case RACIAL_SUBTYPE_DRIDER:
		case RACIAL_SUBTYPE_DURZAGON_ROF:
		case RACIAL_SUBTYPE_LIZARDKING_ROF:
		case RACIAL_SUBTYPE_YUANTI_HALFBLOOD_ROF:
			return 4;
	}
	*/
	return 0;
}


/*

RACIAL_SUBTYPE_AZERBLOOD_ROF
RACIAL_SUBTYPE_GITHYANKI
RACIAL_SUBTYPE_HAGSPAWN
RACIAL_SUBTYPE_HALFCELESTIAL
RACIAL_SUBTYPE_HALFDROW
RACIAL_SUBTYPE_HUMAN_DEEP_IMASKARI_ROF
RACIAL_SUBTYPE_INCORPOREAL
RACIAL_SUBTYPE_MAGICAL_BEAST
RACIAL_SUBTYPE_PLANT
RACIAL_SUBTYPE_VOLODNI_ROF






*/


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Get level adjustment
int CSLGetLevelAdjustment(object oCreature)
{
	switch( GetSubRace(oCreature) ){
		case RACIAL_SUBTYPE_AASIMAR:
		case RACIAL_SUBTYPE_TIEFLING:
		case RACIAL_SUBTYPE_GRAY_DWARF:
		case RACIAL_SUBTYPE_AIR_GENASI:
		case RACIAL_SUBTYPE_FIRE_GENASI:
		case RACIAL_SUBTYPE_EARTH_GENASI:
		case RACIAL_SUBTYPE_WATER_GENASI: return 1;
		case RACIAL_SUBTYPE_DROW:
		case RACIAL_SUBTYPE_GITHYANKI:
		case RACIAL_SUBTYPE_GITHZERAI:    return 2;
		case RACIAL_SUBTYPE_SVIRFNEBLIN:  return 3;
	}
	return 0;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Get PCs' average Level
int CSLGetPCAverageLevel()
{
	object oPC = GetFirstPC(TRUE);
	int    iLv = 0;
	int    iC  = 0;
	while( GetIsObjectValid(oPC) )
	{
		iLv += GetTotalLevels(oPC, TRUE);
		iLv += CSLGetLevelAdjustment(oPC);
		iC  ++;
		oPC = GetNextPC(TRUE);
	}
	if( iC > 0 )
	{
		return (iLv/iC);
	}
	return 0;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Get PCs' average XP
int CSLGetPCAverageXP()
{
	object oPC = GetFirstPC(TRUE);
	int    iXP = 0;
	int    iC  = 0;
	while( GetIsObjectValid(oPC) )
	{
		iXP += GetXP(oPC);
		iC  ++;
		oPC = GetNextPC(TRUE);
	}
	if( iC > 0 )
	{
		return (iXP/iC);
	}
	return 0;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Get the XP needed to reach a certain level
int CSLGetXPForLevel(int iLv){
	// XP follows an arithmetic progression:
	// 1000+2000+3000..+n = 1000(1+n)n/2 where n = iLv-1
	return iLv*(iLv-1)*500;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Level Creature to certain level
// oTrg  : Target
// iLV   : Level
// iAuto : automatic or manual
void CSLLevelUpCreature(object oTrg, int iLv, int iAuto=FALSE)
{
	if( GetTotalLevels(oTrg, TRUE) < iLv )
	{
		int iXP = CSLGetXPForLevel(iLv);
		if( iAuto )
		{
			ResetCreatureLevelForXP(oTrg, iXP, TRUE);
		}
		else
		{
			SetXP(oTrg, iXP);
		}
	}
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Adds a companion to oPC
// sRef : Companion ResRef
// iJn  : 0 Add Only, 1 Add & Join, 2 Add & Force Join
// iALv : Auto adjust level if true (For new companions only)
void CSLAddCompanion(object oPC, string sRef, int iJn=0, int iALv=TRUE)
{
	object oCmp = OBJECT_INVALID;
	string sRN  = GetFirstRosterMember();
	// Check Roster Member list
	while( (sRN != sRef) && (sRN != "") )
	{
		sRN = GetNextRosterMember();
	}
	// Companion not in Roster List
	if( sRN != sRef )
	{
		// look for an existing instance
		oCmp = GetObjectByTag(sRef);
		if( !GetIsObjectValid(oCmp) )
		{
			// Not found, Create one
			oCmp = CSLCreateCreature(sRef, oPC, sRef);
		}
		CSLLevelUpCreature(oCmp, GetTotalLevels(oPC, TRUE), iALv);
		AddRosterMemberByCharacter(sRef, oCmp);
		// Save and unspawn if add to roster only
		if( iJn <= 0 )
		{
			DespawnRosterMember(sRef); 
		}
	}
	// Spawn and join
	if( iJn > 0 )
	{
		AddRosterMemberToParty(sRef, oPC);
		if( iJn >= 2 )
		{
			// Force Join (Cannot remove)
			SetIsRosterMemberSelectable(sRef, FALSE);
		}
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Show Party Selection Screen
// iMdt : Selection is Mandatory if true (cannot cancel)
// iPSz : Party Size
// sScr : Script to run when party accpeted
void CSLSelectParty(object oPC, int iMdt=FALSE, int iPSz=3, string sScr="")
{
	string sGUI = "SCREEN_PARTYSELECT";
	string sCnl = "REMOVE_PARTY";
	string sCls = "CloseButton";
	
	CloseGUIScreen(oPC, sGUI);	
	SetRosterNPCPartyLimit(iPSz);
	SetGUIObjectDisabled(oPC, sGUI, sCnl, iMdt);
	SetGUIObjectDisabled(oPC, sGUI, sCls, iMdt);
	SetLocalGUIVariable(oPC, sGUI, 0, sScr);
	DelayCommand(0.1f, DisplayGuiScreen(oPC, sGUI, TRUE));
}



/**  
* Wrapper for get last killer which gets the 
* @author
* @param 
* @see 
* @return 
*/
object CSLGetKiller(object oKilled)
{
	object oKiller = GetLocalObject(oKilled, "KILLER");
	if (oKiller==OBJECT_INVALID) { oKiller = GetLastHostileActor(oKilled); }
	if (oKiller==OBJECT_INVALID) { oKiller=GetLastDamager(oKilled); }
	if (oKiller==OBJECT_INVALID) { oKiller = GetLastKiller(); }
	
	if (!GetIsPC(oKiller) && GetIsPC(GetMaster(oKiller)))
	{
		oKiller = GetMaster(oKiller);
	}		
	return oKiller;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSaveParty(object oPC, object oLeader)
{
   if (oLeader!=OBJECT_INVALID) {
      SetLocalObject(oPC, "MYPARTY", oLeader); // HERE'S SOMEONE IN MY PARTY, MOST LIKELY THE LEADER
   } else {
      DeleteLocalObject(oPC, "MYPARTY"); // I'M NOT PARTYING DELETE MY LEADER
   }
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustAbilityEffect( int iAdjustmentAmount, int iStat, object oTarget = OBJECT_SELF )
{
	//int iRawScore = GetAbilityScore(oTarget,iStat,TRUE);
	int iSpellId = -(CSL_CHARMOD_SPELLSTATID+iStat);
	int iModifier;
	string sStat = CSLAbilityStatToString(iStat);
	
	int iOriginalStat = GetLocalInt(oTarget,"CSL_ABILITYORIG_"+sStat ); // store original stat just because we might run into trouble
	if ( iOriginalStat == 0 )
	{
		SetLocalInt(oTarget,"CSL_ABILITYORIG_"+sStat,GetAbilityScore(oTarget,iStat,TRUE) );
	}
		
	
	string sModifier = GetLocalString(oTarget,"CSL_MOD_ABILITY_"+sStat );
	if ( sModifier == "" )
	{
		int iRawScore = CSLGetNaturalAbilityScore(oTarget, iStat );
		int iCurrentScore = GetAbilityScore(oTarget, iStat, FALSE);
		int iCurrentModifier = iCurrentScore - iRawScore;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	iModifier = CSLGetMin(iModifier,12);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	if ( iModifier > 0 )
	{
		eEffect = EffectAbilityIncrease(iStat,iModifier);
		
	}
	else if ( iModifier < 0 )
	{
		eEffect = EffectAbilityDecrease(iStat,-iModifier);
		
	}
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);
	//SetLocalInt(oTarget,"CSL_ABILITYMOD_"+IntToString(iStat) );

	SetLocalString(oTarget,"CSL_MOD_ABILITY_"+sStat,IntToString(iModifier) );
	
	return iModifier;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustAbilityBase( int iAdjustmentAmount, int iStat, object oTarget = OBJECT_SELF )
{
	string sStat = CSLAbilityStatToString(iStat);
	
	int iOriginalStat = GetLocalInt(oTarget,"CSL_ABILITYORIG_"+sStat ); // store original stat just because we might run into trouble
	if ( iOriginalStat == 0 )
	{
		SetLocalInt(oTarget,"CSL_ABILITYORIG_"+sStat,GetAbilityScore(oTarget,iStat,TRUE) );
	}
	
	
	int iRawScore = GetAbilityScore(oTarget,iStat,TRUE)+iAdjustmentAmount;
	iRawScore = CSLGetWithinRange(iRawScore,1,50);
	SetBaseAbilityScore(oTarget,iStat,iRawScore);
	return iRawScore;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustAlignment( int iAdjustmentAmount, int iAxis = ALIGNMENT_AXIS_GOODEVIL, object oTarget = OBJECT_SELF )
{
	
	int iGoodEvilValue, iLawChaosValue, iNewGoodEvilValue, iNewLawChaosValue;
	
	if ( iAxis == ALIGNMENT_AXIS_LAWCHAOS )
	{
		iLawChaosValue = CSLGetWithinRange(GetLawChaosValue(oTarget)+iAdjustmentAmount,0,100);
		if ( iAdjustmentAmount > 0 )
		{
			AdjustAlignment(oTarget, ALIGNMENT_LAWFUL, iAdjustmentAmount);
			
		}
		else if ( iAdjustmentAmount < 0 )
		{
			AdjustAlignment(oTarget, ALIGNMENT_CHAOTIC, -iAdjustmentAmount);
		}
		iNewLawChaosValue = GetLawChaosValue(oTarget);
		if ( iGoodEvilValue != iNewLawChaosValue )
		{
			if ( iLawChaosValue > iNewLawChaosValue ) //iCurrentGoodEvilAlign )
			{
				iAdjustmentAmount =  iLawChaosValue - iNewLawChaosValue;
				AdjustAlignment(oTarget, ALIGNMENT_LAWFUL, iAdjustmentAmount );
			}
			else if ( iLawChaosValue < iNewLawChaosValue )//  iCurrentGoodEvilAlign )
			{
				iAdjustmentAmount = iNewLawChaosValue - iLawChaosValue;
				AdjustAlignment(oTarget, ALIGNMENT_CHAOTIC, iAdjustmentAmount );
			}
		}
		return GetLawChaosValue(oTarget);
	
	}
	else // must be good evil axis
	{
		iGoodEvilValue = CSLGetWithinRange(GetGoodEvilValue(oTarget)+iAdjustmentAmount,0,100);
		if ( iAdjustmentAmount > 0 )
		{
			AdjustAlignment(oTarget, ALIGNMENT_GOOD, iAdjustmentAmount);
			
		}
		else if ( iAdjustmentAmount < 0 )
		{
			AdjustAlignment(oTarget, ALIGNMENT_EVIL, -iAdjustmentAmount );
		}
		iNewGoodEvilValue = GetGoodEvilValue(oTarget);
		if ( iGoodEvilValue != iNewGoodEvilValue )
		{
			if ( iGoodEvilValue > iNewGoodEvilValue ) //iCurrentGoodEvilAlign )
			{
				iAdjustmentAmount =  iGoodEvilValue - iNewGoodEvilValue;
				AdjustAlignment(oTarget, ALIGNMENT_GOOD, iAdjustmentAmount );
			}
			else if ( iGoodEvilValue < iNewGoodEvilValue )//  iCurrentGoodEvilAlign )
			{
				iAdjustmentAmount = iNewGoodEvilValue - iGoodEvilValue;
				AdjustAlignment(oTarget, ALIGNMENT_EVIL, iAdjustmentAmount );
			}
		}
		return GetGoodEvilValue(oTarget);
	}
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustSaveEffect( int iAdjustmentAmount, int iSaveThrowType, object oTarget = OBJECT_SELF )
{
	int iSpellId = -(CSL_CHARMOD_SPELLSAVEID+iSaveThrowType);
	int iModifier;
	string sSaveThrowType = CSLSaveBaseTypeToString(iSaveThrowType);
	
	
	string sModifier = GetLocalString(oTarget,"CSL_MOD_SAVINGTHROW_"+sSaveThrowType );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iSaveThrowType );
		//int iCurrentScore = GetAbilityScore(oTarget, iSaveThrowType, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	//iModifier = CSLGetMin(iModifier,12);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	if ( iModifier > 0 )
	{
		eEffect = EffectSavingThrowIncrease(iSaveThrowType,iModifier);
		
	}
	else if ( iModifier < 0 )
	{
		eEffect = EffectSavingThrowDecrease(iSaveThrowType,-iModifier);
		
	}
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_SAVINGTHROW_"+sSaveThrowType,IntToString(iModifier) );
	
	return iModifier;
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustSkillEffect( int iAdjustmentAmount, int iSkill, object oTarget = OBJECT_SELF )
{
	/*
		effect EffectSkillIncrease(int nSkill, int nValue);
	effect EffectSkillDecrease(int nSkill, int nValue);
	void SetBaseSkillRank(object oCreature, int nSkill, int nRank, int bTrackWithLevel = TRUE);
	*/
	int iSpellId = -(CSL_CHARMOD_SPELLSKILLID+iSkill);
	int iModifier;
	string sSkill = CSLSkillTypeToString(iSkill);
	
	
	string sModifier = GetLocalString(oTarget,"CSL_MOD_SKILL_"+sSkill );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iSkill );
		//int iCurrentScore = GetAbilityScore(oTarget, iSkill, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	//iModifier = CSLGetMin(iModifier,12);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	if ( iModifier > 0 )
	{
		eEffect = EffectSkillIncrease(iSkill,iModifier);
		
	}
	else if ( iModifier < 0 )
	{
		eEffect = EffectSkillDecrease(iSkill,-iModifier);
		
	}
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_SKILL_"+sSkill,IntToString(iModifier) );
	
	return iModifier;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustSkillBase( int iAdjustmentAmount, int iSkill, object oTarget = OBJECT_SELF )
{
	string sSkill = CSLAbilityStatToString(iSkill);
	
	int iOriginalStat = GetLocalInt(oTarget,"CSL_SKILLORIG_"+sSkill ); // store original stat just because we might run into trouble
	if ( iOriginalStat == 0 )
	{
		SetLocalInt(oTarget,"CSL_SKILLORIG_"+sSkill,GetAbilityScore(oTarget,iSkill,TRUE) );
	}
	
	
	int iRawScore = GetSkillRank(iSkill,oTarget,TRUE)+iAdjustmentAmount;
	iRawScore = CSLGetWithinRange(iRawScore,0,50);
	// void SetBaseSkillRank(object oCreature, int nSkill, int nRank, int bTrackWithLevel = TRUE);
	SetBaseSkillRank(oTarget,iSkill,iRawScore);
	return iRawScore;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustDamageEffect( int iAdjustmentAmount, int iDamageType = DAMAGE_TYPE_VARIED, object oTarget = OBJECT_SELF )
{
	int iSpellId = -(CSL_CHARMOD_SPELLDAMAGEID+iDamageType);
	int iModifier;
		
	string sModifier = GetLocalString(oTarget,"CSL_MOD_DAMAGE_"+IntToString(iDamageType) );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iAttack );
		//int iCurrentScore = GetAbilityScore(oTarget, iAttack, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	iModifier += iAdjustmentAmount;
	
	//iModifier = CSLGetMin(iModifier,12);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	if ( iModifier > 0 )
	{
		eEffect = EffectDamageIncrease(iModifier, iDamageType);
		
	}
	else if ( iModifier < 0 )
	{
		eEffect = EffectDamageDecrease(-iModifier, iDamageType);
		
	}
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_DAMAGE_"+IntToString(iDamageType),IntToString(iModifier) );
	
	return iModifier;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustArcaneSpellFailureEffect( int iAdjustmentAmount, object oTarget = OBJECT_SELF )
{
	
	int iSpellId = -(CSL_CHARMOD_SPELLARCSPELLFAILID);
	int iModifier;
		
	string sModifier = GetLocalString(oTarget,"CSL_MOD_ARCSPELLFAILURE" );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iAttack );
		//int iCurrentScore = GetAbilityScore(oTarget, iAttack, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	iModifier = CSLGetMin(iModifier,100);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	
	eEffect = EffectArcaneSpellFailure(iModifier);
	
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_ARCSPELLFAILURE",IntToString(iModifier) );
	
	return iModifier;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustArmorCheckPenaltyEffect( int iAdjustmentAmount, object oTarget = OBJECT_SELF )
{
	
	int iSpellId = -(CSL_CHARMOD_SPELLARMORCHECKPENID);
	int iModifier;
		
	string sModifier = GetLocalString(oTarget,"CSL_MOD_ARCSPELLFAILURE" );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iAttack );
		//int iCurrentScore = GetAbilityScore(oTarget, iAttack, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	iModifier = CSLGetMax(iModifier,0);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	
	if ( iModifier > 0 )
	{
		eEffect = EffectArmorCheckPenaltyIncrease(oTarget,iModifier ); // only positive of this, so can't really modify
		
	}
	//else if ( iModifier < 0 )
	//{
	//	eEffect = EffectAttackDecrease(-iModifier, iAttackType);
	//	
	//}
	
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_ARCSPELLFAILURE",IntToString(iModifier) );
	
	return iModifier;
}

/*
int CSLAdjustEncumbranceEffect( int iAdjustmentAmount, object oTarget = OBJECT_SELF )
{
	
	int iSpellId = -(CSL_CHARMOD_SPELLARMORCHECKPENID);
	int iModifier;
		
	string sModifier = GetLocalString(oTarget,"CSL_MOD_ARCSPELLFAILURE" );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iAttack );
		//int iCurrentScore = GetAbilityScore(oTarget, iAttack, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	iModifier = CSLGetMax(iModifier,0);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	
	if ( iModifier > 0 )
	{
		eEffect = EffectArmorCheckPenaltyIncrease(oTarget,iModifier ); // only positive of this, so can't really modify
		
	}
	//else if ( iModifier < 0 )
	//{
	//	eEffect = EffectAttackDecrease(-iModifier, iAttackType);
	//	
	//}
	
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_ARCSPELLFAILURE",IntToString(iModifier) );
	
	return iModifier;
}
// */

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustGold( int iAdjustmentAmount, object oTarget = OBJECT_SELF )
{
	if ( iAdjustmentAmount > 0 )
	{
		GiveGoldToCreature(oTarget, iAdjustmentAmount, FALSE );
	}
	else if ( iAdjustmentAmount < 0 )
	{
		TakeGoldFromCreature(-iAdjustmentAmount, oTarget, TRUE, FALSE);
	}	
	return iAdjustmentAmount;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustHitPoints( int iAdjustmentAmount, object oTarget = OBJECT_SELF )
{
	
	int iSpellId = -(CSL_CHARMOD_SPELLHITPOINTSID);
	int iModifier;
	
	// SendMessageToPC( GetFirstPC(),"Adjusting Hitpoints by "+IntToString(iAdjustmentAmount));
	int iCurrentHitpoints = GetCurrentHitPoints(oTarget);
	int iTargetHitpoints = iCurrentHitpoints+iAdjustmentAmount;
	int iMaxHitpoints =  GetMaxHitPoints(oTarget);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId ); // make sure any temporary hit points are gone
	if ( iTargetHitpoints <= iMaxHitpoints )
	{		
		if ( iAdjustmentAmount < 0 )
		{
			//effect EffectDamage(int nDamageAmount, int nDamageType=DAMAGE_TYPE_MAGICAL, int nDamagePower=DAMAGE_POWER_NORMAL, int nIgnoreResistances=FALSE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(-iAdjustmentAmount, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY,TRUE )), oTarget );	
			return iAdjustmentAmount;
		}
		else if ( iAdjustmentAmount > 0 )
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectHeal(iAdjustmentAmount)), oTarget );
		}
		return iAdjustmentAmount;
	}
	else
	{
		int iBonusHitPoints = iTargetHitpoints - iMaxHitpoints;
		
		effect eEffect = EffectTemporaryHitpoints( iBonusHitPoints );
		eEffect = SupernaturalEffect(eEffect);
		eEffect = SetEffectSpellId(eEffect,iSpellId);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);
		return iBonusHitPoints;
	
	}
	
	return 0; // should not have hit this
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustAttackEffect( int iAdjustmentAmount, int iAttackType = ATTACK_BONUS_MISC, object oTarget = OBJECT_SELF )
{
	int iSpellId = -(CSL_CHARMOD_SPELLATTACKID+iAttackType);
	int iModifier;
		
	string sModifier = GetLocalString(oTarget,"CSL_MOD_ATTACK_"+IntToString(iAttackType) );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iAttack );
		//int iCurrentScore = GetAbilityScore(oTarget, iAttack, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	//iModifier = CSLGetMin(iModifier,12);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	if ( iModifier > 0 )
	{
		eEffect = EffectAttackIncrease(iModifier, iAttackType);
		
	}
	else if ( iModifier < 0 )
	{
		eEffect = EffectAttackDecrease(-iModifier, iAttackType);
		
	}
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_ATTACK_"+IntToString(iAttackType),IntToString(iModifier) );
	
	return iModifier;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustACEffect( int iAdjustmentAmount, int iACType = AC_DODGE_BONUS, object oTarget = OBJECT_SELF )
{
	/*
	int GetAC(object oObject, int nForFutureUse=0);
	effect EffectACDecrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL);
	effect EffectACIncrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL, int bVsSpiritsOnly=FALSE);
	int    AC_DODGE_BONUS                   = 0;
	int    AC_NATURAL_BONUS                 = 1;
	int    AC_ARMOUR_ENCHANTMENT_BONUS      = 2;
	int    AC_SHIELD_ENCHANTMENT_BONUS      = 3;
	int    AC_DEFLECTION_BONUS              = 4;

	*/
	
	int iSpellId = -(CSL_CHARMOD_SPELLACID+iACType);
	int iModifier;
		
	string sModifier = GetLocalString(oTarget,"CSL_MOD_AC_"+IntToString(iACType) );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iAC );
		//int iCurrentScore = GetAbilityScore(oTarget, iAC, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	//iModifier = CSLGetMin(iModifier,12);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	if ( iModifier > 0 )
	{
		eEffect = EffectACIncrease(iModifier, iACType);
		
	}
	else if ( iModifier < 0 )
	{
		eEffect = EffectACDecrease(-iModifier, iACType);
		
	}
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_AC_"+IntToString(iACType),IntToString(iModifier) );
	
	return iModifier;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLAdjustSREffect( int iAdjustmentAmount, object oTarget = OBJECT_SELF )
{
	/*
	int GetAC(object oObject, int nForFutureUse=0);
	effect EffectACDecrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL);
	effect EffectACIncrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL, int bVsSpiritsOnly=FALSE);
	int    AC_DODGE_BONUS                   = 0;
	int    AC_NATURAL_BONUS                 = 1;
	int    AC_ARMOUR_ENCHANTMENT_BONUS      = 2;
	int    AC_SHIELD_ENCHANTMENT_BONUS      = 3;
	int    AC_DEFLECTION_BONUS              = 4;

	*/
	
	int iSpellId = -(CSL_CHARMOD_SPELLRESISTID);
	int iModifier;
		
	string sModifier = GetLocalString(oTarget,"CSL_MOD_SR" );
	if ( sModifier == "" )
	{
		//int iRawScore = CSLGetNaturalAbilityScore(oTarget, iAttack );
		//int iCurrentScore = GetAbilityScore(oTarget, iAttack, FALSE);
		//int iCurrentModifier = iCurrentScore - iRawScore;
		iModifier = 0;
	}
	else
	{
		iModifier = StringToInt(sModifier);
	}
	
	iModifier += iAdjustmentAmount;
	
	//iModifier = CSLGetMin(iModifier,12);
	// remove previous versions
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
	effect eEffect;
	if ( iModifier > 0 )
	{
		eEffect = EffectSpellResistanceIncrease(iModifier, -1);
		
	}
	else if ( iModifier < 0 )
	{
		eEffect = EffectSpellResistanceDecrease(-iModifier);
		
	}
	eEffect = SupernaturalEffect(eEffect);
	eEffect = SetEffectSpellId(eEffect,iSpellId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);

	SetLocalString(oTarget,"CSL_MOD_SR",IntToString(iModifier) );
	
	return iModifier;
}


void CSLUpdateStatsUIDisplay( object oChar )
{
	int iHD = GetHitDice(oChar)+1;
	
	string sTopLine;
	sTopLine += "XP " + IntToString( GetXP(oChar) );
	sTopLine += " / " + IntToString( ((iHD * (iHD - 1)) / 2) * 1000 );


	string sBottomLine;
	sBottomLine += "AC " + IntToString(GetAC(oChar));
	sBottomLine += " BAB " + IntToString(GetBaseAttackBonus(oChar));  // GetBaseAttackBonus  // GetTRUEBaseAttackBonus
	sBottomLine += " HP " + IntToString(GetCurrentHitPoints(oChar));

	SetGUIObjectText( oChar, "SCREEN_PLAYERMENU", "MAINSCREEN_EXPERIENCE", 1, sTopLine );
	SetGUIObjectText( oChar, "SCREEN_PLAYERMENU", "MAINSCREEN_STATS", 1, sBottomLine );
	
	
	// lets fix autofollow now
	object oTarget = GetPlayerCurrentTarget(oChar);
	if ( GetLocalInt(oChar, "CSL_FOLLOW") )
	{
		SetGUIObjectHidden( oChar, "SCREEN_HOTBAR", "followOn-btn", TRUE ); // hides
		SetGUIObjectHidden( oChar, "SCREEN_HOTBAR", "followOff-btn", FALSE ); // shows
	}
	else if ( CSLAutoFollowIsValid( oChar, oTarget )  ) 
	{
		// turn it so on button and enabled
		SetGUIObjectHidden( oChar, "SCREEN_HOTBAR", "followOn-btn", FALSE ); // shows
		SetGUIObjectDisabled( oChar, "SCREEN_HOTBAR", "followOn-btn", FALSE ); //enables
		SetGUIObjectHidden( oChar, "SCREEN_HOTBAR", "followOff-btn", TRUE ); // hides
	}
	else // turn it on button and disabled
	{
		SetGUIObjectHidden( oChar, "SCREEN_HOTBAR", "followOn-btn", FALSE ); // shows
		SetGUIObjectDisabled( oChar, "SCREEN_HOTBAR", "followOn-btn", TRUE ); // disables
		SetGUIObjectHidden( oChar, "SCREEN_HOTBAR", "followOff-btn", TRUE ); // hides
	}
	
	// fixes counterspell being available
	if ( GetHasFeat( FEAT_COUNTERSPELL, oChar) )
	{
		SetGUIObjectDisabled( oChar, "SCREEN_HOTBAR", "counterspellOn-btn", FALSE ); // enables button
	}
	else
	{
		SetGUIObjectDisabled( oChar, "SCREEN_HOTBAR", "counterspellOn-btn", TRUE ); // disables button
	}
	
	

}


/*
else if (sTool=="faction")
	{
		if (GetIsPC(oTarget))
		{
			SendMessageToPC(oPC, "Target must NOT be a PC for this function.");			
			return DMFI_STATE_ERROR;
		}
		
		if (sCommand=="hostile")
			nTest = 0;
		else if (sCommand=="commoner")
			nTest = 1;
		else if (sCommand=="defender")
			nTest = 3;
		else if (sCommand=="merchant")
			nTest = 2;
		else 
		{
			SendMessageToPC(oPC, "Default Faction Required as Parameter.");			
			return DMFI_STATE_ERROR;
		}
		AssignCommand(oTarget, ClearAllActions(TRUE));
		ChangeToStandardFaction(oTarget, nTest);
		
		oTest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oTarget, 1);
		if (GetIsObjectValid(oTest))
			DelayCommand(1.0, AssignCommand(oTarget, ActionAttack(oTest, FALSE)));
	
		SendMessageToPC(oPC, "Target set to faction: " + sCommand);
	}
	*/



/*
if (sCommand=="on")
		{
			n = 1;
			oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			while (GetIsObjectValid(oTarget))
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
				oTest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget, 1);
				if (GetIsObjectValid(oTest))
					DelayCommand(1.0, AssignCommand(oTarget, ActionAttack(oTest, FALSE)));
				n++;
				oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			}
			SendMessageToPC(oPC, "START BATTLE: All NPCs set to HOSTILE");
		}
		else 
		{
			n = 1;
			oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			while (GetIsObjectValid(oTarget))
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				ChangeToStandardFaction(oTarget, STANDARD_FACTION_COMMONER);
				n++;
				oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			}
			SendMessageToPC(oPC, "STOP BATTLE:  All NPCs set to Commoner");
		}
		*/


	//int iRawScore = GetAbilityScore(oTarget,iStat,TRUE);
	/*
	effect EffectDamageIncrease(int nBonus, int nDamageType=DAMAGE_TYPE_MAGICAL, int nVersusRace=-1);
effect EffectDamageDecrease(int nPenalty, int nDamageType=DAMAGE_TYPE_MAGICAL);
effect EffectAttackDecrease(int nPenalty, int nModifierType=ATTACK_BONUS_MISC);
effect EffectAttackIncrease(int nBonus, int nModifierType=ATTACK_BONUS_MISC);

	
	
	int SAVING_THROW_ALL                    = 0;
	int SAVING_THROW_FORT                   = 1;
	int SAVING_THROW_REFLEX                 = 2;
	int SAVING_THROW_WILL                   = 3;
	
	int SAVING_THROW_CHECK_FAILED           = 0;
	int SAVING_THROW_CHECK_SUCCEEDED        = 1;
	int SAVING_THROW_CHECK_IMMUNE           = 2;
	
	
	int SAVING_THROW_TYPE_ALL               = 0;
	int SAVING_THROW_TYPE_NONE              = 0;
	int SAVING_THROW_TYPE_MIND_SPELLS       = 1;
	int SAVING_THROW_TYPE_POISON            = 2;
	int SAVING_THROW_TYPE_DISEASE           = 3;
	int SAVING_THROW_TYPE_FEAR              = 4;
	int SAVING_THROW_TYPE_SONIC             = 5;
	int SAVING_THROW_TYPE_ACID              = 6;
	int SAVING_THROW_TYPE_FIRE              = 7;
	int SAVING_THROW_TYPE_ELECTRICITY       = 8;
	int SAVING_THROW_TYPE_POSITIVE          = 9;
	int SAVING_THROW_TYPE_NEGATIVE          = 10;
	int SAVING_THROW_TYPE_DEATH             = 11;
	int SAVING_THROW_TYPE_COLD              = 12;
	int SAVING_THROW_TYPE_DIVINE            = 13;
	int SAVING_THROW_TYPE_TRAP              = 14;
	int SAVING_THROW_TYPE_SPELL             = 15;
	int SAVING_THROW_TYPE_GOOD              = 16;
	int SAVING_THROW_TYPE_EVIL              = 17;
	int SAVING_THROW_TYPE_LAW               = 18;
	int SAVING_THROW_TYPE_CHAOS             = 19;

	
	int GetFortitudeSavingThrow(object oTarget);
	int GetWillSavingThrow(object oTarget);
	int GetReflexSavingThrow(object oTarget);
	// - nSave: SAVING_THROW_* (not SAVING_THROW_TYPE_*)
	effect EffectSavingThrowDecrease(int nSave, int nValue, int nSaveType=SAVING_THROW_TYPE_ALL);
	effect EffectSavingThrowIncrease(int nSave, int nValue, int nSaveType=SAVING_THROW_TYPE_ALL, int bVsSpiritsOnly=FALSE);
	*/

/*
void SetNoticeText( object oPlayer, string sText );  // UIText_OnUpdate_DisplayNoticeText()



void SetRenderWaterInArea( object oArea, int bRender );



effect EffectDamageReductionNegated();
effect EffectConcealmentNegated();


void SetGUIProgressBarPosition( object oPlayer, string sScreenName, string sUIObjectName, float fPosition );
void SetScrollBarRanges( object oPlayer, string sScreenName, string sScrollBarName, int nMinSize, int nMaxSize, int nMinValue, int nMaxValue );
void SetScrollBarValue( object oPlayer, string sScreenName, string sScrollBarName, int nValue );


object GetPlayerCurrentTarget( object oCreature );
object GetPlayerCreatureExamineTarget( object oCreature );


int SetWeaponVisibility( object oObject, int nVisibile, int nType=0 );


effect EffectMaxDamage();





int GetTRUEBaseAttackBonus( object oTarget );
effect EffectBABMinimum( int nBABMin );



effect EffectBonusHitpoints( int nHitpoints );


void SetLevelUpPackage( object oCreature, int nPackage );
int GetLevelUpPackage( object oCreature );

void SetCombatOverrides( object oCreature, object oTarget, int nOnHandAttacks, int nOffHandAttacks, int nAttackResult, int nMinDamage, int nMaxDamage, int bSuppressBroadcastAOO, int bSuppressMakeAOO, int bIgnoreTargetReaction, int bSuppressFeedbackText );
void ClearCombatOverrides( object oCreature );


int GetNumActions( object oObject );


effect EffectArmorCheckPenaltyIncrease( object oTarget, int nPenaltyAmt ); always positive


int GetCharBackground( object oCreature );


int GetStealthMode(object oCreature);
int GetDetectMode(object oCreature);
int GetDefensiveCastingMode(object oCreature);
int GetAppearanceType(object oCreature);

void SetSkillPointsRemaining(object oPC, int nPoints);
int GetSkillPointsRemaining(object oPC);



int GetSpellResistance( object oCreature );
eSREffect = EffectSpellResistanceIncrease(nSREffect);
eSREffect = EffectSpellResistanceDecrease(-nSREffect);	
	
	int GetCurrentAction(object oObject=OBJECT_SELF);

effect EffectTurnResistanceDecrease(int nHitDice);
effect EffectTurnResistanceIncrease(int nHitDice);

int GetCollision(object oTarget);
void SetCollision(object oTarget, int bCollision);
	

	
	
	int GetMovementRate(object oCreature);
effect EffectMovementSpeedIncrease(int nPercentChange);
	effect EffectMovementSpeedDecrease(int nPercentChange);
	float GetMovementRateFactor( object oCreature );
void SetMovementRateFactor( object oCreature, float fFactor );




effect EffectNegativeLevel(int nNumLevels, int bHPBonus=FALSE);

effect EffectModifyAttacks(int nAttacks);
void SetBaseAttackBonus( int nBaseAttackBonus, object oCreature = OBJECT_SELF );
void RestoreBaseAttackBonus( object oCreature = OBJECT_SELF );


int GetIsCompanionPossessionBlocked( object oCreature );

int GetIsListening(object oObject);
void SetListening(object oObject, int bValue);



	*/

void CSLModifyLocalIntOnFaction(object oPC, string sVarName, int iDelta, int bPCOnly=TRUE)
{
    object oPartyMem = GetFirstFactionMember(oPC, bPCOnly);
    while (GetIsObjectValid(oPartyMem)) 
	{
		CSLIncrementLocalInt(oPartyMem, sVarName, iDelta);
        oPartyMem = GetNextFactionMember(oPC, bPCOnly);
    }
}	

// Return the number of other players in the PC's party
// Does NOT include associates.
int CSLGetNumberPartyMembers(object oPC)
{
    int nNumber = 1;
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem))
    {

        nNumber++;
        // * MODIFIED February 2003. Was an infinite loop before
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    return nNumber;
}






// Given a gold value, divides it equally among the party members
// None given to associates.
void CSLGiveGoldToAllEqually(object oPC, int nGoldToDivide)
{
    int nMembers = CSLGetNumberPartyMembers(oPC);
    int nEqualAmt = nGoldToDivide/nMembers;

    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveGoldToCreature(oPartyMem, nEqualAmt);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveGoldToCreature(oPC, nEqualAmt);
}

// Given a gold value, gives that amount to all party members
// None given to associates.
void CSLGiveGoldToAll(object oPC, int nGold)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveGoldToCreature(oPartyMem, nGold);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveGoldToCreature(oPC, nGold);
}


// Given an XP value, divides it equally among party members
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>) to
//      get the amount of XP assigned to that quest in the 
//      journal. 
void CSLGiveXPToAllEqually(object oPC, int nXPToDivide)
{
    int nMembers = CSLGetNumberPartyMembers(oPC);
    int nEqualAmt = nXPToDivide/nMembers;

    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveXPToCreature(oPartyMem, nEqualAmt);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveXPToCreature(oPC, nEqualAmt);
}


// Given an XP value, gives that amount to all party members.
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>)
//      get the amount of XP assigned to that quest in the 
//      journal. 
void CSLGiveXPToAll(object oPC, int nXP)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) {
        GiveXPToCreature(oPartyMem, nXP);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
    //GiveXPToCreature(oPC, nXP);
}


/* not used
int CSLGetJournalQuestEntry(string sPlotID, object oCreature)
{
    int iQuestEntry = GetLocalInt(oCreature, "NW_JOURNAL_ENTRY" + sPlotID);
 	return (iQuestEntry);
}
*/


/* not used
// Determine if Quest sPlotID is not 0 (assumes non-zero as having been assigned).
int CSLGetIsJournalQuestAssigned(string sPlotID, object oCreature)
{
	return (CSLGetJournalQuestEntry(sPlotID, oCreature) > 0);
}
*/


/*	
// Determine if Quest sPlotID is not 0, but has not reached an endpoint (entryID non-zero and non-endpoint).
GetIsJournalQuestActive(string sPlotID, object oCreature)

// Determine if Quest sPlotID has reached any endpoint.
GetIsJournalQuestFinished(string sPlotID, object oCreature)
*/

// Return last auto save time hash
/* not used
int CSLGetAutoSaveTimeHash()
{
	int nTimeHash = GetGlobalInt( "00_nAutoSaveLastSave" );
	return ( nTimeHash );
}
*/

// Return TRUE if Single Player and sufficient time has passed since last save
int CSLGetAbleToAutoSave( int bUseCoolDown=TRUE )
{	
	if ( GetIsSinglePlayer() )
	{
		if ( bUseCoolDown )
		{
			int nCurrentTime = CSLGetCurrentTimeHash();
			int nLastSave = GetGlobalInt( "00_nAutoSaveLastSave" );
			//CSLMessage_PrettyMessage( "nCurrentTime = " + IntToString( nCurrentTime ) + ", nLastSave = " + IntToString( nLastSave ) );
			if ( CSLGetTimeHashDifference( nCurrentTime, nLastSave ) >= AUTOSAVE_COOL_DOWN )
			{
				//PrettyDebug( "CSLGetAbleToAutoSave() = TRUE" );
				return ( TRUE );
			}		
		}
		else
		{
			//PrettyDebug( "CSLGetAbleToAutoSave() = TRUE" );
			return ( TRUE );		
		}
	}
	
	//PrettyDebug( "CSLGetAbleToAutoSave() = FALSE" );
	return ( FALSE );
}

// Auto Save if able to auto save
void CSLAttemptSinglePlayerAutoSave( int bUseCoolDown=TRUE )
{
	if ( CSLGetAbleToAutoSave( bUseCoolDown ) == TRUE )
	{
		int nCurrentTime = CSLGetCurrentTimeHash();
		SetGlobalInt( "00_nAutoSaveLastSave", nCurrentTime );
		DoSinglePlayerAutoSave();
	}
}

/* not used anywhere */
// reward w/ plot item - currently gives to all players so all can advance plot on their own
/*
void CSLRewardPartyUniqueItem(object oPC, string sItemResRef)
{
	XXCSLCreateItemOnFaction(oPC, sItemResRef);
}
*/

/* not used anywhere */
// reward player w/ item - currently gives only one of the item - party must decide how to split it up.
/*
void CSLRewardPartyItem(object oPC, string sItemResRef)
{
	XXCreateItemOnObject(sItemResRef, oPC);
}
*/

// reward player w/ Gold - currently everyone gets full amount
void CSLRewardPartyGold(object oPC, int iGold)
{
	CSLGiveGoldToAll(oPC, iGold);
	//CSLGiveGoldToAllEqually(oPC, iGold);
}

// reward player w/ XP - currently everyone gets full amount
// this should be used only for non-quest related XP rewards
void CSLRewardPartyXP(object oPC, int iXP)
{
	CSLGiveXPToAll(oPC, iXP);
	//CSLGiveXPToAllEqually(oPC, iXP);
}


// Give XP rewards for quest.  Amount given is tracked, but there is no cap.
// return amount awarded
int CSLRewardPartyQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100)
{
    // Give the party XP
	int iQuestXPReward =  (GetJournalQuestExperience(sQuestTag) * iQuestXPPercent)/100;
    CSLGiveXPToAll(oPC, iQuestXPReward);

	// track amount given
    string sXPQuestPercentRewarded = sQuestTag + "_XP_QPR";
	CSLModifyLocalIntOnFaction(oPC, sXPQuestPercentRewarded, iQuestXPPercent);

	return (iQuestXPReward);
}





// get the percent rewarded so far to this PC for this quest
int CSLGetQuestXPPercentRewarded(object oPC, string sQuestTag)
{
    string sXPQuestPercentRewarded = sQuestTag + "_XP_QPR";
	int iQuestXPPercentRewarded = GetLocalInt(oPC, sXPQuestPercentRewarded);
	return (iQuestXPPercentRewarded);

}

//----------------------------------------
// Quest Rewards (non-party)
//----------------------------------------

int CSLGetMinXPForLevel(int iLevel)
{
	int nMinXP = StringToInt(Get2DAString("exptable", "XP", iLevel-1));
	return(nMinXP);
}

void CSLAwardXP(object oPC, int iXPAwardID, int bWholeParty=TRUE)
{
	string sWarnText;
	
    int iXP 		= StringToInt(Get2DAString("k_xp_awards", "XP", iXPAwardID));
    int iStringRef 	= StringToInt(Get2DAString("k_xp_awards", "DescStrRef", iXPAwardID));
	string sTlkText = GetStringByStrRef(iStringRef);
    //string sText	= Get2DAString(TABLE_XP_AWARD, "DescriptionText", iXPAwardID);

	if (iStringRef == 0)
	{
		//sWarnText = "DescStrRef not defined in k_xp_awards.2da for Row # " + IntToString(iXPAwardID);
		//PrettyError(sWarnText);
	}
	else if (sTlkText == "")
	{
		//sWarnText = "String # " + IntToString(iStringRef) + " is empty or not found in Tlk table as specified in k_xp_awards.2da for Row # " + IntToString(iXPAwardID);
		//PrettyError(sWarnText);
	}
	
	if (bWholeParty)
	{
		CSLMessage_SendToParty(oPC, sTlkText, TRUE);
		
		CSLRewardPartyXP(oPC, iXP);
	}
	else
	{				
    	SendMessageToPC(oPC, sTlkText);
		SetNoticeText(oPC,sTlkText);
    	GiveXPToCreature(oPC, iXP);
	}
}


// reward xp amount to single player, subject to cap
// return amount awarded
int CSLRewardCappedQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100, int iQuestXPPercentCap = 100)
{
	int iQuestXPPercentRewarded = CSLGetQuestXPPercentRewarded(oPC, sQuestTag);

	// reduce reward to cap amount if necessary
	if ((iQuestXPPercentRewarded + iQuestXPPercent) > iQuestXPPercentCap)
	{
		iQuestXPPercent = iQuestXPPercentCap - iQuestXPPercentRewarded;
		if (iQuestXPPercent < 0)
			return (0);
	}

    string sXPQuestPercentRewarded = sQuestTag + "_XP_QPR";
	int iQuestXPReward =  (GetJournalQuestExperience(sQuestTag) * iQuestXPPercent)/100;
	GiveXPToCreature(oPC, iQuestXPReward);
	CSLIncrementLocalInt(oPC, sXPQuestPercentRewarded, iQuestXPPercent);

	return (iQuestXPReward);
}
	
	
	
// reward xp amount to party, subject to cap
void CSLRewardPartyCappedQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100, int iQuestXPPercentCap = 100)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) 
	{
		CSLRewardCappedQuestXP(oPartyMem, sQuestTag, iQuestXPPercent, iQuestXPPercentCap);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
}	



// heal character by a single point if needed
void CSLConstitutionBugCheck( object oPC )
{
    if ( GetCurrentHitPoints(oPC) > GetMaxHitPoints(oPC))
	{	
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), oPC);	
	}	
}	


void CSLFixSlowingOnExit( object oPC )
{
	// this is going to find a single haste item, and re-equip it to fix the slowing bug on exiting grease and the like
	// just an experiment to see if this works since the boots are dex specific and are always a single boots item
	// mainly based on the fact players say swapping them in and out fixes their issues
	//DelayCommand(0.2, SCReQuip(GetExitingObject(), INVENTORY_SLOT_BOOTS));
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
	if ( oItem == OBJECT_INVALID )
	{
		return;
	}
	
	if ( GetTag(oItem) == "dex_bootsvelocity" )
	{
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_BOOTS)));
		// DelayCommand(0.2, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_BOOTS)));
	}
	
	// try a temporary haste effect of a single round perhaps as well, to see if it can flush out remaining issues
}



void DMFI_Report(object oPC, object oTool, string sCommand)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Report Start", oPC ); }
	//Purpose: Report information for all PCs on the server. sCommand can be
	//Gold Value, XP, Net Worth.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 6/29/6
	string sMessage;
	object oTarget = GetFirstPC();
	
	SendMessageToPC(oPC, "Reporting data for all PCs:");
	while (oTarget!=OBJECT_INVALID)
	{
		if (sCommand=="gold")
		{
			sMessage = " GOLD VALUE: " + IntToString(GetGold(oTarget));
		}
		else if (sCommand=="xp")
		{
			sMessage = " CURRENT XP: " + IntToString(GetXP(oTarget));
		}
		else if (sCommand=="networth")
		{
			sMessage = " NET WORTH: " + IntToString(DMFI_GetNetWorth(oTarget));
		}

		SendMessageToPC(oPC, GetName(oTarget) + sMessage);
		oTarget = GetNextPC();
	}
}


object DMFI_BestRoller(object oTarget, int bSkill, int nConstant)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BestRoller Start", GetFirstPC() ); }
	//Purpose: Return the "best roller" for the skill from oTarget's Party
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 1/7/7
	object oRoller;
	int nMod;
	int nBestMod = -99;
	object oBestRoller;
	int nTest;
	
	if (!GetIsPC(oTarget))
		return oTarget;

	oRoller = GetFirstFactionMember(oTarget, FALSE);
	while (oRoller!=OBJECT_INVALID)
	{
			if (bSkill==1)
			{ // get skill mod
				nMod = GetSkillRank(nConstant, oRoller);
				if (nMod>nBestMod)
				{
					nBestMod = nMod;
					oBestRoller = oRoller;
				}
			} // get skill mod
			else if (bSkill==2)
			{ // get ability mod
				nMod = GetAbilityModifier(nConstant, oRoller);
				if (nMod>nBestMod)
				{
					nBestMod = nMod;
					oBestRoller = oRoller;
				}
			} // get ability mod
			else if (bSkill==3)
			{// get saving throw mod
				if (nConstant==1)	nMod = GetFortitudeSavingThrow(oRoller);
				else if (nConstant==2)  nMod = GetReflexSavingThrow(oRoller);
				else if (nConstant==3)  nMod = GetWillSavingThrow(oRoller);
			
				if (nMod>nBestMod)
				{
					nBestMod = nMod;
					oBestRoller = oRoller;
				}
			}// get saving throw mod
				
		oRoller = GetNextFactionMember(oTarget, FALSE);
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BestRoller End", GetFirstPC() ); }
	return oBestRoller;
}


void DMFI_RollCheck(object oSpeaker, string sSkill, int bDMRequest=FALSE, object oDM=OBJECT_INVALID, object oTool=OBJECT_INVALID)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_RollCheck Start", GetFirstPC() ); }
	//Purpose: Rolls a check for oSpeaker
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 9/22/6
	int nMod;
	int nRoll;
	int bSkill;
	int nConstant;
	int nTotal;
	int bFail;
	string sText;
	string sDC;
	string sDetail;
	string sReport;
	string sRoll;
	string sRollText;
	string sDMRollText;
	object oRoller;
	object oAgainst;
	string sName;

	if (sSkill == EMT_ABL_STRENGTH)	{ bSkill=2; nConstant=0;}
	else if (sSkill == EMT_ABL_DEXTERITY)	{ bSkill=2; nConstant=1; }
	else if (sSkill == EMT_ABL_CONSTITUTION)  { bSkill=2; nConstant=2; }
	else if (sSkill == EMT_ABL_INTELLIGENCE)  { bSkill=2; nConstant=3; }
	else if (sSkill == EMT_ABL_WISDOM)		{ bSkill=2; nConstant=4; }
	else if (sSkill == EMT_ABL_CHARISMA)	{ bSkill=2; nConstant=5; }

	else if (sSkill == EMT_SAVE_FORTITUDE)	{ bSkill=3; nConstant=1; }
	else if (sSkill == EMT_SAVE_REFLEX)		{ bSkill=3; nConstant=2; }
	else if (sSkill == EMT_SAVE_WILL)		{ bSkill=3; nConstant=3; }

	//else if (sSkill == EMT_SKL_ANIMAL_EMPATHY){ bSkill=1; nConstant=0; bFail=1; }
	else if (sSkill == EMT_SKL_APPRAISE)	{ bSkill=1; nConstant=20;  }
	else if (sSkill == EMT_SKL_BLUFF)		{ bSkill=1; nConstant=23; }
	else if (sSkill == EMT_SKL_CONCENTRATION) { bSkill=1; nConstant=1; }
	else if (sSkill == EMT_SKL_CRAFT_ALCHEMY) { bSkill=1; nConstant=27; }
	else if (sSkill == EMT_SKL_CRAFT_ARMOR)	{ bSkill=1; nConstant=25;  }
	else if (sSkill == EMT_SKL_CRAFT_TRAP)	{ bSkill=1; nConstant=22; }
	else if (sSkill == EMT_SKL_CRAFT_WEAPON)  { bSkill=1; nConstant=26; }
	else if (sSkill == EMT_SKL_DISABLE_TRAP)  { bSkill=1; nConstant=2; bFail=1; }
	else if (sSkill == EMT_SKL_DISCIPLINE)	{ bSkill=1; nConstant=3; }
	else if (sSkill == EMT_SKL_DIPLOMACY)	{ bSkill=1; nConstant=12; }
	else if (sSkill == EMT_SKL_HEAL)		{ bSkill=1; nConstant=4; }
	else if (sSkill == EMT_SKL_HIDE)		{ bSkill=1; nConstant=5; }
	else if (sSkill == EMT_SKL_INTIMIDATE)	{ bSkill=1; nConstant=24; }
	else if (sSkill == EMT_SKL_LISTEN)		{ bSkill=1; nConstant=6; }
	else if (sSkill == EMT_SKL_LORE)		{ bSkill=1; nConstant=7; }
	else if (sSkill == EMT_SKL_MOVE_SILENTLY) { bSkill=1; nConstant=8; }
	else if (sSkill == EMT_SKL_OPEN_LOCK)	{ bSkill=1; nConstant=9; bFail=1; }
	else if (sSkill == EMT_SKL_PARRY)		{ bSkill=1; nConstant=10; }
	else if (sSkill == EMT_SKL_PERFORM)	{ bSkill=1; nConstant=11; }
	//else if (sSkill == EMT_SKL_PERSUADE)	{ bSkill=1; nConstant=12; }
	//else if (sSkill == EMT_SKL_PICK_POCKET)	{ bSkill=1; nConstant=13; bFail=1; }
	else if (sSkill == EMT_SKL_SEARCH)		{ bSkill=1; nConstant=14; }
	else if (sSkill == EMT_SKL_SET_TRAP)	{ bSkill=1; nConstant=15; bFail=1; }
	else if (sSkill == EMT_SKL_SLEIGHT_OF_HAND){ bSkill=1; nConstant=13; bFail=1; }
	else if (sSkill == EMT_SKL_SPELLCRAFT)	{ bSkill=1; nConstant=16; bFail=1;; }
	else if (sSkill == EMT_SKL_SPOT)		{ bSkill=1; nConstant=17; }
	else if (sSkill == EMT_SKL_SURVIVAL)	{ bSkill=1; nConstant=29; }
	else if (sSkill == EMT_SKL_TAUNT)		{ bSkill=1; nConstant=18;; }
	else if (sSkill == EMT_SKL_TUMBLE)		{ bSkill=1; nConstant=21; bFail=1; }
	else if (sSkill == EMT_SKL_USE_MAGIC_DEVICE) { bSkill=1; nConstant=19; bFail=1;; }

	if (!bDMRequest)
	{ // PLAYER CODE
		oAgainst = GetLocalObject(oTool, DMFI_TARGET);
		if (bSkill==1)
		{// get the skill
			nMod = GetSkillRank(nConstant, oSpeaker);
			if ((bFail) && (nMod==0))
			{
				sText = CSLColorText("Roller: " + CSLStringToProper(sSkill) + " FAILED:  Training is required for this skill.", COLOR_RED);
				AssignCommand(oSpeaker, SpeakString(" " + sText));
				return;
			}
		}// get the skill
		else if (bSkill==2)
		{
			nMod = GetAbilityModifier(nConstant, oSpeaker);
		}
		else if (bSkill==3)
		{// get saving throw mod
			if (nConstant==1)	nMod = GetFortitudeSavingThrow(oSpeaker);
			else if (nConstant==2)  nMod = GetReflexSavingThrow(oSpeaker);
			else if (nConstant==3)  nMod = GetWillSavingThrow(oSpeaker);
		}// get saving throw mod
		nRoll = d20();
		
		if (GetIsObjectValid(oAgainst))
		{
			sName = GetName(oAgainst);
		}
		else
		{
			sName = "General Area";	
		}
		sText = "  Against DC: " + sName;
		
		sText = sText + "\n" + CSLColorText("Roller: " + CSLStringToProper(sSkill) + "  Mod: " + IntToString(nMod) + "  TOTAL: " + IntToString(nRoll+nMod), COLOR_CYAN);
		AssignCommand(oSpeaker, SpeakString(" " + sText));
		SetLocalObject(GetModule(), "DMFILastRoller", oSpeaker);
	} // PLAYER CODE
	
	else
	{ // DM CODE
		sDC = GetStringLowerCase(GetLocalString(oTool, "DMFIDicebagDC"));
		sDetail = GetStringLowerCase(GetLocalString(oTool, "DMFIDicebagDetail"));
		sReport = GetStringLowerCase(GetLocalString(oTool, "DMFIDicebagReport"));
		sRoll = GetStringLowerCase(GetLocalString(oTool, "DMFIDicebagRoll"));

		if (sRoll=="party")
		{
			oRoller = GetFirstFactionMember(oSpeaker, FALSE);
		}
		else if (sRoll=="pc")
		{
			oRoller = oSpeaker;
		}
		else if (sRoll=="best")
		{
			oRoller = DMFI_BestRoller(oSpeaker, bSkill, nConstant);
		}
		
		while (oRoller!=OBJECT_INVALID)
		{
			if (bSkill==1)
			{
				nMod = GetSkillRank(nConstant, oRoller);
				if (bFail==1 && nMod==0)
				{
					sText = CSLColorText("Roller: " + GetName(oRoller) + " FAILED:  Training is required for this skill.", COLOR_RED);
					
					if (sReport=="dm")
						SendMessageToPC(oDM, sText);
				
					else if (sReport=="party")
					{
						CSLMessage_SendTalkText(oRoller, sText);
						SendMessageToPC(oDM, sText);
					}	
					else
					{
						SendMessageToPC(oRoller, sText);
						SendMessageToPC(oDM, sText);
					}
					return;
				}
			}
			else if (bSkill==2) 
			{
				nMod=GetAbilityModifier(nConstant, oRoller);
			}
			else if (bSkill==3)
			{// get saving throw mod
				if (nConstant==1)	nMod = GetFortitudeSavingThrow(oSpeaker);
				else if (nConstant==2)  nMod = GetReflexSavingThrow(oSpeaker);
				else if (nConstant==3)  nMod = GetWillSavingThrow(oSpeaker);
			}// get saving throw mod

			nRoll = d20();
			nTotal = nRoll + nMod;

			if (nTotal >= StringToInt(sDC)) 
			{
				sRollText = " SUCCESS ";
			}
			else
			{
				sRollText = " FAILED ";
			}

			// EXAMPLE:  WISDOM  FAILED
			sRollText = CSLStringToProper(sSkill) + sRollText;
			sDMRollText = sRollText;
			// EXAMPLE:  WIS FAILED + ROLL RESULT
			if (sDetail!="low") sRollText = sRollText + "  Mod: " + IntToString(nMod) + "  TOTAL: " + IntToString(nTotal);
			sDMRollText = sDMRollText + "  Mod: " + IntToString(nMod) + "  TOTAL: " + IntToString(nTotal);
			// EXAMPLE:  WIS FAILED + ROLL RESULT AGAINST DC OF
			if (sDetail=="high") sRollText = sRollText + "  Against DC: " + sDC;
			sDMRollText = sDMRollText + "  Against DC: " + sDC;

			if (sReport=="dm")
			{
				SendMessageToPC(oDM, "Roller: " + GetName(oRoller) + " " + sDMRollText);
			}
			else if (sReport=="party")
			{
				CSLMessage_SendTalkText(oRoller, " "+ sRollText, COLOR_CYAN);
				SendMessageToPC(oDM, "Roller: " + GetName(oRoller) + " " + sDMRollText);
			}
			else
			{
				SendMessageToPC(oRoller, " " + sRollText);
				SendMessageToPC(oDM, "Roller: " + GetName(oRoller) + " " + sDMRollText);
			}
			// REPEAT IF APPROPRIATE AND IF NOT, BREAK FROM LOOP
			if ((sRoll=="party") && (GetIsPC(oSpeaker)))
			{
				oRoller = GetNextFactionMember(oSpeaker, FALSE);
			}
			else
			{
				oRoller = OBJECT_INVALID;
			}
		}
	}// DM CODE

} // DMFI_RollCheck()

//DMFI function, review to consolidate ( already have a list party function )
void SeeParty(object oDM)
{
    object oParty = GetFirstPC();
    string sFin = "<b>DMFI STATUS SHEET</b>\n\n";
    
    while (GetIsObjectValid(oParty))
	{
		string sName = GetName(oParty);
		string sAccount = GetPCPlayerName(oParty);
		string sCDKey = GetPCPublicCDKey(oParty);
		string sCurHp = IntToString(GetCurrentHitPoints(oParty));
		string sMaxHp = IntToString(GetMaxHitPoints(oParty));
		object oArea = GetArea(oParty);
		string sArea = GetName(oArea);
		string sDesc = GetDescription(oParty);
		string sDest = GetStringLeft(sDesc,120);
		int iIntObj = ObjectToInt(oParty);
		int iIntArea = ObjectToInt(oArea);
		string sIObj = IntToString(iIntObj);
		string sIAre = IntToString(iIntArea);
		
		
		sFin = sFin+"<b>"+sName+"</b>: ("+sCurHp+"/"+sMaxHp+")  ("+sIObj+").\n";
		sFin += "Account: "+sAccount+"";
		if ( sCDKey != "" )
		{
			sFin += " ( "+sCDKey+" ).";
		}
		sFin += "\n";
		sFin += "Location: <i>"+sArea+"</i> ("+sIAre+")\n";
		sFin += "<i>"+sDesc+"</i>\n\n";
		
		oParty = GetNextPC();
	}
        
    DisplayMessageBox(oDM,-1,sFin,"","",FALSE,"SCREEN_MESSAGEBOX_REPORT",0,"Done");	    
    
}


void DMFI_RollBones(object oPC, object oTarget, string sCommand)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_RollBones Start", oPC ); }
	//Purpose: Rolls dice for oTarget: 2d4 = two dice with 4 sides
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 9/22/6
	int n, nLength, nTest, nNum, nDice;
	string sDice, sReport, sRoll;
	object oTool, oTest;
	nLength = GetStringLength(sCommand);
	nTest = FindSubString(sCommand, "d");

	nNum = StringToInt(GetStringLeft(sCommand, nTest));
	nDice = StringToInt(GetStringRight(sCommand, nLength -(nTest+1)));

	n = ((nDice==2) || (nDice==3) || (nDice==4) || (nDice==6) || (nDice==8) ||
		(nDice==10) || (nDice==12) || (nDice==20) || (nDice==100));

	if ( n && nTest!=-1)
	{ // valid format
		if (CSLGetIsDM(oPC))
		{	// DM Code
			oTool = CSLDMFI_GetTool(oPC);
			sReport = GetStringLowerCase(GetLocalString(oTool, "DMFIDicebagReport"));
			sRoll = GetStringLowerCase(GetLocalString(oTool, "DMFIDicebagRoll"));

			if (sReport=="party")
			{
				oTest = GetFirstFactionMember(oTarget, FALSE);
			}
			else
			{
				oTest = oTarget;
			}
		}	// END DM Code
		else
		{
			oTest = oPC;
		}

		while (oTest!=OBJECT_INVALID)
		{ // WHILE STATEMENT
			switch (nDice)
			{
				case 2: { n = d2(nNum); sDice = "d2" ; break;}
				case 3: { n = d3(nNum); sDice = "d3" ; break;}
				case 4: { n = d4(nNum); sDice = "d4" ; break;}
				case 6: { n = d6(nNum); sDice = "d6" ; break;}
				case 8: { n = d8(nNum); sDice = "d8" ; break;}
				case 10:{ n = d10(nNum);sDice = "d10" ;break;}
				case 12:{ n = d12(nNum);sDice = "d12" ;break;}
				case 20:{ n = d20(nNum);sDice = "d20" ;break;}
				case 100:{ n= d100(nNum);sDice = "d100" ;break;}
				default: n=0;
			}
			if (nNum==0) 
			{
				n=0; // special case override
			}
			if (CSLGetIsDM(oPC))
			{
				if (sReport=="dm")
				{
					SendMessageToPC(oPC, "Roller: " + GetName(oTest) + " " + "DMFI Dicebag Result: " + IntToString(nNum) + sDice + "= " + IntToString(n));
				}
				if (sReport=="party")
				{
					CSLMessage_SendTalkText(oTest, " " + "DMFI Dicebag Result: " + IntToString(nNum) + sDice+" = " + IntToString(n), COLOR_CYAN);
					SendMessageToPC(oPC, "Roller: " + GetName(oTest) + " " + "DMFI Dicebag Result: " + IntToString(nNum) + sDice + "= " + IntToString(n));
				}
				else
				{
					SendMessageToPC(oTest, " " + "DMFI Dicebag Result: " + IntToString(nNum) + sDice+" = " + IntToString(n));
					SendMessageToPC(oPC, "Roller: " + GetName(oTest) + " " + "DMFI Dicebag Result: " + IntToString(nNum) + sDice + "= " + IntToString(n));
				}
			}
			else
			{
				CSLMessage_SendTalkText(oTest, " " + "DMFI Dicebag Result: " + IntToString(nNum) + sDice+" = " + IntToString(n), COLOR_CYAN);
			}
			if (sReport=="party")
			{
				oTest = GetNextFactionMember(oTarget, TRUE);
			}
			else
			{
				oTest=OBJECT_INVALID;
			}
		} // WHILE STATEMENT
	} // VALID FORMAT
	else
	{ // NOT VALID FORMAT
		SendMessageToPC(oPC, "DMFI Dice format is .roll 2d4 where you roll d4 times 2. D&D Dice only.");
	} // NOT VALID FORMAT
}


string DMFI_FindPartialSkill(string sCommand)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_FindPartialSkill Start", GetFirstPC() ); }
	//Purpose: Returns full version of a shortcut skill, ability, save
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 6/27/6
	string sSkill;
	if	(FindSubString(sCommand, "str")!=-1)	{ sSkill = EMT_ABL_STRENGTH; }
	else if (FindSubString(sCommand, "dex")!=-1)	{ sSkill = EMT_ABL_DEXTERITY; }
	else if (FindSubString(sCommand, "cons")!=-1) { sSkill = EMT_ABL_CONSTITUTION; }
	else if (FindSubString(sCommand, "inte")!=-1) { sSkill = EMT_ABL_INTELLIGENCE; }
	else if (FindSubString(sCommand, "wis")!=-1)	{ sSkill = EMT_ABL_WISDOM; }
	else if (FindSubString(sCommand, "cha")!=-1)	{ sSkill = EMT_ABL_CHARISMA; }
	
	else if (FindSubString(sCommand, "fort")!=-1)	{ sSkill = EMT_SAVE_FORTITUDE; }
	else if (FindSubString(sCommand, "ref")!=-1)		{ sSkill = EMT_SAVE_REFLEX; }
	else if (FindSubString(sCommand, "wil")!=-1)			{ sSkill = EMT_SAVE_WILL; }
	
	//else if (FindSubString(sCommand, "ani")!=-1) { sSkill = EMT_SKL_ANIMAL_EMPATHY; }
	else if (FindSubString(sCommand, "conc")!=-1)  { sSkill = EMT_SKL_CONCENTRATION; }
	else if (FindSubString(sCommand, "disable")!=-1)	{ sSkill = EMT_SKL_DISABLE_TRAP; }
	else if (FindSubString(sCommand, "disc")!=-1)	{ sSkill = EMT_SKL_DISCIPLINE; }
	else if (FindSubString(sCommand, "hea")!=-1)		{ sSkill = EMT_SKL_HEAL; }
	else if (FindSubString(sCommand, "hid")!=-1)		{ sSkill = EMT_SKL_HIDE; }
	else if (FindSubString(sCommand, "listen")!=-1)		{ sSkill = EMT_SKL_LISTEN; }
	else if (FindSubString(sCommand, "lor")!=-1)		{ sSkill = EMT_SKL_LORE; }
	else if (FindSubString(sCommand, "mov")!=-1)  { sSkill = EMT_SKL_MOVE_SILENTLY; }
	else if (FindSubString(sCommand, "open")!=-1)	{ sSkill = EMT_SKL_SET_TRAP; }
	else if (FindSubString(sCommand, "par")!=-1)		{ sSkill = EMT_SKL_PARRY; }
	else if (FindSubString(sCommand, "perf")!=-1)		{ sSkill = EMT_SKL_PERFORM; }
	//else if (FindSubString(sCommand, "pers")!=-1)	{ sSkill = EMT_SKL_PERSUADE; }
	//else if (FindSubString(sCommand, "pick")!=-1)	{ sSkill = EMT_SKL_PICK_POCKET; }
	else if (FindSubString(sCommand, "sea")!=-1)		{ sSkill = EMT_SKL_SEARCH; }
	else if (FindSubString(sCommand, "settra")!=-1)	{ sSkill = EMT_SKL_SET_TRAP; }
	else if (FindSubString(sCommand, "spe")!=-1)	{ sSkill = EMT_SKL_SPELLCRAFT; }
	else if (FindSubString(sCommand, "spo")!=-1)		{ sSkill = EMT_SKL_SPOT; }
	else if (FindSubString(sCommand, "tau")!=-1)		{ sSkill = EMT_SKL_TAUNT; }
	else if (FindSubString(sCommand, "use")!=-1) { sSkill = EMT_SKL_USE_MAGIC_DEVICE; }
	else if (FindSubString(sCommand, "app")!=-1)	{ sSkill = EMT_SKL_APPRAISE; }
	else if (FindSubString(sCommand, "tum")!=-1)		{ sSkill = EMT_SKL_TUMBLE; }
	else if (FindSubString(sCommand, "crafttr")!=-1)	{ sSkill = EMT_SKL_CRAFT_TRAP; }
	else if (FindSubString(sCommand, "blu")!=-1)		{ sSkill = EMT_SKL_BLUFF; }
	else if (FindSubString(sCommand, "inti")!=-1)	{ sSkill = EMT_SKL_INTIMIDATE; }
	else if (FindSubString(sCommand, "craftarm")!=-1)	{ sSkill = EMT_SKL_CRAFT_ARMOR; }
	else if (FindSubString(sCommand, "craftwea")!=-1)	{ sSkill = EMT_SKL_CRAFT_WEAPON; }
	
	else if (FindSubString(sCommand, "dip")!=-1)	{ sSkill = EMT_SKL_DIPLOMACY; }
	else if (FindSubString(sCommand, "craftal")!=-1)  { sSkill = EMT_SKL_CRAFT_ALCHEMY; }
	else if (FindSubString(sCommand, "sur")!=-1)	{ sSkill = EMT_SKL_SURVIVAL; }
	else if (FindSubString(sCommand, "sle")!=-1){ sSkill = EMT_SKL_SLEIGHT_OF_HAND; }
	
	else sSkill = "";
	return sSkill;
}

