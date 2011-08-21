// gc_influence( int nCompanion, string sCheck )
/* This checks the influence rating between the companion to the PC, comparing it with sCheck.
   
   Parameters:
     int nCompanion  = This is the integer value of the companion to check. (See ginc_companions)
     string sCheck   = The operation to check on the influence rating.
	                   You can specify =, <, >, or !
					   e.g. sCheck of "=50" returns TRUE if influence is equal to 50.
					   sCheck of "<-80" returns TRUE if influence is less than -80.
					   sCheck of "!0" returns TRUE if influence is not equal to 0.
					   You may specify another companion's influence instead of an integer by prepending a "C"
					   eg. sCheck of "<C2" returns TRUE if influence is less than companion two's.
	1	Khelgar
	2	Neeshka
	3	Elanee
	4	Qara
	5	Sand
	6	Grobnar
	7	Casavir
	8	Bishop
	9	ShandraJerro
	10	Construct
	11	Zhjaeve
	12	AmmonJerro
	13  Bevil
*/
// ChazM 5/4/05
// BMA 5/5/05 switched to use companion table in ginc_companions
// ChazM 6/15/05 removed include "ginc_companions" (now included by "ginc_var_ops")
// BMA-OEI 12/05/05 added CSLMessage_PrettyMessage()
// TDE 2/14/04 - Added companion ID table
// BMA-OEI 7/10/06 -- Updated to use GetInfluenceByNumber()

#include "_SCInclude_Group"
#include "_CSLCore_Math"

// compare integer values
//	nValue - value to compare 
//	sCheck - string containing optional comparison operator and value
// 			value can be an integer or "C" + integer to represent a companion's influence	
int CompanionCompareInts(int nValue, string sCheck)
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
	string sValueTag = GetStringLeft(sValue, 1);

	if(sValueTag == "C" || sValueTag == "c")
	{
		int nCompanion = StringToInt(GetStringRight( sValue,GetStringLength(sValue)-1 ));
		nCheck = GetGlobalInt(GetCompInfluenceGlobVar(nCompanion));
	}
	else
	{
		nCheck = StringToInt(sValue);
	}

	return (CSLCheckVariableInt(nValue, sOperator, nCheck));
}


int StartingConditional( int nCompanion, string sCheck )
{
	int nInfluence = GetInfluenceByNumber( nCompanion );
	int nRet = CompanionCompareInts( nInfluence, sCheck );
	
 	//CSLMessage_PrettyMessage("gc_influence: " + sVarName + sCheck + " = " + IntToString(nValue) + " " + sCheck + ":" + IntToString(iRet));
	return ( nRet );
}