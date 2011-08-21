/** @file
* @brief Math Related Functions
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
#include "_CSLCore_Math_c"


/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////
/*
int CSLGetMax(int iNum1 = 0, int iNum2 = 0);

int CSLGetMin(int iNum1 = 0, int iNum2 = 0);

float CSLGetMaxf(float iNum1 = 0.0, float iNum2 = 0.0);

float CSLGetMinf(float iNum1 = 0.0, float iNum2 = 0.0);

int CSLIsWithinRange(int iIn, int nMin, int nMax );

int CSLGetWithinRange(int iIn, int nMin, int nMax );

int CSLIsWithinRangef( float flValue, float flMin, float flMax );

float CSLGetWithinRangef(float flValue, float flMin, float flMax);

int CSLMaxLocalInt(object oObject, string sKey, int iIn);

int CSLMinLocalInt(object oObject, string sKey, int iIn);

int CSLIncrementLocalInt(object oObject, string sFld, int iVal = 1);

int CSLDecrementLocalInt(object oObject, string sFld, int iVal = 1, int bZeroLimit = FALSE);

float CSLIncrementLocalFloat(object oObject, string sFld, float fVal = 0.0f);

float CSLDecrementLocalFloat(object oObject, string sFld, float fVal = 0.0f, int bZeroLimit = FALSE);

int CSLRoundToNearest(int iIn, int nNearest=5);

int CSLBitAdd( int iVal, int iBits );

int CSLBitSub( int iVal, int iBits );

int CSLBitSubGroup( int iVal, int iBits1 = 0, int iBits2 = 0, int iBits3 = 0, int iBits4 = 0, int iBits5 = 0, int iBits6 = 0, int iBits7 = 0, int iBits8 = 0, int iBits9 = 0 );

float CSLACosH( float fValue );

float CSLASinH( float fValue );

float CSLATanH( float fValue );

void CSLTimedFlag( object oObject, string sFld, float fDelay );
*/

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/************************************************************/
/** @name Range Functions
* Used to keep numbers within a minimum and maximum value
********************************************************* @{ */

/**  
* the Integer Maximum of two values
* @author
* @param 
* @see 
* @return 
*/
int CSLGetMax(int iNum1 = 0, int iNum2 = 0)
{
	return (iNum1 > iNum2) ? iNum1 : iNum2;
}


/**  
* the Integer Minimum of two values
* @author
* @param 
* @see 
* @return 
*/
int CSLGetMin(int iNum1 = 0, int iNum2 = 0)
{
	return (iNum1 < iNum2) ? iNum1 : iNum2;
}


/**  
* the Float Maximum of two values
* @author
* @param 
* @see 
* @return 
*/
float CSLGetMaxf(float iNum1 = 0.0, float iNum2 = 0.0)
{
	return (iNum1 > iNum2) ? iNum1 : iNum2;
}

/**  
* the Float Minimum of two values
* @author
* @param 
* @see 
* @return 
*/
float CSLGetMinf(float iNum1 = 0.0, float iNum2 = 0.0)
{
	return (iNum1 < iNum2) ? iNum1 : iNum2;
}

/**  
* Returns a float rounded up to the next highest number if its above an even amount, only works up to 2 decimal places so 1.009 would return 1, while 1.010 would return 2
* @todo need to verify this works
* @author
* @param 
* @see 
* @return 
*/
int CSLCeilf( float fIn )
{
	return ( FloatToInt( fIn*100) % 100 ) ? FloatToInt( fIn ) + 1 : FloatToInt( fIn );
	//return 0; // Modulo % only works on integers :(
}


/**  
* Rounds given number to nearest specified place
* @author
* @param 
* @see 
* @return 
*/
int CSLRoundToNearest(int iIn, int nNearest=5)
{
	return iIn - (iIn % nNearest);
}

/**  
* Returns the True if the first value is between or equal to the 2nd and 3rd values
* @author
* @param iIn Original Value
* @param iMin Mininum Value
* @param iMax Maximum Value
* @see 
* @replaces IsIntInRange by OEI from ginc_math
* @return  TRUE if  between iMin and iMax, otherwise false
*/
int CSLIsWithinRange(int iIn, int iMin, int iMax )
{
	if ( iIn < iMin )
	{
		return FALSE;
	}
	if ( iIn > iMax )
	{
		return FALSE;
	}
	return TRUE;
}

/**  
* Returns the either the original value, or the minimum or maximum values if it exceeds them
* @param iIn Original Value
* @param iMin Mininum Value
* @param iMax Maximum Value
* @see 
* @replaces ClampInt
* @return Value which is adjusted to be between iMin and iMax
*/
int CSLGetWithinRange(int iIn, int iMin, int iMax )
{
	if ( iIn < iMin )
	{
		return iMin;
	}
	if ( iIn > iMax )
	{
		return iMax;
	}
	return iIn;
}

/**  
* Returns the True if the first value is between or equal to the minimum and maximum values
* @author
* @param fIn Original Value
* @param fMin Mininum Value
* @param fMax Maximum Value 
* @see 
* @return TRUE if  between iMin and iMax, otherwise false
*/
int CSLIsWithinRangef( float fIn, float fMin, float fMax )
{
	if ( fIn < fMin )
	{
		return FALSE;
	}
	if ( fIn > fMax )
	{
		return FALSE;
	}
	return TRUE;
}


/**  
* Checks if flValue is between flMin and flMax
* @author
* @param 
* @see 
* @replaces ClampFloat
* @return Value which is adjusted to be between iMin and iMax
*/
float CSLGetWithinRangef(float fIn, float fMin, float fMax)
{
	if ( fIn < fMin )
	{
		return fMin;
	}
	if ( fIn > fMax )
	{
		return fMax;
	}
	return fIn;
}

/**  
* Checks if a float is likely the same value as an int, accounting for innaccuracies in floats
* @author
* @param 
* @see 
* @return TRUE or FALSE
* @replaces IsFloatNearInt by OEI from ginc_math
*/
int CSLIsFloatNearInt(float fValue, int iIn)
{
	//int iRet = FALSE;
	float fCompareValue = IntToFloat(iIn);
	if (fValue > fCompareValue + SC_EPSILON)
		return (FALSE);

	if (fValue < fCompareValue - SC_EPSILON)
		return (FALSE);
	
	return (TRUE);
}


//@}

/************************************************************/
/** @name LocalVariable functions
* Description
********************************************************* @{ */



//CSLDataArray_SetInt/CSLSetBooleanValue
// Set a true/false value on oTarget
void CSLSetBooleanValue(object oTarget, string sVarname, int bVal=TRUE)
{
    if (GetIsObjectValid(oTarget) && sVarname != "") {
        SetLocalInt(oTarget, sVarname, bVal);
    }
}
//CSLDataArray_GetInt/CSLGetBooleanValue
// Get the value of a true/false variable on oTarget
int CSLGetBooleanValue(object oTarget, string sVarname)
{
    if (GetIsObjectValid(oTarget) && sVarname != "") {
        return GetLocalInt(oTarget, sVarname);
    }
    return 0;
}



/**  
* Gets a local int, and if it's not already defined it sets a default value for it
* @author
* @param 
* @see 
* @return 
*/
int CSLDefineLocalInt(object oObject, string sFld, int iIn)
{
	int iCur = GetLocalInt(oObject, sFld);
	if (!iCur)
	{
		SetLocalInt(oObject, sFld, iIn);
		iCur = iIn;
	}
	return iCur;
}


/**  
* Gets a local float, and if it's not already defined it sets a default value for it
* @author
* @param 
* @see 
* @return 
*/
float CSLDefineLocalFloat(object oObject, string sFld, float fValue)
{
	float fCur = GetLocalFloat(oObject, sFld);
	if ( fCur != 0.0f )
	{
		SetLocalFloat(oObject, sFld, fValue);
		fCur = fValue;
	}
	return fCur;
}


/**  
* Takes an variable name on an object, and a value, and returns whichever is highest, does not change the localint
* @author
* @param 
* @see 
* @return 
*/
int CSLMaxLocalInt(object oObject, string sKey, int iIn, int bUpdateVarWithResult = FALSE )
{
	int iCur = GetLocalInt(oObject, sKey);
	iCur = CSLGetMax( iIn, iCur );
	
	if ( bUpdateVarWithResult )
	{
		SetLocalInt(oObject, sKey, iCur);
	}
	return iCur;
}

