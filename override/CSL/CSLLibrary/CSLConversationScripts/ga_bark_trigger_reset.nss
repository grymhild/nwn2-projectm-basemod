// ga_bark_trigger_reset
/*
	Description:
	reset last bark trigger.
	
	Place this on last node of dialog (we didn't speak so reset and give someone else a chance)

*/
// ChazM 5/25/07

//#include "ginc_trigger"
//#include "ginc_vars"
#include "_CSLCore_Player"

const string CSLVAR_LAST_BARK_TRIGGER 	= "__LAST_BARK_TRIGGER";

void main()
{
	object oLastBarkTrigger = GetLocalObject(OBJECT_SELF, CSLVAR_LAST_BARK_TRIGGER);
	CSLDoneFlag_UnSet(oLastBarkTrigger);
}