/** @file
* @brief Include file for Clock and related User Interfaces
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/


#include "_CSLCore_Time"
#include "_CSLCore_UI"
#include "_CSLCore_Player"


//Display Format Constants
const int M_D_Y_TEXT				= 1;
const int M_D_Y_SLASHES				= 2;
const int D_M_Y_TEXT				= 3;
const int D_M_Y_SLASHES				= 4;
const int Y_M_D_TEXT				= 5;
const int Y_M_D_SLASHES				= 6;


void SCClock_Display( object oTargetToDisplay, object oPC = OBJECT_SELF, string sScreenName = SCREEN_CLOCK )
{
	if ( !GetIsObjectValid( oTargetToDisplay) )
	{
		CloseGUIScreen( oPC,sScreenName );
		return;
	}

	//CSLDMVariable_SetLvmTarget(oPCToShowVars, oTargetToDisplay);
	DisplayGuiScreen(oPC, sScreenName, FALSE, XML_CLOCK);
	//CSLDMVariable_InitTargetVarRepository (oPCToShowVars, oTargetToDisplay);
	//SCCacheStats( oTargetToDisplay );
	//DelayCommand( 0.5, SCCharEdit_Build( oTargetToDisplay, oPC, sScreenName ) );
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

// The date in standard Forgotten Realms format
string SCGetFRDisplayDate(struct CTimeDate rTimeDate)
{
	string sOut;
	sOut += IntToString(rTimeDate.iYear) + " ";
	sOut += SCGetFRYearName(rTimeDate.iYear) + " ";
	sOut += SCGetFRMonthName(rTimeDate.iMonth) + " ";
	sOut += IntToString(rTimeDate.iDay);
	
	return (sOut);	
}

// The time in standard Forgotten Realms format
string SCGetFRDisplayTime(struct CTimeDate rTimeDate)
{
	string sOut;
	sOut += IntToString(rTimeDate.iHour) + ":";
	sOut += IntToString(rTimeDate.iMinute) + ":";
	sOut += IntToString(rTimeDate.iSecond) + ".";
	sOut += IntToString(rTimeDate.iMillisecond);
	
	return (sOut);
}

// The date in clock format
string SCGetClockDisplayDate(struct CTimeDate rTimeDate, int nDisplayFormat = M_D_Y_TEXT)
{
	string sOut;
	switch (nDisplayFormat)
	{
		case M_D_Y_TEXT:
			sOut += SCGetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iDay) + ", ";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case M_D_Y_SLASHES:
			sOut += IntToString(rTimeDate.iMonth) + "/";
			sOut += IntToString(rTimeDate.iDay) + "/";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case D_M_Y_TEXT:
			sOut += IntToString(rTimeDate.iDay) + " ";
			sOut += SCGetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case D_M_Y_SLASHES:
			sOut += IntToString(rTimeDate.iDay) + "/";
			sOut += IntToString(rTimeDate.iMonth) + "/";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case Y_M_D_TEXT:
			sOut += IntToString(rTimeDate.iYear) + " ";
			sOut += SCGetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iDay);
		break;
		
		case Y_M_D_SLASHES:
			sOut += IntToString(rTimeDate.iYear) + "/";
			sOut += IntToString(rTimeDate.iMonth) + "/";
			sOut += IntToString(rTimeDate.iDay);
		break;
		
		default:
			sOut += SCGetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iDay) + ", ";
			sOut += IntToString(rTimeDate.iYear);
		break;
	}	
	return (sOut);	
}

// The time in clock format
string SCGetClockDisplayTime(struct CTimeDate rTimeDate)
{
	string sOut;
	int iTimeRef = StringToInt(Get2DAString("time", "Name", rTimeDate.iHour));
	int iHourRef = 201139;
	//time of day
	sOut += GetStringByStrRef(iTimeRef) + " - ";
	//"Hour: "
	sOut += GetStringByStrRef(iHourRef);
	//digit representing hour
	sOut += " " + IntToString(rTimeDate.iHour);	
	return (sOut);
}

string SCGetClockDisplay(struct CTimeDate rTimeDate, int bTimeOnly)
{
	string sOut;
	string sTest = GetStringByStrRef(0);
	string sYear = SCGetFRYearName(rTimeDate.iYear);
	sOut += SCGetClockDisplayTime(rTimeDate);
	if(!bTimeOnly)
	{
		sOut += "\n" + SCGetClockDisplayDate(rTimeDate, M_D_Y_TEXT);
		if(sYear != sTest)
		{
			sOut += "\n" + sYear;
		}	
	}	
	return (sOut);
}



// update clock for a specific Player
void CSLUpdateClockForPlayer(object oPC)
{
	int bTimeOnly = GetGlobalInt("N2_S_ONLY_SHOW_TIME");
	struct CTimeDate rTimeDate = CSLGetCurrentCTimeDate();
	string sTime = SCGetClockDisplay(rTimeDate, bTimeOnly);
	SetLocalGUIVariable(oPC, "SCREEN_PLAYERMENU", 1, sTime);
	string sImage = Get2DAString("time", "Image", GetTimeHour());
	SetGUITexture(oPC, "SCREEN_PLAYERMENU", GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
	SetGUITexture(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, sImage);
	SetLocalGUIVariable(oPC, SCREEN_OL_FRAME, 1, sTime);
	//PrettyDebug("I AM WORKING");
}

// Set clock on (or off) for a specific Player
void CSLSetClockOnForPlayer(object oPC, int bClockOn=TRUE, int bOLMap = FALSE)
{	
	if(bOLMap)
	{
		int bHidden = !bClockOn;
		SetGUIObjectHidden(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, bHidden);
		// if turning on, then we should update it.
		if (bClockOn)
			CSLUpdateClockForPlayer(oPC);	
	}
	
	else
	{
		int bHidden = !bClockOn;
		SetGUIObjectHidden(oPC, "SCREEN_PLAYERMENU", GUI_PLAYERMENU_CLOCK_BUTTON, bHidden);
		// if turning on, then we should update it.
		if (bClockOn)
			CSLUpdateClockForPlayer(oPC);
	}
	
}

// update clock for all Players
// if clock is off (hidden), updates won't take effect.
void CSLUpdateClockForAllPlayers()
{	
	int bTimeOnly = GetGlobalInt("N2_S_ONLY_SHOW_TIME");
	struct CTimeDate rTimeDate = CSLGetCurrentCTimeDate();
	string sTime = SCGetClockDisplay(rTimeDate, bTimeOnly);
	string sImage = Get2DAString("time", "Image", GetTimeHour());
	object oPC = GetFirstPC();
	while(GetIsObjectValid(oPC))
	{
		SetGUITexture(oPC, "SCREEN_PLAYERMENU", GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
		SetLocalGUIVariable(oPC, "SCREEN_PLAYERMENU", 1, sTime);
		
		SetGUITexture(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, sImage);
		SetLocalGUIVariable(oPC, SCREEN_OL_FRAME, 1, sTime);
		//PrettyDebug("I AM WORKING");
		//AssignCommand(oPC, SpeakString("Yes I am working"));
		oPC = GetNextPC();
	}
}

// Set clock on (or off) for all Players
void CSLSetClockOnForAllPlayers(int bClockOn=TRUE, int bOLMap = FALSE)
{	
	int bHidden = !bClockOn;
	object oPC = GetFirstPC();
	while(GetIsObjectValid(oPC))
	{
		if(bOLMap)
			SetGUIObjectHidden(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, bHidden);
			
		else
			SetGUIObjectHidden(oPC, "SCREEN_PLAYERMENU", GUI_PLAYERMENU_CLOCK_BUTTON, bHidden);

		//AssignCommand(oPC, SpeakString("Yes I am working"));
		oPC = GetNextPC();
	}
	// if turning on, then we should update it.
	if (bClockOn)
		CSLUpdateClockForAllPlayers();
}



