#include "_CSLCore_Messages"

void main()
{

	object oPC = OBJECT_SELF;
	object oSpeaker = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER");
	object oTarget = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET");
	string sInput = GetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD");
	
	CSLMessage_SendText(oSpeaker, "DEBUGGING: CMD 1");
	CSLMessage_SendText(oSpeaker, "DEBUGGING: sInput: " + sInput);
	CSLMessage_SendText(oSpeaker, "DEBUGGING: oPlayer: " + GetName(oPC));
	CSLMessage_SendText(oSpeaker, "DEBUGGING: oSpeaker: " + GetName(oSpeaker));
	CSLMessage_SendText(oSpeaker, "DEBUGGING: oTarget: " + GetName(oTarget));	
	
	if (sInput==".stop")
	{
		// Setting this variable will not allow further plugins OR
		// the default DMFI behavior to run - Set it for OVERRIDES!
		SetLocalInt(GetModule(), "Override", 1);
		CSLMessage_SendText(oSpeaker, "DEBUGGING: OVERRIDE - CMD2 will not run.");
	}	

}	
			