#include "_CSLEvent_Mod_i"
#include "hcr2_core_i"
#include "elu_functions_i"

void main()
{
	h2_LogMessage(H2_LOG_DEBUG, "Executed pm_mod_onpcloaded");

	object oPC = GetEnteringObject();

	CSLEvent_Mod_OnPCLoaded();


	int nRace = GetSubRace(oPC);
	int nECL = StringToInt(Get2DAString("racialsubtypes", "ECL", nRace));
	if (nECL > 0)
		SetLocalInt(oPC, RACIAL_ECL, nECL);

	SetGlobalGUIVariable(oPC, 100, "datatest");
	SetGlobalGUIVariable(oPC, 101, "placeable");
	SetGlobalGUIVariable(oPC, 102, "gui_elu_useskill_e");
	SetGlobalGUIVariable(oPC, 103, "target:object");
	SetGlobalGUIVariable(oPC, 104, "true");

	SCCacheStats( oPC );


	DisplayGuiScreen(oPC, "SCREEN_GUI_CONTROL", FALSE, "uicontrol.XML");

	GiveXPToCreature(oPC, 1000000); //for testing
	h2_SetPlayerState(oPC, H2_PLAYER_STATE_ALIVE); //For Project M.. It's single player so force player state to alive on load.
	h2_AddPlayerSkin(oPC);


	//For ELU to enable Enhanced Familiar/AnimalCompanion
	FeatAdd(oPC, 2002, FALSE);

	ExecuteScript("hcr2_bleedsystempcl", OBJECT_SELF);

	AssignCommand(oPC, ActionSpeakString("dm_debuglevel 9"));
}