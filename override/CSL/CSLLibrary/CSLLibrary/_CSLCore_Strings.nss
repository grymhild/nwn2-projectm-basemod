/** @file
* @brief String related functions
*
*  push and pop They add or delete from the right side of an array (the last position). So, if you want to add an element to the end of an array, you would use the push function:
*  shift and unshift If you want to simply add or delete an element from the left side of an array (element zero), you can use the unshift and shift functions. To add an element to the left side, you would use the unshift function and write something like this:
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/**
General purpose string library, as part of the Common Script Library.

Designed to allow multiple projects work together better in NWN2 and to make commonly used functions available which are rock solid.

Developed for personal use, but also I use it in supporting various community projects, and move all of their string related functions to this one spot.

Credits:
Seed and the Dungeon Eternal Previous admins, which this started from.
Lilac Soul
Jailiax - Spell casting framework
Nytir
Demetrious, Deva B. Winblood and others with the DMFI
Kaedrin
LadyDesire and the folks at the PRC
Numerous sample functions posts, as well as things taken from RealBasic, Javascript, PHP.

If you see anything here that is yours, please contact me so i can properly credit you.


Note these are functions included in Nwscript.nss for strings, basically here for reference since these are the primary functions i can leverage in this library

int GetStringLength(string sString); // on error ""
string GetStringUpperCase(string sString); // on error ""
string GetStringLowerCase(string sString); // on error ""
string GetStringRight(string sString, int nCount); // on error ""
string GetStringLeft(string sString, int nCount); // on error ""
string InsertString(string sDestination, string sString, int nPosition); // on error ""
string GetSubString(string sString, int nStart, int nCount); // on error ""
int FindSubString(string sString, string sSubString, int nStart = 0); // on error -1
string GetMatchedSubstring(int nString); // Dialogs
int GetMatchedSubstringsCount(); // Dialogs
string GetStringByStrRef(int nStrRef, int nGender=GENDER_MALE);
string RandomName();
int CharToASCII( string sString );
int StringCompare( string sString1, string sString2, int nCaseSensitive=FALSE );  //A simple C-Style string compare
int TestStringAgainstPattern(string sPattern, string sStringToTest); // on error FALSE
*/
/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////




// alphabet sort constants, used to use case statements with strings
const int CSL_LETTER_NA  = -1; // not a letter
const int CSL_LETTER_A  = 1;
const int CSL_LETTER_B  = 2;
const int CSL_LETTER_C  = 3;
const int CSL_LETTER_D  = 4;
const int CSL_LETTER_E  = 5;
const int CSL_LETTER_F  = 6;
const int CSL_LETTER_G  = 7;
const int CSL_LETTER_H  = 8;
const int CSL_LETTER_I  = 9;
const int CSL_LETTER_J  = 10;
const int CSL_LETTER_K  = 11;
const int CSL_LETTER_L  = 12;
const int CSL_LETTER_M  = 13;
const int CSL_LETTER_N  = 14;
const int CSL_LETTER_O  = 15;
const int CSL_LETTER_P  = 16;
const int CSL_LETTER_Q  = 17;
const int CSL_LETTER_R  = 18;
const int CSL_LETTER_S  = 19;
const int CSL_LETTER_T  = 20;
const int CSL_LETTER_U  = 21;
const int CSL_LETTER_V  = 22;
const int CSL_LETTER_W  = 23;
const int CSL_LETTER_X  = 24;
const int CSL_LETTER_Y  = 25;
const int CSL_LETTER_Z  = 26;


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

const string SC_CHAR_BREAK = "\n";

const int SC_ASCIITYPE_INVALID = -1;
const int SC_ASCIITYPE_CONTROL = 0;
const int SC_ASCIITYPE_TAB = 1;
const int SC_ASCIITYPE_RETURN = 2;
const int SC_ASCIITYPE_SPACE = 3;
const int SC_ASCIITYPE_PUNCTUATION = 4;
const int SC_ASCIITYPE_QUOTE = 5;
const int SC_ASCIITYPE_SEPARATOR = 6;
const int SC_ASCIITYPE_EXTENDED = 7;
const int SC_ASCIITYPE_NUMBER = 8;
const int SC_ASCIITYPE_LOWERCASE = 9;
const int SC_ASCIITYPE_UPPERCASE = 10;



/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// This is a core library that should not include anything


/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////
/*
//////////////// Capitalization /////////////////////
string CSLInitCap(string sIn);
string CSLStringToProper_ReturnSpaces( string sIn, string sPrevIn = " " );
string CSLStringToProper( string sIn );

//////////////// Language /////////////////////
string CSLAddS(string sIn, int iIn, string sS = "s");
string CSLAddAnd(string sIn);
string CSLSexString(object oPC, string sMale, string sFemale);

//////////////// Reordering Characters /////////////////////
string CSLStringShuffle ( string sIn );
string CSLStringReverse( string sIn );

//////////////// Padding and Trimming /////////////////////
string CSLTrim( string sIn, string sPadChar = " " );
string CSLTrimLeft( string sIn, string sPadChar = " " );
string CSLTrimRight( string sIn, string sPadChar = " " );
string CSLStringRepeat( string sIn, int iRepeatCount );
string CSLPadLeft( string sIn, int iLength, string sPadChar = " ");
string CSLPadRight( string sIn, int iLength, string sPadChar = " ");
string CSLPadBoth( string sIn, int iLength, string sPadChar = " ");

//////////////// Splicing and Splitting /////////////////////
string CSLStringSplit( string sIn, int iLength = 1, string sGlue = "," );
string CSLStringSplice(string sString, int nIndex, int nCount);

//////////////// Finding and Replacing /////////////////////
int CSLStringGetSubStringCount(string sFull, string sLookFor);
string CSLReplaceSubString(string sString, string sMatch, string sReplace);
string CSLReplaceAllSubStrings(string sString, string sMatch, string sReplace);
string CSLStringSwapChars(string sString, string sMatchChar, string sReplaceChar);


string CSLStringTranslateChars(string sString, string sMatchList, string sReplaceList);
int CSLStringStartsWith(string sIn, string sMatch, int bCaseSensitive = TRUE );
string CSLRemovePrefix(string sIn, string sPrefix);
string CSLGetIllegalCharacterFreeString(string sString, string sIllegalCharacters=" ");
string CSLGetLegalCharacterString(string sString, string sLegalCharacters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890");

//////////////// Lists /////////////////////
string CSLDelimList(string s1 = "", string s2 = "", string s3 = "", string s4 = "", string s5 = "", string s6 = "", string s7 = "", string s8 = "", string s9 = "", string s10 = "", string s11 = "", string s12 = "", string s13 = "", string s14 = "", string s15 = "");
//string CSLColorText(string sString, int nColor);
string CSLInQs(string sIn);

//////////////// ASCII /////////////////////
string CSLASCIIToChar( int iIn );


//////////////// Other /////////////////////
//string CSLWordWrap( string sIn, int iWidth, string sBreakChar = SC_CHAR_BREAK );
string CSLFormatFloat(float fVal, int iDec=2);
string CSLAppendLocalString(object oObj, string sVar, string sIn);


// Delimiter Type Functions
//string CSLStringBefore(string sIn, string sDelimiter=",");
//string CSLRemoveParsed(string sIn,string sParsed,string sDelimiter=".");
*/

int CSLGetCharASCIIType( string sIn );

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/************************************************************/
/** @name Capitalization functions
* Description
********************************************************* @{ */

/**  
* Makes the Initial letter uppercase and the rest lowercase
* @param sIn Input String
* @return 
*/
string CSLInitCap(string sIn)
{
	return GetStringUpperCase(GetStringLeft(sIn,1)) + GetStringLowerCase(GetStringRight(sIn, GetStringLength(sIn)-1));
}

/**  
* Helper function for CSLStringToProper, takes a single character, and if it's a space or punctuation it returns a space, otherwise it returns the character, used in strProper soas to ignore
* @param sIn Input String
* @param sPrevIn Previous Input string, allows to make smarter choices and handle irish type names
* @see CSLStringToProper
* @return space or character, with all punctionation returning as a space
*/
string CSLStringToProper_ReturnSpaces( string sIn, string sPrevIn = " " )
{
	if ( sIn == "" || sIn == " " )
	{
		return " "; 
	}
	
	int iType = CSLGetCharASCIIType(sIn);
	
	if ( iType >= SC_ASCIITYPE_EXTENDED ) // all letters, digits and things i don't know about
	{
		return sIn;
	}
	else if ( iType >= SC_ASCIITYPE_QUOTE ) // quotes and things like dashes, which can be in middle of a word ( like Don't and Super-charge ) but are spaces if not
	{
		if ( sPrevIn == " " )
		{
			return " ";
		}
		else
		{
			return "'";
		}
	}
	else // treat everything else like a space, since if it precedes a character, it will work
	{
		return " ";
	}
	return sIn;
}



/**  
* Makes a string propercase, with logic added to deal with Irish names and titles like DM, or PC
* @param sIn Input String
* @return 
*/
string CSLStringToProper( string sIn )
{
	string sOut;
	string sLower = GetStringLowerCase( sIn );
	
	// start them all out as spaces, these are so the function can look forward and back
	string sPrePrePreChar = " ";
	string sPrePreChar = " ";
	string sPreChar = " ";
	string sChar = " ";
	string sPostChar = " ";	
	
	sChar = CSLStringToProper_ReturnSpaces(GetStringLowerCase( GetSubString(sIn, 0, 1) ) );
	
	int iCount;
	int iLength = GetStringLength( sIn );
	for ( iCount = 0; iCount < iLength; iCount++)
	{
		sPostChar = CSLStringToProper_ReturnSpaces( GetStringLowerCase( GetSubString(sIn, iCount+1, 1) ), sChar );
		
		if ( sChar == " " )
		{
			sChar = " "; 
		}
		// it's uppper, previous space or a McNelly type of name
		else if ( sPreChar == " " || ( sPrePrePreChar == " " && sPrePreChar == "m" &&  sPreChar  =="c" ) )
		{
			sOut += GetStringUpperCase( GetSubString( sIn, iCount, 1) );
		} 
		// next look for DM and PC and other 2 letter abbreviations
		else if (
				sPrePreChar == " " &&  sPostChar == " "   && 
				( sPreChar == "d" && sChar == "m" ) || ( sPreChar == "p" && sChar == "c" )
				) 
		{
			sOut += GetStringUpperCase( GetSubString(sIn, iCount, 1) );
		}
		else
		{
			//Legal character, add to sOutPut
			sOut += GetSubString(sIn, iCount, 1);
		}
		
		// offset the previous characters, this is how we iterate the string
		sPrePrePreChar = sPrePreChar;
		sPrePreChar = sPreChar;
		sPreChar = sChar;
		sChar = sPostChar;
	}
	return sOut;
}

//@}

/************************************************************/
/** @name Language functions
* Description
********************************************************* @{ */

/**  
* Adds an s to an item name if it's needed, iln is the quanity of the given item
* @param sIn Name of Item
* @param iIn Quanity of item
* @param sS Plural string to add, usually "s" or "es"
* @return 
*/
string CSLAddS(string sIn, int iIn, string sS = "s")
{
	if (iIn==1) return sIn;
	return sIn + sS;
}


/**  
* Adds an and to the end of the string
* @param sIn Input String
* @return 
*/
string CSLAddAnd(string sIn)
{
   if (sIn!="") sIn += " and ";
   return sIn;
}


/**  
* Takes an object and two parameters, and returns one of them based on the sex of the object
* @param oPC Target Object
* @param sMale Male descriptive name
* @param sFemale Female descriptive name
* @return 
*/
string CSLSexString(object oPC, string sMale, string sFemale)
{
   return ( GetGender(oPC)==GENDER_FEMALE ) ? sFemale : sMale;
}

//@}

/************************************************************/
/** @name String_Reordering functions
* Description
********************************************************* @{ */

/**  
* Randomly sorts the letters in the string
* @param sIn Input String
* @return 
*/
string CSLStringShuffle ( string sIn )
{
	if (sIn == "")
	{
		return "";
	}
	
	string sOut = "";
	int iRand = 0;
	
	while ( GetStringLength( sIn ) )
	{
		iRand = Random( GetStringLength( sIn ) );
		sOut += GetSubString( sIn, iRand, 1);
		
		sIn =  GetStringLeft( sIn, iRand )+ GetStringRight( sIn, GetStringLength( sIn )-(iRand+1) );
	}
	
	return sOut;
}

/**  
* Reverses the letters in the string
* @param sIn Input String
* @return 
*/
string CSLStringReverse( string sIn )
{
    string sOut = "";
    int iCounter;

    for ( iCounter = GetStringLength( sIn ); iCounter >= 0; iCounter-- )
    {
       sOut += GetSubString(sIn, iCounter, 1);
    }

    return sOut;
}

//@}

