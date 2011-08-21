

void main(string sInput)
{
	object oChar = GetControlledCharacter(OBJECT_SELF);
	SendMessageToPC(oChar, "Called setspellcb with: " + sInput);

	int nIndex = FindSubString(sInput, ":");	
	int nLength = GetStringLength(sInput);
	int nSpellID = StringToInt(GetSubString(sInput,0, nIndex));
	int nIndex2 = FindSubString(sInput, ":", nIndex + 1);
	
	int nClass = StringToInt(GetSubString(sInput, nIndex + 1, nIndex2 - (nIndex + 1)));
	
	int nClassPosition = 0;
	if (GetClassByPosition(1, oChar) == nClass)
		nClassPosition = 1;
	else if (GetClassByPosition(2, oChar) == nClass)
		nClassPosition = 2;
	else if (GetClassByPosition(3, oChar) == nClass)
		nClassPosition = 3;
	else if (GetClassByPosition(4, oChar) == nClass)
		nClassPosition = 4;
		
	if (nClassPosition != 0)
	{
		int bAdd = (GetSubString(sInput, nLength - 1, 1) == "1");
		SetSpellKnown(oChar, nClassPosition - 1, nSpellID, bAdd);
	}
	else
		SendMessageToPC(oChar, "Could not find ClassID: " + IntToString(nClass) + " on " + GetName(oChar));
}