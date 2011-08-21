
void CSLSwap(object oObj, string sVarPrefix, string sDataType, int nIndex1, int nIndex2);
int CSLCompare(object oObj, string sPrefix, string sDataType, int nIndex1, int nIndex2);
void CSLSiftDown(object oObj, string sPrefix, string sDataType, int nStart, int nEnd);
void CSLDelayHeapify(object oObj, string sPrefix, string sDataType, int nStart, int nLengthOfArray, int nSegmentSize, string sScriptToFireWhenDone);
void CSLHeapify(object oObj, string sPrefix, string sDataType, int nLengthOfArray, int nSegmentSize, string sScriptToFireWhenDone);
void CSLDelaySort(object oObjWithArrayVars, string sVarPrefix, string sDataType, int nEnd, int nSegmentSize, string sScriptToFireWhenDone);
void CSLSort(object oObjWithArrayVars, string sVarPrefix, string sDataType, int nLengthOfArray, string sScriptToFireWhenDone = "");


//Function called by Sort, do not call directly
void CSLSwap(object oObj, string sVarPrefix, string sDataType, int nIndex1, int nIndex2)
{
	string sVar1 = sVarPrefix + IntToString(nIndex1);
	string sVar2 = sVarPrefix + IntToString(nIndex2);
	if (sDataType == "string")
	{
		string s1 = GetLocalString(oObj, sVar1);
		string s2 = GetLocalString(oObj, sVar2);
		SetLocalString(oObj, sVar1, s2);
		SetLocalString(oObj, sVar2, s1);
		//WriteTimestampedLogEntry("Swap: " + sVar1 + "=" + s2);
		//WriteTimestampedLogEntry("Swap: " + sVar2 + "=" + s1);
	}
	else if (sDataType == "int")
	{
		int n1 = GetLocalInt(oObj, sVar1);
		int n2 = GetLocalInt(oObj, sVar2);
		SetLocalInt(oObj, sVar1, n2);
		SetLocalInt(oObj, sVar2, n1);
	}
	else if (sDataType == "float")
	{
		float f1 = GetLocalFloat(oObj, sVar1);
		float f2 = GetLocalFloat(oObj, sVar2);
		SetLocalFloat(oObj, sVar1, f2);
		SetLocalFloat(oObj, sVar2, f1);
	}
}

//Function called by Sort, do not call directly
int CSLCompare(object oObj, string sPrefix, string sDataType, int nIndex1, int nIndex2)
{
	string sVar1 = sPrefix + IntToString(nIndex1);
	string sVar2 = sPrefix + IntToString(nIndex2);
	if (sDataType == "string")
	{
		string s1 = GetLocalString(oObj, sVar1);
		string s2 = GetLocalString(oObj, sVar2);
		int nResult = (StringCompare(s1, s2) <= 0);
		return nResult;
	}
	else if (sDataType == "int")
	{
		int n1 = GetLocalInt(oObj, sVar1);
		int n2 = GetLocalInt(oObj, sVar2);
		return (n1 <= n2);
	}
	else if (sDataType == "float")
	{
		float f1 = GetLocalFloat(oObj, sVar1);
		float f2 = GetLocalFloat(oObj, sVar2);
		return (f1 <= f2);
	}
	return FALSE;
}

//Function called by Sort, do not call directly
void CSLSiftDown(object oObj, string sPrefix, string sDataType, int nStart, int nEnd)
{
	int nRoot = nStart;
	while (nRoot * 2 + 1 <= nEnd)
	{
		int nChild = nRoot * 2 + 1;
		if (nChild + 1 <= nEnd && CSLCompare(oObj, sPrefix, sDataType, nChild, nChild + 1))
			nChild = nChild + 1;
        if (CSLCompare(oObj, sPrefix, sDataType, nRoot, nChild))
        {
		    CSLSwap(oObj, sPrefix, sDataType, nRoot, nChild);
            nRoot = nChild;
        }
		else
        	return;
	}
}

//Function called by Sort, do not call directly
void CSLDelayHeapify(object oObj, string sPrefix, string sDataType, int nStart, int nLengthOfArray, int nSegmentSize, string sScriptToFireWhenDone)
{
	//int nStart = (nCount - 2) / 2;
	int nOrigStart = nStart;
	while (nStart >= 0 && nStart + nSegmentSize > nOrigStart)
	{
		CSLSiftDown(oObj, sPrefix, sDataType, nStart, nLengthOfArray - 1);
		nStart--;
	}
	if (nStart >= 0)
		DelayCommand(0.01, CSLDelayHeapify(oObj, sPrefix, sDataType, nStart, nLengthOfArray, nSegmentSize, sScriptToFireWhenDone));
	else
	{	//I'm done
		int nEnd = nLengthOfArray - 1;
		DelayCommand(0.01, CSLDelaySort(oObj, sPrefix, sDataType, nEnd, nSegmentSize, sScriptToFireWhenDone));
	}
}

//Function called by Sort, do not call directly
void CSLHeapify(object oObj, string sPrefix, string sDataType, int nLengthOfArray, int nSegmentSize, string sScriptToFireWhenDone)
{
	int nStart = (nLengthOfArray - 2) / 2;
	CSLDelayHeapify(oObj, sPrefix, sDataType, nStart, nLengthOfArray, nSegmentSize, sScriptToFireWhenDone);
}

//Function called by Sort, do not call directly
void CSLDelaySort(object oObjWithArrayVars, string sVarPrefix, string sDataType, int nEnd, int nSegmentSize, string sScriptToFireWhenDone)
{
	int nStart = nEnd;
	//WriteTimeStampedLogEntry(sVarPrefix + ": " + " entries remaining = " + IntToString(nStart));
	while (nEnd > 0 && nEnd > nStart - nSegmentSize)
	{
		CSLSwap(oObjWithArrayVars, sVarPrefix, sDataType, 0, nEnd);
		CSLSiftDown(oObjWithArrayVars, sVarPrefix, sDataType, 0, nEnd - 1);
		nEnd = nEnd - 1;
	}
	if (nEnd == 0)
	{
		WriteTimestampedLogEntry(sVarPrefix + ": Sort Completed.");
		if (sScriptToFireWhenDone != "")
		{
			WriteTimestampedLogEntry(sVarPrefix + " executing end of sort script: " + sScriptToFireWhenDone);
			AddScriptParameterString(sVarPrefix);
			int nRet = ExecuteScriptEnhanced(sScriptToFireWhenDone, oObjWithArrayVars, TRUE);			
			if (nRet == -1)
				WriteTimestampedLogEntry("ERROR executing script " + sScriptToFireWhenDone + " failed.");
		}
	}
	else
		DelayCommand(0.01, CSLDelaySort(oObjWithArrayVars, sVarPrefix, sDataType, nEnd, nSegmentSize, sScriptToFireWhenDone));
}

//Sorts a zero-based array like list where the values are retrived via:
//GetLocal[sDataType](oObjWithArrayVars, sVarPrefixX)
//where X is 0 to nLengthOfArray.
//sDataType can be "string", "int", or "float"
void CSLSort(object oObjWithArrayVars, string sVarPrefix, string sDataType, int nLengthOfArray, string sScriptToFireWhenDone = "")
{
	if (!GetIsObjectValid(oObjWithArrayVars) || (sDataType != "int" && sDataType != "float" && sDataType != "string"))
		return;														   //50 = nSegmentSize
	CSLHeapify(oObjWithArrayVars, sVarPrefix, sDataType, nLengthOfArray, 50, sScriptToFireWhenDone);
}