/************************************************************/
/** @name Random String functions
* Description
********************************************************* @{ */

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLPickOne(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="")
{
	int i=(s1!="")+(s2!="")+(s3!="")+(s4!="")+(s5!="")+(s6!="")+(s7!="")+(s8!="")+(s9!=""); // count strings not null
	i=Random(i)+1;
	if (i==1) return s1;
	if (i==2) return s2;
	if (i==3) return s3;
	if (i==4) return s4;
	if (i==5) return s5;
	if (i==6) return s6;
	if (i==7) return s7;
	if (i==8) return s8;
	if (i==9) return s9;
	return "";
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLRandomLetter(string sAlpha="abcdefghijklmnopqrstuvwxyz")
{
	return GetSubString(sAlpha, Random(GetStringLength(sAlpha)), 1);
}

//@}


/************************************************************/
/** @name Padding_And_Trimming functions
* Description
********************************************************* @{ */

/**  
* Removes all sPadChar from the left and right of the string
* @param sIn Input String
* @param sPadChar Character to Remove, defaults to spaces
* @return 
*/
string CSLTrim( string sIn, string sPadChar = " " )
{
	// make sure sPadChar is good
	if ( sPadChar == "") { return sIn; }
	else if ( GetStringLength( sPadChar ) > 1 ) { sPadChar = GetStringLeft( sPadChar, 1 ); }

	int iLen = GetStringLength(sIn);
	while (iLen > 0)
	{
		if ( GetStringRight(sIn,1)==sPadChar )
		{
			sIn = GetStringLeft(sIn, iLen - 1);
		}
		else if ( GetStringLeft(sIn,1)==sPadChar )
		{
			sIn = GetStringRight(sIn, iLen - 1);
		}
		else
		{
			break;
		}
		iLen = iLen - 1;
	}
	return sIn;
}


/**  
* Removes all sPadChar from the left of the string
* @param sIn Input String
* @param sPadChar Character to Remove, defaults to spaces
* @return 
*/
string CSLTrimLeft( string sIn, string sPadChar = " " )
{
	// make sure sPadChar is good
	if ( sPadChar == "") { return sIn; }
	else if ( GetStringLength( sPadChar ) > 1 ) { sPadChar = GetStringLeft( sPadChar, 1 ); }

	while ( GetStringLeft( sIn, 1 ) == sPadChar)
	{
		sIn = GetStringRight( sIn, GetStringLength( sIn )-1 );
	}
	
	return sIn;
}

/**  
* Removes all sPadChar from the right of the string
* @param sIn Input String
* @param sPadChar Character to Remove, defaults to spaces
* @return 
*/
string CSLTrimRight( string sIn, string sPadChar = " " )
{
	// make sure sPadChar is good
	if ( sPadChar == "") { return sIn; }
	else if ( GetStringLength( sPadChar ) > 1 ) { sPadChar = GetStringLeft( sPadChar, 1 ); }

	while ( GetStringRight( sIn, 1 ) == sPadChar)
	{
		sIn = GetStringLeft( sIn, GetStringLength( sIn )-1 );
	}
	
	return sIn;
}

/**  
* Repeats a given string by the given amount, makes a "0" into "0000" for example
* @param sIn Input String
* @param iRepeatCount
* @return 
*/
string CSLStringRepeat( string sIn, int iRepeatCount )
{
	string sOut = "";
    int iCounter;

    for ( iCounter = 0; iCounter <= iRepeatCount; iCounter++ )
    {
       sOut += sIn;
    }
    return sOut;
}

/**  
* Ensures a string fits in a given number of characters, adding ... to the end if it needs to be trimmed
* @author Caos as part of dm inventory system, integrating
* @param sIn Input String
* @param iMaxLength = 17
* @param sTruncateSymbol = "..."
* @replaces GetTrimmedString
* @return 
*/
string CSLTruncate(string sIn, int iMaxLength = 17, string sTruncateSymbol = "..." ) 
{
	if (GetStringLength(sIn) > iMaxLength)
	{
		sIn = GetStringLeft(sIn, iMaxLength - 1) + sTruncateSymbol;
	}
	
	return sIn;
}

/**  
* Returns sIn such that GetStringLength(sIn)=iLength by appending sPadChar to the left
* @param sIn Input String
* @param iLength
* @param sPadChar = " "
* @return 
*/
string CSLPadLeft( string sIn, int iLength, string sPadChar = " ")
{
	if ( sPadChar == "")
	{
		return sIn;
	}
	else if ( GetStringLength( sPadChar ) > 1 )
	{
		sPadChar = GetStringLeft( sPadChar, 1 );
	}
	
	int iLenIn = GetStringLength( sIn );
	if ( iLenIn > iLength )
	{
		sIn = CSLTrimLeft( sIn, sPadChar );
	}
	
	// need to start of since it might of been padding that just got removed
	iLenIn = GetStringLength( sIn );
	
	if ( iLenIn < iLength )
	{
		int iPadLength = iLength - iLenIn;
		sIn = sIn + CSLStringRepeat( sPadChar, iPadLength );
		// sIn = GetStringRight( sIn, iLength );
	}
	return sIn;
}

/**  
* Returns sIn such that GetStringLength(sIn)=iLength by appending sPadChar to the Right
* @param sIn Input String
* @param iLength
* @param sPadChar = " "
* @return 
*/
string CSLPadRight( string sIn, int iLength, string sPadChar = " ")
{
	if ( sPadChar == "")
	{
		return sIn;
	}
	else if ( GetStringLength( sPadChar ) > 1 )
	{
		sPadChar = GetStringRight( sPadChar, 1 );
	}
	
	int iLenIn = GetStringLength( sIn );
	if ( iLenIn > iLength )
	{
		sIn = CSLTrimRight( sIn, sPadChar );
	}
	
	// need to start of since it might of been padding that just got removed
	iLenIn = GetStringLength( sIn );
	if ( iLenIn < iLength )
	{
		int iPadLength = iLength - iLenIn;
		sIn =  CSLStringRepeat( sPadChar, iPadLength ) + sIn;
		// sIn = GetStringLeft( sIn, iLength );
	}
	return sIn;
}

/**  
* Returns sIn such that GetStringLength(sIn)=iLength by appending sPadChar to both sides
* @param sIn Input String
* @param iLength
* @param sPadChar = " "
* @return 
*/
string CSLPadBoth( string sIn, int iLength, string sPadChar = " ")
{
	if ( sPadChar == "")
	{
		return sIn;
	}
	else if ( GetStringLength( sPadChar ) > 1 )
	{
		sPadChar = GetStringRight( sPadChar, 1 );
	}
	
	int iLenIn = GetStringLength( sIn );
	if ( iLenIn > iLength )
	{
		sIn = CSLTrimLeft( sIn, sPadChar );
	}
	
	// need to start of since it might of been padding that just got removed
	iLenIn = GetStringLength( sIn );
	if ( iLenIn < iLength )
	{
		int iPadLength = ( iLength - iLenIn );
		iPadLength = ( iPadLength % 2 ) ? (iPadLength/2) : ( (iPadLength/2) + 1 ) ; // that does the equivalent of a ceil function
		string sPadding = CSLStringRepeat( sPadChar, iPadLength );
		sIn =  sPadding + sIn + sPadding;
		sIn = GetStringLeft( sIn, iLength ); // catch any errors
	}
	return sIn;
}

//@}

/************************************************************/
/** @name Splicing_And_Splitting functions
* Description
********************************************************* @{ */

/**  
* CSLStringSplit("Hello, 1, "-") returns "H-e-l-l-o"
* @param sIn Input String
* @param iLength = 1
* @param sGlue = ","
* @return 
*/
string CSLStringSplit( string sIn, int iLength = 1, string sGlue = "," )
{
    if( iLength > 0)
    {
        string sOut = "";
        while( GetStringLength( sIn ) >= iLength )
        {
            if ( sOut != "" )
			{
				sOut += sGlue;
			}
			sOut += GetStringLeft( sIn, iLength );
			sIn = GetStringRight( sIn, GetStringLength( sIn )-iLength );
        }
        return sOut;
    }
    return sIn;
}


/**  
* Remove part of a string beginning at nIndex.  nIndex is a zero based index into the string.
* Example:
* SpliceString("Hello, 1, 3) returns "Ho"
* @author Based largely on OEI function
* @param sString
* @param nIndex
* @param nCount
* @return 
*/
string CSLStringSplice( string sString, int nIndex, int nCount )
{
	int nStringLeftLength = nIndex; // These are equal because we want to not include where we are pointing to on the left side.
	int nStringRightLength = GetStringLength(sString) - nCount - nStringLeftLength;
	sString = GetStringLeft(sString, nStringLeftLength) + GetStringRight(sString, nStringRightLength);
	return (sString);
}

//@}

/************************************************************/
/** @name Find_And_Replace functions
* Description
********************************************************* @{ */

/**  
* Using the new string array simulator, this function cycles through a
* full length string counting every time it reaches the searched string
* This is like FindSubString except it counts the total instead of returning
* the first.
* @author DragonWR12LB
* @param sFull The string that contains all the information.
* @param sLookFor The substring we're looking for, each instance of this is counted once.
* @return Count of substrings that match parameter
*/
int CSLStringGetSubStringCount( string sFull, string sLookFor )
{
	int iLength = GetStringLength(sFull);
	int i,iLocate,iTotal;
	while(i<iLength)
	{
		iLocate = FindSubString(sFull, sLookFor, i);
		//No more found.
		if(iLocate == -1)
		{
			i += iLength;
			//Match IS found.
		}
		else
		{
			//Save the count.
			iTotal++;
			//Tack that distance onto the loop so we don't check it again.
			i = (iLocate+1);
		}
	}
	//Created by: DragonWR12LB
	return iTotal;
}



/**  
* Replace first instance of sMatch in sString with sReplace
* @author Based largely on OEI function, but exactly the same as jailiax function ( spellcasting framework )
* @param sString
* @param sMatch
* @param sReplace
* @replaces JXStringReplace XXXReplaceChars
* @return 
*/
string CSLReplaceSubString(string sString, string sMatch, string sReplace)
{
	int nPosition = FindSubString(sString, sMatch);
	if (nPosition != -1)
	{
		int nStringLeftLength = nPosition+1;
		int nStringRightLength = GetStringLength(sString) - GetStringLength(sMatch) - nStringLeftLength;
		sString = GetStringLeft(sString, nStringLeftLength) + sReplace + GetStringRight(sString, nStringRightLength);
	}
	return (sString);
}



/**  
* Replace all instances of sMatch in sString with sReplace (from left to right)
* @author OEI Based function
* @param sString
* @param sMatch
* @param sReplace
* @return 
*/
string CSLReplaceAllSubStrings(string sString, string sMatch, string sReplace)
{
	//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLReplaceAllSubStrings sString="+sString+" sMatch="+sMatch+" sReplace="+sReplace+"</color>");
	
	
	string sSearchString = sString;
	string sWorkingString = "";
	int nMatchLength = GetStringLength(sMatch);
	int nStringLeftLength;
	int nStringRightLength;
	
	int iPosition = FindSubString(sSearchString, sMatch);
	while (iPosition != -1)
	{
		nStringLeftLength = iPosition; // + nMatchLength; // number of chars up to replacement
		nStringRightLength = GetStringLength(sSearchString) - (nStringLeftLength+nMatchLength);
		
		//sWorkingString = GetStringLeft(sSearchString, nStringLeftLength);
		
		sWorkingString += GetStringLeft(sSearchString, iPosition) + sReplace;
		
		sSearchString = GetStringRight(sSearchString, nStringRightLength);
		
		
		
		//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLReplaceAllSubStrings sWorkingString="+sWorkingString+" sSearchString="+sSearchString+" iPosition="+IntToString(iPosition)+" nStringLeftLength="+IntToString(nStringLeftLength)+" nStringRightLength="+IntToString(nStringRightLength)+" </color>");
		
		iPosition = FindSubString(sSearchString, sMatch);
	}
	// all matches replaced, now tack on remaining right part of string.
	
	//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLReplaceAllSubStrings sWorkingString="+sWorkingString+" sSearchString="+sSearchString+"</color>");
	
	sWorkingString += sSearchString;
	
	return sWorkingString;
}


//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLStringGetFirstWord sLetter="+sLetter+" iStart="+IntToString(iStart)+"</color>");
	

			//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLStringGetFirstWord Leter Ending sLetter="+sLetter+" iStart="+IntToString(iStart)+" sFoundText="+sFoundText+"</color>");	

		//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLStringGetFirstWord sLetter="+sLetter+" iStart="+IntToString(iStart)+" sFoundText="+sFoundText+"</color>");
	
	

/**  
* Removes all <tags>, as denoted by a matched pair of < and >
* @author Pain
* @param sString
* @param sMatch
* @param sReplace
* @return 
*/
string CSLRemoveAllTags(string sString, string sReplace = "", string sBeginTag = "<", string sEndTag = ">" )
{
	//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLRemoveAllTags sString="+sString+" sReplace="+sReplace+"</color>");
	
	
	string sSearchString = sString;
	string sWorkingString = "";
	int iBeginLength = GetStringLength(sBeginTag);
	int iEndLength = GetStringLength(sEndTag);
	
	int nStringLeftLength;
	int nStringRightLength;
	
	int iFirstPosition = FindSubString(sSearchString, sBeginTag);
	int iNextPosition;
	while (iFirstPosition != -1)
	{
		nStringLeftLength = iFirstPosition;  // + iBeginLength; // number of chars up to replacement
		
		iNextPosition = FindSubString(sSearchString, sEndTag, iFirstPosition);
		
		if ( iNextPosition != -1 )
		{
			nStringRightLength = GetStringLength( sSearchString ) - (iNextPosition+iEndLength );
		}
		else
		{
			nStringRightLength = GetStringLength(sSearchString) - nStringLeftLength;
		}
		//sWorkingString = GetStringLeft(sSearchString, nStringLeftLength);
		
		
		sWorkingString += GetStringLeft(sSearchString, iFirstPosition) + sReplace;
		
		sSearchString = GetStringRight(sSearchString, nStringRightLength);
		
		//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLRemoveAllTags sWorkingString="+sWorkingString+" sSearchString="+sSearchString+" iFirstPosition="+IntToString(iFirstPosition)+" iNextPosition="+IntToString(iNextPosition)+" nStringLeftLength="+IntToString(nStringLeftLength)+" nStringRightLength="+IntToString(nStringRightLength)+" </color>");
		
		iFirstPosition = FindSubString(sSearchString, sBeginTag);
		
		
		
		
		/*
		iNextPosition = FindSubString(sSearchString, sEndTag, iFirstPosition);
		if ( iNextPosition != -1 )
		{
			sWorkingString += GetStringLeft(sSearchString, iFirstPosition );
			sSearchString = GetStringRight(sSearchString, GetStringLength( sSearchString ) - (iNextPosition+iEndLength ) );
	
		}
		else
		{
			sWorkingString += GetStringLeft(sSearchString, iFirstPosition);
			sSearchString = GetStringRight(sSearchString, GetStringLength(sSearchString) - iFirstPosition );
		}
		iFirstPosition = FindSubString(sSearchString, sBeginTag);
		*/
	}
	//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLReplaceAllSubStrings sWorkingString="+sWorkingString+" sSearchString="+sSearchString+"</color>");
	
	sWorkingString += sSearchString;
	return sWorkingString;
	/*
	string sSearchString = sString;
	string sWorkingString = "";
	int nMatchLength = GetStringLength(sMatch);
	int nStringLeftLength;
	int nStringRightLength;
	
	int iPosition = FindSubString(sSearchString, sMatch);
	while (iPosition != -1)
	{
		nStringLeftLength = iPosition + nMatchLength; // number of chars up to replacement
		nStringRightLength = GetStringLength(sSearchString) - nStringLeftLength;
		
		sWorkingString = GetStringLeft(sSearchString, nStringLeftLength);
		sSearchString = GetStringRight(sSearchString, nStringRightLength);
		
		sWorkingString += GetStringLeft(sWorkingString, iPosition + 1) + sReplace;
		iPosition = FindSubString(sSearchString, sMatch);
	}
	// all matches replaced, now tack on remaining right part of string.
	sWorkingString += sSearchString;
	
	return (sWorkingString);
	*/
}


/**  
* Replace a token by the specified value in a source string, and returns the result.
* If the source string contains many occurences of the token, all occurences are replaced.
* @author jailiax function ( supports spellcasting framework )
* @param sSource String that contains the substrings to replace
* @param iCustomTokenNumber Token number (from 0 to 9999)
* @param sTokenValue Value for the token
* @param sTokenName Name of the token
* @replaces JXStringReplaceToken
* @return 
*/
string CSLStringReplaceToken(string sSource, int iCustomTokenNumber, string sTokenValue, string sTokenName = "CUSTOM")
{
	string sToken = "<" + sTokenName + IntToString(iCustomTokenNumber) + ">";

	return CSLReplaceSubString(sSource, sToken, sTokenValue);
}





/**  
* Changes all instances of sMatch character with sReplace, note that this is for single characters only
* @param sString
* @param sMatchChar
* @param sReplaceChar
* @return 
*/
string CSLStringSwapChars(string sString, string sMatchChar, string sReplaceChar)
{
	int n=0;
	string sLetter, sFinal;
	
	sLetter = GetSubString(sString, n, 1);
	while ( sLetter!="" )
	{
		if (sLetter==sMatchChar)	
		{
			sFinal = sFinal + sReplaceChar;
		}
		else
		{
			sFinal = sFinal + sLetter;
		}
		n++;
		sLetter = GetSubString(sString, n, 1);
	}
	return sFinal;
}




/**  
* This swaps out the given character with another character
* But the given character and the replaced character actually can be multiple
* ie  CSLStringTranslateChars( "Hello World", "eol", "301" ) will return "H3110 W0rld", note that it is not case sensitive
* this is probably something better used on small strings
* @author Not really sure where this came from at this point
* @param sString
* @param sMatchList
* @param sReplaceList
* @return 
*/
string CSLStringTranslateChars(string sString, string sMatchList, string sReplaceList)
{
	int n=0;
	string sLetter, sFinal;
	
	sLetter = GetSubString(sString, n, 1);
	while ( sLetter!="" )
	{
		int iPosition = FindSubString(sMatchList, sLetter);
		if ( iPosition > -1 )	
		{
			sFinal = sFinal + GetSubString( sReplaceList, iPosition, 1 );
		}
		else
		{
			sFinal = sFinal + sLetter;
		}
		n++;
		sLetter = GetSubString(sString, n, 1);
	}
	return sFinal;
}




/**  
* Tests if the string begins with the same string as sMatch, can be case insensitive
* @param sIn Input String
* @param sMatch
* @param bCaseSensitive = TRUE
* @return 
*/
int CSLStringStartsWith(string sIn, string sMatch, int bCaseSensitive = TRUE )
{
	if ( ! bCaseSensitive ) // this means its not case sensitive
	{
		return (GetStringLowerCase(GetStringLeft(sIn, GetStringLength(sMatch)))==GetStringLowerCase(sMatch));
	}	
	return (GetStringLeft(sIn, GetStringLength(sMatch))==sMatch);
}

/**  
* Returns letter sort CSL_LETTER_* constant which allows using letters in case statements
* @param sIn Input String
* @return CSL_LETTER_* constant
*/
int CSLAlphabeticalSortConstant( string sSin )
{
	if ( sSin == "" )
	{
		return CSL_LETTER_NA;
	}
	
	return FindSubString("Aabcdefghijklmnopqrstuvwxyz", GetStringLowerCase(GetStringLeft(sSin, 1)) );
}

/**  
* Gets the first found word in the input string, able to account for differing word boundaries such as dashes and quotes in addition to spaces
* @param sIn Input String
* @param iStart Starting point in string to start searching
* @param sLegalCharacters Allowed legal characters that comprise a word, defaults to letters and numbers
* @return 
*/
string CSLStringGetFirstWord(string sIn, int iStart = 0, string sLegalCharacters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" )
{
	string sFoundText = "";
	
	string sLetter = GetSubString(sIn, iStart, 1);
	//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLStringGetFirstWord sLetter="+sLetter+" iStart="+IntToString(iStart)+"</color>");
	
	while ( sLetter!="" )
	{
		if (FindSubString(sLegalCharacters, sLetter) == -1 )
		{
			//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLStringGetFirstWord Leter Ending sLetter="+sLetter+" iStart="+IntToString(iStart)+" sFoundText="+sFoundText+"</color>");	
			return sFoundText;
		}
		sFoundText += sLetter;
		iStart++;
		sLetter = GetSubString(sIn, iStart, 1);
		//SendMessageToPC(GetFirstPC(),"<color=SlateGray>Debug: CSLStringGetFirstWord sLetter="+sLetter+" iStart="+IntToString(iStart)+" sFoundText="+sFoundText+"</color>");
	}
	return sFoundText;
}

/**  
* Removes the provided string from the beginning of a string
* @author Demetrious and supporting the DMFI
* @param sIn Input String
* @param sPrefix
* @return 
*/
string CSLRemovePrefix(string sIn, string sPrefix)
{ 
  string sReturn;
  int nLength = GetStringLength(sIn);
  int nPrefixLength = GetStringLength(sPrefix);
  sReturn = GetStringRight(sIn, nLength - nPrefixLength);

  return sReturn;
}

/**  
* Adjusts a given string to be free of illegal characters ( as defined by sIllegalCharacters )
* @author Lilac Soul
* @param sString Input String
* @param sIllegalCharacters=" "
* @return 
*/
string CSLGetIllegalCharacterFreeString(string sString, string sIllegalCharacters=" ")
{
	string sOutPut, sChar;
	int nCount;
	for (nCount=0; nCount < GetStringLength(sString); nCount++)
	{
		//Is this a legal character?
		sChar=GetSubString(sString, nCount, 1);
		if ( !TestStringAgainstPattern("**"+sChar+"**", sIllegalCharacters) )
		//Legal character, add to sOutPut
		sOutPut=sOutPut+sChar;
	}
	return sOutPut;
}


/**  
* Returns string where all contents match those provided in parameter, letters and numbers by default
* @author Lilac Soul
* @param sString Input String
* @param sLegalCharacters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
* @return 
*/
string CSLGetLegalCharacterString(string sString, string sLegalCharacters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
{
	string sOutPut, sChar;
	int nCount;
	for (nCount=0; nCount<GetStringLength(sString); nCount++)
	{
		//Is this a legal character?
		sChar=GetSubString(sString, nCount, 1);
		if (TestStringAgainstPattern("**"+sChar+"**", sLegalCharacters))
		{
			//Legal character, add to sOutPut
			sOutPut=sOutPut+sChar;
		}
	}
	return sOutPut;
}

/**  
* Tests if given string has urls, websites or emails that could indicate it's potential spam
* @param sText
* @return 
*/
int CSLGetIsSpam(string sText)
{
   if(TestStringAgainstPattern("**http:**|**www.**|**.*a.**|*n.*n.*n.*n", sText)) return TRUE;
   return FALSE;
}

//@}

/************************************************************/
/** @name List functions
* Description
********************************************************* @{ */
//////////////// Lists /////////////////////



string CSL_QUOTE = "";

/**  
* Returns a Quote Character. Note must have quote defined in the module or on custom waypoint blueprint to properly do quotes.
* @author Brian Meyer
* @return A Double Quote Character
*/
string CSLGetQuote()
{
	//string sQuote = CSL_QUOTE;
	if ( CSL_QUOTE == "" )
	{
		string sQuote;
		sQuote = GetLocalString( GetModule(), "CSL_QUOTE" );
		if ( sQuote == "" )
		{
			object oQuoteHolder = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypointquote", GetStartingLocation(), FALSE, "nw_waypointquote"); 
			sQuote = GetLocalString( oQuoteHolder, "QUOTE" );
			DestroyObject(oQuoteHolder, 0.0f, FALSE);

			SetLocalString(GetModule(), "CSL_QUOTE", sQuote );
		}	
		CSL_QUOTE = sQuote; // cache this for later use in the same script
		return sQuote;
	}
	return CSL_QUOTE;
}

//@}

/************************************************************/
/** @name ASCII functions
* Description
********************************************************* @{ */
//////////////// ASCII /////////////////////

/**  
* Returns Ascii character for a given decimal number, and a space on error. Note must have quote defined in the module or on custom blueprint to properly do quotes.
* @author Brian Meyer
* @param iIn Decimal Number
* @return Ascii Character
*/
string CSLASCIIToChar( int iIn )
{
	int iSubIn = iIn / 10;
	
	switch ( iSubIn )
	{
		case 3:
		switch ( iIn )
		{
			case 33: return "!"; break;
			case 34: return CSLGetQuote(); break; // this is a ", not sure how to do it yet "/"" won't compile, might have to pull it from a tlk value
			case 35: return "#"; break;
			case 36: return "$"; break;
			case 37: return "%"; break;
			case 38: return "&"; break;
			case 39: return "'"; break;
		}
		break;
		
		case 4:
		switch ( iIn )
		{
			case 40: return "("; break;
			case 41: return ")"; break;
			case 42: return "*"; break;
			case 43: return "+"; break;
			case 44: return ","; break;
			case 45: return "-"; break;
			case 46: return "."; break;
			case 47: return "/"; break;
			case 48: return "0"; break;
			case 49: return "1"; break;
		}
		break;
		
		case 5:
		switch ( iIn )
		{
			case 50: return "2"; break;
			case 51: return "3"; break;
			case 52: return "4"; break;
			case 53: return "5"; break;
			case 54: return "6"; break;
			case 55: return "7"; break;
			case 56: return "8"; break;
			case 57: return "9"; break;
			case 58: return ":"; break;
			case 59: return ";"; break;
			case 60: return "<"; break;
		}
		break;
		
		case 6:
		switch ( iIn )
		{
			case 61: return "="; break;
			case 62: return ">"; break;
			case 63: return "?"; break;
			case 64: return "@"; break;
			case 65: return "A"; break;
			case 66: return "B"; break;
			case 67: return "C"; break;
			case 68: return "D"; break;
			case 69: return "E"; break;
			case 70: return "F"; break;
		}
		break;
		
		case 7:
		switch ( iIn )
		{
			case 71: return "G"; break;
			case 72: return "H"; break;
			case 73: return "I"; break;
			case 74: return "J"; break;
			case 75: return "K"; break;
			case 76: return "L"; break;
			case 77: return "M"; break;
			case 78: return "N"; break;
			case 79: return "O"; break;
			case 80: return "P"; break;
		}
		break;
		
		case 8:
		switch ( iIn )
		{
			case 81: return "Q"; break;
			case 82: return "R"; break;
			case 83: return "S"; break;
			case 84: return "T"; break;
			case 85: return "U"; break;
			case 86: return "V"; break;
			case 87: return "W"; break;
			case 88: return "X"; break;
			case 89: return "Y"; break;
			case 90: return "Z"; break;
		}
		break;
		
		case 9:
		switch ( iIn )
		{
			case 91: return "["; break;
			case 92: return "\\"; break; // not sure if this will work, but hopefully it will, this is an escape character
			case 93: return "]"; break;
			case 94: return "^"; break;
			case 95: return "_"; break;
			case 96: return "`"; break;
			case 97: return "a"; break;
			case 98: return "b"; break;
			case 99: return "c"; break;
			case 100: return "d"; break;
		}
		break;
		
		case 10:
		switch ( iIn )
		{
			case 101: return "e"; break;
			case 102: return "f"; break;
			case 103: return "g"; break;
			case 104: return "h"; break;
			case 105: return "i"; break;
			case 106: return "j"; break;
			case 107: return "k"; break;
			case 108: return "l"; break;
			case 109: return "m"; break;
			case 110: return "n"; break;
		}
		break;
		
		case 11:
		switch ( iIn )
		{
			case 111: return "o"; break;
			case 112: return "p"; break;
			case 113: return "q"; break;
			case 114: return "r"; break;
			case 115: return "s"; break;
			case 116: return "t"; break;
			case 117: return "u"; break;
			case 118: return "v"; break;
			case 119: return "w"; break;
			case 120: return "x"; break;
		}
		break;
		
		case 12:
		switch ( iIn )
		{
			case 121: return "y"; break;
			case 122: return "z"; break;
			case 123: return "{"; break;
			case 124: return "|"; break;
			case 125: return "}"; break;
			case 126: return "~"; break;
		}
	}
	return " ";
}




/**  
* Returns what category a character is, note that I made more categories soas to support the "strproper" function
* @author Brian Meyer
* @param sIn Single Character to test
* @return SC_ASCIITYPE_* constants, showing what type a character is being viewed
*/
int CSLGetCharASCIIType( string sIn )
{
	int iDecValue = CharToASCII(sIn);
	if ( iDecValue == 9 ) // "\t" if that even exists in game
	{
		return SC_ASCIITYPE_TAB;
	}
	else if ( iDecValue == 10 || iDecValue == 13 ) // for "\n"
	{
		return SC_ASCIITYPE_RETURN;
	}
	else if ( iDecValue == 32 ) // " "
	{
		return SC_ASCIITYPE_SPACE;
	}
	else if ( iDecValue > 127 && iDecValue < 256 ) // all that foreign stuff, need to make this more accurate to deal with tilde's and the like, this is based on font/encoding
	{
		return SC_ASCIITYPE_EXTENDED;
	}
	else if ( iDecValue >= 65 && iDecValue <= 90 ) // a-z
	{
		return SC_ASCIITYPE_LOWERCASE;
	}
	else if ( iDecValue >= 97 && iDecValue <= 122 ) // A-Z
	{
		return SC_ASCIITYPE_UPPERCASE;
	}
	else if ( iDecValue >= 48 && iDecValue <= 57 ) // 0-9
	{
		return SC_ASCIITYPE_NUMBER;
	}
	else if ( iDecValue == 127 || ( iDecValue >= 0 && iDecValue <= 31 ) ) // all those odd characters
	{
		return SC_ASCIITYPE_CONTROL;
	}
	else if ( iDecValue == 34 || iDecValue == 39 ) // handles " and '
	{
		return SC_ASCIITYPE_QUOTE;
	}
	else if ( iDecValue == 45 || iDecValue == 33 || iDecValue == 63 ) // handles - ! ? which might be treated like a letter
	{
		return SC_ASCIITYPE_SEPARATOR;
	}
	else if ( iDecValue >= 35 && iDecValue <= 64 ) // # $ % & ' ( ) * + ' - . /  : ; < = > ? Note that some are repeats but they are already handled like a-z
	{
		return SC_ASCIITYPE_PUNCTUATION;
	}
	else if ( iDecValue >= 91 && iDecValue <= 96 ) // [ \ ] ^ _ `
	{
		return SC_ASCIITYPE_PUNCTUATION;
	}
	else if ( iDecValue >= 123 && iDecValue <= 126 ) // { | } ~
	{
		return SC_ASCIITYPE_PUNCTUATION;
	}
	return SC_ASCIITYPE_INVALID;
}

//@}

/************************************************************/
/** @name Miscellaneous functions
* Description
********************************************************* @{ */
/**  
* Convert float to string and remove the white spaces that normally occur in FloatToString
* @author Nytir
* @param fVal Raw float Number
* @param iDec Decimal places desired
* @return 
*/
string CSLFormatFloat(float fVal, int iDec=2)
{
	string sInt = IntToString(FloatToInt(fVal));
	string sFlt = FloatToString(fVal,18,iDec);
	int    iLen = GetStringLength(sInt) + 1 + iDec;
	return GetStringRight(sFlt, iLen);
}


/**  
* Appends a string to a string already stored on an object
* @author Nytir
* @param oObj
* @param sVar
* @param sIn Input String
* @return the new string combining the original with the appeneded text
*/
string CSLAppendLocalString(object oObj, string sVar, string sIn)
{
	SetLocalString(oObj, sVar, GetLocalString(oObj, sVar) + sIn);
	return GetLocalString(oObj, sVar);
}

/**  
* Appends a string to an existing global string
* @author 
* @param sVar
* @param sIn Input String
* @return the new string combining the original with the appeneded text
*/
string CSLAppendGlobalString( string sVar, string sIn, int bUnique=FALSE ) // , string sDelimiter=","
{
	string sList = GetGlobalString(sVar);
	if ( bUnique == FALSE || FindSubString( sList, sIn ) == -1 )
	{
		sList += sIn;
		SetGlobalString(sVar, sList);
	}
	return sList;
}



//@}

/************************************************************/
/** @name Markup functions
* Description
********************************************************* @{ */

/**  
* Puts Color markup around a string, for use in dialogs and messages to players
* 
* Note: a few colors I went to "light" versions.  This was based on my 
* preference.  A complete list of supported colors are in  nwn2_color.2da	
*
* @author Demetrious with modifications by Brian Meyer from DMFI
* @param sString The string to set to a given color
* @param nColor uses COLOR_* fog color constants in nwscript.nss
* @param nColor uses COLOR_* fog color constants in nwscript.nss
* @return 
*/
string CSLColorText( string sString, int nColor, string sColor = "" )
{
	if ( sColor == "" )
	{
		if (nColor==COLOR_BLACK) { sColor = "black"; }
		else if (nColor==COLOR_BLUE) { sColor = "cornflowerblue"; }
		else if (nColor==COLOR_BLUE_DARK) { sColor = "steelblue"; }
		else if (nColor==COLOR_BROWN) { sColor = "burlywood"; }
		else if (nColor==COLOR_BROWN_DARK) { sColor = "saddlebrown"; }
		else if (nColor==COLOR_CYAN) { sColor = "cyan"; }
		else if (nColor==COLOR_GREEN) { sColor = "lightgreen"; }
		else if (nColor==COLOR_GREEN_DARK) { sColor = "darkgreen"; }
		else if (nColor==COLOR_GREY) { sColor = "lightgrey"; }
		else if (nColor==COLOR_MAGENTA) { sColor = "magenta"; }
		else if (nColor==COLOR_ORANGE) { sColor = "orange"; }
		else if (nColor==COLOR_ORANGE_DARK) { sColor = "darkorange"; }
		else if (nColor==COLOR_RED) { sColor = "red"; }
		else if (nColor==COLOR_RED_DARK) { sColor = "darkred"; }
		else if (nColor==COLOR_WHITE) { sColor = "white"; }
		else if (nColor==COLOR_YELLOW) { sColor = "yellow"; }
		else if (nColor==COLOR_YELLOW_DARK) { sColor = "gold"; }
		else 
		{
			return sString;
		}
	}
	/*
	int  COLOR_BLACK            = 0; 
	int  COLOR_BLUE_DARK        = 102;
	int  COLOR_BLUE             = 255;
	int  COLOR_GREEN_DARK       = 23112;
	int  COLOR_GREEN            = 65280;
	int  COLOR_CYAN             = 65535;
	int  COLOR_BROWN_DARK       = 6697728;
	int  COLOR_RED_DARK         = 6684672;
	int  COLOR_BROWN            = 10053120;
	int  COLOR_GREY             = 10066329;
	int  COLOR_YELLOW_DARK      = 11184640;
	int  COLOR_ORANGE_DARK      = 13395456;
	int  COLOR_ORANGE           = 16750848;
	int  COLOR_RED              = 16711680;
	int  COLOR_MAGENTA          = 16711935;
	int  COLOR_YELLOW           = 16776960;
	int  COLOR_WHITE            = 16777215;
	*/


  return  "<color="+sColor+">"+sString+"</color>";
}


/**  
* Puts bold markup around a string, for use in dialogs and messages to players
* @author from DMFI
* @param sString
* @return 
*/
string CSLBoldText( string sString )
{
	return "<b>"+sString+"</b>"; 
}


/**  
* Puts Italic markup around a string, for use in dialogs and messages to players
* @author from DMFI
* @param sString
* @return 
*/
string CSLItalicText( string sString )
{
	return "<i>"+sString+"</i>"; 
}



//@}

/************************************************************/
/** @name Delimiter functions
* Description
********************************************************* @{ */
/////////////// Delimiter functions
/////////////// Functions which work with delimiters

/**  
* Adds commas between multiple items, good for use in creating SQL statments
* @param s1 First Element
* @param s2 Second Element
* @param s3 Third Element
* @param s4 Fourth Element
* @param s5 Fifth Element
* @param s6 Sixth Element
* @param s7 Seventh Element
* @param s8 Eighth Element
* @param s9 Ninth Element
* @param s10 Tenth Element
* @param s11 Eleventh Element
* @param s12 Twelph Element
* @param s13 Thirteenth Element
* @param s14 Fourteenth Element
* @param s15 Fifteenth Element
* @see CSLDelimit
* @replaces MakeList
* @return String Separated by Commas
*/
string CSLDelimList(string s1 = "", string s2 = "", string s3 = "", string s4 = "", string s5 = "", string s6 = "", string s7 = "", string s8 = "", string s9 = "", string s10 = "", string s11 = "", string s12 = "", string s13 = "", string s14 = "", string s15 = "")
{
   string sDelimiter = ",";
   if (s2 == "") { return s1; } else { s1 += sDelimiter + s2; }
   if (s3 == "") { return s1; } else { s1 += sDelimiter + s3; }
   if (s4 == "") { return s1; } else { s1 += sDelimiter + s4; }
   if (s5 == "") { return s1; } else { s1 += sDelimiter + s5; }
   if (s6 == "") { return s1; } else { s1 += sDelimiter + s6; }
   if (s7 == "") { return s1; } else { s1 += sDelimiter + s7; }
   if (s8 == "") { return s1; } else { s1 += sDelimiter + s8; }
   if (s9 == "") { return s1; } else { s1 += sDelimiter + s9; }
   if (s10 == "") { return s1; } else { s1 += sDelimiter + s10; }
   if (s11 == "") { return s1; } else { s1 += sDelimiter + s11; }
   if (s12 == "") { return s1; } else { s1 += sDelimiter + s12; }
   if (s13 == "") { return s1; } else { s1 += sDelimiter + s13; }
   if (s14 == "") { return s1; } else { s1 += sDelimiter + s14; }
   if (s15 == "") { return s1; } else { s1 += sDelimiter + s15; }
   return s1;
}

/**  
* Adds delimters between multiple items, good for use in creating SQL statments
* @param sDelimiter Delimter to separate the provided elements with
* @param s1 First Element
* @param s2 Second Element
* @param s3 Third Element
* @param s4 Fourth Element
* @param s5 Fifth Element
* @param s6 Sixth Element
* @param s7 Seventh Element
* @param s8 Eighth Element
* @param s9 Ninth Element
* @param s10 Tenth Element
* @param s11 Eleventh Element
* @param s12 Twelph Element
* @param s13 Thirteenth Element
* @param s14 Fourteenth Element
* @param s15 Fifteenth Element
* @see CSLDelimList
* @return String Separated by sDelimiter
*/
string CSLDelimit(string sDelimiter=",", string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="", string s10="", string s11="", string s12="", string s13="", string s14="", string s15="")
{
   if (s2=="") { return s1; } else { s1 += sDelimiter + s2; }
   if (s3=="") { return s1; } else { s1 += sDelimiter + s3; }
   if (s4=="") { return s1; } else { s1 += sDelimiter + s4; }
   if (s5=="") { return s1; } else { s1 += sDelimiter + s5; }
   if (s6=="") { return s1; } else { s1 += sDelimiter + s6; }
   if (s7=="") { return s1; } else { s1 += sDelimiter + s7; }
   if (s8=="") { return s1; } else { s1 += sDelimiter + s8; }
   if (s9=="") { return s1; } else { s1 += sDelimiter + s9; }
   if (s10=="") { return s1; } else { s1 += sDelimiter + s10; }
   if (s11=="") { return s1; } else { s1 += sDelimiter + s11; }
   if (s12=="") { return s1; } else { s1 += sDelimiter + s12; }
   if (s13=="") { return s1; } else { s1 += sDelimiter + s13; }
   if (s14=="") { return s1; } else { s1 += sDelimiter + s14; }
   if (s15=="") { return s1; } else { s1 += sDelimiter + s15; }
   return s1;
}

/**  
* To find portion of string that occurs before first occurance of sDelimiter, if not found returns entire string
* @author Original Scripter: Deva B. Winblood and taken from the DMFI to provide support for that library
* @param sIn Input String
* @param sDelimiter="."
* @replaces CSLParse
* @return The portion of the string before the Delimiter
*/
string CSLStringBefore(string sIn, string sDelimiter=",")
{
	int iPosition = FindSubString( sIn, sDelimiter );
	if ( iPosition == -1 ) // Delimiter not found so the entire string is returned
	{ 
		return sIn;
	}
	else if ( iPosition == 0 ) // The delimter is in the first position which makes it return nothing
	{ 
		return "";
	}
	return GetStringLeft( sIn, iPosition );
}

/**  
* To find portion of string that occurs before last occurance of sDelimiter, if not found returns entire string
* @author Original Scripter: Deva B. Winblood and taken from the DMFI to provide support for that library
* @param sIn Input String
* @param sDelimiter="."
* @replaces CSLParse
* @todo need to do unit testing on this
* @return The portion of the string before the Delimiter
*/
string CSLStringBeforeLast(string sIn, string sDelimiter=",")
{
	int iPosition = FindSubString( sIn, sDelimiter );
	int iLastPosition = iPosition;
	if ( iPosition == -1 ) // Delimiter not found so the entire string is returned
	{ 
		return sIn;
	}
	
	while( iPosition > -1 )
	{	
		iLastPosition = iPosition;
		iPosition = FindSubString( sIn, sDelimiter, iPosition+1 );
	}
	
	return GetStringLeft( sIn, iPosition );
}

/**  
* Gets portion of string after first occurance of delimiter, returns "" if delimiter not present
* @author Original Scripter: Deva B. Winblood and taken from the DMFI to provide support for that library
* @param sIn Input String
* @param sDelimiter="."
* @return The portion of the string after the Delimiter
*/
string CSLStringAfter(string sIn, string sDelimiter=",")
{
	int iPosition = FindSubString( sIn, sDelimiter );
	if ( iPosition == -1 ) // Delimiter not found so nothing is returned
	{ 
		return "";
	}
	//else if ( iPosition == 0 ) // The delimter is in the first position which makes it return nothing
	//{ 
	//	//return "";
	//	return sIn;
	//}
	return GetStringRight( sIn, GetStringLength(sIn)-(iPosition+1) );
}


/**  
* Gets portion of string after Last occurance of delimiter, returns "" if delimiter not present
* @author Pain
* @param sIn Input String
* @param sDelimiter="."
* @todo need to do unit testing on this
* @return The portion of the string after the Delimiter
*/
string CSLStringAfterLast(string sIn, string sDelimiter=",")
{
	int iPosition = FindSubString( sIn, sDelimiter );
	int iLastPosition = iPosition;
	if ( iPosition == -1 ) // Delimiter not found so nothing is returned
	{ 
		return "";
	}
	
	while( iPosition > -1 )
	{	
		iLastPosition = iPosition;
		iPosition = FindSubString( sIn, sDelimiter, iPosition+1 );
	}
		
	return GetStringRight( sIn, GetStringLength(sIn)-(iLastPosition+1) );
}



/**  
* To remove the parsed portion of the string, this takes the length of the parsed string and uses it to remove that much from the original string
* @author Original Scripter: Deva B. Winblood and taken from the DMFI to provide support for that library
* @param sIn Input String
* @param sParsed
* @param sDelimiter
* @return Corrected String
*/
string CSLRemoveParsed( string sIn, string sParsed, string sDelimiter=",")
{ 
	string sRet="";
	if (GetStringLength(sParsed)<=GetStringLength(sIn))
	{ // okay lengths
		sRet=GetStringRight(sIn,GetStringLength(sIn)-GetStringLength(sParsed));
		while(GetStringLeft(sRet,1)==sDelimiter&&GetStringLength(sDelimiter)>0)
		{ // strip prefix delimiter
			sRet=GetStringRight(sRet,GetStringLength(sRet)-1);
		} // strip prefix delimiter
	} // okay lengths
	return sRet;
}

/**  
* To retrieve serialized data stored with a #X# followed by a # or for a tag named SPL with a value of 35, the input would be #SPL#35#
*  This assumes the tagname is the X and the delimiter is the # which always surrounds the tagname and follows the value as well
* If the input is a @XXX@, it then assumes @ follows the value as well ( @SPL@35@ ) which allows nesting hashed values inside of other serialized values
*
*   This format is used by CSLSerializeLocation and provides a tagged based method of storing data which can handle some values being omitted
* @param sIn Input String
* @param sHashMarker A beginning hash, in the form #X# or #XXX#
* @return Corrected String
*/ 
string CSLUnserializeByHashValue( string sIn, string sHashMarker, string sDefaultValue = "" )
{
	int iPos, iCount;
    int iLen = GetStringLength(sIn);
	if ( iLen == 0 )
	{
		return sDefaultValue;
	}
	iPos = FindSubString(sIn, sHashMarker) + GetStringLength(sHashMarker);
	if ( iPos == -1 )
	{
		return sDefaultValue;
	}
    
    iCount = FindSubString(GetSubString(sIn, iPos, iLen - iPos), GetStringLeft(sHashMarker,1) );
    return GetSubString(sIn, iPos, iCount);
}



//@}

/************************************************************/
/** @name Nth functions
* Description
********************************************************* @{ */


// Put this in global scope for the Nth Functions, avoids usage of a global var but it's always getting declared.
string CSLNth_GlobalLastVar;

/** 
* Used with CSLNth_Pop and CSLNth_Shift to allow the removed element to be accessed
* @replaces XXXCSLListGetCurrent, XXX
*/
string CSLNth_GetLast()
{
   //return GetLocalString(GetModule(), "CSLNTH_LAST");
   return CSLNth_GlobalLastVar;
}


int CSLGetWordCount( string sIn, int iSmallestWordSize = 3, int iStart = 0 )
{
	if ( sIn == "" || GetStringLength( sIn ) <= iSmallestWordSize )
	{
		return 0;
	}
	int iLastPosition = 0;
	int iCount = 0;
	
	int iPosition = 0;
	iPosition = FindSubString( sIn, " ", iStart );
	if ( iPosition == -1 ) // no more to find
	{ 
		return 1; // delimiter not present, must be a single word
	}
	
	//iStart = iPosition+1;
	iCount = 1;
	
	while( iPosition > -1 )
	{	
		if ( (iLastPosition+iSmallestWordSize) <= iPosition )
		{
			iCount++;
		}
		iPosition = FindSubString( sIn, " ", iPosition+1 );
		if ( iPosition == -1 ) // no more to find
		{
			return iCount;
		}
		iLastPosition = iPosition;
	}
	return iCount;
}

/**  
* Returns the number of delimited items in the given string, for use with Nth functions in a iterator
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index from which to get the value
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @param iStart Position to start looking for delimiters
* @replaces XXXCSLListGetCount, CSLGetNthCount
* @return The total number of elements
*/
int CSLNth_GetCount( string sIn, string sDelimiter=",", int iStart = 0 )
{
	if ( sIn == "" )
	{
		return 0;
	}
	
	int iCount = 0;
	
	int iPosition = 0;
	iPosition = FindSubString( sIn, sDelimiter, iStart );
	if ( iPosition == -1 ) // no more to find
	{ 
		return 1; // delimiter not present, must be a single element
	}
	
	//iStart = iPosition+1;
	iCount = 1;
	
	while( iPosition > -1 )
	{	
		iCount++;
		iPosition = FindSubString( sIn, sDelimiter, iPosition+1 );
		if ( iPosition == -1 ) // no more to find
		{
			return iCount;
		}
	}
	return iCount;
}


/**  
* Returns the position that the Nth item starts at in the given string using a comma or another provided parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index from which to get the value
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @param iStart Position to start looking for delimiters
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces CSLGetNthPosition 
* @return 
*/
int CSLNth_GetPosition( string sIn, int iOccurance = 1, string sDelimiter=",", int iStart = 0 )
{
	if ( iOccurance == 1 )
	{
		return iStart;
	}
	
	int iPosition = FindSubString( sIn, sDelimiter, iStart );
	if ( iPosition == -1 ) // no more to find
	{ 
		return -1;
	}
	//iStart = iPosition+1;
	iOccurance--;
	
	while( iOccurance > 1 )
	{
		iPosition = FindSubString( sIn, sDelimiter, iPosition+1 );
		if ( iPosition == -1 ) // no more to find
		{ 
			return -1;
		}
		//iStart = iPosition+1;
		iOccurance--;
	}
	return iPosition+1;
}

/**  
* Returns the length of the Nth item in the given string using a comma or another provided parameter
* 
* Use the CSLNth_GetPosition prior to get the iPosition Parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iPosition The starting position
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces XXXCSLGetNthLength
* @return Lenght of the Nth Item
*/
int CSLNth_GetElementLength( string sIn, int iPosition, string sDelimiter="," )
{
	//iPosition = CSLNth_GetPosition( sIn, iIndex, sDelimiter );
	int iNextPosition = FindSubString( sIn, sDelimiter, iPosition );
	
	if ( iNextPosition == -1 ) // no more delimters are present
	{
		iNextPosition = GetStringLength( sIn );	
	}
	
	
	if ( iNextPosition >= iPosition ) // make sure it's result is 0 or higher
	{
		return iNextPosition-iPosition;
	}
	return 0;
}


/**  
* Gets the Nth substring separated by commas, or the given delimiter, Nth is 1 based
* Example:
* GetWord("VFX_IMP_ACID", 3, "_"); // returns "ACID"
* GetWord("Dog,Cat,Frog", 2, ","); // returns "Cat"
* GetWord("Dog", 1, ","); // returns "Dog"
* GetWord("Dog", 2, ","); // returns ""
* GetWord("Hello, it's nice to see you again!", 5, " "); // returns "see"
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index from which to get the value
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @replaces GetWord from the DMFI, JXStringSplit from jailiax, CSLListGetElement from Seed, CSLGetTokenByPosition from theatre system
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces XXXCSLGetNthString
* @return 
*/
string CSLNth_GetNthElement(string sIn, int iOccurance, string sDelimiter=",")
{
	if ( GetStringLength( sDelimiter ) != 1 )
	{
		return "";
	}
	
	// no delimiters
	if ( FindSubString( sIn, sDelimiter ) == -1 )
	{
		if ( iOccurance == 1 )
		{
			return sIn;
		}
		else
		{
			return "";
		}
	}
	
	sIn = sIn+sDelimiter;
	
	int nNth = 0;
	int nLength = GetStringLength(sIn);
	string sSub;
	string sWord;
	int nCount=0;
	while (nNth < nLength)
	{
		sSub = GetSubString(sIn, nNth, 1);
		if (sSub==sDelimiter)
		{
			sWord = GetStringLeft(sIn, nNth);
			
			nCount++;
			if (nCount==iOccurance)
			{
				return sWord;
			}
			sIn = GetStringRight( sIn, nLength-(nNth+1) );
			
			nLength = GetStringLength(sIn);
			nNth = -1;
		}
		nNth++;
	}
	return "";
}

/**  
* Gets the Nth substring separated by commas as an integer, or the given delimiter, Nth is 1 based
* used to replace GetIntParam which is 0 based, so add one to it
*/
int CSLNth_GetNthElementInt(string sIn, int iOccurance, string sDelimiter=",")
{
	return StringToInt( CSLNth_GetNthElement( sIn, iOccurance, sDelimiter) );
}

/**  
* Gets the Nth substring separated by commas as an Float, or the given delimiter, Nth is 1 based
* used to replace GetIntParam which is 0 based, so add one to it
*/
float CSLNth_GetNthElementFloat(string sIn, int iOccurance, string sDelimiter=",")
{
	return StringToFloat( CSLNth_GetNthElement( sIn, iOccurance, sDelimiter) );
}

/**  
* Returns a random Nth item in the given string using a comma or another provided parameter
* @author Brian Meyer based on RealBasics NthString function
* @replaces XXXCSLPickOneFromList, XXXCSLGetRandomtNthString
* @return 
*/
string CSLNth_GetRandomElement(string sIn, string sDelimiter=",")
{
	if (sIn=="") // don't bother
	{
		return "";
	}
	int iOccurance = CSLNth_GetCount( sIn, sDelimiter );
	if ( iOccurance==1 ) // don't bother
	{
		return sIn;
	}
	return CSLNth_GetNthElement( sIn, Random(iOccurance), sDelimiter );
}


/**  
* Removes the Nth item in the given string using a comma or another provided parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index to determine which element gets removed
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces XXXCSLGetNthRemove
* @todo Need to do QA checks, see if they compile and if they remove things as advertised
* @return 
*/
string CSLNth_RemoveElement(string sIn, int iOccurance, string sDelimiter=",")
{
	if ( FindSubString( sIn, sDelimiter ) == -1 ) // only one element since no delimiters, very easy to change it
	{
		if ( iOccurance == 1 )
		{
			return "";
		}
		else
		{
			return sIn;
		}
	}
	
	int iPosition = CSLNth_GetPosition( sIn, iOccurance, sDelimiter );
	int iLength = CSLNth_GetElementLength( sIn, iPosition, sDelimiter );
	int iTotalLength = GetStringLength(sIn);
	
	// try to just do one string concatanation since the string involved could be larger
	if ( iOccurance == 1 ) // first element
	{
		return GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
	}
	else if ( ( iPosition + iLength ) >= iTotalLength ) // last element
	{
		return GetStringLeft(sIn, iPosition-1);
	}
	// else in the middle
	return GetStringLeft(sIn, iPosition-1) + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
}



/**  
* Replaces the Nth item in the given string using a comma or another provided parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sIn The delimited string from which the value will be extracted
* @param sReplace The string to replace the string found at the given occurance
* @param iOccurance One based index to determine which element gets removed
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces XXXCSLGetNthReplace
* @todo Need to do QA checks, see if they compile and if they replace things as advertised
* @return 
*/
string CSLNth_ReplaceElement(string sIn, string sReplace, int iOccurance, string sDelimiter=",")
{
	if ( FindSubString( sIn, sDelimiter ) == -1 ) // only one element since no delimiters, very easy to change it
	{
		if ( iOccurance == 1 )
		{
			return sReplace;
		}
		else
		{
			return sIn;
		}
	}
	
	int iPosition = CSLNth_GetPosition( sIn, iOccurance, sDelimiter );
	int iLength = CSLNth_GetElementLength( sIn, iPosition, sDelimiter );
	int iTotalLength = GetStringLength(sIn);
	
	// try to just do one string concatanation since the string involved could be larger
	if ( iOccurance == 1 ) // first element
	{
		return sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
	}
	else if ( ( iPosition + iLength ) >= iTotalLength ) // last element
	{
		return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace;
	}
	// else in the middle
	return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
}

// finds position of first occurance of said string
int CSLNth_Find(string sArray, string sValue, string sDelimiter="," )
{
	if ( sArray == "" )
	{
		return -1;
	}
	
	int iPosition = FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sValue+sDelimiter );
	if ( iPosition == -1)
	{
		return -1;
	}
	sArray = GetStringLeft(sArray, iPosition-1);
	return CSLNth_GetCount(sArray,sDelimiter)+1;
}

// finds and replaces a single element in the array
string CSLNth_Replace(string sArray, string sNeedle, string sReplace, string sDelimiter="," )
{
	if ( sArray == "" )
	{
		return "";
	}
	
	int iPosition = FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNeedle+sDelimiter );
	if ( iPosition == -1)
	{
		return sArray;
	}
	//sArray = GetStringLeft(sArray, iPosition-1);
	//return CSLNth_GetCount(sArray,sDelimiter)+1;
	int iLength = GetStringLength(sNeedle);
	int iTotalLength = GetStringLength(sArray);
	if ( sReplace == "" )
	{
		return GetStringLeft(sArray, iPosition-1) + sDelimiter + GetStringRight(sArray, iTotalLength-iLength-iPosition-1);
	}
	return GetStringLeft(sArray, iPosition-1) + sDelimiter + sReplace + sDelimiter + GetStringRight(sArray, iTotalLength-iLength-iPosition-1);
	
	/*
	int iPosition = CSLNth_GetPosition( sIn, iOccurance, sDelimiter );
	int iLength = CSLNth_GetElementLength( sIn, iPosition, sDelimiter );
	int iTotalLength = GetStringLength(sIn);
	
	// try to just do one string concatanation since the string involved could be larger
	if ( iOccurance == 1 ) // first element
	{
		return sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
	}
	else if ( ( iPosition + iLength ) >= iTotalLength ) // last element
	{
		return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace;
	}
	// else in the middle
	return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
	*/
	
}

/**  
* Appends sNew to the end of the given Nth array string using a comma or another provided parameter if it's not the only item
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sArray The delimited string from which the value will be appended
* @param sNew The string to append to the end of the string
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces XXXCSLNthPush
* @todo Need to do QA checks, see if they compile and if they replace things as advertised
* @return a new Array
*/
string CSLNth_Push(string sArray, string sNew, string sDelimiter=",", int bUnique = FALSE )
{
	if ( sArray == "" )
	{
		return sNew;
	}
	
	if ( bUnique == TRUE && FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNew+sDelimiter ) != -1 )
	{
		return sArray;
	}
	
	return sArray+sDelimiter+sNew;
}

