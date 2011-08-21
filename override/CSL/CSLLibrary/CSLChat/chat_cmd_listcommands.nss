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
	sMessage = "<color=black>"+"These are the commands you can use via chat. They can be typed into any chat channel (party, talk, shout, etc.) and have the same effect in all of them. They are case insensitive."+"</color>"+"\n";
	sMessage += "<color=green>"+"Commands shown in green must be sent via tell or with a target selected."+"</color>"+"\n";
	
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "listemotes "+"</color>"+"<color=SaddleBrown>"+"= Lists the useable chat emotes."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "listcommands "+"</color>"+"<color=SaddleBrown>"+"= Lists the useable chat commands."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "listmeta "+"</color>"+"<color=SaddleBrown>"+"= Lists the useable meta channel commands."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "listignored "+"</color>"+"<color=SaddleBrown>"+"= Lists the players you have chosen to ignore."+"</color>"+"\n";
	sMessage += "\n";
	
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "playerlist (pl) "+"</color>"+"<color=SaddleBrown>"+" = Shows levels for all party members"+"</color>"+"\n";
	if (CSLVerifyDMKey(oPC) || CSLVerifyAdminKey(oPC)) 
	{
		sMessage += "<color=green>" + CHAT_COMMAND_SYMBOL + "playerinfo "+"</color>"+"<color=SaddleBrown>"+" = (must be sent in a tell) = Lists the target's Playername, CD Key, IP, Classes, Experience, Experience Needed for Next Level, Area, Partymembers, Diety, Subrace, Gold, and Gold Plus Inventory Value."+"</color>"+"\n";
	}
	else 
	{
		sMessage += "<color=green>" + CHAT_COMMAND_SYMBOL + "playerinfo (pi) "+"</color>"+"<color=SaddleBrown>"+" = (must be sent in a tell) = Lists the target's Playername, Classes, and Levels. If used on yourself it shows some additional information such as Player Net Worth."+"</color>"+"\n";
	}
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "lfp"+"</color>"+"<color=SaddleBrown>"+" = Announces that you are looking for a group in shout."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "save "+"</color>"+"<color=SaddleBrown>"+" = saves your character to the server harddisk."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d "+"</color>"+"<color=SaddleBrown>"+" = sets all characters logged into the server to dislike."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "da "+"</color>"+"<color=SaddleBrown>"+" = sets all characters in current area to dislike."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "craft "+"</color>"+"<color=SaddleBrown>"+" = displays the crafting dialog that allows weapon and armor changes."+"</color>"+"\n";
	
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "autobuff "+"</color>"+"<color=SaddleBrown>"+" = makes your character cast commonly needed buffs on themselves if they have them memorized."+"</color>"+"\n";

