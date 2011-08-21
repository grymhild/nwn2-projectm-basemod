/** @file
* @brief Time related functions
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
const int AUTOSAVE_COOL_DOWN	= 5; 						// in in-game hours
//const string AUTOSAVE_LAST_SAVE	= "00_nAutoSaveLastSave"; 	// time hash timestamp




/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCUtilityConstants"
#include "_CSLCore_Strings"
#include "_CSLCore_Nwnx"

#include "_CSLCore_UI"

// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////
/*
string CSLHoursMinutes(int iTime);
int CSLTimeStamp();
string CSLHoursInDays(int nHours);
struct structCSLDate CSLDecodeDate(int iDate);
int CSLEncodeDate(struct structCSLDate D);
int CSLGetCurrentDate();
struct structCSLDate CSLElapsedTime(int StartDate);
void CSLSetSavedDate(int iValue);
int CSLGetSavedDate();
int CSLGetDateInitialized();
void CSLInitializeDate();
void CSLsetTimeBasedOnRealTime();
*/

//-------------------------------------------------
// Structures
//-------------------------------------------------

struct CTimeDate
{
    int iYear;
	int iMonth;
    int iDay;
	int iHour;
	int iMinute;
	int iSecond;
	int iMillisecond;
};

// prefix: rhp
struct CHoursPassed
{
    int nNumModuleHoursPassed;
 	int nNumCampaignHoursPassed;
};

//-------------------------------------------------
// Constants
//-------------------------------------------------

const int EVENT_TIME_EVENT 			= 1012;