/**
* Joins two arrays together, appending any unique elements from the second array to the first array.
*/
string CSLNth_JoinUnique( string sArray, string sNew, string sDelimiter=","  )
{
	if ( sArray == "" )
	{
		return sNew;
	}
	
	if ( sNew != "" ) // nothing to do, lets just end this
	{
		string sNewItem;
		
		int iNewArrayCount = CSLNth_GetCount( sNew, sDelimiter );
		int i;
		for ( i=1; i <= iNewArrayCount; i++ )
		{
			sNewItem = CSLNth_GetNthElement(sNew, i, sDelimiter);
			if ( FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNewItem+sDelimiter ) == -1 )
			{
				sArray += sDelimiter+sNewItem;
			}
		}
	}
	///SendMessageToPC(GetFirstPC(), sArray+" merging with "+sNew+" = "+sArray);
	return sArray;
}

/**
* Adds an item to the front of an array
* @replaces XXXCSLNthUnShift
*/
string CSLNth_UnShift(string sArray, string sNew, string sDelimiter=",", int bUnique = FALSE )
{
	if ( sArray == "" )
	{
		return sNew;
	}
	
	if ( bUnique == TRUE && FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNew+sDelimiter ) != -1 )
	{
		return sArray;
	}
	
	return sNew+sDelimiter+sArray;
}

