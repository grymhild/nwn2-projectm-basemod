// gc_range_hour
/*
	Description:
	Checks to see if the current hour is within the specified hour range.
	Each day has hours 0 - 23 
	int iStart - start of range 
	int iEnd - end of range (24 hour clock)
*/
// ChazM 11/27/06

#include "_CSLCore_Time"

int StartingConditional(int iStartHour, int iEndHour)
{
	// reduce hour to valid value to avoid mistakes using 
	// hour 24 instead of hour 0.
	iStartHour =  iStartHour % 24;
	iEndHour = iEndHour % 24;
	return (CSLIsCurrentHourInRange(iStartHour, iEndHour));
}