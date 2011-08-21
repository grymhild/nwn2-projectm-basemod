#include "_SCInclude_DMFI"

void main()
{

	object oPC = OBJECT_SELF;
	object oSpeaker = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER");
	object oTarget = GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET");
	string sInput = GetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD");
	
	
	
	if (FindSubString(sInput, "wave")!=-1)
	{
		CSLMessage_SendText(oSpeaker, "DEBUGGING: EMT 1");
		CSLMessage_SendText(oSpeaker, "DEBUGGING: sInput: " + sInput);
		CSLMessage_SendText(oSpeaker, "DEBUGGING: oPlayer: " + GetName(oPC));
		CSLMessage_SendText(oSpeaker, "DEBUGGING: oSpeaker: " + GetName(oSpeaker));
		CSLMessage_SendText(oSpeaker, "DEBUGGING: oTarget: " + GetName(oTarget));	
		
		DelayCommand(3.0, AssignCommand(oTarget, SpeakString("Greetings Lad!! (added via plugin)")));
	}		 

}	
			