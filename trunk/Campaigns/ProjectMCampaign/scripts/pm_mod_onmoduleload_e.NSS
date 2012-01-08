#include "_CSLEvent_Mod_i"
#include "elu_skills_i"
#include "elu_feats_i"
#include "hcr2_debug_i"

void main()
{
	CSLGetDataPoint(H2_CORE_DATA_POINT);
	h2_SetModLocalInt(H2_LOGLEVEL, H2_LOG_DEBUG);
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onmoduleload");

	CSLEvent_Mod_OnModuleLoad();

	LoadClass2DAData();
	LoadSkill2DAData();
	LoadClassFeatData();

	SetMaxHenchmen(10);
	
	ExecuteScript("x2_mod_def_load", OBJECT_SELF);

	SetGlobalInt("bNX2_TRANSITIONS", TRUE);
}