/**
* Returns the last element of an array and removes it
* Last item is stored in variable for other usage
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index to determine which element gets removed
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces XXXCSLNthPop
*/
string CSLNth_Pop(string sIn, string sDelimiter=",")
{
	int iPosition = FindSubString( sIn, sDelimiter );
	int iLastPosition = iPosition;
	if ( iPosition == -1 ) // only one element since no delimiters, very easy to change it
	{
		CSLNth_GlobalLastVar = sIn;
		return "";
	}
	
	while( iPosition > -1 )
	{	
		iLastPosition = iPosition;
		iPosition = FindSubString( sIn, sDelimiter, iPosition+1 );
	}
	
	CSLNth_GlobalLastVar = GetStringRight( sIn, GetStringLength(sIn)-(iLastPosition+1) );
	return GetStringLeft( sIn, iLastPosition );
}

/**
* Rotates an array of a limited number of elements, putting the provided at the front of the array if not currently present
* Takes element, puts it on front of array if not already present, removes any elements over x length
*/
string CSLNth_Rotate(string sArray, string sNew, int iMaxLength, string sDelimiter="," )
{
	if ( sArray == "" )
	{
		return sNew;
	}
	
	if ( sNew != "" )
	{
		if ( FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNew+sDelimiter ) == -1 )
		{
			sArray = sNew+sDelimiter+sArray;
		}
	}
	//int iCount = 0;
	
	// now get the total count of elements
	int iPosition = 0;
	int iCount = 0;
	
	while( iPosition > -1 )
	{	
		iCount++;
		iPosition = FindSubString( sArray, sDelimiter, iPosition+1 );
		if ( iPosition == -1 ) // no more to find
		{
			return sArray;
		}
		
		if ( iCount >= iMaxLength )
		{
			return GetStringLeft( sArray, iPosition );
		}
	}
	//return iCount;
	
	return sArray;
}



