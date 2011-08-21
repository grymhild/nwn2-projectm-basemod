int CSLGetTotalClassLevels(object oChar);
object CSLGetDataPoint(string sDataPointTag);

//Gets the total class levels of oChar
int CSLGetTotalClassLevels( object oChar )
{
	int iTotal = 0;
	int iClass;
	iClass = GetClassByPosition(1, oChar );
	if ( iClass != 255 )	
		iTotal  += GetLevelByClass( iClass, oChar );		
	iClass = GetClassByPosition(2, oChar );
	if ( iClass != 255 )	
		iTotal  += GetLevelByClass( iClass, oChar );	
	iClass = GetClassByPosition(3, oChar );
	if ( iClass != 255 )	
		iTotal  += GetLevelByClass( iClass, oChar );		
	iClass = GetClassByPosition(4, oChar );
	if ( iClass != 255 )	
		iTotal  += GetLevelByClass( iClass, oChar );	
	return iTotal;
}

//Create a Waypoint with sDataPointTag for storing variables on instead of using
//the overused module object.
object CSLGetDataPoint(string sDataPointTag)
{
	object oDataPoint = GetObjectByTag(sDataPointTag);
	if (!GetIsObjectValid(oDataPoint))
	{
    	oDataPoint = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation());
		SetTag(oDataPoint, sDataPointTag);
	}
	return oDataPoint;
}

int CSLGetLevelsByClass(object oChar, int nClass)
{
	int i = 0;
	for(i = 1; i <= 4; i++)
		if (GetClassByPosition(i,oChar) == nClass)
			return GetLevelByPosition(i, oChar);
	return 0;
}