/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLSecondsToRounds( float fDuration )
{
	fDuration = fDuration/6;
	return FloatToInt( fDuration );
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLHoursMinutes(int iTime)
{
	int iHours = iTime / 60;
	int iMinutes = iTime % 60;
	string sTime = "";
	if (iHours > 0)
	{
		sTime = IntToString(iHours) + CSLAddS(" hour", iHours) + " ";
	}
	if (iMinutes > 0)
	{
		sTime = sTime + IntToString(iMinutes) + CSLAddS(" minute", iMinutes);
	}
	return sTime;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// * SCDateTime
int CSLTimeStamp()
{
   int iYear = GetCalendarYear();
   int iMonth = GetCalendarMonth();
   int iDay = GetCalendarDay();
   int iHour = GetTimeHour();
   return (iYear)*12*28*24 + (iMonth-1)*28*24 + (iDay-1)*24 + iHour;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLHoursInDays(int nHours)
{
   if (nHours>24) return IntToString(nHours/24)+" days and "+IntToString(nHours%24)+" hours";
   return IntToString(nHours%24)+" hours";
}


float CSLMinutesToSeconds(int iMinutes)
{
    return IntToFloat(iMinutes*60);
/*
    // Use HoursToSeconds to figure out how long a scaled minute
    // is and then calculate the number of real seconds based
    // on that.
    float scaledMinute = HoursToSeconds(1) / 60.0;
    float totalMinutes = minutes * scaledMinute;

    // Return our scaled duration, but before doing so check to make sure
    // that it is at least as long as a round / level (time scale is in
    // the module properties, it's possible a minute / level could last less
    // time than a round / level !, so make sure they get at least as much
    // time as a round / level.
    float totalRounds = RoundsToSeconds(minutes);
    float result = totalMinutes > totalRounds ? totalMinutes : totalRounds;
    return result;
*/
}

// the misc functions by Lord Delekhan seem like they could be useful

//::///////////////////////////////////////////////
//:: Name Persistent World Clock
//:: FileName ld_clock_inc
//:://////////////////////////////////////////////
/*
    This is the core function include for my
    PW clock system.
*/
//:://////////////////////////////////////////////
//:: Created By: Lord Delekhan
//:: Created On: March 17, 2005
//:://////////////////////////////////////////////
struct structCSLDate
{
    int Hour;
    int Day;
    int Month;
    int Year;
};

// converts date back to seperate values
struct structCSLDate CSLDecodeDate(int iDate);
// converts hour, day, month, and year values into a single value for storage
int CSLEncodeDate(struct structCSLDate D);
// returns the current date in encoded form
int CSLGetCurrentDate();
// returns the difference between StartDate and the current date
// in the structure structCSLDate format
struct structCSLDate CSLElapsedTime(int StartDate);
// stores the current date
void CSLSetSavedDate(int iValue);
// gets the saved date
int CSLGetSavedDate();
// Functions Begin Here

struct structCSLDate CSLDecodeDate(int iDate)
{
    struct structCSLDate D;int M, H;
    D.Year = iDate / 8064;
    M = iDate % 8064;
    D.Month = M / 672;
    H = M % 672;
    D.Day = H / 24;
    D.Hour = H % 24;
    return D;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEncodeDate(struct structCSLDate D)
{
    int iDate = (D.Year*8064)+(D.Month*672)+(D.Day*24)+D.Hour;
    return iDate;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetCurrentDate()
{
    struct structCSLDate D;
    D.Year = GetCalendarYear();
    D.Month = GetCalendarMonth();
    D.Day = GetCalendarDay();
    D.Hour = GetTimeHour();
    int iDate = CSLEncodeDate(D);
    return iDate;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
struct structCSLDate CSLElapsedTime(int StartDate)
{
    struct structCSLDate D;
    int iDate;
    iDate = CSLGetCurrentDate() - StartDate;
    D = CSLDecodeDate(iDate);
    return D;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetSavedDate(int iValue)
{
    object oMod = GetModule();
    SetCampaignInt("LDClock","CurrentDate",iValue,oMod);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSavedDate()
{
    object oMod = GetModule();
    return GetCampaignInt("LDClock","CurrentDate",oMod);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetDateInitialized()
{
    object oMod = GetModule();
    return GetCampaignInt("LDClock","DateStored",oMod);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLInitializeDate()
{
    object oMod = GetModule();
    SetCampaignInt("LDClock","DateStored",TRUE,oMod);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLsetTimeBasedOnRealTime()
{
	// By Brian Meyer aka Pain
	// for DungeonEternal.com DEX2 Persistent world
	int iRealStartYear = 2008;
	int iRealStartMonth = 18;
	int iRealStartDay = 10;
	int iRealStartHour = 17;
	int iRealStartMinute = 39;
	
	int iModuleHoursPerMinute = 3;

	// Set this to when the module start, i can actually tie this to the current time in the module in the start script
	//int iModuleStartYear = 1420;  // 1340
	//int iModuleStartMonth = 2;  // 1
	//int iModuleStartDay = 1;  // 1
	
	int iModuleStartYear = GetCalendarMonth();
	int iModuleStartMonth = GetCalendarYear();
	int iModuleStartDay = GetCalendarDay();
	
	int iModuleStartHour = GetTimeHour();  // 1
	int iModuleStartMinute = GetTimeMinute();  // 1
	int iModuleStartSecond = GetTimeSecond();  // 1
	

	
	int iYearsSecs = (365*12*28*60*60);
	int iMonthsSecs = (28*24*60*60); // limited to 28 days per month, per function description, will get wonky other wise
	int iDaysSecs = (24*60*60);
	int iHourSecs = (60*60);
	int iMinSecs = (60);
		
		

	int iAccelerator;
	if ( iModuleHoursPerMinute > 0 ) // make sure no divide by zeros
	{
		iAccelerator = 60/iModuleHoursPerMinute;
	}
	else
	{
		iAccelerator = 1;
	}
	
	// init my vars
	int iRealStartSeconds = 0; // (iRealStartYear-1970*31536000) + (iRealStartMonth*86400*30) + (iRealStartDay*86400);
	
	// this executes the following "SELECT UNIX_TIMESTAMP( ) - UNIX_TIMESTAMP('2008-10-18 15:37:00');"
	// which gets the time since the real start minute
	// will have an issue when the int overflows, but should just be able to set a new start date, which should correlate to wipes, new versions being released
	// and the like
	CSLNWNX_SQLExecDirect( "SELECT UNIX_TIMESTAMP( ) - UNIX_TIMESTAMP('" + IntToString(iRealStartYear) + "-" + IntToString(iRealStartMonth) + "-" + IntToString(iRealStartDay) + " " + IntToString(iRealStartHour) + ":" + IntToString(iRealStartMinute) + ":00');");
	if ( CSLNWNX_SQLFetch() == CSLSQL_SUCCESS)
	{ 
		iRealStartSeconds = StringToInt( CSLNWNX_SQLGetData(1) );  
		
		// only try this if the mysql function worked, leave things in single player working without this
		// don't try this if elapsed seconds are under 0, since the system date must be wrong
		if ( iRealStartSeconds < 0 )
		{
			return;
		}
		
		
		// Time progresses faster in game, so multiply it by the iAccelerator to keep the two time systems in sync
		// For us the game goes 20 times faster, since we are at 3 minutes per hour.
		int iElapsedSeconds =  iRealStartSeconds * iAccelerator;
		
		int iElapsedYears = iElapsedSeconds/iYearsSecs;
		iRealStartSeconds = iElapsedSeconds % iYearsSecs;
		
		int iElapsedMonths = iElapsedSeconds/iMonthsSecs;
		iRealStartSeconds = iElapsedSeconds % iMonthsSecs;
		
		int iElapsedDays = iElapsedSeconds/iDaysSecs;
		iRealStartSeconds = iElapsedSeconds % iDaysSecs;
		
		int iElapsedHours = iElapsedSeconds/iHourSecs;
		iRealStartSeconds = iElapsedSeconds % iHourSecs;
		
		int iElapsedMinutes = iElapsedSeconds/iMinSecs;
		iRealStartSeconds = iElapsedSeconds % iMinSecs;
		
		// per nwn lexicon
		// Tested results give values allowable ranging from 0 to 30000.
		// Specific year to set calendar to from 1340 to 32001.
		// assume this might break if the run for a number of years, but given the 20 to 1 ratio it looks like it would have hit 1429 elapsed years before there is an issue
		SetCalendar( iModuleStartYear+iElapsedYears, iModuleStartMonth+iElapsedMonths, iModuleStartDay+iElapsedDays );
		SetTime( iModuleStartHour+iElapsedHours, iModuleStartMinute+iElapsedMinutes, 1, 1 );
	}
}





//void main (){}

/*
// update clock for a specific Player



*/


/*
// Convert nRounds into a number of seconds
// A round is always 6.0 seconds
float RoundsToSeconds(int nRounds);

// Convert nHours into a number of seconds
// The result will depend on how many minutes there are per hour (game-time)
float HoursToSeconds(int nHours);

// Convert nTurns into a number of seconds
// A turn is always 60.0 seconds
float TurnsToSeconds(int nTurns);

// * Returns TRUE if it is currently day.
int GetIsDay();

// * Returns TRUE if it is currently night.
int GetIsNight();

// * Returns TRUE if it is currently dawn.
int GetIsDawn();

// * Returns TRUE if it is currently dusk.
int GetIsDusk();

this is from ginc_time, has nice stuff for faerun dates in it...
// ginc_time
// / *
//	Time library
//	Includes support functions for "Time Events"
// * /
// ChazM 11/17/06
// ChazM 1/10/07 Added CSLNormalizeCTimeDate(), CSLGetMinutesPerHour(); added prototypes
// ChazM 3/1/07 Num hours passed now saved when CSLHasHourChanged() called
// ChazM 5/31/07 Added UpdateClock()
// ChazM 6/1/07 Added various Clock GUI functions
// MDiekmann 6/6/07 - Added support for clock GUI popup
// ChazM 6/7/07 - CSLHasHourChanged() and CSLCheckTime() now return number of Hours passed; added switches include.
// ChazM 6/22/07 - make friendly with ginc_autosave
// ChazM 7/2/07 - CSLHasHourChanged() updated to calculate both the campaign hours and the module hours
// ChazM 7/25/07 - modified CSLCheckTime(), CSLHasHourChanged() - fix for time updates on module first entry

//void main(){}
//-------------------------------------------------
// Includes
//-------------------------------------------------

//#include "ginc_debug"
#include "ginc_group"
#include "x2_inc_switches"
#include "ginc_autosave"

//-------------------------------------------------
// Structures
//-------------------------------------------------

struct CTimeDate
{
    int iYear;
	int iMonth;
    int iDay;
	int iHour;
	int iMinute;
	int iSecond;
	int iMillisecond;
};

// prefix: rhp
struct CHoursPassed
{
    int nNumModuleHoursPassed;
 	int nNumCampaignHoursPassed;
};
//-------------------------------------------------
// Constants
//-------------------------------------------------

const int EVENT_TIME_EVENT 			= 1012;

//Display Format Constants
const int M_D_Y_TEXT				= 1;
const int M_D_Y_SLASHES				= 2;
const int D_M_Y_TEXT				= 3;
const int D_M_Y_SLASHES				= 4;
const int Y_M_D_TEXT				= 5;
const int Y_M_D_SLASHES				= 6;

const string "PREVIOUS_HOUR" 		= "PREVIOUS_HOUR";
const string "TIME_EVENT_NOTIFY" 		= "TIME_EVENT_NOTIFY";
const string "HOURS_PASSED"       = "HOURS_PASSED";

const string "time" 						= "time";			// 2da
const string "Image" 				= "Image";			// string - image to display
const string "Name" 					= "Name";			// int - str ref

const string GUI_SCREEN_PLAYERMENU			= "SCREEN_PLAYERMENU";
const string GUI_PLAYERMENU_CLOCK_BUTTON 	= "CLOCK_BUTTON";
const string SCREEN_OL_FRAME 				= "SCREEN_OL_MENU";
const string OL_DETAIL_CLOCK				= "OL_CLOCK";
//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------


// CTimeDate functions
//-------------------------------------------------
int CSLGetMinutesPerHour();
struct CTimeDate CSLNormalizeCTimeDate(struct CTimeDate rTimeDate);
struct CTimeDate CSLNewCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
struct CTimeDate CSLGetCurrentCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
struct CTimeDate CSLAddCTimeDate(struct CTimeDate rTimeDate1, struct CTimeDate rTimeDate2);
void CSLSetCTimeDate(struct CTimeDate rTimeDate);

// Hash functions
//-------------------------------------------------
//int CSLGetTimeHash( int nHours, int nDays );
//int CSLGetTimeHashDifference( int nHash1, int nHash2 );
//int CSLGetCurrentTimeHash();
struct CHoursPassed CSLHasHourChanged();
int CSLGetNumHoursPassed();

// Time Registration
//-------------------------------------------------
void CSLNotifyRegisteredObject(object oObject);
void CSLNotifyRegisteredObjects();
void CSLSetUpTimeEvent(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
struct CHoursPassed CSLCheckTime();
void CSLRegisterForTimeEvent(object oObject);

// Clock GUI
//-------------------------------------------------
void CSLSetClockOnForPlayer(object oPC, int bClockOn=TRUE, int bOLMap = FALSE);
void CSLSetClockOnForAllPlayers(int bClockOn=TRUE, int bOLMap = FALSE);
void CSLUpdateClockForPlayer(object oPC);
void CSLUpdateClockForAllPlayers();

// Time & Date display
//-------------------------------------------------
int SCGetFRSeason(struct CTimeDate rTimeDate);
string SCGetFRSeasonName(int iSeason);
string SCGetFRYearName(int iYear);
string SCGetFRMonthName(int iMonth);
string SCGetFRDayName(int iDay);
string SCGetFRDisplayDate(struct CTimeDate rTimeDate);
string SCGetFRDisplayTime(struct CTimeDate rTimeDate);

// Clock Popup set time and date
//--------------------------------------------------
string SCGetClockDisplayDate(struct CTimeDate rTimeDate, int nDisplayFormat = M_D_Y_TEXT);
string SCGetClockDisplayTime(struct CTimeDate rTimeDate);
string SCGetClockDisplay(struct CTimeDate rTimeDate, int bTimeOnly);




// Range Checks
//-------------------------------------------------
int CSLIsCurrentHourInRange(int iStartHour, int iEndHour);
int CSLIsCurrentDayInRange(int iStartDay, int iEndDay);
int CSLIsCurrentMonthInRange(int iStartMonth, int iEndMonth);
int CSLIsCurrentYearInRange(int iStartYear, int iEndYear);


//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// CTimeDate functions
//-------------------------------------------------





// Hash functions
//-------------------------------------------------

// / *
// // Return time hash given nHours and nDays
// Ranges between 24 (0 Hour 1 Day) and 695 (23 Hour 28 Day)
// int CSLGetTimeHash( int nHours, int nDays )
// {
// 	int nTimeHash = nHours + ( nDays * 24 );
// 	return ( nTimeHash );
// }
//
// Return time hash difference (adjusts for wrap around)
// int CSLGetTimeHashDifference( int nHash1, int nHash2 )
// {
// 	int nDifference = nHash1 - nHash2;
//	if ( nDifference < 0 )
//	{
//		nDifference = nDifference + 672; // wrap around
//	}
//	
//	//CSLMessage_PrettyMessage( "CSLGetTimeHashDifference( " + IntToString( nHash1 ) +  ", " + IntToString( nHash2 ) +  " ) = " + IntToString( nDifference ) );
//	return ( nDifference );
//}
//
// Return current time hash
//int CSLGetCurrentTimeHash()
//{
//	int nCurrentHour = GetTimeHour();
//	int nCurrentDay = GetCalendarDay();
//	//CSLMessage_PrettyMessage( "CSLGetCurrentTimeHash(): nCurrentHour = " + IntToString( nCurrentHour ) + ", nCurrentDay = " + IntToString( GetCalendarDay() ) );
//	int nTimeHash = CSLGetTimeHash( nCurrentHour, nCurrentDay );
//	return ( nTimeHash );
//}
//
// * /
// Does module perceive that the hour has changed?  
// returns number of module hours passed (number of campaign hours passed is also stored)
struct CHoursPassed CSLHasHourChanged()
{
	struct CHoursPassed rHP;
	int nNumModuleHoursPassed = 0;
	int nNumCampaignHoursPassed = 0;
	
	// What time is it?
	int nCurrentHour = CSLGetCurrentTimeHash();	
	
	// we save this as a local on the module.  A campaign has multiple modules,
	// and when returning to a module, all the registered objects need to be notified of 
	// the amount of time that has passed.
    object oModule = GetModule();
	int nPreviousModuleHour = GetLocalInt(oModule, "PREVIOUS_HOUR");
	int nPreviousCampaignHour = GetGlobalInt("PREVIOUS_HOUR");

	PrettyDebug ("nCurrentHour = " + IntToString(nCurrentHour));
	PrettyDebug ("nPreviousModuleHour = " + IntToString(nPreviousModuleHour));
	PrettyDebug ("nPreviousCampaignHour = " + IntToString(nPreviousCampaignHour));
	
	// time updates are never 0, so this module has not been initialized yet.
	if (nPreviousModuleHour == 0)
	{
		// initialize previous hour as being the current hour
		nPreviousModuleHour = nCurrentHour;
		SetLocalInt(oModule, "PREVIOUS_HOUR", nPreviousModuleHour);
	}
	
	// time updates are never 0, so this campaign has not been initialized yet.
	if (nPreviousCampaignHour == 0)
	{
		// initialize previous hour as being the current hour
		nPreviousCampaignHour = nCurrentHour;
		SetGlobalInt("PREVIOUS_HOUR", nPreviousCampaignHour);
	}
	
	
	// return false if the time has not incremented.
	// Note that the number of module hours may change even if the number of campaign hours has not 
	// (but not vice versa - except when module hours is 0)
	if (nCurrentHour == nPreviousModuleHour)
		nNumModuleHoursPassed = 0;
	else
	{
		// return true if time has changed, and note the new "previous hour"
        // and number of hours passed
		SetLocalInt(oModule, "PREVIOUS_HOUR", nCurrentHour);
      	nNumModuleHoursPassed = CSLGetTimeHashDifference(nCurrentHour, nPreviousModuleHour);
		SetLocalInt(oModule, "HOURS_PASSED", nNumModuleHoursPassed);
	}
	
	if (nCurrentHour == nPreviousCampaignHour)
		nNumCampaignHoursPassed = 0;
	else
	{				
		SetGlobalInt("PREVIOUS_HOUR", nCurrentHour);
      	nNumCampaignHoursPassed = CSLGetTimeHashDifference(nCurrentHour, nPreviousCampaignHour);
		SetGlobalInt("HOURS_PASSED", nNumCampaignHoursPassed);
	}		

	rHP.nNumModuleHoursPassed = nNumModuleHoursPassed;
	rHP.nNumCampaignHoursPassed = nNumCampaignHoursPassed;
	return (rHP);					
}


/ *
// int GetPreviousHour()
// {
//	int iPreviousHour = GetLocalInt(OBJECT_SELF, "PREVIOUS_HOUR");
//    
//	// if Previous hour is 0, then it  has not been initialized yet.
//	if (iPreviousHour == 0)
//	{
//		// initialize previous hour as being the current hour
//		iPreviousHour = CSLGetCurrentTimeHash();
//		SetLocalInt(oModule, "PREVIOUS_HOUR", iPreviousHour);
//	}
//    
//    return (iPreviousHour);
//}
// * /
int CSLGetNumHoursPassed()
{
    object oModule = GetModule();
	//int iCurrentHour = CSLGetCurrentTimeHash();
    // this is not returning correct thing.
	//int iPreviousHour = GetLocalInt(OBJECT_SELF, "PREVIOUS_HOUR");
	//int iNumHoursPassed = CSLGetTimeHashDifference(iCurrentHour, iPreviousHour);
	//PrettyDebug ("CSLGetNumHoursPassed(): iCurrentHour = " + IntToString(iCurrentHour) + "iPreviousHour = " + IntToString(iPreviousHour));
	//PrettyDebug("CSLGetNumHoursPassed(): iNumHoursPassed = " + IntToString(iNumHoursPassed));
    int iNumHoursPassed = GetLocalInt(oModule, "HOURS_PASSED");
	return (iNumHoursPassed);
}


// Time Registration
//-------------------------------------------------


// Notify the registered object
void CSLNotifyRegisteredObject(object oObject)
{
	// SignalEvent(oObject, evTimeEvent)
	
	string sScript = "t_" + GetTag(oObject);
	ExecuteScript(sScript, oObject);
}

// fires time event on all registered objects
void CSLNotifyRegisteredObjects()
{
	int i = 0;
	float fDelay;
	object oMember = CSLNth_GetNthElement("TIME_EVENT_NOTIFY");
  	event evTimeEvent = EventUserDefined(EVENT_TIME_EVENT);
	while (GetIsObjectValid(oMember))
	{
	 	// Spread the events out a little bit so the server doesn't get swamped
		// w/ event requests.
		// might want to base this on number of objects in group so delay never
		// gets to large
		i++;
		fDelay = IntToFloat(i) * 0.01f;
	
  		DelayCommand(fDelay, CSLNotifyRegisteredObject(oMember));
		oMember = GetNextInGroup("TIME_EVENT_NOTIFY");
	}
}


// Events are stored as module vars "EVENT_<X>" with the value being a string representation of the time.
void CSLSetUpTimeEvent(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0)
{
	struct CTimeDate rTimeDate = CSLNewCTimeDate(iYear, iMonth, iDay, iHour, iMinute, iSecond, iMillisecond);
	
	// insert event into sorted list.	
}


// Determine any scheduled TimeDate events that need to fire.
// TimeDate event data is stored in sorted order.  We check and fire all events that 
// are found to be <= current time.  We can stop processing when we find one > current time.
// The data is stored in 2 places - global vars for the player and companions, and the the current 
// module for all other objects.
void CSLCheckTimeDateEvents()
{
	
}



// Registers object for hourly event notification
void CSLRegisterForTimeEvent(object oObject)
{
	GroupAddMember("TIME_EVENT_NOTIFY", oObject);	// need to fix problems w/ conflicting groups
		
}



// Clock GUI
//-------------------------------------------------



// update clock for a specific Player
void CSLUpdateClockForPlayer(object oPC)
{
	int bTimeOnly = GetGlobalInt(CAMPAIGN_SWITCH_ONLY_SHOW_TIME);
	struct CTimeDate rTimeDate = CSLGetCurrentCTimeDate();
	string sTime = SCGetClockDisplay(rTimeDate, bTimeOnly);
	SetLocalGUIVariable(oPC, GUI_SCREEN_PLAYERMENU, 1, sTime);
	string sImage = Get2DAString("time", "Image", GetTimeHour());
	SetGUITexture(oPC, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
	SetGUITexture(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, sImage);
	SetLocalGUIVariable(oPC, SCREEN_OL_FRAME, 1, sTime);
	PrettyDebug("I AM WORKING");
}


// update clock for all Players
// if clock is off (hidden), updates won't take effect.
void CSLUpdateClockForAllPlayers()
{	
	int bTimeOnly = GetGlobalInt(CAMPAIGN_SWITCH_ONLY_SHOW_TIME);
	struct CTimeDate rTimeDate = CSLGetCurrentCTimeDate();
	string sTime = SCGetClockDisplay(rTimeDate, bTimeOnly);
	string sImage = Get2DAString("time", "Image", GetTimeHour());
	object oPC = GetFirstPC();
	while(GetIsObjectValid(oPC))
	{
		SetGUITexture(oPC, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
		SetLocalGUIVariable(oPC, GUI_SCREEN_PLAYERMENU, 1, sTime);
		
		SetGUITexture(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, sImage);
		SetLocalGUIVariable(oPC, SCREEN_OL_FRAME, 1, sTime);
		//PrettyDebug("I AM WORKING");
		//AssignCommand(oPC, SpeakString("Yes I am working"));
		oPC = GetNextPC();
	}
}

// check if we're ready to fire another event.
// can be called as often as desired.
struct CHoursPassed CSLCheckTime()
{
	CSLCheckTimeDateEvents();
	
	// exit if the time has not incremented.
	//int nNumHoursPassed = CSLHasHourChanged();

	struct CHoursPassed rHP = CSLHasHourChanged();
	int nNumModuleHoursPassed =	rHP.nNumModuleHoursPassed;
	//int nNumCampaignHoursPassed = rHP.nNumCampaignHoursPassed;

	if (nNumModuleHoursPassed != 0)
	{
		//Time has incremented so send notifications		
		CSLNotifyRegisteredObjects();
	}
	//return (nNumHoursPassed);
	return (rHP);
	
}


// Time & Date display
//-------------------------------------------------

const int SEASON_WINTER = 1;
const int SEASON_SPRING = 2;
const int SEASON_SUMMER = 3;
const int SEASON_AUTUMN = 4;

int SCGetFRSeason(struct CTimeDate rTimeDate)
{
	int iMonth = rTimeDate.iMonth;
	int iDay = rTimeDate.iDay;
	
	int iRet;
	switch(iMonth)
	{
		case 1:	iRet = SEASON_WINTER; 		break;
		case 2: iRet = SEASON_WINTER; 		break;
		case 3: iRet = (iDay<19)? SEASON_WINTER: SEASON_SPRING;	 	break;
		case 4:	iRet = SEASON_SPRING; 		break;
		case 5: iRet = SEASON_SPRING; 		break;
		case 6: iRet = (iDay<20)? SEASON_SPRING: SEASON_SUMMER;	 	break;
		case 7:	iRet = SEASON_SUMMER; 		break;
		case 8: iRet = SEASON_SUMMER; 		break;
		case 9: iRet = (iDay<21)? SEASON_SUMMER: SEASON_AUTUMN;	 	break;
		case 10: iRet = SEASON_AUTUMN; 		break;
		case 11: iRet = SEASON_AUTUMN; 		break;
		case 12: iRet = (iDay<20)? SEASON_AUTUMN: SEASON_WINTER;	break;

	}
	return (iRet);
}


string SCGetFRSeasonName(int iSeason)
{
	int iRet;
	string sRet;
	switch(iSeason)
	{
		case SEASON_WINTER: iRet = 201125;	 	break;	//Winter
		case SEASON_SPRING: iRet = 201126;	 	break;	//Spring
		case SEASON_SUMMER: iRet = 201127; 		break;	//Summer
		case SEASON_AUTUMN: iRet = 201128; 		break;	//Fall
	
	}
	sRet = GetStringByStrRef(iRet);
	return (sRet);
}

// Returns the Forgotten Realms name of the year
string SCGetFRYearName(int iYear)
{
	int iRet;
	string sRet;
	switch(iYear)
	{
		case 1372: iRet = 201116; 		break;	//The Year of Wild Magic
		case 1373: iRet = 201117; 		break;	//The Year of Rogue Dragons
		case 1374: iRet = 201118; 		break;	//The Year of Lightning Storms
		case 1375: iRet = 201119; 		break;	//The Year of Risen Elfkin
		case 1376: iRet = 201120; 		break;	//The Year of the Bent Blade
		case 1377: iRet = 201121; 		break;	//The Year of the Haunting
		case 1378: iRet = 201122; 		break;	//The Year of the Cauldron
		case 1379: iRet = 201123; 		break;	//The Year of the Lost Keep
		case 1380: iRet = 201124; 		break;	//The Year of the Blazing Hand
		default:   iRet = 0;			break;	//Bad String
	}
	sRet = GetStringByStrRef(iRet);
	return (sRet);
}



// Returns the Forgotten Realms name of the month
string SCGetFRMonthName(int iMonth)
{
	int iRet;
	string sRet;
	switch(iMonth)
	{
		case 1: iRet = 201101; 			break;	//Hammer
		case 2: iRet = 201102;	 		break;	//Alturiak
		case 3: iRet = 201103; 			break;	//Ches
		case 4: iRet = 201104;	 		break;	//Tarsakh
		case 5: iRet = 201106;	 		break;	//Mirtul
		case 6: iRet = 201108; 			break;	//Kythorn
		case 7: iRet = 201109; 			break;	//Flamerule
		case 8: iRet = 201110; 			break;	//Eleasis
		case 9: iRet = 201111; 			break;	//Eleint
		case 10: iRet = 201112;	 		break;	//Marpenoth
		case 11: iRet = 201113;	 		break;	//Uktar
		case 12: iRet = 201114;	 		break;	//Nightal
	}
	sRet = GetStringByStrRef(iRet);
	return (sRet);
}

// Returns the Forgotten Realms name of the day
string SCGetFRDayName(int iDay)
{
	int iRet;
	string sRet;
	switch(iDay)
	{
		case 1: iRet = 201129; 		break;	//first-day
		case 2: iRet = 201130; 		break;	//second-day
		case 3: iRet = 201131; 		break;	//third-day
		case 4: iRet = 201132; 		break;	//fourth-day
		case 5: iRet = 201133; 		break;	//fifth-day
		case 6: iRet = 201134; 		break;	//sixth-day
		case 7: iRet = 201135; 		break;	//seventh-day
		case 8: iRet = 201136; 		break;	//eighth-day
		case 9: iRet = 201137; 		break;	//ninth-day
		case 10: iRet = 201138; 		break;	//tenth-day
	}
	GetStringByStrRef(iRet);
	return (sRet);
}







// Range Checks
//-------------------------------------------------


// check if current hour is in specified range
int CSLIsCurrentHourInRange(int iStartHour, int iEndHour)
{
	int iCurrentTime = GetTimeHour();	
	return (CSLIsWithinRange(iCurrentTime, iStartHour, iEndHour));
}

// check if current day is in specified range
int CSLIsCurrentDayInRange(int iStartDay, int iEndDay)
{
	int iCurrentDay = GetCalendarDay();
	return (CSLIsWithinRange(iCurrentDay, iStartDay, iEndDay));
}

// check if current month is in specified range
int CSLIsCurrentMonthInRange(int iStartMonth, int iEndMonth)
{
	int iCurrentMonth = GetCalendarMonth();
	return (CSLIsWithinRange(iCurrentMonth, iStartMonth, iEndMonth));
}

// check if current year is in specified range
int CSLIsCurrentYearInRange(int iStartYear, int iEndYear)
{
	int iCurrentYear = GetCalendarYear();
	return (CSLIsWithinRange(iCurrentYear, iStartYear, iEndYear));
}

*/


// Put all my date functions in this one function

//#include "_CSLCore_Nwnx"


// the misc functions by Lord Delekhan seem like they could be useful

//::///////////////////////////////////////////////
//:: Name Persistent World Clock
//:: FileName ld_clock_inc
//:://////////////////////////////////////////////
/*
    This is the core function include for my
    PW clock system.
*/
//:://////////////////////////////////////////////
//:: Created By: Lord Delekhan
//:: Created On: March 17, 2005
//:://////////////////////////////////////////////
/*
struct Date
{
    int Hour;
    int Day;
    int Month;
    int Year;
};

// converts date back to seperate values
struct Date CSLDecodeDate(int iDate);
// converts hour, day, month, and year values into a single value for storage
int CSLEncodeDate(struct Date D);
// returns the current date in encoded form
int CSLGetCurrentDate();
// returns the difference between StartDate and the current date
// in the structure Date format
struct Date CSLElapsedTime(int StartDate);
// stores the current date
void CSLSetSavedDate(int iValue);
// gets the saved date
int CSLGetSavedDate();
// Functions Begin Here

struct Date CSLDecodeDate(int iDate)
{
    struct Date D;int M, H;
    D.Year = iDate / 8064;
    M = iDate % 8064;
    D.Month = M / 672;
    H = M % 672;
    D.Day = H / 24;
    D.Hour = H % 24;
    return D;
}

int CSLEncodeDate(struct Date D)
{
    int iDate = (D.Year*8064)+(D.Month*672)+(D.Day*24)+D.Hour;
    return iDate;
}

int CSLGetCurrentDate()
{
    struct Date D;
    D.Year = GetCalendarYear();
    D.Month = GetCalendarMonth();
    D.Day = GetCalendarDay();
    D.Hour = GetTimeHour();
    int iDate = CSLEncodeDate(D);
    return iDate;
}

struct Date CSLElapsedTime(int StartDate)
{
    struct Date D;int iDate;
    iDate = CSLGetCurrentDate() - StartDate;
    D = CSLDecodeDate(iDate);
    return D;
}

void CSLSetSavedDate(int iValue)
{
    object oMod = GetModule();
    SetCampaignInt("LDClock","CurrentDate",iValue,oMod);
}

int CSLGetSavedDate()
{
    object oMod = GetModule();
    return GetCampaignInt("LDClock","CurrentDate",oMod);
}

int CSLGetDateInitialized()
{
    object oMod = GetModule();
    return GetCampaignInt("LDClock","DateStored",oMod);
}

void CSLInitializeDate()
{
    object oMod = GetModule();
    SetCampaignInt("LDClock","DateStored",TRUE,oMod);
}

void CSLsetTimeBasedOnRealTime()
{
	// By Brian Meyer aka Pain
	// for DungeonEternal.com DEX2 Persistent world
	int iRealStartYear = 2008;
	int iRealStartMonth = 18;
	int iRealStartDay = 10;
	int iRealStartHour = 17;
	int iRealStartMinute = 39;
	
	int iModuleHoursPerMinute = 3;

	// Set this to when the module start, i can actually tie this to the current time in the module in the start script
	//int iModuleStartYear = 1420;  // 1340
	//int iModuleStartMonth = 2;  // 1
	//int iModuleStartDay = 1;  // 1
	
	int iModuleStartYear = GetCalendarMonth();
	int iModuleStartMonth = GetCalendarYear();
	int iModuleStartDay = GetCalendarDay();
	
	int iModuleStartHour = GetTimeHour();  // 1
	int iModuleStartMinute = GetTimeMinute();  // 1
	int iModuleStartSecond = GetTimeSecond();  // 1
	

	
	int iYearsSecs = (365*12*28*60*60);
	int iMonthsSecs = (28*24*60*60); // limited to 28 days per month, per function description, will get wonky other wise
	int iDaysSecs = (24*60*60);
	int iHourSecs = (60*60);
	int iMinSecs = (60);
		
		

	int iAccelerator;
	if ( iModuleHoursPerMinute > 0 ) // make sure no divide by zeros
	{
		iAccelerator = 60/iModuleHoursPerMinute;
	}
	else
	{
		iAccelerator = 1;
	}
	
	// init my vars
	int iRealStartSeconds = 0; // (iRealStartYear-1970*31536000) + (iRealStartMonth*86400*30) + (iRealStartDay*86400);
	
	// this executes the following "SELECT UNIX_TIMESTAMP( ) - UNIX_TIMESTAMP('2008-10-18 15:37:00');"
	// which gets the time since the real start minute
	// will have an issue when the int overflows, but should just be able to set a new start date, which should correlate to wipes, new versions being released
	// and the like
	CSLNWNX_SQLExecDirect( "SELECT UNIX_TIMESTAMP( ) - UNIX_TIMESTAMP('" + IntToString(iRealStartYear) + "-" + IntToString(iRealStartMonth) + "-" + IntToString(iRealStartDay) + " " + IntToString(iRealStartHour) + ":" + IntToString(iRealStartMinute) + ":00');");
	if ( CSLNWNX_SQLFetch() == CSLSQL_SUCCESS)
	{ 
		iRealStartSeconds = StringToInt( CSLNWNX_SQLGetData(1) );  
		
		// only try this if the mysql function worked, leave things in single player working without this
		// don't try this if elapsed seconds are under 0, since the system date must be wrong
		if ( iRealStartSeconds < 0 )
		{
			return;
		}
		
		
		// Time progresses faster in game, so multiply it by the iAccelerator to keep the two time systems in sync
		// For us the game goes 20 times faster, since we are at 3 minutes per hour.
		int iElapsedSeconds =  iRealStartSeconds * iAccelerator;
		
		int iElapsedYears = iElapsedSeconds/iYearsSecs;
		iRealStartSeconds = iElapsedSeconds % iYearsSecs;
		
		int iElapsedMonths = iElapsedSeconds/iMonthsSecs;
		iRealStartSeconds = iElapsedSeconds % iMonthsSecs;
		
		int iElapsedDays = iElapsedSeconds/iDaysSecs;
		iRealStartSeconds = iElapsedSeconds % iDaysSecs;
		
		int iElapsedHours = iElapsedSeconds/iHourSecs;
		iRealStartSeconds = iElapsedSeconds % iHourSecs;
		
		int iElapsedMinutes = iElapsedSeconds/iMinSecs;
		iRealStartSeconds = iElapsedSeconds % iMinSecs;
		
		// per nwn lexicon
		// Tested results give values allowable ranging from 0 to 30000.
		// Specific year to set calendar to from 1340 to 32001.
		// assume this might break if the run for a number of years, but given the 20 to 1 ratio it looks like it would have hit 1429 elapsed years before there is an issue
		SetCalendar( iModuleStartYear+iElapsedYears, iModuleStartMonth+iElapsedMonths, iModuleStartDay+iElapsedDays );
		SetTime( iModuleStartHour+iElapsedHours, iModuleStartMinute+iElapsedMinutes, 1, 1 );
	}
}
//void main (){}
*/


// CTimeDate functions
//-------------------------------------------------
//int CSLGetMinutesPerHour();
//struct CTimeDate CSLNormalizeCTimeDate(struct CTimeDate rTimeDate);
//struct CTimeDate CSLNewCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
//struct CTimeDate CSLGetCurrentCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
//struct CTimeDate CSLAddCTimeDate(struct CTimeDate rTimeDate1, struct CTimeDate rTimeDate2);
//void CSLSetCTimeDate(struct CTimeDate rTimeDate);

// Hash functions
//-------------------------------------------------
//int CSLGetTimeHash( int nHours, int nDays );
//int CSLGetTimeHashDifference( int nHash1, int nHash2 );
//int CSLGetCurrentTimeHash();
//struct CHoursPassed CSLHasHourChanged();
//int CSLGetNumHoursPassed();

// Time Registration
//-------------------------------------------------
//void CSLNotifyRegisteredObject(object oObject);
//void CSLNotifyRegisteredObjects();
//void CSLSetUpTimeEvent(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
//struct CHoursPassed CSLCheckTime();
//void CSLRegisterForTimeEvent(object oObject);

// Clock GUI
//-------------------------------------------------
//void CSLSetClockOnForPlayer(object oPC, int bClockOn=TRUE, int bOLMap = FALSE);
//void CSLSetClockOnForAllPlayers(int bClockOn=TRUE, int bOLMap = FALSE);
//void CSLUpdateClockForPlayer(object oPC);
//void CSLUpdateClockForAllPlayers();


// Clock Popup set time and date
//--------------------------------------------------




// Range Checks
//-------------------------------------------------
//int CSLIsCurrentHourInRange(int iStartHour, int iEndHour);
//int CSLIsCurrentDayInRange(int iStartDay, int iEndDay);
//int CSLIsCurrentMonthInRange(int iStartMonth, int iEndMonth);
//int CSLIsCurrentYearInRange(int iStartYear, int iEndYear);


//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// CTimeDate functions
//-------------------------------------------------


// Return number of minutes set for module (1-59)
int CSLGetMinutesPerHour()
{
	int iRet = FloatToInt(HoursToSeconds(1)/60.0f);
	return (iRet);
}	

// Normalize a time date to be within appropriate values.
// only handles overflow (not underflow)
struct CTimeDate CSLNormalizeCTimeDate(struct CTimeDate rTimeDate)
{
	int iMinsPerHour = CSLGetMinutesPerHour();

	// cascade overflow
	rTimeDate.iSecond 	+= rTimeDate.iMillisecond / 1000;	// MS = 0-999
	rTimeDate.iMinute 	+= rTimeDate.iSecond / 60;			// Sec = 0 - 59
	rTimeDate.iHour 	+= rTimeDate.iMinute  / iMinsPerHour;	// Min = 0-X
	rTimeDate.iDay 		+= rTimeDate.iHour / 24;			// Hour = 0-23
	if (rTimeDate.iDay >= 1)
		rTimeDate.iMonth 	+= (rTimeDate.iDay-1) / 28;			// Day = 1-28
	if (rTimeDate.iMonth >= 1)
		rTimeDate.iYear 	+= (rTimeDate.iMonth-1) / 12;		// Month = 1-12
	
	// remove overflow
	rTimeDate.iMillisecond	%= 1000;
	rTimeDate.iSecond 		%= 60;
	rTimeDate.iMinute 		%= iMinsPerHour;
	rTimeDate.iHour 		%= 24;	
	if (rTimeDate.iDay >= 1)
		rTimeDate.iDay 			= ((rTimeDate.iDay-1) % 28) + 1;
	if (rTimeDate.iMonth >= 1)
		rTimeDate.iMonth 		= ((rTimeDate.iMonth-1) % 12) + 1;
	
	return (rTimeDate);
}


// return an unnormalized CTimeDate 
struct CTimeDate CSLNewCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0)
{
	struct CTimeDate rTimeDate;
	
	rTimeDate.iYear 		= iYear;
	rTimeDate.iMonth 		= iMonth;
	rTimeDate.iDay 			= iDay;
	rTimeDate.iHour 		= iHour;
	rTimeDate.iMinute 		= iMinute;
	rTimeDate.iSecond 		= iSecond;
	rTimeDate.iMillisecond 	= iMillisecond;

	return (rTimeDate);
}

// the params for this indicate additonal offset.
// return an unnormalized CTimeDate 
struct CTimeDate CSLGetCurrentCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0)
{
	struct CTimeDate rTimeDate;
	
	rTimeDate.iYear 		= GetCalendarYear()		+ iYear;
	rTimeDate.iMonth 		= GetCalendarMonth()	+ iMonth;
	rTimeDate.iDay 			= GetCalendarDay()		+ iDay;
	rTimeDate.iHour 		= GetTimeHour()			+ iHour;
	rTimeDate.iMinute 		= GetTimeMinute()		+ iMinute;
	rTimeDate.iSecond 		= GetTimeSecond()		+ iSecond;
	rTimeDate.iMillisecond 	= GetTimeMillisecond()	+ iMillisecond;

	return (rTimeDate);
}

// return an unnormalized CTimeDate 
struct CTimeDate CSLAddCTimeDate(struct CTimeDate rTimeDate1, struct CTimeDate rTimeDate2)
{
	struct CTimeDate rTimeDate;
	
	rTimeDate.iYear 		= rTimeDate1.iYear + rTimeDate2.iYear;
	rTimeDate.iMonth 		= rTimeDate1.iMonth + rTimeDate2.iMonth;
	rTimeDate.iDay 			= rTimeDate1.iDay + rTimeDate2.iDay;
	rTimeDate.iHour 		= rTimeDate1.iHour + rTimeDate2.iHour;
	rTimeDate.iMinute 		= rTimeDate1.iMinute + rTimeDate2.iMinute;
	rTimeDate.iSecond 		= rTimeDate1.iSecond + rTimeDate2.iSecond;
	rTimeDate.iMillisecond 	= rTimeDate1.iMillisecond + rTimeDate2.iMillisecond;

	return (rTimeDate);
}

// Sets the time and date.  The TimeDate does not need to be normalized.
// The overflow values for any field will advance the next field.
// Note: if the time is set previous to what it currently is this will cause the day to advance.  Becuase 
// of this, care should be taken when incrementing by very small units (seconds & milliseconds).
void CSLSetCTimeDate(struct CTimeDate rTimeDate)
{
	int iYear		= rTimeDate.iYear;
	int iMonth		= rTimeDate.iMonth;
	int iDay		= rTimeDate.iDay;	
	
	SetCalendar(iYear, iMonth, iDay);

	int iHour		= rTimeDate.iHour; 	
	int iMinute		= rTimeDate.iMinute;
	int iSecond		= rTimeDate.iSecond;
	int iMillisecond= rTimeDate.iMillisecond;
	
	SetTime (iHour, iMinute, iSecond, iMillisecond);
}

int CSLGetTimeHash( int nHours, int nDays )
{
	int nTimeHash = nHours + ( nDays * 24 );
	return ( nTimeHash );
}

// Return time hash difference (adjusts for wrap around)
int CSLGetTimeHashDifference( int nHash1, int nHash2 )
{
	int nDifference = nHash1 - nHash2;
	if ( nDifference < 0 )
	{
		nDifference = nDifference + 672; // wrap around
	}
	
	//CSLMessage_PrettyMessage( "CSLGetTimeHashDifference( " + IntToString( nHash1 ) +  ", " + IntToString( nHash2 ) +  " ) = " + IntToString( nDifference ) );
	return ( nDifference );
}

// Return current time hash
int CSLGetCurrentTimeHash()
{
	int nCurrentHour = GetTimeHour();
	int nCurrentDay = GetCalendarDay();
	//CSLMessage_PrettyMessage( "CSLGetCurrentTimeHash(): nCurrentHour = " + IntToString( nCurrentHour ) + ", nCurrentDay = " + IntToString( GetCalendarDay() ) );
	int nTimeHash = CSLGetTimeHash( nCurrentHour, nCurrentDay );
	return ( nTimeHash );
}

// Hash functions
//-------------------------------------------------

/*
// Return time hash given nHours and nDays
// Ranges between 24 (0 Hour 1 Day) and 695 (23 Hour 28 Day)


*/
// Does module perceive that the hour has changed?  
// returns number of module hours passed (number of campaign hours passed is also stored)
struct CHoursPassed CSLHasHourChanged()
{
	struct CHoursPassed rHP;
	int nNumModuleHoursPassed = 0;
	int nNumCampaignHoursPassed = 0;
	
	// What time is it?
	int nCurrentHour = CSLGetCurrentTimeHash();	
	
	// we save this as a local on the module.  A campaign has multiple modules,
	// and when returning to a module, all the registered objects need to be notified of 
	// the amount of time that has passed.
    object oModule = GetModule();
	int nPreviousModuleHour = GetLocalInt(oModule, "PREVIOUS_HOUR");
	int nPreviousCampaignHour = GetGlobalInt("PREVIOUS_HOUR");

	//PrettyDebug ("nCurrentHour = " + IntToString(nCurrentHour));
	//PrettyDebug ("nPreviousModuleHour = " + IntToString(nPreviousModuleHour));
	//PrettyDebug ("nPreviousCampaignHour = " + IntToString(nPreviousCampaignHour));
	
	// time updates are never 0, so this module has not been initialized yet.
	if (nPreviousModuleHour == 0)
	{
		// initialize previous hour as being the current hour
		nPreviousModuleHour = nCurrentHour;
		SetLocalInt(oModule, "PREVIOUS_HOUR", nPreviousModuleHour);
	}
	
	// time updates are never 0, so this campaign has not been initialized yet.
	if (nPreviousCampaignHour == 0)
	{
		// initialize previous hour as being the current hour
		nPreviousCampaignHour = nCurrentHour;
		SetGlobalInt("PREVIOUS_HOUR", nPreviousCampaignHour);
	}
	
	
	// return false if the time has not incremented.
	// Note that the number of module hours may change even if the number of campaign hours has not 
	// (but not vice versa - except when module hours is 0)
	if (nCurrentHour == nPreviousModuleHour)
		nNumModuleHoursPassed = 0;
	else
	{
		// return true if time has changed, and note the new "previous hour"
        // and number of hours passed
		SetLocalInt(oModule, "PREVIOUS_HOUR", nCurrentHour);
      	nNumModuleHoursPassed = CSLGetTimeHashDifference(nCurrentHour, nPreviousModuleHour);
		SetLocalInt(oModule, "HOURS_PASSED", nNumModuleHoursPassed);
	}
	
	if (nCurrentHour == nPreviousCampaignHour)
		nNumCampaignHoursPassed = 0;
	else
	{				
		SetGlobalInt("PREVIOUS_HOUR", nCurrentHour);
      	nNumCampaignHoursPassed = CSLGetTimeHashDifference(nCurrentHour, nPreviousCampaignHour);
		SetGlobalInt("HOURS_PASSED", nNumCampaignHoursPassed);
	}		

	rHP.nNumModuleHoursPassed = nNumModuleHoursPassed;
	rHP.nNumCampaignHoursPassed = nNumCampaignHoursPassed;
	return (rHP);					
}


/*
int GetPreviousHour()
{
	int iPreviousHour = GetLocalInt(OBJECT_SELF, "PREVIOUS_HOUR");
    
	// if Previous hour is 0, then it  has not been initialized yet.
	if (iPreviousHour == 0)
	{
		// initialize previous hour as being the current hour
		iPreviousHour = CSLGetCurrentTimeHash();
		SetLocalInt(oModule, "PREVIOUS_HOUR", iPreviousHour);
	}
    
    return (iPreviousHour);
}
*/
int CSLGetNumHoursPassed()
{
    object oModule = GetModule();
	//int iCurrentHour = CSLGetCurrentTimeHash();
    // this is not returning correct thing.
	//int iPreviousHour = GetLocalInt(OBJECT_SELF, "PREVIOUS_HOUR");
	//int iNumHoursPassed = CSLGetTimeHashDifference(iCurrentHour, iPreviousHour);
	//PrettyDebug ("CSLGetNumHoursPassed(): iCurrentHour = " + IntToString(iCurrentHour) + "iPreviousHour = " + IntToString(iPreviousHour));
	//PrettyDebug("CSLGetNumHoursPassed(): iNumHoursPassed = " + IntToString(iNumHoursPassed));
    int iNumHoursPassed = GetLocalInt(oModule, "HOURS_PASSED");
	return (iNumHoursPassed);
}


// Time Registration
//-------------------------------------------------


// Notify the registered object
void CSLNotifyRegisteredObject(object oObject)
{
	// SignalEvent(oObject, evTimeEvent)
	
	string sScript = "t_" + GetTag(oObject);
	ExecuteScript(sScript, oObject);
}

// fires time event on all registered objects
void CSLNotifyRegisteredObjects()
{
	int i = 0;
	float fDelay;
	/*
	object oMember = SCGetFirstInGroup("TIME_EVENT_NOTIFY");
  	event evTimeEvent = EventUserDefined(EVENT_TIME_EVENT);
	while (GetIsObjectValid(oMember))
	{
	 	// Spread the events out a little bit so the server doesn't get swamped
		// w/ event requests.
		// might want to base this on number of objects in group so delay never
		// gets to large
		i++;
		fDelay = IntToFloat(i) * 0.01f;
	
  		DelayCommand(fDelay, CSLNotifyRegisteredObject(oMember));
		oMember = SCGetNextInGroup("TIME_EVENT_NOTIFY");
	}
	*/
}


// Events are stored as module vars "EVENT_<X>" with the value being a string representation of the time.
void CSLSetUpTimeEvent(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0)
{
	struct CTimeDate rTimeDate = CSLNewCTimeDate(iYear, iMonth, iDay, iHour, iMinute, iSecond, iMillisecond);
	
	// insert event into sorted list.	
}


// Determine any scheduled TimeDate events that need to fire.
// TimeDate event data is stored in sorted order.  We check and fire all events that 
// are found to be <= current time.  We can stop processing when we find one > current time.
// The data is stored in 2 places - global vars for the player and companions, and the the current 
// module for all other objects.
void CSLCheckTimeDateEvents()
{
	
}



// Registers object for hourly event notification
void CSLRegisterForTimeEvent(object oObject)
{
	// SCGroupAddMember("TIME_EVENT_NOTIFY", oObject);	// need to fix problems w/ conflicting groups
		
}



// Clock GUI
//-------------------------------------------------




// check if we're ready to fire another event.
// can be called as often as desired.
struct CHoursPassed CSLCheckTime()
{
	CSLCheckTimeDateEvents();
	
	// exit if the time has not incremented.
	//int nNumHoursPassed = CSLHasHourChanged();

	struct CHoursPassed rHP = CSLHasHourChanged();
	int nNumModuleHoursPassed =	rHP.nNumModuleHoursPassed;
	//int nNumCampaignHoursPassed = rHP.nNumCampaignHoursPassed;

	if (nNumModuleHoursPassed != 0)
	{
		//Time has incremented so send notifications		
		CSLNotifyRegisteredObjects();
	}
	//return (nNumHoursPassed);
	return (rHP);
	
}







// Range Checks
//-------------------------------------------------


// check if current hour is in specified range
int CSLIsCurrentHourInRange(int iStartHour, int iEndHour)
{
	int iCurrentTime = GetTimeHour();	
	return CSLIsWithinRange(iCurrentTime, iStartHour, iEndHour);
}

// check if current day is in specified range
int CSLIsCurrentDayInRange(int iStartDay, int iEndDay)
{
	int iCurrentDay = GetCalendarDay();
	return CSLIsWithinRange(iCurrentDay, iStartDay, iEndDay);
}

// check if current month is in specified range
int CSLIsCurrentMonthInRange(int iStartMonth, int iEndMonth)
{
	int iCurrentMonth = GetCalendarMonth();
	return CSLIsWithinRange(iCurrentMonth, iStartMonth, iEndMonth);
}

// check if current year is in specified range
int CSLIsCurrentYearInRange(int iStartYear, int iEndYear)
{
	int iCurrentYear = GetCalendarYear();
	return CSLIsWithinRange(iCurrentYear, iStartYear, iEndYear);
}