//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	string sMessage;
	sMessage = "<color=DarkGreen>"+"These are the DM commands that DMs and DMs logged in as players can use via chat. Unlike most normal commands, they must be typed into tells. The person the tell is sent to will be the target of the command, in most cases, though several commands do not require targets. They are case insensitive."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"listcommands "+"</color>"+"<color=black>"+"= The sender of the tell is sent a list explaining all the dm_ commands for use by DMs and DMs logged in as players."+"</color>"+"\n";
	
	
	sMessage = "\n"+"<color=DarkGreen>"+"Movement"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"port here "+"</color>"+"<color=black>"+"= The target of the tell is teleported to the sender. May not be used on other DMs."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"port wp WP_TAG"+"</color>"+"<color=black>"+"Ports you to a Waypoint in the game"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"port jail "+"</color>"+"<color=black>"+"= The target of the tell is sent for detainment. May not be used on other DMs."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"port leader "+"</color>"+"<color=black>"+"= The target of the tell is teleported to his partyleader. May not be used on other DMs."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"port there "+"</color>"+"<color=black>"+"= The sender of the tell is teleported to the target."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"port town "+"</color>"+"<color=black>"+"= The target of the tell is teleported to town. May not be used on other DMs."+"</color>"+"\n";

	sMessage += "\n"+"<color=DarkGreen>"+"Proto DM Power"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"invis "+"</color>"+"<color=black>"+"= The sender of the tell is made cutsecene invisible and ghosted."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"uninvis "+"</color>"+"<color=black>"+"= The sender of the tell is no longer cutsecene invisible or ghosted."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"invuln "+"</color>"+"<color=black>"+"= The target of the tell is made invulnerable."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"uninvuln "+"</color>"+"<color=black>"+"= The target of the tell is made vulnerable again."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"tell MESSAGE "+"</color>"+"<color=black>"+"Use this command in a Tell to a player to speak through Clancy when logged in as a PC-DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"chat hide/show/toggle "+"</color>"+"<color=black>"+"Use this command show or hide yourself in the player list shown to players."+"</color>"+"\n";
	
	//sMessage += ""+"<color=orange>"+"/v "+"</color>"+"<color=black>"+"= This is the ventriloquism command. Once they use the DM Voice Thrower to select a target, the dm may 'throw' their voice to the target creature at any time, simply by typing /v with a space after it, before the text to be spoken by the target. May only be used by DMs. May not be targeted at other DMs. Unlike most DM commands, "+"<color=mediumpurple>"+"/v"+"</color>"+"<color=black>"+" does not need to be entered in a tell."+"</color>";
	
	sMessage += "\n"+"<color=DarkGreen>"+"Player Administration"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"charedit"+"</color>"+"<color=black>"+" opens the character editor for the target"+"</color>"+"\n";
	
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givefeat"+"</color>"+"<color=black>"+" Manually adds the given feat to the target, can make a character invalid"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"removefeat"+"</color>"+"<color=black>"+" Manually removes the given feat to the target"+"</color>"+"\n";
	
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"listspell [class] [levels]"+"</color>"+"<color=black>"+" Lists spells by class and level, class is any of the spellcasting base classes, and levels are either a single level or a range, leaving blank parameters will use the targets information for what spells book to show."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givespell [spellid]"+"</color>"+"<color=black>"+" Manually adds the given spell to the target, uses first spellbook it finds that can accept a spell, use a - before spell id to remove a spell"+"</color>"+"\n";
	
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"shadowthief"+"</color>"+"<color=black>"+" Manually add the Shadow Thief feat to the target"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"change_appear "+"</color>"+"<color=black>"+"= Allows the DM to change the appearance of the targeted creature. The command format is "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"change_appear ("+"appearance number"+")"+"</color>"+"<color=black>"+" . Example: to change the target of the tell's appearance to that of a badger: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"change_appear 8"+"</color>"+"<color=black>"+" .There are too many appearance numbers to list, but experimentation will yeild results, as with the dm console command. Numbers range up to around 1500 or so if CEP is installed, fewer otherwise."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"change_appear base "+"</color>"+"<color=black>"+"= Resets the appearance of the target of the tell to what it was before any "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"change_appear"+"</color>"+"<color=black>"+"= Resets the appearance of the target of the tell to what it was before any "+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givexp "+"</color>"+"<color=black>"+"= Gives the target of the tell the specified amount of experience. The command format is "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givexp ("+"amount of xp to give"+")"+"</color>"+"<color=black>"+". To award 500xp, for instance, you would type: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givexp 500"+"</color>"+"<color=black>"+"."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givegold "+"</color>"+"<color=black>"+"= Gives the target of the tell the specified amount of gold. The command format is "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givegold ("+"amount of gold to give"+")"+"</color>"+"<color=black>"+". To award 500 gold, for instance, you would type: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givegold 500"+"</color>"+"<color=black>"+"."+"</color>"+"\n";	
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givelevel "+"</color>"+"<color=black>"+"= Gives the target of the tell the specified number of levels. The command format is "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givelevel ("+"number of levels to give"+")"+"</color>"+"<color=black>"+". To give 2 levels, for instance, you would type: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givelevel 2"+"</color>"+"<color=black>"+"."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"takexp "+"</color>"+"<color=black>"+"= Removes the specified amount of experience from the target of the tell. The command format is "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"takexp ("+"amount of xp to take"+")"+"</color>"+"<color=black>"+". To remove 500xp, for instance, you would type: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"takexp 500"+"</color>"+"<color=black>"+"."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"takelevel "+"</color>"+"<color=black>"+"= Removes the specified number of levels from the target of the tell. The command format is "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"takelevel ("+"number of levels to take"+")"+"</color>"+"<color=black>"+". To take 2 levels, for instance, you would type: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"takelevel 2"+"</color>"+"<color=black>"+"."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"freeze "+"</color>"+"<color=black>"+"= Makes the target player's character uncommandable by the targeted player. May not be targeted at a DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"unfreeze "+"</color>"+"<color=black>"+"= Makes the target player's character commandable by the target player again."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"align lg|cg|ng|ln|cn|tn|le|ce|ne"+"</color>"+"<color=black>"+"Sets the Targets Alignment"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"pcdm ADD/REMOVE "+"</color>"+"<color=black>"+"Sets/Clears the PC-DM flag on a Player Account."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"journal "+"</color>"+"<color=black>"+"= Shows the target player's journal entries."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"description "+"</color>"+"<color=black>"+"= Shows the target player's description."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"clientextender "+"</color>"+"<color=black>"+"= Sets options for client extender on target - use help as parameter to get a list of all parameters."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"setname "+"</color>"+"<color=black>"+"= Sets the targets name, first word is the first name, rest are used for the last name."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"settag stag "+"</color>"+"<color=black>"+"= Sets the targets tag."+"</color>"+"\n";
	
	if( CSLGetPreferenceSwitch("LanguagesEnabled", FALSE ) )
	{
	sMessage += "\n"+"<color=DarkGreen>"+"Languages"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"listlanguage"+"</color>"+"<color=black>"+" Lists all languages, with known languages in white"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"givelanguage [language]"+"</color>"+"<color=black>"+" Manually adds the given language to the target"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"removelanguage [language]"+"</color>"+"<color=black>"+" Manually removes the given language to the target"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>" + CHAT_COMMAND_SYMBOL + "language [language]"+"</color>"+"<color=black>"+" Sets the current language in use for target, use common to turn off."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>" + CHAT_COMMAND_SYMBOL + "translate(sp) [language] [message]"+"</color>"+"<color=black>"+" translates a single message to the given language, sp is an alias for translate."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>" + CHAT_COMMAND_SYMBOL + "voicethrow [on/off]"+"</color>"+"<color=black>"+" Allows voice throwing."+"</color>"+"\n";
	}
	
	sMessage += "\n"+"<color=DarkGreen>"+"Adventure Tools"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"setcr "+"</color>"+"<color=black>"+"= The target is set to the given CR."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"setcasterlevel "+"</color>"+"<color=black>"+"= The target is set to cast all spells at the given level."+"</color>"+"\n";
	
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"kill "+"</color>"+"<color=black>"+"= The target of the tell is killed. May not be used on DMs."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"rez "+"</color>"+"<color=black>"+"= The target of the tell is resurrected. May not be used on other DMs."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"rest "+"</color>"+"<color=black>"+"= The target of the tell is allowed to rest again."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"areabash ON/OFF"+"</color>"+"<color=black>"+" Makes an area where a bash is happening auto-rez players after 60 seconds, and prevents drops and other things from coming from monsters"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"moverate "+"</color>"+"<color=black>"+"= The targets moveratefactor is returned, setting to reset will use value from appearance.2da, and omitting a parameter will show the current move rate factor."+"</color>"+"\n";
	
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"weather"+"</color>"+"<color=black>"+" Sets the weather for the area, type in with no parameters to get a list of available options to the command"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"sendurl http://www.someurl.com/"+"</color>"+"<color=black>"+"Displays link to target they can click on"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"giveitem (resref) "+"</color>"+"<color=black>"+"= Creates an item of the entered resref on the target of the tell."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx "+"</color>"+"<color=black>"+"= Allows the DM to create any vfx on the target of the tell. For COM, IMP, and FNF visuals, the format is simple, because the duration type and duration are always 0: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx ("+"vfx#"+") 0 0"+"</color>"+"<color=black>"+" . Example: to apply a meteor swarm vfx effect on the target of the tell: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"vfx 28 0 0"+"</color>"+"<color=black>"+" . Use .SEF filename in place of number for NWN2 effects."+"</color>"+"\n";
	sMessage += "<color=black>"+"For DUR, BEAM, and EYES visuals, a duration type and duration must be specified, and you may also make the effect extraordinary (undispellable) or supernatural (not removed by rest), or both. Format: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx ("+"vfx#"+") ("+"duration type#"+") ("+"duration"+") (E/S/SE)"+"</color>"+"<color=black>"+" . Duration type is either 1 for temporary or 2 for permanent. Duration is the number of seconds you want the effect to last. Example: to apply a dominated vfx effect for a duration of 5 minutes: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"vfx 209 1 300 ."+"</color>"+"\n";
	sMessage += "<color=black>"+"To make that same effect Extraordinary: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"vfx 209 1 300 E"+"</color>"+"<color=black>"+" . To make permanent vfx you use 2 for the type, and use 0 for the number of seconds: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"vfx 209 2 0"+"</color>"+"<color=black>"+" . Because vfx numbers are far from intuitive, a "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx_list_*"+"</color>"+"<color=black>"+" command is available to show what vfx # creates what effect."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx_list_* "+"</color>"+"<color=black>"+"= Lists the vfx numbers and names of each type of vfx, by replacing the asterisk with one of 6 three-letter fx type codes: "+"<color=DarkGreen>"+"dur, bea, eye, imp, com, fnf"+"</color>"+"<color=black>"+". Example: "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx_list_fnf"+"</color>"+"<color=black>"+" lists all the vfx names and numbers for Fire-and-Forget type visual effects. "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx_list_dur"+"</color>"+"<color=black>"+" lists duration types, "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx_list_bea"+"</color>"+"<color=black>"+" lists beam types, and so on."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx_loc "+"</color>"+"<color=black>"+"= This command is identical in function and format to the "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx"+"</color>"+"<color=black>"+" command, but will create the effect at the targets location instead of on the target."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx_rem "+"</color>"+"<color=black>"+"= Removes all visual effects on the target of the tell that were created by the sender of the tell. This includes all those created by the "+"<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"fx command."+"</color>"+"\n";

	sMessage += "\n"+"<color=DarkGreen>"+"Server Administration"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"reset "+"</color>"+"<color=black>"+"= The server is shut down and restarted in 2 minutes."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"resetdelay "+"</color>"+"<color=black>"+"= Delays a server reset by one hour."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"table show tablename"+"</color>"+"<color=black>"+"= shows the variable editor for a dataobject by name of table name."+"</color>"+"\n";
	
	
	
	sMessage += "\n"+"<color=DarkGreen>"+"Battles ( Beta )"+"</color>"+"\n";
	//sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"debugtesterlevel VALUE "+"</color>"+"<color=black>"+"As above but just for testers"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"setmaincastle VALUE "+"</color>"+"<color=black>"+"Sets the main castle owner"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"setsecondcastle VALUE "+"</color>"+"<color=black>"+"Sets the second castle owner"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"startbattle "+"</color>"+"<color=black>"+"Starts a battle"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"endbattle "+"</color>"+"<color=black>"+"Ends a battle"+"</color>"+"\n";
	
	sMessage += "\n"+"<color=DarkGreen>"+"Policing"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"getbanlist "+"</color>"+"<color=black>"+"= Sends the sender of the tell a list of all the players banned from shout or DM channel."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"getbanreason "+"</color>"+"<color=black>"+"= Tells the sender of the tell why the target of the tell was banned from shout channel - Spam or DM. The reason for the banning is only stored until the next reset, so will not display for permabanned players. The name of the DM who did the ban will be shown for DM bans, and the message that resulted in the ban will be displayed for spam autobans."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"bandm "+"</color>"+"<color=black>"+"= Bans the target of the tell from using DM channel until the next reset. May not be targeted at a DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"unbandm "+"</color>"+"<color=black>"+"= The target of the tell is no longer banned from using DM channel."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"banplayer "+"</color>"+"<color=black>"+"= Bans the target player's cdkey permanently from your server. If the banned player attempts to reconnect they are autobooted. May not be targeted at a DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"banaccount "+"</color>"+"<color=black>"+"= Bans the target player's cdkey permanently from your server. If the banned player attempts to reconnect they are autobooted. May not be targeted at a DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"bancdkey "+"</color>"+"<color=black>"+"= Bans the target player's cdkey permanently from your server. If the banned player attempts to reconnect they are autobooted. May not be targeted at a DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"bantemp LENGTH PERIOD REASON "+"</color>"+"<color=black>"+" bans player temporarily. Length can be any number, Period should be DAY or HOUR, always give a reason"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"banshout_temp "+"</color>"+"<color=black>"+"= Bans the target of the tell from using shout channel until the next reset. May not be targeted at a DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"banshout_perm "+"</color>"+"<color=black>"+"= Bans the target of the tell from using shout channel permanently. May not be targeted at a DM."+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"unbanshout "+"</color>"+"<color=black>"+"= The target of the tell is no longer banned from using shout channel."+"</color>"+"\n";
	if ((DM_PLAYERS_HEAR_DM && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_PLAYERS_HEAR_DM && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM)))) sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"ignoredm "+"</color>"+"<color=black>"+"= The sender of the tell will ignore DM channel if they are logged in as a player."+"</color>"+"\n";
	if ((DMS_HEAR_META && CSLVerifyDMKey(oDM) && CSLGetIsDM(oDM)) || (DM_PLAYERS_HEAR_META && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_DMS_HEAR_META && CSLVerifyAdminKey(oDM) && CSLGetIsDM(oDM)) || (ADMIN_PLAYERS_HEAR_META && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM)))) sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"ignoremeta "+"</color>"+"<color=black>"+"= The sender of the tell will ignore meta channels."+"</color>"+"\n";
	if ((DMS_HEAR_TELLS && CSLVerifyDMKey(oDM) && CSLGetIsDM(oDM)) || (DM_PLAYERS_HEAR_TELLS && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_DMS_HEAR_TELLS && CSLVerifyAdminKey(oDM) && CSLGetIsDM(oDM)) || (ADMIN_PLAYERS_HEAR_TELLS && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM)))) sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"ignoretells "+"</color>"+"<color=black>"+"= The sender of the tell will ignore all tells except those sent to or by him."+"</color>"+"\n";
	if ((DM_PLAYERS_HEAR_DM && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_PLAYERS_HEAR_DM && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM)))) sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"unignoredm "+"</color>"+"<color=black>"+"= The sender of the tell will no longer ignore DM channel."+"</color>"+"\n";
	if ((DMS_HEAR_META && CSLVerifyDMKey(oDM) && CSLGetIsDM(oDM)) || (DM_PLAYERS_HEAR_META && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_DMS_HEAR_META && CSLVerifyAdminKey(oDM) && CSLGetIsDM(oDM)) || (ADMIN_PLAYERS_HEAR_META && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM)))) sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"unignoremeta "+"</color>"+"<color=black>"+"= The sender of the tell will no longer ignore meta channels."+"</color>"+"\n";
	if ((DMS_HEAR_TELLS && CSLVerifyDMKey(oDM) && CSLGetIsDM(oDM)) || (DM_PLAYERS_HEAR_TELLS && CSLVerifyDMKey(oDM) && (!CSLGetIsDM(oDM))) || (ADMIN_DMS_HEAR_TELLS && CSLVerifyAdminKey(oDM) && CSLGetIsDM(oDM)) || (ADMIN_PLAYERS_HEAR_TELLS && CSLVerifyAdminKey(oDM) && (!CSLGetIsDM(oDM)))) sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"unignoretells "+"</color>"+"<color=black>"+"= The sender of the tell will no longer ignore any tells."+"</color>"+"\n";
	
	
	sMessage += "\n"+"<color=DarkGreen>"+"Debugging"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"getinfo "+"</color>"+"<color=black>"+"Shows the detailed information on the target"+"</color>"+"\n";
	
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"debuglevel VALUE "+"</color>"+"<color=black>"+"Sets how many debug messages 1-10, 1 is few messages, 10 all messages"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"settester "+"</color>"+"<color=black>"+"Sets target so they can see more debug messages"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"unsettester "+"</color>"+"<color=black>"+"Sets target so they can see more debug messages"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"showspellstats "+"</color>"+"<color=black>"+"Shows the Caster Levels for a target"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"resetspellstats "+"</color>"+"<color=black>"+"Makes the spells stats reapply upon next spell cast"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"showeffects "+"</color>"+"<color=black>"+"Shows the effects on a target"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"showitemproperties "+"</color>"+"<color=black>"+"Shows the item properties for a target"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"showvar VAR_NAME "+"</color>"+"<color=black>"+"Shows variable settings on the target"+"</color>"+"\n";
	sMessage += "<color=DarkGreen>"+CHAT_DMCOMMAND_SYMBOL+"setint VAR VALUE "+"</color>"+"<color=black>"+"Sets an Integer on the target"+"</color>"+"\n";

	
	
	//SendMessageToPC(oDM, sMessage);
	
	
	CSLInfoBox( oDM, "DM Chat Commands", "Dex DM Chat Commands", sMessage );

}