/**  
* Removes the first item in the given string using a comma or another provided parameter
* First item is stored in variable for other usage
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index to determine which element gets removed
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @replaces XXXCSLNthShift XXXCSLListPopElement
* @return 
*/
string CSLNth_Shift(string sIn, string sDelimiter=",")
{
	int iPosition = FindSubString( sIn, sDelimiter );
	if ( iPosition == -1 ) // only one element since no delimiters, very easy to change it
	{
		CSLNth_GlobalLastVar = sIn;
		return "";
	}
	 
	int iTotalLength = GetStringLength(sIn);
	
	CSLNth_GlobalLastVar = GetStringLeft( sIn, iPosition );
	return GetStringRight( sIn, GetStringLength(sIn)-(iPosition+1) );
}

/**  
* Merges multiple Nth Arrays into a single larger array
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sArray The delimited string from which the value will be appended
* @param sNew The string to append to the end of the string
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see CSLNth_GetNthElement
* @see CSLNth_GetCount
* @see CSLNth_GetElementLength
* @see CSLNth_GetPosition 
* @todo Need to do QA checks, see if they compile and if they replace things as advertised
* @return a new Array
*/
string CSLNth_Merge(string sArray, string sDelimiter=",", string sArrayNew1="", string sArrayNew2="", string sArrayNew3="", string sArrayNew4="", string sArrayNew5="", string sArrayNew6="", string sArrayNew7="", string sArrayNew8="", string sArrayNew9="", string sArrayNew10="", string sArrayNew11="" )
{
	if ( sArrayNew1 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew1;
		}
		else
		{
			sArray += sDelimiter+sArrayNew1;
		}
	}
	
	if ( sArrayNew2 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew2;
		}
		else
		{
			sArray += sDelimiter+sArrayNew2;
		}
	}
	
	if ( sArrayNew3 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew3;
		}
		else
		{
			sArray += sDelimiter+sArrayNew3;
		}
	}
	
	if ( sArrayNew4 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew4;
		}
		else
		{
			sArray += sDelimiter+sArrayNew4;
		}
	}
	
	if ( sArrayNew5 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew5;
		}
		else
		{
			sArray += sDelimiter+sArrayNew5;
		}
	}
	
	if ( sArrayNew6 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew6;
		}
		else
		{
			sArray += sDelimiter+sArrayNew6;
		}
	}
	
	if ( sArrayNew7 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew7;
		}
		else
		{
			sArray += sDelimiter+sArrayNew7;
		}
	}
	
	if ( sArrayNew8 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew8;
		}
		else
		{
			sArray += sDelimiter+sArrayNew8;
		}
	}
	
	if ( sArrayNew9 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew9;
		}
		else
		{
			sArray += sDelimiter+sArrayNew9;
		}
	}
	
	if ( sArrayNew10 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew10;
		}
		else
		{
			sArray += sDelimiter+sArrayNew10;
		}
	}
	
	if ( sArrayNew11 != "" )
	{
		if ( sArray == "" )
		{
			sArray = sArrayNew11;
		}
		else
		{
			sArray += sDelimiter+sArrayNew11;
		}
	}
	return sArray;
}





