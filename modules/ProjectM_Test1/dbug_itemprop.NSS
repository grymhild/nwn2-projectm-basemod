

void main()
{
	itemproperty ip = GetFirstItemProperty(OBJECT_SELF);
	while (GetIsItemPropertyValid(ip))
	{
		int nType = GetItemPropertyType(ip);						
		int nSubType = GetItemPropertySubType(ip);
		int nParm = GetItemPropertyParam1(ip);
		int nParmValue = GetItemPropertyParam1Value(ip);
		string sMsg = "IPTYPE = " + IntToString(nType) + " IPSUBTYPE = " + IntToString(nSubType) + " IPPARM1 = " + IntToString(nParm) + " IPPARM1VALUE = " + IntToString(nParmValue);			
		SendMessageToPC(GetItemPossessor(OBJECT_SELF), sMsg); 			
		ip = GetNextItemProperty(OBJECT_SELF);
	}
	SendMessageToPC(GetItemPossessor(OBJECT_SELF), "Done inspecting item properties");
}