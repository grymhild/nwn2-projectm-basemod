// gc_range_month
/*
	Description:
	Checks to see if the current month is within the specified Month range.
	Each year has 12 Months.
	int iStartMonth - start of range
	int iEndMonth - end of range
*/
// ChazM 11/27/06

#include "_CSLCore_Time"

int StartingConditional(int iStartMonth, int iEndMonth)
{
	return (CSLIsCurrentMonthInRange(iStartMonth, iEndMonth));
}