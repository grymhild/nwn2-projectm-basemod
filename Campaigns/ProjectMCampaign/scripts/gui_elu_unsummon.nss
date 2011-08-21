#include "elu_fam_ancom_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed gui_elu_unsummon");
	object oSummoned = GetPlayerCurrentTarget(OBJECT_SELF);
	string sName = "OBJECT_INVALID";
	if (GetIsObjectValid(oSummoned))
	{
		sName = GetName(oSummoned);		
		HandleUnsummon(oSummoned);		
	}
	h2_LogMessage(H2_LOG_DEBUG, GetName(GetMaster(oSummoned)) + " unsummoned creature: " + sName);
}