#include "elu_functions_i"

void main(string sVarPrefix)
{
	int nFeatSortCount = GetLocalInt(GetModule(), "featsortdone");
	nFeatSortCount++;
	SetLocalInt(GetModule(), "featsortdone", nFeatSortCount);
	if (nFeatSortCount == 10)
		WriteTimestampedLogEntry("Finished LoadFeat2DAData");
}