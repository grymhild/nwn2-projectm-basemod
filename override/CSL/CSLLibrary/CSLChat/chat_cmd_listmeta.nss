//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	string sMessage;
	sMessage = "<color=orange>"+"These are the commands you can use via chat. They can be typed into any chat channel (party, talk, shout, etc.) and have the same effect in all of them. They are case insensitive."+"</color>"+"\n";
	sMessage += "<color=palegreen>"+"Commands shown in green must be sent via tell."+"</color>"+"\n";
	sMessage += "<color=orange>" + CHAT_COMMAND_SYMBOL + "metaaccept "+"</color>"+"<color=black>"+"= Accepts an invitation to a metachannel."+"</color>"+"\n";
	sMessage += "<color=orange>" + CHAT_COMMAND_SYMBOL + "metadecline "+"</color>"+"<color=black>"+"= Declines an invitation to a metachannel."+"</color>"+"\n";
	sMessage += "<color=orange>" + CHAT_COMMAND_SYMBOL + "metadisband "+"</color>"+"<color=black>"+"= Removes every member of the metachannel. Only the leader of the metachannel can disband it."+"</color>"+"\n";
	sMessage += "<color=palegreen>" + CHAT_COMMAND_SYMBOL + "metainvite "+"</color>"+"<color=black>"+"(must be sent in a tell) = Invites the target of the tell to your current metachannel. If you are not in a meta chanel, a new channel will be created if that person accepts."+"</color>"+"\n";
	sMessage += "<color=palegreen>" + CHAT_COMMAND_SYMBOL + "metakick "+"</color>"+"<color=black>"+"(must be sent in a tell) = Kicks the target of the tell from your metachannel. Only the leader of the metachannel can kick people from it."+"</color>"+"\n";
	sMessage += "<color=orange>" + CHAT_COMMAND_SYMBOL + "metaleave "+"</color>"+"<color=black>"+"= Removes you from your current metachannel."+"</color>"+"\n";
	sMessage += "<color=orange>" + CHAT_COMMAND_SYMBOL + "metalist "+"</color>"+"<color=black>"+"= Lists the people in your metachannel."+"</color>"+"\n";
	sMessage += "<color=orange>" + "/m "+"</color>"+"<color=black>"+"= Sends the text entered after the channel designation to the player's metachannel."+"</color>"+"\n";
	sMessage += "<color=palegreen>" + CHAT_COMMAND_SYMBOL + "ignore "+"</color>"+"<color=black>"+"(must be sent in a tell) = You will not receive tells from the player you send this command to."+"</color>"+"\n";
	sMessage += "<color=palegreen>" + CHAT_COMMAND_SYMBOL + "unignore "+"</color>"+"<color=black>"+"(must be sent in a tell) = Removes ignore status."+"</color>"+"\n";
	sMessage += "<color=orange>" + CHAT_COMMAND_SYMBOL + "list ignored "+"</color>"+"<color=black>"+"= Lists the players you have chosen to ignore."+"</color>"+"\n";
	// SendMessageToPC(oPC, sMessage);
	CSLInfoBox( oPC, "Meta Channel Commands", "Meta Channel Commands", sMessage );
}