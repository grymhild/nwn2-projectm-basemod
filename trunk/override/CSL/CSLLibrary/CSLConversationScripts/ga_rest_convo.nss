// ga_rest_convo
/*
    master script for conversation "rest"
*/
// 
// ChazM 4/5/07 - change to use string ref
const int STR_REF_REST_IMMINENT_DANGER		= 206063;	// "This place is in imminent danger."
const int STR_REF_REST_EXTREME_DANGER		= 206064;	// "This is an extremely dangerous place to rest."
const int STR_REF_REST_VERY_DANGEROUS		= 186202;	// "This is a very dangerous place to rest."	
const int STR_REF_REST_DANGEROUS			= 186203;	// "This is a dangerous place to rest."
const int STR_REF_REST_SOMEWHAT_DANGEROUS 	= 186204;	// "This is a somewhat dangerous place to rest."
const int STR_REF_REST_RELATIVELY_SAFE		= 186205;	// "This is a relatively safe place to rest."
const int STR_REF_REST_SAFE					= 186206;	// "This is a safe place to rest."

// percentages corresponding to the level of safety
const int REST_IMMINENT_DANGER			= 100;	
const int REST_EXTREME_DANGER			= 80;
const int REST_VERY_DANGEROUS			= 60;	
const int REST_DANGEROUS				= 40;
const int REST_SOMEWHAT_DANGEROUS 		= 20;
const int REST_RELATIVELY_SAFE			= 1;
const int REST_SAFE						= 0;


// DayTime is either Day or Dawn while NightTime is Night & Dusk
int GetIsDayTime()
{
	if (GetIsDay() || GetIsDawn())
		return TRUE;
	else
		return FALSE;		
}

// This suffix is appened to variable names
string GetTimeOfDaySuffix(string sSuffix="")
{
	if (sSuffix != "")
	{
		return sSuffix;
	}
	
	if (GetIsDayTime())
	{
		return ("_DAY");
	}
	return ("_NIGHT");
}		

// returns the variable storing the table name for day or night
// if sSuffix is blank, the current time will be used for returning the var
string GetTableNameVar(string sSuffix="")
{
	return ("WM_ENC_TABLE" + GetTimeOfDaySuffix(sSuffix));
}

string GetProbabilityVar(string sSuffix="")
{
	return ("WM_ENC_PROB" + GetTimeOfDaySuffix(sSuffix));
}

// returns a string ref based on the probabiltiy passed in.
int WMGetRestStringRef(int nDangerLevel)
{
	int nRet;
	if (nDangerLevel >= REST_IMMINENT_DANGER)
		nRet = STR_REF_REST_IMMINENT_DANGER;
	else if (nDangerLevel >= REST_EXTREME_DANGER)
		nRet = STR_REF_REST_EXTREME_DANGER;
	else if (nDangerLevel >= REST_VERY_DANGEROUS)
		nRet = STR_REF_REST_VERY_DANGEROUS;
	else if (nDangerLevel >= REST_DANGEROUS)
		nRet = STR_REF_REST_DANGEROUS;
	else if (nDangerLevel >= REST_SOMEWHAT_DANGEROUS)
		nRet = STR_REF_REST_SOMEWHAT_DANGEROUS;
	else if (nDangerLevel >= REST_RELATIVELY_SAFE)
		nRet = STR_REF_REST_RELATIVELY_SAFE;
	else // if (nDangerLevel >= REST_SAFE)
		nRet = STR_REF_REST_SAFE;
	
	return (nRet);
}	



//--------------------------------------------------------------------------
// Get the probability for a wandering monster depending on the time of day
//--------------------------------------------------------------------------
int WMGetWanderingMonsterProbability(object oPC)
{
	object oArea = GetArea(oPC);
    int nProb = GetLocalInt(oArea, GetProbabilityVar());
	int nCumProb = GetLocalInt(oArea, "WM_ENC_CUM_TOTAL");
	nProb += nCumProb;
	return (nProb);
}

#include "_SCInclude_Overland"
//#include "ginc_restsys"

void main(int nAction)
{
    object oPC = GetPCSpeaker();

    switch ( nAction )
    {

        case 100:	// set up token
		{
			int nProb = WMGetWanderingMonsterProbability(oPC);
			int nResRef = WMGetRestStringRef(nProb);
			string sRestSafety = GetStringByStrRef(nResRef);
			SetCustomToken (99, sRestSafety);
			break;
		}
        case 200:	//
			break;

        case 300:	//
			break;

        case 400:	//
			break;

        case 500:	//
			break;
    }

}