/**
* Sorts a delimited list using a basic bubble sort, only for very small lists which need to be put into order
* iMaxIterations is a safety measure, or to allow multiple passes to avoid a TMI, a 27 item list such as an alphabet is done in about 20 iterations, currently set so high as to never be seen
* @replaces XXXCSLNthSort
*/
string CSLNth_Sort( string sIn, string sDelimiter=",", int iMaxIterations = 999 )
{
	int iPosition = FindSubString( sIn, sDelimiter );
	int iLastPosition;
	int iIterationCount = 0;
	if ( iPosition == -1 ) // no items therefore nothing to sort
	{
		return sIn;
	}
	
	string sCompleted, sCurrent, sPrevious, sSwap;
	int bChanged;
	
	do
	{
		bChanged = FALSE;
		sCompleted = "";
		sPrevious = "";
		sCurrent = "";
		iPosition = -1;
		do
		{	
			iPosition++;
			iLastPosition = iPosition;
			
			iPosition = FindSubString( sIn, sDelimiter, iPosition );
			if ( iPosition == -1 )
			{
				sCurrent = GetSubString(sIn, iLastPosition, GetStringLength(sIn)-iLastPosition);
			}
			else
			{
				sCurrent = GetSubString(sIn, iLastPosition, iPosition-iLastPosition);
			}
			
			if ( sPrevious != "" && sCurrent != "" )
			{
				if ( StringCompare( sPrevious,sCurrent, FALSE ) > 0 ) // did not seem to work with a simple "as is" truth test until i added the " > 0 "
				{
					bChanged = TRUE;
					sSwap = sPrevious;
					sPrevious = sCurrent;
					sCurrent = sSwap;
				}
			}
			sCompleted = CSLNth_Push(sCompleted, sPrevious);
			
			sPrevious = sCurrent;
			sCurrent = "";
			
		}
		while( iPosition > -1 );
			
		sIn = CSLNth_Push(sCompleted, sPrevious); // grab final one
		iIterationCount++;
		
	}
	while( bChanged == TRUE && iIterationCount < iMaxIterations );
	
	return sIn;
}

//@}



/************************************************************/
/** @name CSLStringArray functions
* List Functions for use with Local Vars, wrapper for Nth Functions
********************************************************* @{ */

// not really needed but makes the entire system more logical, assumes list is created with Nth functions, possibly can add summary features to this ( max, min, total elements and the like since i have accessors )
// makes working with vars on objects more convenient mainly
void CSLLocalList_Set( object oObject, string sVarName, string sList, string sDelimiter = "," )
{
	SetLocalString(oObject, sVarName, sList);
}

string CSLLocalList_Get( object oObject, string sVarName )
{
	return GetLocalString(oObject, sVarName );
}

string CSLLocalList_GetRandomElement( object oObject, string sVarName, string sDelimiter="," )
{
	return CSLNth_GetRandomElement( GetLocalString(oObject, sVarName), sDelimiter);
}

string CSLLocalList_GetNthElement( object oObject, string sVarName, int iNthOccurance, string sDelimiter="," )
{
	return CSLNth_GetNthElement( GetLocalString(oObject, sVarName), iNthOccurance, sDelimiter );
}

int CSLLocalList_Count( object oObject, string sVarName, string sDelimiter="," )
{
	return CSLNth_GetCount( GetLocalString(oObject, sVarName), sDelimiter );
}

void CSLLocalList_Sort( object oObject, string sVarName, string sDelimiter="," )
{
	string sList = CSLNth_Sort( GetLocalString(oObject, sVarName), sDelimiter );
	SetLocalString(oObject, sVarName, sList);
}

string CSLLocalList_Push( object oObject, string sVarName, string sIn, int bUnique=FALSE, string sDelimiter = ","  )
{
	//string sDelimiter = GetLocalString(oObject, sVarName+"_DELIM");
	string sList = CSLNth_Push( GetLocalString(oObject, sVarName), sIn, sDelimiter, bUnique );
	SetLocalString(oObject, sVarName, sList);
	return sList;
}

string CSLLocalList_UnShift( object oObject, string sVarName, string sIn, int bUnique=FALSE, string sDelimiter = ","  )
{
	//string sDelimiter = GetLocalString(oObject, sVarName+"_DELIM");
	string sList = CSLNth_Push( GetLocalString(oObject, sVarName), sIn, sDelimiter, bUnique );
	SetLocalString(oObject, sVarName, sList);
	return sList;
}

string CSLLocalList_Pop( object oObject, string sVarName, string sDelimiter = ","  )
{
	//string sDelimiter = GetLocalString(oObject, sVarName+"_DELIM");
	string sList = CSLNth_Pop( GetLocalString(oObject, sVarName), sDelimiter );
	SetLocalString(oObject, sVarName, sList);
	return CSLNth_GetLast();
}


string CSLLocalList_Shift( object oObject, string sVarName, string sDelimiter = ","  )
{
	//string sDelimiter = GetLocalString(oObject, sVarName+"_DELIM");
	string sList = CSLNth_Shift( GetLocalString( oObject, sVarName), sDelimiter );
	SetLocalString(oObject, sVarName, sList);
	return CSLNth_GetLast();
}



//@}

/************************************************************/
/** @name CSLGlobalList
* List Functions for use with Global Vars, wrapper for Nth Functions
********************************************************* @{ */

// not really needed but makes the entire system more logical, assumes list is created with Nth functions, possibly can add summary features to this ( max, min, total elements and the like since i have accessors )
// makes working with vars on objects more convenient mainly
void CSLGlobalList_Set( string sVarName, string sList, string sDelimiter = "," )
{
	SetGlobalString(sVarName, sList);
}

string CSLGlobalList_Get( string sVarName )
{
	return GetGlobalString( sVarName );
}

string CSLGlobalList_GetRandomElement( string sVarName, string sDelimiter="," )
{
	return CSLNth_GetRandomElement( GetGlobalString(sVarName), sDelimiter);
}

string CSLGlobalList_GetNthElement( string sVarName, int iNthOccurance, string sDelimiter="," )
{
	return CSLNth_GetNthElement( GetGlobalString(sVarName), iNthOccurance, sDelimiter );
}

int CSLGlobalList_Count( string sVarName, string sDelimiter="," )
{
	return CSLNth_GetCount( GetGlobalString(sVarName), sDelimiter );
}