/*
const string COMMAND8 = "= Does an arranged party loot split roll, if the command giver is the party leader.";
const string "(must be sent in a tell) = Lists the target's Playername, CD Key, IP, Classes, Experience, Experience Needed for Next Level, Area, Partymembers, Diety, Subrace, Gold, and Gold Plus Inventory Value." = "(must be sent in a tell) = Lists the target's Playername, CD Key, IP, Classes, Experience, Experience Needed for Next Level, Area, Partymembers, Diety, Subrace, Gold, and Gold Plus Inventory Value.";
const string "(must be sent in a tell) = Lists the target's Playername, Classes, and Levels. If used on yourself it shows some additional information such as Player Net Worth." = "(must be sent in a tell) = Lists the target's Playername, Classes, and Levels. If used on yourself it shows some additional information such as Player Net Worth.";
*/
	sMessage += "\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d4 "+"</color>"+"<color=SaddleBrown>"+"= Rolls a d4."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d6 "+"</color>"+"<color=SaddleBrown>"+"= Rolls a d6."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d8 "+"</color>"+"<color=SaddleBrown>"+"= Rolls a d8."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d10 "+"</color>"+"<color=SaddleBrown>"+"= Rolls a d10."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d12 "+"</color>"+"<color=SaddleBrown>"+"= Rolls a d12."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d20 "+"</color>"+"<color=SaddleBrown>"+"= Rolls a d20."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "d100 "+"</color>"+"<color=SaddleBrown>"+"= Rolls a d100."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "setcache % "+"</color>"+"<color=SaddleBrown>"+" = Sets the % of XP and Gold earned per Kill that goes into your PC Cache."+"</color>"+"\n";
	
	if (ENABLE_WEAPON_VISUALS) sMessage += "\n";
	if (ENABLE_WEAPON_VISUALS) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "wpac "+"</color>"+"<color=SaddleBrown>"+"= Changes weapon visual to acid."+"</color>"+"\n";
	if (ENABLE_WEAPON_VISUALS) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "wpco "+"</color>"+"<color=SaddleBrown>"+"= Changes weapon visual to cold."+"</color>"+"\n";
	if (ENABLE_WEAPON_VISUALS) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "wpel "+"</color>"+"<color=SaddleBrown>"+"= Changes weapon visual to electric."+"</color>"+"\n";
	if (ENABLE_WEAPON_VISUALS) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "wpev "+"</color>"+"<color=SaddleBrown>"+"= Changes weapon visual to evil."+"</color>"+"\n";
	if (ENABLE_WEAPON_VISUALS) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "wpfi "+"</color>"+"<color=SaddleBrown>"+"= Changes weapon visual to fire."+"</color>"+"\n";
	if (ENABLE_WEAPON_VISUALS) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "wpho "+"</color>"+"<color=SaddleBrown>"+"= Changes weapon visual to holy."+"</color>"+"\n";
	
	sMessage += "\n";
	if( CSLGetPreferenceSwitch("LanguagesEnabled", FALSE ) )
	{
		sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "language"+"</color>"+"<color=SaddleBrown>"+" = Splits the specified amount of Gold between all current party members."+"</color>"+"\n";
		sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "voicethrow on/off"+"</color>"+"<color=SaddleBrown>"+" = Enables you to throw your voice or emotes to controlled characters."+"</color>"+"\n";
		
		sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "language [language]"+"</color>"+"<color=SaddleBrown>"+" Sets the current language in use, use common to turn off."+"</color>"+"\n";
		sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "translate(sp) [language] [message]"+"</color>"+"<color=SaddleBrown>"+" translates a single message to the given language, sp is an alias for translate."+"</color>"+"\n";
		sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "voicethrow [on/off]"+"</color>"+"<color=SaddleBrown>"+" Allows voice throwing."+"</color>"+"\n";
		
		sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "accent [pirate|shakespeare]"+"</color>"+"<color=SaddleBrown>"+" sets it so you talk with the given accent."+"</color>"+"\n";
	}
	
	//sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "language"+"</color>"+"<color=SaddleBrown>"+" = Enables you to set your default language."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "setpass PASSWORD "+"</color>"+"<color=SaddleBrown>"+" = Sets your password so you can access on-line statistics for your account."+"</color>"+"\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "playertools on/off"+"</color>"+"<color=SaddleBrown>"+" = Turn the DMFI Player tools on or off"+"</color>"+"\n";
	
	sMessage += "\n";
	sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "bug "+"</color>"+"<color=SaddleBrown>"+" = displays Bug Reporting tool. Please use this to report module bugs you find."+"</color>"+"\n";
	
	//if (ENABLE_PLAYER_SETNAME || CSLVerifyDMKey(oPC) || CSLVerifyAdminKey(oPC)) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "setname "+"</color>"+"<color=SaddleBrown>"+" = Allows the speaker to rename one of their items. The command format is "+"<color=mediumpurple>"+CHAT_COMMAND_SYMBOL+"setname ("+"old name"+")@("+"new name"+")"+"</color>"+"<color=SaddleBrown>"+" . The command is case-sensitive. Example: To rename item Longsword to Sam's Sword: "+"<color=mediumpurple>"+CHAT_COMMAND_SYMBOL+"setname "+"Longsword"+"@"+"Sam's Sword"+"</color>"+"<color=SaddleBrown>"+" . Items with an '@' in the name will prevent this command from working properly."+"</color>"+"\n";
	//if (ENABLE_PLAYER_SETNAME || CSLVerifyDMKey(oPC) || CSLVerifyAdminKey(oPC)) sMessage += "<color=black>" + CHAT_COMMAND_SYMBOL + "setnameall "+"</color>"+"<color=SaddleBrown>"+" = This command is identical in function and format to setname, but will rename all items of the old name specified instead of just one."+"</color>"+"\n";
	//SendMessageToPC(oPC, sMessage);
	
	CSLInfoBox( oPC, "Dex Chat Commands", "Dex Chat Commands", sMessage );
}