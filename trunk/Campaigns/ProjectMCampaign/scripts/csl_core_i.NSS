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

int CSLGetBannedSchool(int nActiveSchool)
{
	switch (nActiveSchool)
	{
		case SPELL_SCHOOL_ABJURATION: return SPELL_SCHOOL_CONJURATION;
		case SPELL_SCHOOL_CONJURATION: return SPELL_SCHOOL_TRANSMUTATION;
		case SPELL_SCHOOL_DIVINATION: return SPELL_SCHOOL_ILLUSION;
		case SPELL_SCHOOL_ENCHANTMENT: return SPELL_SCHOOL_ILLUSION;
		case SPELL_SCHOOL_EVOCATION: return SPELL_SCHOOL_CONJURATION;
		case SPELL_SCHOOL_ILLUSION: return SPELL_SCHOOL_ENCHANTMENT;
		case SPELL_SCHOOL_NECROMANCY: return SPELL_SCHOOL_DIVINATION;
		case SPELL_SCHOOL_TRANSMUTATION: return SPELL_SCHOOL_CONJURATION;		
	}
	return -1;
}