void CSLGlobalList_Sort( string sVarName, string sDelimiter="," )
{
	string sList = CSLNth_Sort( GetGlobalString(sVarName), sDelimiter );
	SetGlobalString(sVarName, sList);
}

// * @replaces XXXCSLAppendGlobalString and XXXCSLListAppendGlobal
string CSLGlobalList_Push( string sVarName, string sIn, int bUnique=FALSE, string sDelimiter = ","  )
{
	string sList = CSLNth_Push( GetGlobalString(sVarName), sIn, sDelimiter, bUnique );
	SetGlobalString(sVarName, sList);
	return sList;
}

string CSLGlobalList_UnShift( string sVarName, string sIn, int bUnique=FALSE, string sDelimiter = ","  )
{
	string sList = CSLNth_Push( GetGlobalString(sVarName), sIn, sDelimiter, bUnique );
	SetGlobalString(sVarName, sList);
	return sList;
}

string CSLGlobalList_Pop( string sVarName, string sDelimiter = ","  )
{
	string sList = CSLNth_Pop( GetGlobalString(sVarName), sDelimiter );
	SetGlobalString(sVarName, sList);
	return CSLNth_GetLast();
}


string CSLGlobalList_Shift( string sVarName, string sDelimiter = ","  )
{
	string sList = CSLNth_Shift( GetGlobalString(sVarName), sDelimiter );
	SetGlobalString(sVarName, sList);
	return CSLNth_GetLast();
}



//@}

/************************************************************/
/** @name CSLStringArray functions
* Description
********************************************************* @{ */

/**
* @private
*/
struct CSLStringArray {
    int iActive;
	int iCount;
	int iCurrentIndex;
	int iPosition;
	int iLength;
	string sArray;
	string sDelimiter;
};

/**
* @private
*/
struct CSLStringArray strSA; // put it into global scope





/**  
* Deletes the current string array from memory allowing a new one to be used.
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
*/
void CSLStringArrayDelete(  )
{
	strSA.iCount = 0;
	strSA.iCurrentIndex = -1;
	strSA.iPosition = -1;
	strSA.iLength = -1;
	strSA.sArray = "";
	strSA.sDelimiter = "";
	strSA.iActive = FALSE;
}


/**  
* Prints the contents of the CSLStringArray struct, used in debugging and QA testing
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @return String showing all the contents and details of the current CSLStringArray
*/
string CSLStringArrayPrint(  )
{
	return " Elements="+IntToString(strSA.iCount)+" Active="+IntToString(strSA.iActive)+" Index="+IntToString(strSA.iCurrentIndex)+"  Position="+IntToString(strSA.iPosition)+"  Length="+IntToString(strSA.iLength)+"  Delimter="+strSA.sDelimiter+" ArrayData="+strSA.sArray;
}



/**  
* Returns the currently selected String Array Item
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayPrint
* @return The current CSLStringArray element as determined by the internal pointer
*/
string CSLStringArrayCurrent(  )
{
	return GetSubString( strSA.sArray, strSA.iPosition, strSA.iLength );
}


/**  
* Returns the String Array Current Index
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The current CSLStringArray internal pointer index position
*/
int CSLStringArrayCurrentIndex( )
{
	return strSA.iCurrentIndex;
}

/**  
* Returns the String Array Count of the number of elements
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The current CSLStringArray internal pointer index position
*/
int CSLStringArrayCount( )
{
	return strSA.iCount;
}

/**  
* Description
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer
* @param iIndex
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The current CSLStringArray element as determined by the provided index
*/
string CSLStringArrayIndex( int iIndex )
{
	string sDelimiter = strSA.sDelimiter;
	string sArray = strSA.sArray;
	int iArrayCount = strSA.iCount;
	int iLength = strSA.iLength;
	int iPosition = strSA.iPosition;
	
	if ( iIndex > iArrayCount || iArrayCount < 1)
	{
		return ""; // it's a higher value than what is in the array
	}
	
	if ( strSA.iCurrentIndex == iIndex ) // we already have this value, so no need to relookup the result
	{
		return GetSubString( sArray, iPosition, iLength );
	}
	
	
	
	if ( iArrayCount == 1 )
	{
		strSA.iPosition = 0;
		strSA.iLength = 0;
		return strSA.sArray; // only one value anyway, so no need to iterate the array
	}
	
	iPosition = CSLNth_GetPosition( sArray, iIndex, sDelimiter );
	
	if ( iArrayCount == iIndex ) // iIndex ==  )
	{
		// these guys when not commented cause crashing
		iLength = GetStringLength( sArray );
		iLength = iLength-iPosition;
	}
	else
	{
		// these guys when not commented cause crashing
		iLength = FindSubString( sArray, sDelimiter, iPosition );
		iLength = iLength-iPosition;
	}
	
	strSA.iPosition = iPosition;
	strSA.iLength = iLength;
	strSA.iCurrentIndex = iIndex;
	
	return GetSubString( sArray, iPosition, iLength );
}




/**  
* Initializes a string array variable, Note only one can be used in a single script and it's kept in memory until the current script ends running.
*
* This is a simple and temporary array to store a limited number of items with more advanced array functions. There are array systems to store data on objects which is more permament and one to deal with a string directly, please choose the one which works best for the problem at hand.
*
* Example Usage:
* CSLStringArrayCreate('1,2,3,4,5,6,7,8,9,10');
* This creates a CSLStringArray which has the strings 1 thru 10
*
* Navigation:
* CSLStringArrayFirst(); // will return '1' 
* CSLStringArrayNext(); // will return '2'
* CSLStringArrayLast(); // will return '10'
* CSLStringArrayPrev(); // will return '9'
* CSLStringArrayIndex(3); // will return '3' or the 3rd element ( 3 just so happens to be the string in the third element )
*
* Standard Array Functions like found in most languages:
* CSLStringArrayShift(); returns the first item '1' and the array is now '2,3,4,5,6,7,8,9,10'
* CSLStringArrayPop(); returns the last item '10' and the array is now '2,3,4,5,6,7,8,9'
* CSLStringArrayUnShift('A'); // adds 'A' to the front and the array is now 'A,2,3,4,5,6,7,8,9'
* CSLStringArrayPush('B'); // adds 'B' to the end and the array is now 'A,2,3,4,5,6,7,8,9,B'
* CSLStringArrayReplace( 'C', 5 ); // will take the 5th element of '5' and change it to 'C' which makes the array 'A,2,3,4,C,6,7,8,9,B'
*
* To clean up and remove the array, note this does not need to be called but will be needed if you want to use twice in the same script.
* CSLStringArrayDelete();
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time. This is one of the Pseudo Array Systems, with CSLStringArray, Nth functions for simple strings, and DataObjects. 
* @author Brian Meyer
* @param sIn An optional string with the desired array elements separated by commas ( or whatever is used as your sDelimiter parameter )
* @param sDelimiter Defaults to a comma, but should be any character which is not present in any of the strings being put into the array
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return FALSE if there already is an active CSLStringArray, TRUE if it successfully created a new one.
*/
int CSLStringArrayCreate( string sIn, string sDelimiter = "," )
{
	
	int iActive = strSA.iActive; // seems to crash if used directly
	if ( iActive == TRUE ) { return FALSE; } // don't let a new one be started if it's already being used
	strSA.sArray = sIn;
	strSA.sDelimiter = sDelimiter;
	strSA.iCount = CSLNth_GetCount( strSA.sArray, strSA.sDelimiter );
	CSLStringArrayIndex( 1 );
	return TRUE;
}



/**  
* Gets the first item in the current array
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The first CSLStringArray element
*/
string CSLStringArrayFirst(  )
{
	return CSLStringArrayIndex( 1 );
}


/**  
* Gets the last item in the current array
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The Last CSLStringArray element
*/
string CSLStringArrayLast(  )
{
	return CSLStringArrayIndex( strSA.iCount );
}


/**  
* Gets the next item in the current array
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The next CSLStringArray element
*/
string CSLStringArrayNext(  )
{
	return CSLStringArrayIndex( strSA.iCurrentIndex+1 );
}


/**  
* Gets the previous item in the current array
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return  The previous CSLStringArray element
*/
string CSLStringArrayPrev(  )
{
	return CSLStringArrayIndex( strSA.iCurrentIndex-1 );
}


/**  
* Helper function that gets the string array struct
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return  The entire CSLStringArray internal struct
*/
string CSLStringArrayGet(  )
{
	return strSA.sArray;
}


/**  
* Returns last element, removing it from the array
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The last CSLStringArray element
*/
string CSLStringArrayPop(  )
{
	if ( strSA.iCount == 1 )
	{
		strSA.iCount = 0;
		strSA.iCurrentIndex = -1;
		strSA.iPosition = -1;
		strSA.iLength = -1;
		strSA.sArray = "";
		return strSA.sArray;
	}
	else if ( strSA.iCount == 0 )
	{
		return "";
	}
	
	strSA.iPosition = CSLNth_GetPosition( strSA.sArray, strSA.iCurrentIndex, strSA.sDelimiter  );
	
	
	string sCurrent = GetStringRight(strSA.sArray, GetStringLength(strSA.sArray)-(strSA.iPosition) );
	strSA.sArray = GetStringLeft(strSA.sArray, strSA.iPosition-1 );
	
	strSA.iCount--;
	strSA.iCurrentIndex = -1;
	strSA.iPosition = -1;
	strSA.iLength = -1;
	
	return sCurrent;
	
}


/**  
* Adds elements to the end of the array and returns the entire array
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @param sElement String to be added to the end of the array
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
*/
void CSLStringArrayPush( string sElement )
{
	
	strSA.iPosition = GetStringLength( strSA.sArray );
	strSA.iLength = GetStringLength( sElement );
	
	if ( strSA.iPosition == 0 )
	{
		strSA.sArray = sElement;
	}
	else
	{
		strSA.iPosition++;
		strSA.sArray += strSA.sDelimiter+sElement;
	}
	strSA.iCount++;	
	
}


/**  
* Returns the first element of an array and removes it
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayUnShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
* @return The first CSLStringArray element
*/
string CSLStringArrayShift( )
{
	
	if ( strSA.iCount == 1 )
	{
		strSA.iCount = 0;
		strSA.iCurrentIndex = -1;
		strSA.iPosition = -1;
		strSA.iLength = -1;
		strSA.sArray = "";
		return strSA.sArray;
	}
	else if ( strSA.iCount == 0 )
	{
		return "";
	}
	
	int iPosition = FindSubString( strSA.sArray, strSA.sDelimiter );
	//int iLength = CSLNth_GetElementLength( strSA.sArray, iPosition, strSA.sDelimiter )
	
	string sCurrent = GetStringLeft(strSA.sArray, iPosition );
	strSA.sArray = GetStringRight(strSA.sArray, GetStringLength(strSA.sArray)-(iPosition+1) );
	
	strSA.iCount--;
	strSA.iCurrentIndex = -1;
	strSA.iPosition = -1;
	strSA.iLength = -1;
	
	return sCurrent;
	
	//return "";
}


/**  
* Adds an items to the front of an array
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @param sElement String to add to the front of the Array
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayReplace
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
*/
void CSLStringArrayUnShift( string sElement )
{
	
	strSA.iPosition = 0;
	strSA.iLength = GetStringLength( sElement );
	
	if ( strSA.sArray == "" )
	{
		strSA.sArray = sElement;
	}
	else
	{
		strSA.sArray = sElement + strSA.sDelimiter + strSA.sArray;
	}
	strSA.iCount++;
	
}

/**  
* replaces given value at the given index with the new element
*
* Part of the CSLStringArray system which is a Pseudo Array which is available globally until the current script ends, only one can be in use at a time.
* @author Brian Meyer
* @param sElement String to put into the array  
* @param iIndex Element Position to put array into, previous value is replaced
* @see CSLStringArrayCreate
* @see CSLStringArrayDelete
* @see CSLStringArrayUnShift
* @see CSLStringArrayShift
* @see CSLStringArrayPush
* @see CSLStringArrayPop
* @see CSLStringArrayGet
* @see CSLStringArrayFirst
* @see CSLStringArrayNext
* @see CSLStringArrayPrev
* @see CSLStringArrayLast
* @see CSLStringArrayIndex
* @see CSLStringArrayCurrentIndex
* @see CSLStringArrayCurrent
* @see CSLStringArrayPrint
*/
void CSLStringArrayReplace( string sElement, int iIndex )
{
	
	int iArrayCount = strSA.iCount;
	
	if ( (iIndex > iArrayCount) || (iArrayCount < 1) || (sElement == "") )
	{
		return; // it's a higher value than what is in the array
	}
	
	string sDelimiter = strSA.sDelimiter;
	//string sArray = strSA.sArray;
	int iLength = strSA.iLength;
	int iPosition = strSA.iPosition;
	

	
	if ( iArrayCount == 1 ) // only one element, very easy to change it
	{
		iPosition = 0;
		strSA.sArray = sElement; // only one value anyway, so no need to iterate the array
	}
	else if ( iIndex == iArrayCount )
	{
		iPosition = CSLNth_GetPosition( strSA.sArray, iIndex, sDelimiter );
		iLength = CSLNth_GetElementLength( strSA.sArray, iPosition, sDelimiter );
		strSA.sArray = GetStringLeft(strSA.sArray, iPosition-1 ) + sDelimiter + sElement;
	}
	else if ( iIndex == 1 )
	{
		iPosition = 0;
		iLength = CSLNth_GetElementLength( strSA.sArray, iPosition, sDelimiter );
		strSA.sArray = sElement + sDelimiter + GetStringRight(strSA.sArray, GetStringLength(strSA.sArray)-iLength-iPosition-1);
	}
	else
	{
		iPosition = CSLNth_GetPosition( strSA.sArray, iIndex, sDelimiter );
		iLength = CSLNth_GetElementLength( strSA.sArray, iPosition, sDelimiter );
		strSA.sArray = GetStringLeft(strSA.sArray, iPosition-1) + sDelimiter + sElement + sDelimiter + GetStringRight(strSA.sArray, GetStringLength(strSA.sArray)-iLength-iPosition-1);
	}
	
	
	//strSA.sArray = sArray;
	strSA.iLength = GetStringLength( sElement );
	strSA.iPosition = iPosition;
	strSA.iCurrentIndex = iIndex;
	
}

