#include "seed_db_inc"
#include "_SCInclude_Chat"

void main(string sText)
{ 
	if (GetIsSinglePlayer())
	{
		object oWP = GetObjectByTag(sText);
		SendMessageToPC(OBJECT_SELF, "Porting to " + GetName(oWP));
		AssignCommand(OBJECT_SELF, JumpToObject(oWP));
		return;
	}
   
	if (sText != "")
	{
		if ( GetStringLeft(sText,1) == CHAT_EMOTE_SYMBOL )
		{
			SendMessageToPC(OBJECT_SELF, "text: " + sText);   
			CSLExecuteChatScript( "emote", OBJECT_SELF, OBJECT_INVALID, CHAT_MODE_TALK, GetStringRight(sText, GetStringLength(sText) - 1) );
			return; 
		}
		SDB_LogMsg("FEEDBACK", sText, OBJECT_SELF);
		SendMessageToPC(OBJECT_SELF, "Your message will be read shortly by someone who cares...");
	}
	else
	{
		SendMessageToPC(OBJECT_SELF, "Didn't you have something you wanted to say?");
	}
	CloseGUIScreen(OBJECT_SELF, "SCREEN_STRINGINPUT_MESSAGEBOX");
}