/**  
* Takes an variable name on an object, and a value, and returns whichever is lowest, does not change the localint
* @author
* @param 
* @see 
* @return named variable value unless it's value is 0, and then returns iln
*/
int CSLMinLocalInt(object oObject, string sKey, int iIn, int bUpdateVarWithResult = FALSE )
{
	int iCur = GetLocalInt(oObject, sKey);
	
	if ( iCur == 0 ) // Zeros might be a null, so if it's 0, i'll just return the  provided value
	{
		iCur = iIn;
	}
	else
	{
		iCur = CSLGetMin( iIn, iCur );
	}
	
	if ( bUpdateVarWithResult )
	{
		SetLocalInt(oObject, sKey, iCur);
	}
	
	return iCur;
}

/**  
* Takes an variable name on an object, and a value, and returns whichever is highest, does not change the localint
* @author
* @param 
* @see 
* @return 
*/
float CSLMaxLocalFloat(object oObject, string sKey, float fIn, int bUpdateVarWithResult = FALSE )
{
	float fCur = GetLocalFloat(oObject, sKey);
	fCur = CSLGetMaxf( fIn, fCur );
	
	if ( bUpdateVarWithResult )
	{
		SetLocalFloat(oObject, sKey, fCur);
	}
	return fCur;
}

/**  
* Takes an variable name on an object, and a value, and returns whichever is lowest, does not change the localint
* @author
* @param 
* @see 
* @return named variable value unless it's value is 0, and then returns iln
*/
float CSLMinLocalFloat(object oObject, string sKey, float fIn, int bUpdateVarWithResult = FALSE )
{
	float fCur = GetLocalFloat(oObject, sKey);
	
	if ( fCur == 0.0f ) // Zeros might be a null, so if it's 0, i'll just return the  provided value
	{
		fCur = fIn;
	}
	else
	{
		fCur = CSLGetMinf( fIn, fCur );
	}
	
	if ( bUpdateVarWithResult )
	{
		SetLocalFloat(oObject, sKey, fCur);
	}
	
	return fCur;
}

/**  
* A timesd flag
* @author
* @param 
* @see 
* @return 
*/
void CSLTimedFlag(object oObject, string sFld, float fDelay )
{
	SetLocalInt(oObject, sFld, TRUE);
	AssignCommand(oObject, DelayCommand(fDelay, DeleteLocalInt(oObject, sFld)));
}