void CSLSetLocalStringArray( object oObject, string sVariableName )
{
	SetLocalString( oObject, sVariableName, strSA.sDelimiter + strSA.sArray );
}

void CSLGetLocalStringArray( object oObject, string sVariableName )
{
	string sArray = GetLocalString( oObject, sVariableName );
	string sDelimter = GetStringLeft(sArray, 1);
	sArray = GetStringRight(sArray, GetStringLength(sArray)-1);
	CSLStringArrayCreate( sArray, sDelimter );
}

//@}

/************************************************************/
/** @name TestUnit functions
* Description
********************************************************* @{ */

/**  
* Runs test output to provided player object to test library
* @author Brian Meyer
* @param oTester Player to send test results to  
*/
/*
void CSLStringTestUnit( object oPC = OBJECT_SELF )
{
    SendMessageToPC( oPC, CSLColorText( "TEST CASE: String Array Functions" , COLOR_GREEN) );
    SendMessageToPC( oPC, "Parameters: none");
	SendMessageToPC( oPC, "Various String Array Functions from the CSL library");
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLNth_GetCount" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7,8,9,0') should return '10' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7,8,9,0" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7,8,9') should return '9' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7,8,9" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7,8') should return '8' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7,8" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6,7') should return '7' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6,7" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5,6') should return '6' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5,6" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4,5') should return '5' and returns "+IntToString(CSLNth_GetCount("1,2,3,4,5" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3,4') should return '4' and returns "+IntToString(CSLNth_GetCount("1,2,3,4" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2,3') should return '3' and returns "+IntToString(CSLNth_GetCount("1,2,3" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('1,2') should return '2' and returns "+IntToString(CSLNth_GetCount("1,2" )) );
	
	SendMessageToPC( oPC, "CSLNth_GetCount('1') should return '1' and returns "+IntToString(CSLNth_GetCount("1" )) );
	SendMessageToPC( oPC, "CSLNth_GetCount('') should return '0' and returns "+IntToString(CSLNth_GetCount("" )) );
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLNth_GetPosition" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 1) should return '0' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 1 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 2) should return '2' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 2 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 3) should return '4' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 3 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 4) should return '6' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 4 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 5) should return '8' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 5 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 6) should return '10' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 6 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 7) should return '12' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 7 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 8) should return '14' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 8 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 9) should return '16' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 9 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 10) should return '18' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 10 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 11) should return '-1' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 11 )) );	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2,3,4,5,6,7,8,9,0', 12) should return '-1' and returns "+IntToString(CSLNth_GetPosition("1,2,3,4,5,6,7,8,9,0", 12 )) );	
	
	SendMessageToPC( oPC, "CSLNth_GetPosition('1', 1) should return '0' and returns "+IntToString(CSLNth_GetPosition("1", 1 )) );
	SendMessageToPC( oPC, "CSLNth_GetPosition('1,2', 2) should return '2' and returns "+IntToString(CSLNth_GetPosition("1,2", 1 )) );

	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLNth_GetNthElement" , COLOR_GREEN) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 1) should return '0' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 1 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1', 1) should return '1' and returns "+CSLNth_GetNthElement("1", 1 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2', 2) should return '2' and returns "+CSLNth_GetNthElement("1,2", 2 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 2) should return '2' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 2 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 3) should return '3' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 3 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 4) should return '4' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 4 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 5) should return '5' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 5 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 6) should return '6' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 6 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 7) should return '7' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 7 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 8) should return '8' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 8 ) );
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 9) should return '9' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 9 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 10) should return '0' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 10 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 11) should return '' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 11 ) );	
	SendMessageToPC( oPC, "CSLNth_GetNthElement('1,2,3,4,5,6,7,8,9,0', 12) should return '' and returns "+CSLNth_GetNthElement("1,2,3,4,5,6,7,8,9,0", 12 ) );
	
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('1,2,3,4,5,6,7,8,9,0', 'three', 3) should return '1,2,three,4,5,6,7,8,9,0' and returns "+CSLNth_ReplaceElement("1,2,3,4,5,6,7,8,9,0", "three", 3) );
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('1,2,3,4,5,6,7,8,9,0', 'one', 1) should return 'one,2,3,4,5,6,7,8,9,0' and returns "+CSLNth_ReplaceElement("1,2,3,4,5,6,7,8,9,0", "one", 1) );
	SendMessageToPC( oPC, "CSLNth_ReplaceElement('1,2,3,4,5,6,7,8,9,0', 'ten', 10) should return '1,2,3,4,5,6,7,8,9,ten' and returns "+CSLNth_ReplaceElement("1,2,3,4,5,6,7,8,9,0", "ten", 10) );
	
	SendMessageToPC( oPC, CSLColorText( "TEST CASE: CSLStringArray" , COLOR_GREEN) );
	CSLStringArrayCreate("1,2,3,4,5,6,7,8,9AA,10" );
	SendMessageToPC( oPC, "CSLStringArrayCreate('1,2,3,4,5,6,7,8,9AA,10') results in ( "+CSLStringArrayPrint( )+" ) " );
	
	SendMessageToPC( oPC, "CSLStringArrayFirst() should return '1' and results in "+CSLStringArrayFirst()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayNext() should return '2' and results in "+CSLStringArrayNext()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayNext() should return '3' and results in "+CSLStringArrayNext()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayNext() should return '4' and results in "+CSLStringArrayNext()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayLast() should return '10' and results in "+CSLStringArrayLast()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayPrev() should return '9AA' and results in "+CSLStringArrayPrev()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayPrev() should return '8' and results in "+CSLStringArrayPrev()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayPrev() should return '7' and results in "+CSLStringArrayPrev()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayFirst() should return '1' and results in "+CSLStringArrayFirst()+" ( "+CSLStringArrayPrint( )+" ) " );
	
	SendMessageToPC( oPC, "CSLStringArrayIndex(1) should return '1' and results in "+CSLStringArrayIndex(1)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(2) should return '2' and results in "+CSLStringArrayIndex(2)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(3) should return '3' and results in "+CSLStringArrayIndex(3)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(4) should return '4' and results in "+CSLStringArrayIndex(4)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(5) should return '5' and results in "+CSLStringArrayIndex(5)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(6) should return '6' and results in "+CSLStringArrayIndex(6)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(7) should return '7' and results in "+CSLStringArrayIndex(7)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(8) should return '8' and results in "+CSLStringArrayIndex(8)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(9) should return '9AA' and results in "+CSLStringArrayIndex(9)+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayIndex(10) should return '10' and results in "+CSLStringArrayIndex(10)+" ( "+CSLStringArrayPrint( )+" ) " );
	
	SendMessageToPC( oPC, "CSLStringArrayPop() should return '10' and results in "+CSLStringArrayPop()+" ( "+CSLStringArrayPrint( )+" ) " );
	SendMessageToPC( oPC, "CSLStringArrayShift() should return '1' and results in "+CSLStringArrayShift()+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayPush("A");
	SendMessageToPC( oPC, "CSLStringArrayPush('A') should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayUnShift("B");
	SendMessageToPC( oPC, "CSLStringArrayUnShift('B') should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayReplace( "X", 1 );
	SendMessageToPC( oPC, "CSLStringArrayReplace( 'X', 1 ) should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayReplace( "Y", 5 );
	SendMessageToPC( oPC, "CSLStringArrayReplace( 'Y', 5 ) should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayReplace( "Z", 10 );
	SendMessageToPC( oPC, "CSLStringArrayReplace( 'Z', 10 ) should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
	
	CSLStringArrayDelete();
	SendMessageToPC( oPC, "CSLStringArrayDelete() should return '' and results in "+" ( "+CSLStringArrayPrint( )+" ) " );
}
*/
//@}

/// Never finished this but here is notes for doing word wrap
//////////////// Other /////////////////////

// * Takes a given block of text, and drops in line breaks at a given width, but will respect words
// Very simple at first, will add more sophisticated exceptions later

/**  
* Description
* @param sIn Input String
* @param iWidth
* @param sBreakChar = SC_CHAR_BREAK
* @return 
*/
/*
string CSLWordWrap( string sIn, int iWidth, string sBreakChar = SC_CHAR_BREAK )
{
	string sOut = "";
	
	
	
	
	return sOut;
}
*/

/*
function word_wrap($chars,$str)
{
	$cpy=strip_tags($str);
	$chk=array_reverse(preg_split('`\s`',$cpy));
	$chk2=array_reverse(preg_split('`\s`',$str));
	$len=0;
	$retVal='';
	
	// we want to work backwards on this
	for( $i = count($chk)-1; $i >= 0; $i-- ) 
	{
		// $len is the current segment length in the stripped string
		if($len>0 && ($len + strlen($chk[$i])) > $chars)
		{
			// add a line break
			$retVal.='<br />'."\n";
			$len=0;
		}
		else if($len>0)
		{
			// space between words needs to be counted
			$len++;
		}
		
		// add the necessary pieces to the string
		$pop1 = array_pop($chk); // get next piece from each version
		$pop2 = array_pop($chk2);
		$retVal.=$pop2.' ';
		$len+=strlen($pop1);
		$pattern='`'.preg_quote($pop1).'`';
		while(!preg_match($pattern,strip_tags($pop2)))
		{
			// if pop1 and pop2 are not referencing the same element
			$pop2=array_pop($chk2);
			$retVal.=$pop2.' ';
			if($pop2==NULL) break;
		}
	}
	return $retVal;
}
*/


/*
public static string[] Wrap(string text, int maxLength)
{
	text = text.Replace("\n", " ");
	text = text.Replace("\r", " ");
	text = text.Replace(".", ". ");
	text = text.Replace(">", "> ");
	text = text.Replace("\t", " ");
	text = text.Replace(",", ", ");
	text = text.Replace(";", "; ");
	text = text.Replace("
	", " ");
	text = text.Replace(" ", " ");
	 
	string[] Words = text.Split(' ');
	int currentLineLength = 0;
	ArrayList Lines = new ArrayList(text.Length / maxLength);
	string currentLine = "";
	bool InTag = false;
	 
	foreach (string currentWord in Words)
	{
		//ignore html
		if (currentWord.Length > 0)
		{
			 
			if (currentWord.Substring(0,1) == "<")
			InTag = true;
			 
			if (InTag)
			{
				//handle filenames inside html tags
				if (currentLine.EndsWith("."))
				{
					currentLine += currentWord;
				}
				else
				{
					currentLine += " " + currentWord;
				}
				
				if (currentWord.IndexOf(">") > -1)
				{
					InTag = false;
				}
				 
			}
			else
			{
				if (currentLineLength + currentWord.Length + 1 < maxLength)
				{
					currentLine += " " + currentWord;
					currentLineLength += (currentWord.Length + 1);
				}
				else
				{
					Lines.Add(currentLine);
					currentLine = currentWord;
					currentLineLength = currentWord.Length;
				}
			}
		}
	}
	 
	if (currentLine != "")
	{
		Lines.Add(currentLine);
	}
	string[] textLinesStr = new string[Lines.Count];
	Lines.CopyTo(textLinesStr, 0);
	return textLinesStr;
}
*/
/*
// {{{ wordwrap
function wordwrap( str, int_width, str_break, cut ) {
    // Wraps a string to a given number of characters
    // 
    // +    discuss at: http://kevin.vanzonneveld.net/techblog/article/javascript_equivalent_for_phps_wordwrap/
    // +       version: 810.819
    // +   original by: Jonas Raoni Soares Silva (http://www.jsfromhell.com)
    // +   improved by: Nick Callen
    // +    revised by: Jonas Raoni Soares Silva (http://www.jsfromhell.com)
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: Sakimori
    // *     example 1: wordwrap('Kevin van Zonneveld', 6, '|', true);
    // *     returns 1: 'Kevin |van |Zonnev|eld'
    // *     example 2: wordwrap('The quick brown fox jumped over the lazy dog.', 20, '<br />\n');
    // *     returns 2: 'The quick brown fox <br />\njumped over the lazy<br />\n dog.'
    // *     example 3: wordwrap('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.');
    // *     returns 3: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod \ntempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim \nveniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea \ncommodo consequat.'

    // PHP Defaults
    var m = ((arguments.length >= 2) ? arguments[1] : 75   );
    var b = ((arguments.length >= 3) ? arguments[2] : "\n" );
    var c = ((arguments.length >= 4) ? arguments[3] : false);

    var i, j, l, s, r;

    str += '';

    if (m < 1) {
        return str;
    }

    for (i = -1, l = (r = str.split("\n")).length; ++i < l; r[i] += s) {
        for(s = r[i], r[i] = ""; s.length > m; r[i] += s.slice(0, j) + ((s = s.slice(j)).length ? b : "")){
            j = c == 2 || (j = s.slice(0, m + 1).match(/\S*(\s)?$/))[1] ? m : j.input.length - j[0].length || c == 1 && m || j.input.length + (j = s.slice(m).match(/^\S* /)).input.length;
        }
    }

    return r.join("\n");
}// }}}

*/


// Given a varname, value, and PC, sets the variable on 
// all members of the PC's party, including associates. 
// For strings.
void CSLSetLocalStringOnFaction(object oPC, string sVarname, string value)
{
    object oPartyMem = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMem)) {
        SetLocalString(oPartyMem, sVarname, value);
        oPartyMem = GetNextFactionMember(oPC, FALSE);
    }
    //SetLocalString(oPC, sVarname, value);
}