/**
* Increments specified local integer and returns 
* @author
* @param 
* @replaces XXXModifyLocalInt
* @see 
* @return 
*/
int CSLIncrementLocalInt(object oObject, string sFld, int iVal = 1)
{
	int nNew = GetLocalInt(oObject, sFld) + iVal;
	SetLocalInt(oObject, sFld, nNew);
	return nNew;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLDecrementLocalInt(object oObject, string sFld, int iVal = 1, int bZeroLimit = FALSE)
{
	int nNew = GetLocalInt(oObject, sFld) - iVal;
	if ( bZeroLimit && nNew < 0 )
	{
		nNew = 0;
	}
	SetLocalInt(oObject, sFld, nNew);
	return nNew;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
float CSLIncrementLocalFloat(object oObject, string sFld, float fVal = 0.0f)
{
	float fNew = GetLocalFloat(oObject, sFld) + fVal;
	SetLocalFloat(oObject, sFld, fNew);
	return fNew;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
float CSLDecrementLocalFloat(object oObject, string sFld, float fVal = 0.0f, int bZeroLimit = FALSE)
{
	float fNew = GetLocalFloat(oObject, sFld) - fVal;
	if ( bZeroLimit && fNew < 0.0f )
	{
		fNew = 0.0f;
	}
	SetLocalFloat(oObject, sFld, fNew);
	return fNew;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLIncrementLocalInt_Void( object oObject, string sField, int iVal = 1 )
{
	int nNew = GetLocalInt(oObject, sField) + iVal;
	SetLocalInt(oObject, sField, nNew);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDecrementLocalInt_Void(object oObject, string sField, int iVal = 1, int bZeroLimit = FALSE)
{
	int nNew = GetLocalInt(oObject, sField) - iVal;
	if ( bZeroLimit && nNew < 0 )
	{
		nNew = 0;
	}
	SetLocalInt(oObject, sField, nNew);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLIncrementLocalFloat_Void(object oObject, string sFld, float fVal = 0.0f)
{
	float fNew = GetLocalFloat(oObject, sFld) + fVal;
	SetLocalFloat(oObject, sFld, fNew);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDecrementLocalFloat_Void(object oObject, string sFld, float fVal = 0.0f,  int bZeroLimit = FALSE)
{
	float fNew = GetLocalFloat(oObject, sFld) - fVal;
	if ( bZeroLimit && fNew < 0.0f )
	{
		fNew = 0.0f;
	}
	SetLocalFloat(oObject, sFld, fNew);
}

/**  
* Raises local integer for set period of time
* @author
* @param 
* @see 
* @return 
*/
int CSLIncrementLocalInt_Timed(object oObject, string sFld, float fDelay, int iVal = 1)
{
   int nNew = GetLocalInt(oObject, sFld) + iVal;
   SetLocalInt(oObject, sFld, nNew);
   //AssignCommand(oObject, 
   DelayCommand(fDelay, CSLDecrementLocalInt_Void(oObject, sFld, iVal, TRUE ));
   //);
   return nNew;
}


/**  
* Lowers local integer for set period of time
* @author
* @param 
* @see 
* @return 
*/
int CSLDecrementLocalInt_Timed(object oObject, string sFld, float fDelay, int iVal = 1)
{
   int nNew = GetLocalInt(oObject, sFld) - iVal;
   SetLocalInt(oObject, sFld, nNew);
   //AssignCommand(oObject, 
   DelayCommand(fDelay, CSLIncrementLocalInt_Void(oObject, sFld, iVal));
   //);
   return nNew;
}

//@}

/************************************************************/
/** @name GlobalVariable functions
* Description
********************************************************* @{ */

/**  
* Gets a global int, and if it's not already defined it sets a default value for it
* @author
* @param 
* @see 
* @return 
*/
int CSLDefineGlobalInt(string sFld, int iIn)
{
	int iCur = GetGlobalInt(sFld);
	if (!iCur)
	{
		SetGlobalInt(sFld, iIn);
		iCur = iIn;
	}
	return iCur;
}


/**  
* Gets a global float, and if it's not already defined it sets a default value for it
* @author
* @param 
* @see 
* @return 
*/
float CSLDefineGlobalFloat(string sFld, float fValue)
{
	float fCur = GetGlobalFloat(sFld);
	if ( fCur != 0.0f )
	{
		SetGlobalFloat( sFld, fValue);
		fCur = fValue;
	}
	return fCur;
}


/**  
* Returns whichever is highest, either the Global Int or passed in value
* @author
* @param 
* @see 
* @return 
*/
int CSLMaxGlobalInt( string sKey, int iIn)
{
   int iCur = GetGlobalInt( sKey);
   return CSLGetMax( iIn, iCur );
}

/**  
* Returns whichever is lowest, either the Global Int or passed in value
* @author
* @param 
* @see 
* @return named variable value unless it's value is 0, and then returns iln
*/
int CSLMinGlobalInt( string sKey, int iIn)
{
   int iCur = GetGlobalInt( sKey);
   if ( iCur == 0 ) // Zeros might be a null, so if it's 0, i'll just return the  provided value
   {
		return iIn;
   }
   return CSLGetMin( iIn, iCur );
}


/**
* Increments specified global integer and returns result
* @author
* @param 
* @see 
* @replaces XXXModifyGlobalInt
* @return 
*/
int CSLIncrementGlobalInt(string sFld, int iVal = 1)
{
	int nNew = GetGlobalInt(sFld) + iVal;
	SetGlobalInt(sFld, nNew);
	return nNew;
}

/**  
* Decrements specified global integer and returns result
* @author
* @param 
* @see 
* @return 
*/
int CSLDecrementGlobalInt(string sFld, int iVal = 1, int bZeroLimit = FALSE)
{
	int nNew = GetGlobalInt(sFld) - iVal;
	if ( bZeroLimit && nNew < 0 )
	{
		nNew = 0;
	}
	SetGlobalInt(sFld, nNew);
	return nNew;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
float CSLIncrementGlobalFloat(string sFld, float fVal = 0.0f)
{
	float fNew = GetGlobalFloat(sFld) + fVal;
	SetGlobalFloat(sFld, fNew);
	return fNew;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
float CSLDecrementGlobalFloat(string sFld, float fVal = 0.0f, int bZeroLimit = FALSE)
{
	float fNew = GetGlobalFloat(sFld) - fVal;
	if ( bZeroLimit && fNew < 0.0f )
	{
		fNew = 0.0f;
	}
	SetGlobalFloat(sFld, fNew);
	return fNew;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLIncrementGlobalInt_Void(string sField, int iVal = 1 )
{
	int nNew = GetGlobalInt(sField) + iVal;
	SetGlobalInt(sField, nNew);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDecrementGlobalInt_Void(string sField, int iVal = 1, int bZeroLimit = FALSE)
{
	int nNew = GetGlobalInt(sField) - iVal;
	if ( bZeroLimit && nNew < 0 )
	{
		nNew = 0;
	}
	SetGlobalInt(sField, nNew);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLIncrementGlobalFloat_Void(string sFld, float fVal = 0.0f)
{
	float fNew = GetGlobalFloat(sFld) + fVal;
	SetGlobalFloat(sFld, fNew);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDecrementGlobalFloat_Void(string sFld, float fVal = 0.0f,  int bZeroLimit = FALSE)
{
	float fNew = GetGlobalFloat(sFld) - fVal;
	if ( bZeroLimit && fNew < 0.0f )
	{
		fNew = 0.0f;
	}
	SetGlobalFloat(sFld, fNew);
}

/**  
* Raises global integer for set period of time
* @author
* @param 
* @see 
* @return 
*/
int CSLIncrementGlobalInt_Timed(string sFld, float fDelay, int iVal = 1)
{
   int nNew = GetGlobalInt(sFld) + iVal;
   SetGlobalInt(sFld, nNew);
   //AssignCommand(oObject, 
   DelayCommand(fDelay, CSLDecrementGlobalInt_Void(sFld, iVal, TRUE ));
   //);
   return nNew;
}


/**  
* Lowers global integer for set period of time
* @author
* @param 
* @see 
* @return 
*/
int CSLDecrementGlobalInt_Timed(string sFld, float fDelay, int iVal = 1)
{
   int nNew = GetGlobalInt(sFld) - iVal;
   SetGlobalInt(sFld, nNew);
   //AssignCommand(oObject, 
   DelayCommand(fDelay, CSLIncrementGlobalInt_Void(sFld, iVal));
   //);
   return nNew;
}

//@}

/************************************************************/
/** @name Bitwise functions
* Handles bitwise math which allows testing multiple TRUE/FALSE values hidding in a single integer
* Each one should use the BIT constants which progress such as 1,2,4,8 ( which are 0001, 0010, 0100, and 1000 and this is all about whether a particular position in 0010 is "1" or "0" )
* 
* Test for if a bit value is in use with
* if ( iValue & iNewValue )
*
* Add a bit value
* iValue = iValue | iNewValue;
* iValue |= iNewValue;
*
* Subtract a bit value
* iValue = iValue & ~iNewValue;
* iValue &= ~iNewValue;
********************************************************* @{ */

/**  
* Adds given bit to the stored integer variable
* @author
* @param 
* @see 
* @return 
*/
void CSLAddLocalBit(object oObject, string sVarName, int nValue)
{
	SetLocalInt( oObject, sVarName, GetLocalInt( oObject, sVarName) | nValue );
}


/**  
* Subtracts given bit from the stored integer variable
* @author
* @param 
* @see 
* @return 
*/
void CSLSubLocalBit(object oObject, string sVarName, int nValue)
{
	SetLocalInt( oObject, sVarName, GetLocalInt( oObject, sVarName) & ~nValue );
}


/**  
* Adds the bits to the given number, can be used for example to combine bit type values like metamagic
* It is highly recommended that the bitwise operation inside the function is used instead, but since many don't know bitwise operators very well, this hopefully will help until they familiarize themselves with such
* @author
* @param 
* @see 
* @return 
*/
int CSLBitAdd( int iVal, int iBits )
{
	return iVal | iBits;
}

/**  
* Subtracts the bits to the given number, can be used for example to combine bit type values like metamagic
* @author
* @param 
* @see 
* @return 
*/
int CSLBitSub( int iVal, int iBits )
{
	return iVal & ~iBits;
}

/**  
* Subtracts all the given bits from the given number, enmasse
* @author
* @param 
* @see 
* @return 
*/
int CSLBitSubGroup( int iVal, int iBits1 = 0, int iBits2 = 0, int iBits3 = 0, int iBits4 = 0, int iBits5 = 0, int iBits6 = 0, int iBits7 = 0, int iBits8 = 0, int iBits9 = 0 )
{
	return iVal & ~( iBits1 | iBits2 | iBits3 | iBits4 | iBits5 | iBits6 | iBits7 | iBits8 | iBits9 );
}


/**  
* sets state of iBitFlags in iIn and returns new value.
* if multiple flags, all will be modified
* @author
* @param 
* @see 
* @replaces SetState by OEI from ginc_math
* @return 
*/
int CSLBitSetState(int iIn, int iBitFlags, int bSet = TRUE)
{
	if(bSet == TRUE)
	{
		iIn = iIn | iBitFlags;
	}
	else if (bSet == FALSE)
	{
		iIn = iIn & ~iBitFlags;
	}
	return (iIn);
}


/**  
* returns state of iBitFlag in iIn.  
* if multiple flags, will return true if any are true.
* in use by one other function there
* @author
* @param 
* @see 
* @replaces GetState by OEI from ginc_math
* @return 
*/
int CSLBitGetState(int iIn, int iBitFlags)
{
	return (iIn & iBitFlags);
}


/**  
* Takes an integer from 1-32 and returns a number with that bit set to one
* If provided a 3, it returns 0x0100, if provided a 1 it returns 0x0001
* Note that 3 returns 4, 4 returns 8, 5 returns 16, and each increasing bit set actually doubles the previous value
* @author
* @param iIn
* @see 
* @replaces GetState by OEI from ginc_math
* @return number with the bit set correlating to iIn
*/
int CSLIntegertoBit(int iIn )
{
	return 1 << iIn;
}

/**  
* sets the bit flags on or off in the local int
* @author
* @param 
* @see 
* @replaces SetLocalIntState by OEI from ginc_math
* @return 
*/
void CSLSetLocalIntBitState(object oTarget, string sVariable, int iBitFlags, int bSet = TRUE)
{
	int iIn = GetLocalInt(oTarget, sVariable);
	int iNewValue = CSLBitSetState(iIn, iBitFlags, bSet);
	SetLocalInt(oTarget, sVariable, iNewValue);
}


/**  
* if multiple flags, will return true if any of iBitFlags are true.
* @author
* @param 
* @see 
* @replaces GetLocalIntState by OEI from ginc_math
* @return TRUE or FALSE
*/
int CSLGetLocalIntBitState(object oTarget, string sVariable, int iBitFlags)
{
	int iIn = GetLocalInt(oTarget, sVariable);
	return (CSLBitGetState(iIn, iBitFlags));
}

string CSLBinaryBitsToString( int iInteger )
{
	string sOutput = "";
	
	sOutput += (iInteger & BIT31) ? "1" : "0";
	sOutput += (iInteger & BIT30) ? "1" : "0";
	sOutput += (iInteger & BIT29) ? "1" : "0";
	sOutput += " ";
	sOutput += (iInteger & BIT28) ? "1" : "0";
	sOutput += (iInteger & BIT27) ? "1" : "0";
	sOutput += (iInteger & BIT26) ? "1" : "0";
	sOutput += (iInteger & BIT25) ? "1" : "0";
	sOutput += " ";
	sOutput += (iInteger & BIT24) ? "1" : "0";
	sOutput += (iInteger & BIT23) ? "1" : "0";
	sOutput += (iInteger & BIT22) ? "1" : "0";
	sOutput += (iInteger & BIT21) ? "1" : "0";
	sOutput += " ";
	sOutput += (iInteger & BIT20) ? "1" : "0";
	sOutput += (iInteger & BIT19) ? "1" : "0";
	sOutput += (iInteger & BIT18) ? "1" : "0";
	sOutput += (iInteger & BIT17) ? "1" : "0";
	sOutput += " ";
	sOutput += (iInteger & BIT16) ? "1" : "0";
	sOutput += (iInteger & BIT15) ? "1" : "0";
	sOutput += (iInteger & BIT14) ? "1" : "0";
	sOutput += (iInteger & BIT13) ? "1" : "0";
	sOutput += " ";
	sOutput += (iInteger & BIT12) ? "1" : "0";
	sOutput += (iInteger & BIT11) ? "1" : "0";
	sOutput += (iInteger & BIT10) ? "1" : "0";
	sOutput += (iInteger & BIT9) ? "1" : "0";
	sOutput += " ";
	sOutput += (iInteger & BIT8) ? "1" : "0";
	sOutput += (iInteger & BIT7) ? "1" : "0";
	sOutput += (iInteger & BIT6) ? "1" : "0";
	sOutput += (iInteger & BIT5) ? "1" : "0";
	sOutput += " ";
	sOutput += (iInteger & BIT4) ? "1" : "0";
	sOutput += (iInteger & BIT3) ? "1" : "0";
	sOutput += (iInteger & BIT2) ? "1" : "0";
	sOutput += (iInteger & BIT1) ? "1" : "0";
	return sOutput;
}

int CSLDotDecimalToInteger( string sDotDecimal )
{
	//string sDotDecimal = "1.2.3.4";
	int iPosition, iNextPosition;
	int iInt1, iInt2, iInt3, iInt4;
	
	iPosition = 0;
	iNextPosition = FindSubString( sDotDecimal, ".", iPosition );
	iInt1 = StringToInt( GetSubString(sDotDecimal, iPosition, iNextPosition ) );
	
	iPosition = iNextPosition+1;
	iNextPosition = FindSubString( sDotDecimal, ".", iPosition );
	iInt2 = StringToInt( GetSubString(sDotDecimal, iPosition, iNextPosition-iPosition ) );
	
	iPosition = iNextPosition+1;
	iNextPosition = FindSubString( sDotDecimal, ".", iPosition );
	iInt3 = StringToInt( GetSubString(sDotDecimal, iPosition, iNextPosition-iPosition ) );
	
	iPosition = iNextPosition+1;
	iNextPosition = FindSubString( sDotDecimal, ".", iPosition );
	iInt4 = StringToInt( GetSubString(sDotDecimal, iPosition, iNextPosition-iPosition ) );

	return ( iInt1 << 24 ) | ( iInt2 << 16 ) | ( iInt3 << 8 ) | iInt4;
}


string CSLIntegerToDotDecimal( int iInteger )
{
	string sOutput = "";
	//SendMessageToPC( GetFirstPC(), "Raw: "+CSLBinaryBitsToString(iInteger) );
	
	//SendMessageToPC( GetFirstPC(), "0xff000000: "+CSLBinaryBitsToString( ( iInteger & 0xff000000 ) >> 24 ) );
	//SendMessageToPC( GetFirstPC(), "0x00ff0000: "+CSLBinaryBitsToString( ( iInteger & 0x00ff0000 ) >> 16 ) );
	//SendMessageToPC( GetFirstPC(), "0x0000ff00: "+CSLBinaryBitsToString( ( iInteger & 0x0000ff00 ) >> 8 ) );
	//SendMessageToPC( GetFirstPC(), "0x000000ff: "+CSLBinaryBitsToString( ( iInteger & 0x000000ff ) ) );
	sOutput += IntToString( ( iInteger & 0xff000000 ) >> 24 )+".";
	sOutput += IntToString( ( iInteger & 0x00ff0000 ) >> 16 )+".";
	sOutput += IntToString( ( iInteger & 0x0000ff00 ) >> 8 )+".";
	sOutput += IntToString( ( iInteger & 0x000000ff ) );
	return sOutput;
}




//@}

/************************************************************/
/** @name Measurement functions
* Description
********************************************************* @{ */

/**  
* Convertion to Convert Meters To Feet
* @author Karl Nickels (Syrus Greycloak)
* @param fMeters Meters Value
* @see 
* @return Feet
*/
float CSLMetersToFeet(float fMeters) {
    return (fMeters/0.31);
}


/**  
* Returns maximum possible integer value ( mainly for reference )
* @author
* @param 
* @see 
* @return 
*/
int CSLGetMaxIntegerValue()
{
	return 2147483647;
}

/**  
* Returns maximum possible float value ( mainly for reference basically 3.402823e38 )
* @author
* @param 
* @see 
* @return 
*/
float CSLGetMaxFloatValue()
{
	return 34028230000000000000000000000000000000.0f;//;
}


//@}

/************************************************************/
/** @name Trigonometery functions
* Description
********************************************************* @{ */

/**  
* Description
* @author based on php to javascript library
* @param 
* @see 
* @return 
*/
float CSLACosH( float fValue )
{
    return log(fValue + sqrt(fValue*fValue-1));
}

/**  
* Description
* @author based on php to javascript library
* @param 
* @see 
* @return 
*/
float CSLASinH( float fValue )
{
    return log(fValue + sqrt(fValue*fValue+1));
}

/**  
* Description
* @author based on php to javascript library
* @param 
* @see 
* @return 
*/
float CSLATanH( float fValue )
{ 
    return 0.5 * log((1+fValue)/(1-fValue));
}


// Maths operation: fValue is raised to the power of fExponent
// * Returns zero if fValue ==0 and fExponent <0
//float pow(float fValue, float fExponent);

// const float CSLMATH_E   =      2.71828182845904523536028747135266250f 

//The exp() method returns the value of Ex, where E is Euler's number (approximately 2.7183) and x is the number passed to it.
float CSLExp( float fValue )
{
	return pow(CSLMATH_E, fValue);
}



/**  
* Description
* @author
* @param n1 is the number that would be divided
* @param n2 is the number to be divided by
* @see 
* @return 1 (TRUE) or 0 (FALSE)
*/
int CSLGetIsDivisible(int n1, int n2)
{
	// Probably redo this with a modulus function
	float f = IntToFloat(n1) / IntToFloat(n2);
	float f2 = IntToFloat(n1/n2);
	if ( f == f2 ) return 1;
	else return 0;
}

/**  
* Returns whether sWord is a number or not
* @author Demetrious from DMFI
* @param sWord
* @replaces GetIsValidInt
* @return 
*/
int CSLGetIsNumber(string sWord)
{   
    // much faster version without all the declarations
    return (sWord == IntToString(StringToInt(sWord)));
    /*
    int n;
    string sTest;

    n = StringToInt(sWord);
    sTest = IntToString(n);

    if (sWord!=sTest)
    {
        return FALSE;
	}
    return TRUE;
    */
}

/**  
* Formula for returning a weighted result based on a quadratic equation, Made for dealing with integers mainly
* @author
* @param 
* @see 
* @return 
*/
int CSLQuadratic( int iIn, float fA, float fB, float fC )
{
	// note that fA cannot be 0
	
	float fIn = IntToFloat( iIn );
	float fYout =  ( ( fA * pow( fIn, 2.0f) ) )  + ( fB * fIn ) + fC ;
	
	return FloatToInt( fYout );
}

//@}

/************************************************************/
/** @name Hex functions
* Description
********************************************************* @{ */
/**
 * Takes a string in the standard hex number format (0x####) and converts it
 * into an integer type value. Only the last 8 characters are parsed in order
 * to avoid overflows.
 * If the string is not parseable (empty or contains characters other than
 * those used in hex notation), the function errors and returns 0.
 *
 * Full credit to Axe Murderer
 *
 * @param sHex  The string to convert
 * @return      Integer value of sHex or 0 on error
 */
/**  
* Converts a Hex String to An Int
* @author
* @param 
* @see 
* @replaces JXGetIsTargetTypeArea
* @return 
*/
int CSLHexStringToInt(string sHex)
{
	int dec = 0;

	// We don't care about the "0x" prefix
	sHex = GetSubString(sHex, 2, GetStringLength(sHex) - 2);
	if(sHex == "") return 0;
	
	int len = GetStringLength(sHex);

	int i;
	string digit;
	int multiplier;
	for (i = 0; i < len; i++)
	{
		digit = GetSubString(sHex, i, 1);
		if (GetStringUpperCase(digit) == "A")
		{
			multiplier = 10;
		}
		else if (GetStringUpperCase(digit) == "B")
		{
			multiplier = 11;
		}
		else if (GetStringUpperCase(digit) == "C")
		{
			multiplier = 12;
		}
		else if (GetStringUpperCase(digit) == "D")
		{
			multiplier = 13;
		}
		else if (GetStringUpperCase(digit) == "E")
		{
			multiplier = 14;
		}
		else if (GetStringUpperCase(digit) == "F")
		{
			multiplier = 15;
		}
		else
		{
			multiplier = StringToInt(digit);
		}
		int j;
		int digitLoc = 1;
		for (j = 1; j < len -i; j++)
		{
			digitLoc *= 16;
		}
		dec += multiplier * digitLoc;
	}

	return dec;
}
/*
version from the PRC
int XXXHexToInt(string sHex)
{
    if(sHex == "") return 0;                            // Some quick optimisation for empty strings
    sHex = GetStringRight(GetStringLowerCase(sHex), 8); // Truncate to last 8 characters and convert to lowercase
    if(GetStringLeft(sHex, 2) == "0x")                  // Cut out '0x' if it's present
        sHex = GetStringRight(sHex, GetStringLength(sHex) - 2);
    string sConvert = "0123456789abcdef";               // The string to index using the characters in sHex
    int nReturn, nHalfByte;
    while(sHex != "")
    {
        nHalfByte = FindSubString(sConvert, GetStringLeft(sHex, 1)); // Get the value of the next hexadecimal character
        if(nHalfByte == -1) return 0;                                // Invalid character in the string!
        nReturn  = nReturn << 4;                                     // Rightshift by 4 bits
        nReturn |= nHalfByte;                                        // OR in the next bits
        sHex = GetStringRight(sHex, GetStringLength(sHex) - 1);      // Remove the parsed character from the string
    }

    return nReturn;
}
*/


//@}

/************************************************************/
/** @name Random Number functions
* Description
********************************************************* @{ */

/**  
* Returns a random integer which can be any possible value, if called multiple times 
* you can pass in the same number so it's set only once
* @param iPreviousValidNumber Used for handling repeated use, it only returns a random number if it starts with -1
* @return integers from 1 to a little over 2.1 billion, the largest possible 32 bit number that exists in NWN2. 
*/
int CSLGetRandomSerialNumber( int iPreviousValidNumber = -1 )
{
	if ( iPreviousValidNumber == -1 )
	{
		return Random( 2147483640 )+1;
	}
	return iPreviousValidNumber;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLRandomUpperHalf(int nIn)
{
	if (nIn)
	{
		nIn = nIn - Random(nIn/2);
	}
	return nIn;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLPickOneInt(int i1=-1, int i2=-1, int i3=-1, int i4=-1, int i5=-1, int i6=-1, int i7=-1, int i8=-1, int i9=-1, int i10=-1)
{
	int i=(i1>-1)+(i2>-1)+(i3>-1)+(i4>-1)+(i5>-1)+(i6>-1)+(i7>-1)+(i8>-1)+(i9>-1)+(i10>-1); // count ints not null
	i=Random(i)+1;
	if (i==1) return i1;  if (i==2) return i2;  if (i==3) return i3;  if (i==4) return i4;  if (i==5) return i5;
	if (i==6) return i6;  if (i==7) return i7;  if (i==8) return i8;  if (i==9) return i9;  if (i==10) return i10;
	return -1;
}



/**  
* This function allows the die size to be adjusted on the fly or to use odd die sizes. If you are always using a specific size of dice you should use the d100(), d20(), d10(), d12(), d8(), d6(), d4(), d3() or d2() functions instead.
* @param iDiceType The size of the die
* @param iNumDice The number of dice to be rolled
* @return random number
*/
int CSLDieX(int iDiceType, int iNumDice=1)
{
	if ( iNumDice < 0 )
	{
		// deal with a negative number of dice by returning a negative random value
		return -CSLDieX(iDiceType, abs(iNumDice) );
	}
	
	switch(iDiceType)
	{
		case SC_DIETYPE_D0:
			return 0;
			break;
		case SC_DIETYPE_D2:
			return d2( iNumDice );
			break;
		case SC_DIETYPE_D3:
			return d3( iNumDice );
			break;
		case SC_DIETYPE_D4:
			return d4( iNumDice );
			break;
		case SC_DIETYPE_D6:
			return d6( iNumDice );
			break;
		case SC_DIETYPE_D8:
			return d8( iNumDice );
			break;
		case SC_DIETYPE_D10:
			return d10( iNumDice );
			break;
		case SC_DIETYPE_D12:
			return d12( iNumDice );
			break;
		case SC_DIETYPE_D20:
			return d20( iNumDice );
			break;
		case SC_DIETYPE_D100:
			return d100( iNumDice );
			break;
		default:
			// we can't use a stock function, so lets go ahead and figure it out ourselves
			int iDamage = 0;
			int nCounter;
			for( nCounter = 0; nCounter < iNumDice; nCounter++)
			{
				iDamage += Random( iDiceType )+1;
			}
			return iDamage;
	}
	// will never hit this
	return 0;

}


/**  
* Gets a random number between two numbers. Note that the numbers given will ARE NOT EVER returned as it randomly returns what is BETWEEN them.
* @author
* @param iMin
* @param iMax
* @see 
* @replaces RandomIntBetween
* @return 
*/
int CSLRandomBetween(int iMin, int iMax )
{
    int iOffSet = iMax-iMin;
    return Random(iOffSet)+iMin;
}

// gives a random number between fMin and fMax
// preserve 2 decimal places
/**  
* Description
* @author
* @param 
* @see 
* @return 
* @replaces RandomFloatBetween
*/
float CSLRandomBetweenFloat(float fMin = 0.4, float fMax = 1.1)
{
	float fRandom = fMax - fMin;
	if(fRandom > 0.0)
	{
		int nRandom;
		nRandom = FloatToInt(fRandom  * 100.0f);
		nRandom = Random(nRandom) + 1;
		fRandom = IntToFloat(nRandom);
		fRandom /= 100.0f;
		return fRandom + fMin;
	}
	return fMin;
}

// gives a random number between fMin and fMax
// preserve 2 decimal places
/**  
* Description
* @author
* @param 
* @see 
* @replaces RandomFloat as well
* @return 
*/
float CSLRandomUpToFloat( float fMax = 1.1 )
{
	if( fMax > 0.0)
	{
		int nRandom;
		nRandom = FloatToInt(fMax  * 100.0f);
		nRandom = Random(nRandom) + 1;
		fMax = IntToFloat(nRandom);
		fMax /= 100.0f;
		return fMax;
	}
	return 0.0f;
}


/**  
* gives a random number between -fMagnitude and fMagnitude, preserve 2 decimal places
* @author
* @param 
* @see 
* @replaces RandomDelta by OEI
* @return 
*/
float CSLRandomDeltaFloat(float fMagnitude )
{
	float fRet = IntToFloat(Random(FloatToInt(fMagnitude * 100.0f)))/100.0f;
	if (d2()==1)
    {
        fRet = -fRet;
	}
	return (fRet);
}


/**  
* takes a string with pluses and die rolls, as in 1+2+3+1d4+2d8, minuses are currently being tested
* Allows any number of items to be added in a given string, from integers to die rolls. It does not support other symbols so only + or - are supported, so a 1*1 would be seen as an 11.
* Very simple logic, using + as a delimeter and any found group containing a "d" in it as a dice, support any die size ( even non standard ) based on number after the d , and the number prior to the d is used as the number of dice.
* @author Pain
* @param sIn String to evaluate holding an expression similar to "1+1d6+4d12"
* @see CSLDieX
* @return random number based on the given string
*/
int CSLRollStringtoInt( string sIn )
{
	int iPosition = 0;
	int iPrevPosition = 0;
	
	
	int iDPosition = 0;
	int iTotal = 0;
	string sFound;
	string sDice;
	string sDieSize;
	string sOperator;
	sIn = GetStringLowerCase( sIn ); // make sure lower case so D and d both work
	//SendMessageToPC(GetFirstPC(), "Starting With val "+sIn);
	// experiemental section, only hit if minus involved and basically inserts a + in fron of the given minus so we can still use the + as a delimter
	int iMinusPosition = FindSubString( sIn, "-" );
	if ( iMinusPosition > -1 )
	{
		string sWorkingString;
		int nStringLeftLength, nStringRightLength;
		while (  iMinusPosition > -1 )
		{
			nStringLeftLength = iMinusPosition; // number of chars up to replacement
			nStringRightLength = GetStringLength(sIn) - nStringLeftLength-1;
			
			sWorkingString = GetStringLeft(sIn, nStringLeftLength);
			sIn = GetStringRight(sIn, nStringRightLength);
			
			sWorkingString += "+-";
			
			//SendMessageToPC(GetFirstPC(), "Working X Length="+IntToString(GetStringLength(sIn))+" nStringLeftLength="+IntToString(nStringLeftLength)+" nStringRightLength="+IntToString(nStringRightLength)+" iMinusPosition="+IntToString(iMinusPosition)+" sIn="+sIn );
			
			iMinusPosition = FindSubString(sIn, "-");
		}
		//SendMessageToPC(GetFirstPC(), "Working sWorkingString="+sWorkingString+" sIn="+sIn); 
		sWorkingString += sIn;
		sIn = sWorkingString;
	}
	// end experimental section
	//SendMessageToPC(GetFirstPC(), sIn);
	sIn += "+"; // trailing plus soas to make sure it iterates them all
	iPosition = FindSubString( sIn, "+", 0 );
	while( iPosition > -1 )
	{
		
		iPosition = FindSubString( sIn, "+", iPrevPosition );
		if ( iPosition > -1 )
		{
			sFound = GetSubString(sIn, iPrevPosition, iPosition-iPrevPosition);
		}
		else
		{
			sFound = GetSubString(sIn, iPrevPosition, GetStringLength( sIn )-iPrevPosition );	
		}
		//SendMessageToPC( GetFirstPC(), sFound );
		iPrevPosition = iPosition+1;
		
		int iDPosition = FindSubString( sFound, "d" );
		if ( iDPosition > -1 )
		{
			sDice = GetStringLeft( sFound, iDPosition );
			sDieSize = GetStringRight( sFound, GetStringLength(sFound)-iDPosition-1 );
			/*
			if ( GetStringLeft( sDice, 1 ) == "-" )
			{
				sOperator = "-";
				sFound = GetStringRight( sDice, GetStringLength(sDice)-1 );
			}
			else
			{
				sOperator = "+";
			}
			*/
			int itempTotal = CSLDieX( StringToInt(sDieSize), StringToInt(sDice) );
			//SendMessageToPC(GetFirstPC(), "Working X Length="+IntToString(GetStringLength(sIn))+" sDice="+sDice+" sDieSize="+sDieSize+" itempTotal="+IntToString(itempTotal)+" sIn="+sFound );
			iTotal += itempTotal;
			/*
			if ( sOperator == "+" )
			{
				iTotal += itempTotal;
			}
			else
			{
				iTotal -= itempTotal;
			}
			*/
			//SendMessageToPC( GetFirstPC(), " --- sDice:"+sDice+" sDieSize:"+sDieSize+" = "+IntToString( itempTotal )+" now at "+IntToString( iTotal ) );
		}
		else
		{
			iTotal += StringToInt(sFound);
			//SendMessageToPC( GetFirstPC(), " --- Integer:"+sFound+" now at "+IntToString( iTotal ) );
		}
		
	
	}
	return iTotal;
}

/**  
* Modifies an integer with the passed in values, which passes thru to advanced die roll interpreter which can handle standard 1d6 type syntax
* @author Pain
* @param iIntegerToModify original value to modify
* @param sRollString which can be any set numbers separated by + or - symbols. A leading + - or = affects how it modifies the original value ( it will process the entire string and then subtract the result from the given number ). Using ++ or -- alone will increment or decrment by one.
* @param bDefaultIsAdd This controls the behavior if there is no leading + or - on the string, if FALSE the default is setting iIntegerToModify to the result of the roll, if TRUE it instead adds the result to iIntegerToModify, if the first character in iIntegerToModify is + or - or =, it uses those regardless
* @replaces CalcNewIntValue
* @see CSLRollStringtoInt
* @return integer result
*/
int CSLModifyIntWithRollString( int iIntegerToModify, string sRollString, int bDefaultIsAdd = FALSE )
{
	// trim left, basically make sure we have the correct leading digit since input is going to be from writers
	while ( GetStringLeft(sRollString, 1) == " ")
    {
        sRollString = GetStringRight(sRollString, GetStringLength(sRollString) - 1);
    }
    // trim right, we can just ignore this since it's only leading digits we care about
    //while ( GetStringRight(sRollString, 1 ) == " " )
    //{
    //    sRollString = GetStringLeft(sRollString, GetStringLength(sRollString) - 1);
    //}
	
	if ( sRollString == "++" )
	{
		iIntegerToModify++;
	}
	else if ( sRollString == "--" )
	{
		iIntegerToModify--;
	}
	else
	{
		string sOperator = GetStringLeft(sRollString, 1);
		string sOperator2 = GetStringLeft(sRollString, 2);
		if ( (sOperator == "=") || (sOperator == "+") || (sOperator == "-") )
		{
			if ( (sOperator == "+=") || (sOperator == "-=") )
			{
				sRollString = GetStringRight(sRollString, GetStringLength(sRollString) - 2);
			}
			else
			{
				sRollString = GetStringRight(sRollString, GetStringLength(sRollString) - 1);
			}
		}
		else
		{
			if (bDefaultIsAdd)
			{
				sOperator = "+";
			}
			else
			{			
				sOperator = "=";
			}
		}
	
		if ( sOperator == "+" )
		{
			iIntegerToModify += CSLRollStringtoInt( sRollString );
		}
		else if ( sOperator == "-" )
		{
			iIntegerToModify -= CSLRollStringtoInt( sRollString );
		}
		else
		{
			iIntegerToModify = CSLRollStringtoInt( sRollString );
		}
	}
	return iIntegerToModify;
}

/**  
* Modifies an integer local variable on an object with the passed in values, which passes thru to advanced die roll interpreter which can handle standard 1d6 type syntax
* @author Pain
* @param iIntegerToModify original value to modify
* @param sRollString which can be any set numbers separated by + or - symbols. A leading + - or = affects how it modifies the original value ( it will process the entire string and then subtract the result from the given number ). Using ++ or -- alone will increment or decrment by one.
* @param bDefaultIsAdd This controls the behavior if there is no leading + or - on the string, if FALSE the default is setting iIntegerToModify to the result of the roll, if TRUE it instead adds the result to iIntegerToModify, if the first character in iIntegerToModify is + or - or =, it uses those regardless
* @see CSLRollStringtoInt
* @see CSLModifyIntWithRollString
* @return integer result
*/
int CSLModifyLocalIntWithRollString( object oTarget, string sVariable, string sRollString, int bDefaultIsAdd = FALSE )
{
	int iIntegerToModify = GetLocalInt( oTarget, sVariable );
	
	iIntegerToModify = CSLModifyIntWithRollString( iIntegerToModify, sRollString, bDefaultIsAdd );
	SetLocalInt( oTarget, sVariable, iIntegerToModify );
	return iIntegerToModify;
}

//@}


/*
/// these are hex functions from ginc_math, need to look and see if these are actually needed for anything
// Return ASCII value of hexadecimal digit sHexDigit
// * Returns -1 if sHexDigit is not a valid hex digit (0-aA)
* @replaces GetHexStringDigitValue by OEI from ginc_math
int CSLGetHexStringDigitValue( string sHexDigit )
{
	int iIn = CharToASCII( sHexDigit );

	if ( ( iIn >= 48 ) && ( iIn <= 57 ) ) 		// 0-9 [0x30-0x39]
	{
		return ( iIn - 48 );
	}
	else if ( ( iIn >= 65 ) && ( iIn <= 70 ) )	// A-F [0x41-0x46]
	{
		return ( iIn - 55 );
	}
	else if ( ( iIn >= 97 ) && ( iIn <= 102 ) )	// a-f [0x61-0x66]
	{
		return ( iIn - 87 );
	}
	else
	{
		return ( -1 );
	}
}

// Return integer value of hexadecimal string sHexString
// * Can convert both "0x????" and "????" where "?" is a hex digit
* @replaces HexStringToInt by OEI from ginc_math
int CSLHexStringToInt( string sHexString )
{
	int nStringLen = GetStringLength( sHexString );
	int nReturn = 0;
	
	if ( nStringLen > 0 )
	{
		int nPos = 0;
		
		// Check for "0x" prefix
		if ( nStringLen >= 2 )
		{
			if ( GetSubString( sHexString, 0, 2 ) == "0x" )
			{
				nPos = 2;
			}
		}
		
		string sChar;
		int nChar;

		// For length of hex string
		while ( nPos < nStringLen )
		{
			// Get digit at position nPos
			sChar = GetSubString( sHexString, nPos, 1 );
			nChar = CSLGetHexStringDigitValue( sChar );
			
			if ( nChar != -1 )
			{
				// "bitshift left 4", OR nChar
				nReturn = ( nReturn << 4 ) | nChar;
			}
			else
			{
				// Invalid hex digit found
				break;
			}
			
			nPos = nPos + 1;
		}
	}
	
	return ( nReturn );
}
*/




/*
Note these are functions included in Nwscript.nss for mathematics

float fabs(float fValue); // Maths operation: absolute value of fValue


float cos(float fValue); // Maths operation: cosine of fValue


float sin(float fValue); // Maths operation: sine of fValue


float tan(float fValue); // Maths operation: tan of fValue

// Maths operation: arccosine of fValue
// * Returns zero if fValue > 1 or fValue < -1
float acos(float fValue);

// Maths operation: arcsine of fValue
// * Returns zero if fValue >1 or fValue < -1
float asin(float fValue);

// Maths operation: arctan of fValue
float atan(float fValue);

// Maths operation: log of fValue
// * Returns zero if fValue <= zero
float log(float fValue);

// Maths operation: fValue is raised to the power of fExponent
// * Returns zero if fValue ==0 and fExponent <0
float pow(float fValue, float fExponent);

// Maths operation: square root of fValue
// * Returns zero if fValue <0
float sqrt(float fValue);

// Maths operation: integer absolute value of iIn
// * Return value on error: 0
int abs(int iIn);

// Convert nInteger to hex, returning the hex value as a string.
// * Return value has the format "0x????????" where each ? will be a hex digit
//   (8 digits in total).
string IntToHexString(int nInteger);



PHP Math functions - Candidates for potential implementation
acosh()	Returns the inverse hyperbolic cosine of a number	4

float acosh( float fValue )
{
    return log(fValue + sqrt(fValue*fValue-1));
}

asinh()	Returns the inverse hyperbolic sine of a number	4

function asinh(arg)
{
    return Math.log(arg + Math.sqrt(arg*arg+1));
}

atan2()	Returns the angle theta of an (x,y) point as a numeric value between -PI and PI radians	3
atanh()	Returns the inverse hyperbolic tangent of a number	4

function atanh(arg) {
    // http://kevin.vanzonneveld.net
    // +   original by: Onno Marsman
    // *     example 1: atanh(0.3);
    // *     returns 1: 0.3095196042031118
 
    return 0.5 * Math.log((1+arg)/(1-arg));
}

base_convert()	Converts a number from one base to another	3
bindec()	Converts a binary number to a decimal number	3
ceil()	Returns the value of a number rounded upwards to the nearest integer	3
cosh()	Returns the hyperbolic cosine of a number	4
decbin()	Converts a decimal number to a binary number	3
dechex()	Converts a decimal number to a hexadecimal number	3
decoct()	Converts a decimal number to an octal number	3
deg2rad()	Converts a degree to a radian number	3
exp()	Returns the value of Ex	3
expm1()	Returns the value of Ex - 1	4
floor()	Returns the value of a number rounded downwards to the nearest integer	3
fmod()	Returns the remainder (modulo) of the division of the arguments	4
getrandmax() Returns the maximum random number that can be returned by a call to the rand() function	3
hexdec()	Converts a hexadecimal number to a decimal number	3
hypot()	Returns the length of the hypotenuse of a right-angle triangle	4
is_finite()	Returns true if a value is a finite number	4
is_infinite()	Returns true if a value is an infinite number	4
is_nan()	Returns true if a value is not a number	4
lcg_value()	Returns a pseudo random number in the range of (0,1)	4
log10()	Returns the base-10 logarithm of a number	3
log1p()	Returns log(1+number)	4
mt_getrandmax()	Returns the largest possible value that can be returned by mt_rand()	3
mt_rand()	Returns a random integer using Mersenne Twister algorithm	3
mt_srand()	Seeds the Mersenne Twister random number generator	3
octdec()	Converts an octal number to a decimal number	3
pi()	Returns the value of PI	3
rad2deg()	Converts a radian number to a degree	3
rand()	Returns a random integer	3
round()	Rounds a number to the nearest integer	3
sinh()	Returns the hyperbolic sine of a number	4
srand()	Seeds the random number generator	3
tan()	Returns the tangent of an angle	3
tanh()	Returns the hyperbolic tangent of an angle	4
*/

/*
nwscript random functions, for reference here
// Get the total from rolling (iNumDice x d2 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d2(int iNumDice=1);

// Get the total from rolling (iNumDice x d3 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d3(int iNumDice=1);

// Get the total from rolling (iNumDice x d4 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d4(int iNumDice=1);

// Get the total from rolling (iNumDice x d6 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d6(int iNumDice=1);

// Get the total from rolling (iNumDice x d8 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d8(int iNumDice=1);

// Get the total from rolling (iNumDice x d10 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d10(int iNumDice=1);

// Get the total from rolling (iNumDice x d12 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d12(int iNumDice=1);

// Get the total from rolling (iNumDice x d20 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d20(int iNumDice=1);

// Get the total from rolling (iNumDice x d100 dice).
// - iNumDice: If this is less than 1, the value 1 will be used.
int d100(int iNumDice=1);

*/



/*
FeatGroups are a way of storing integers on a character in a permament manner
without the need for skins or local variables

( This is in alpha development and some details - like the functions themselves and feats.2da setup - likely
will need to be adjusted to deal with real world issues that come up )

They require multiple FEATS be prepared which can store the number, 8 feats can
store a number up to 255, 9 feats 511, 10 feats 1023 and so on ( see table below ), recommend using a 10 block
range. The largest number which can be stored uses 31 feats as integers higher
than that don't work.

For the most part they are just placeholders to store a value or a set of
values.

Using a number higher than can be stored in the feat range will result in errors
as it will store just the bits in range.

If you only use a single row, it can only store a single digit, either 0 or 1
Each additional row stores double the previous value, so the second row stores a
2 or a 0, if you add the first and second rows you can get a range from 0-3.

The maximum values you can store without an error is as follows
Rows     Range of numbers that can be stored
1    =   0 - 1
2    =   0 - 3
3    =   0 - 7
4    =   0 - 15
5    =   0 - 31
6    =   0 - 63
7    =   0 - 127
8    =   0 - 255
9    =   0 - 511
10   =   0 - 1023
11   =   0 - 2047
12   =   0 - 4095
13   =   0 - 8191
14   =   0 - 16383
15   =   0 - 32767
16   =   0 - 65535
17   =   0 - 131071
18   =   0 - 262143
19   =   0 - 524287
20   =   0 - 1048575
21   =   0 - 2097151
22   =   0 - 4194303
23   =   0 - 8388607
24   =   0 - 16777215
25   =   0 - 33554431
26   =   0 - 67108863
27   =   0 - 134217727
28   =   0 - 268435455
29   =   0 - 536870911
30   =   0 - 1073741823
31*  =   0 - 2147483647

Note that since integers in NWN2 are 32 bit, you can only ever have 31 rows
since each row correlates to one of those bits. This is not a limitation of 
this, but with the integers themselves. ( the 31st bit stores if the number
is positive or negative ) ( Despite a system being 64 bit, the game is 32 bit )

These feats should have no category and be set to be invisible to the player,
and might make a character invalid depending on how they are done.

Example, a set of 10 feats to store langauge points, which should technically
never exceed the range of 0-100
These should be a contiguous range in feats.2da, of at least enough to handle
storing a given integer

Each row in feats.2da should be set up as follows for each row
LABEL FEAT_FEATGROUP_LANGPOINTS
Constant  FEAT_FEATGROUP_LANGPOINTS
FeatCategory ****
PreReqEpic 0
DMFeat 0
REMOVED 0
All of the other columns set to ****

Put these in rows from 8800 to 8807, i only need from 1-100 which would be 7
rows, but went up to 0-255 with 8bits, it also can deal with the fact
that my points might end up being a much higher number at some point

So given a player, i want to store a 13 on him. I store it as follows.
[code]
int iVariableToStore = 13;
object oPlayer = OBJECT_SELF;
CSLIntegerToFeatGroup( iVariableToStore, 8800, 8807, oPlayer );
[/code]

Now the player logs out, gets all their items removed, polymorphs, gets a
creature skin deleted, and gets all the variables stored on them cleaned, and is
put through a save game or two.

[code]
object oPlayer = OBJECT_SELF;
int iVariableToStore = CSLFeatGroupToInteger( 8800, 8807, oPlayer );
[/code]

Despite everything getting wiped, the iVariableToStore should still hold 13, and
unless something affects the feats ( ie no longer having feats.2da for example )

Disadvantages, feats can make a character invalid, and the feats.2da has to be
match the feats on the bic to prevent crashing when you browse your characters,
is not set up to handle negative numbers. Testing should be done to ensure a
number does not exceed the allowed range as it will result in a reduced number.

Possible usage: Skill point storage, storing original race or stat score before
manually adjusting it, storing keys to unlock quests and other codes, storing
the serial number which relates to a database row.

This like anything can be abused if too many integers are stored on a character,
it is very good for storing a few critical numbers on a character related to a
character, which describe their abilities. If the amount of information that
needs to be stored is excessive it is better to use other strategies. Such as
using this to store a serial number which can be used to retrieve information 
from a proper database or using player skins. This also is not to replace
local ints, which do stick if stored on an item, really for critical things only
most likely related to classes and builds.

Going to use my reserved range for the following ranges
8800-8807 language points 8 bit Range (0-255), to keep track of remaining points a player has left to spend ( which increment to match what is spent on lore )
8808-8815 prior lore 8 bit Range (0-255), to keep track of any lore increases which allow player to add language points
8810-8837 27 available bits ( perhaps 2 small ranges )
8838-8868 planned 31 bit range
8869-8899 Mana Points -31 bit  Range
*/

// stores an integer onto a character as a set of feats
void CSLIntegerToFeatGroup( int iInteger, int iStartingFeat, int iEndingFeat, object oTarget = OBJECT_SELF )
{
	int iRow = 0;
	int iCurrentBit = 1;
	int iTotalRows = (iEndingFeat-iStartingFeat);
	//SendMessageToPC(GetFirstPC(),"Integer "+IntToString(iInteger)+" to feat. "+IntToString(iStartingFeat)+" to "+IntToString(iEndingFeat));
	for (iRow = 0; iRow <= iTotalRows; iRow++) 
	{
		if ( iInteger & ( 1 << iRow ) ) // the syntax for getting a given bit is  "1 << iColumn" which shifts the value by that amount
		{
			FeatAdd( oTarget, iStartingFeat+iRow, FALSE, FALSE, FALSE );
			//SendMessageToPC(GetFirstPC(),"1 - Adding Feat "+IntToString(iStartingFeat+iRow)+" Bit="+IntToString(iRow));
		}
		else
		{
			FeatRemove( oTarget, iStartingFeat+iRow );
			//SendMessageToPC(GetFirstPC(),"0 - Removing Feat "+IntToString(iStartingFeat+iRow)+" Bit="+IntToString(iRow));
		}
	}
}

// stores an integer onto a character as a set of feats
int CSLFeatGroupToInteger(  int iStartingFeat, int iEndingFeat, object oTarget = OBJECT_SELF  )
{
	int iInteger;
	int iRow = 0;
	int iCurrentBit = 1;
	int iTotalRows = (iEndingFeat-iStartingFeat);
	//SendMessageToPC(GetFirstPC(),"Getting Integer from feat. "+IntToString(iStartingFeat)+" to "+IntToString(iEndingFeat));
	for (iRow = 0; iRow <= iTotalRows; iRow++) 
	{
		if ( GetHasFeat( iStartingFeat+iRow, oTarget, TRUE ) )
		{
			iInteger |= ( 1 << iRow ); // the syntax for getting a given bit is  "1 << iColumn" which shifts the value by that amount
			//SendMessageToPC(GetFirstPC(),"1 - Has Feat "+IntToString(iStartingFeat+iRow)+" Bit="+IntToString(iRow));
		}
	}
	return iInteger;
}



// CSLCheckVariableFloat()
//
// Evaluates the expression [fValue] [sOperator] [fCheck], as in, say, 5 < 3
// and returns the result -- true or false
// sOperator is =, >, <, or ! (for not equals)
int CSLCheckVariableFloat(float fValue, string sOperator, float fCheck)
{
	//GREATER THAN
    if ( sOperator == ">") 
	{
		return (fValue > fCheck);
	}
    
	//LESS THAN
	if ( sOperator == "<")
    {
		return (fValue < fCheck);
	}
     
	//NOT EQUAL TO
	if ( sOperator == "!")
	{
		//return (fValue != fCheck);
		fValue = fabs(fValue - fCheck);
		return (fValue > SC_EPSILON);
	}
	
	//EQUAL TO
	if( sOperator == "=")
	{
		//return (fValue == fCheck);
		fValue = fabs(fValue - fCheck);
		return (fValue < SC_EPSILON);
	}	

	return FALSE;
}

// CSLCheckVariableInt()
//
// Evaluates the expression [nValue] [sOperator] [nCheck], as in, say, 5 < 3
// and returns the result -- true or false
// sOperator is =, >, <, or ! (for not equals)
int CSLCheckVariableInt(int nValue, string sOperator, int nCheck)
{
	//GREATER THAN
    if ( sOperator == ">") 
	{
		return (nValue > nCheck);
	}
    
	//LESS THAN
	if ( sOperator == "<")
    {
		return (nValue < nCheck);
	}
     
	//NOT EQUAL TO
	if ( sOperator == "!")
	{
		return (nValue != nCheck);
	}
	
	//EQUAL TO
	if( sOperator == "=")
	{
		return (nValue == nCheck);
	}
	
	return FALSE;
}


// compare integer values
//	nValue - value to compare 
//	sCheck - string containing optional comparison operator and value
int CSLCompareInts(int nValue, string sCheck)
{
	int nCheck;
	string sValue;
	string sOperator = GetStringLeft(sCheck, 1);

	//first we consider cases where the user specified an operator as the first character
	//of sCheck
	if(sOperator == ">" || sOperator == "<" || sOperator == "=" || sOperator == "!")
	{
		sValue = GetStringRight( sCheck,GetStringLength(sCheck)-1 );
	}
	//default case -- no operator specified so use whole string as our check value
	else	
	{
		sValue = sCheck;
		sOperator = "=";
	}
	
	// sValue is now sCheck minus any operator on the front end
	// check if sValue has a tag
//	string sValueTag = GetStringLeft(sValue, 1);
//
//	if(sValueTag == "C" || sValueTag == "c")
//	{
//		int nCompanion = StringToInt(GetStringRight( sValue,GetStringLength(sValue)-1 ));
//		nCheck = GetGlobalInt(GetCompInfluenceGlobVar(nCompanion));
//	}
//	else
//	{
		nCheck = StringToInt(sValue);
//	}

	return (CSLCheckVariableInt(nValue, sOperator, nCheck));
}



// Given a varname, value, and PC, sets the variable on 
// all members of the PC's party, including associates. 
// For ints.
void CSLSetLocalIntOnFaction(object oPC, string sVarname, int value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalInt(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalInt(oPC, sVarname, value);
}

// Given a varname, value, and PC, sets the variable on 
// all members of the PC's party. 
// For floats.
void CSLSetLocalFloatOnFaction(object oPC, string sVarname, float value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalFloat(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalFloat(oPC, sVarname, value);
}