//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

string ListEmotesMsg(string sEmote, string sAbbr, string sOpts="", string sTrailing = "\n")
{
	string sMsg = CHAT_EMOTE_SYMBOL+sEmote;
	if ( sOpts != "" )
	{
		sMsg += "(*"+sAbbr+")";
	}
	
	if ( sOpts != "" )
	{
		sMsg += " <color=SaddleBrown>"+sOpts+"</color>";
	}
	return sMsg+sTrailing;
}

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
   string sMsg;
   sMsg += ListEmotesMsg("agree",      "ag");
   sMsg += ListEmotesMsg("annoyed",    "an");
   sMsg += ListEmotesMsg("beer",       "be");
   sMsg += ListEmotesMsg("beg",        "bg");
   sMsg += ListEmotesMsg("bend",       "bn");
   sMsg += ListEmotesMsg("bored",      "bo", "0-1");
   sMsg += ListEmotesMsg("bow",        "bw");
   sMsg += ListEmotesMsg("chat",       "ct");
   sMsg += ListEmotesMsg("cheer",      "ch", "0-3");
   sMsg += ListEmotesMsg("chuckle",    "ck");
   sMsg += ListEmotesMsg("clap",       "cl");
   sMsg += ListEmotesMsg("conjure",    "cj", "0-3");
   sMsg += ListEmotesMsg("cook",       "co", "0-1");
   sMsg += ListEmotesMsg("craft",      "cf");
   sMsg += ListEmotesMsg("cry",        "cr");
   sMsg += ListEmotesMsg("curtsy",     "cy");
   sMsg += ListEmotesMsg("dance",      "da", "0-1");
   sMsg += ListEmotesMsg("dead",       "de", "0/back, 1/front");
   sMsg += ListEmotesMsg("dejected",   "dj");
   sMsg += ListEmotesMsg("demand",     "dm");
   sMsg += ListEmotesMsg("disable",    "di", "0/ground, 1/front");
   sMsg += ListEmotesMsg("dodge",      "do");
   sMsg += ListEmotesMsg("drunk",      "dn");
   sMsg += ListEmotesMsg("duck",       "dk");
   sMsg += ListEmotesMsg("dustoff",    "du");
   sMsg += ListEmotesMsg("eat",        "ea");
   sMsg += ListEmotesMsg("flirt",      "fl");
   sMsg += ListEmotesMsg("forge",      "fo", "0-1");
   sMsg += ListEmotesMsg("get",        "ge", "0/table, 1/ground, 2/low, 3/mid, 4/high");
   sMsg += ListEmotesMsg("hello",      "he", "0-2");
   sMsg += ListEmotesMsg("idle",       "id", "0/injured, 1/cower, 2/pray");
   sMsg += ListEmotesMsg("intimidate", "in");
   sMsg += ListEmotesMsg("kneel",      "kn", "0/up, 1/bow, 2/down, 3/fidget, 4/idle, 5/talk");
   sMsg += ListEmotesMsg("knight",     "kg");
   sMsg += ListEmotesMsg("knockdown",  "kd");
   sMsg += ListEmotesMsg("laugh",      "la", "0-1");
   sMsg += ListEmotesMsg("laydown",    "ld");
   sMsg += ListEmotesMsg("listen",     "li");
   sMsg += ListEmotesMsg("meditate",   "md", "0-1");
   sMsg += ListEmotesMsg("no",         "no");
   sMsg += ListEmotesMsg("pause",      "pa");
   sMsg += ListEmotesMsg("peer",       "pe");
   sMsg += ListEmotesMsg("play",       "pl", "instrument [drum, flute, guitar] model [0-1] song [drum=0-8, flute=0-5, guitar=0-12]");
   sMsg += ListEmotesMsg("plead",      "pd", "0-1");
   sMsg += ListEmotesMsg("point",      "po");
   sMsg += ListEmotesMsg("pray",       "pr", "0-1");
   sMsg += ListEmotesMsg("puke",       "pu");
   sMsg += ListEmotesMsg("rake",       "ra");
   sMsg += ListEmotesMsg("read",       "re", "0-2");
   sMsg += ListEmotesMsg("salute",     "sa", "0-1");
   sMsg += ListEmotesMsg("scratch",    "sc", "0-1");
   sMsg += ListEmotesMsg("scream",     "sr", "0-4");
   sMsg += ListEmotesMsg("search",     "se");
   sMsg += ListEmotesMsg("shovel",     "sv");
   sMsg += ListEmotesMsg("shrug",      "sh");
   sMsg += ListEmotesMsg("sigh",       "sg");
   sMsg += ListEmotesMsg("sing",       "sn", "0-3");
   sMsg += ListEmotesMsg("sit",        "si", "0-2");
   sMsg += ListEmotesMsg("sleep",      "sl");
   sMsg += ListEmotesMsg("smoke",      "sm");
   sMsg += ListEmotesMsg("spasm",      "sp");
   sMsg += ListEmotesMsg("swipe",      "sw");
   sMsg += ListEmotesMsg("talk",       "tl", "0/norm, 1/cheer, 2/force0, 3/force1, 4/force2, 5/force3, 6/injured, 7/laugh, 8/nervous, 9/plead, 10/shout, 11/loop");
   sMsg += ListEmotesMsg("taunt",      "ta", "0-1");
   sMsg += ListEmotesMsg("threaten",   "th");
   sMsg += ListEmotesMsg("tired",      "ti");
   sMsg += ListEmotesMsg("touchheart", "to");
   sMsg += ListEmotesMsg("useitem",    "ui");
   sMsg += ListEmotesMsg("victory",    "vi");
   // causes crash
   //sMsg += ListEmotesMsg("vomit",      "vm");
   sMsg += ListEmotesMsg("wave",       "wa", "0-2");
   sMsg += ListEmotesMsg("whistle",    "wh", "0-5");
   sMsg += ListEmotesMsg("wine",       "wi");
   sMsg += ListEmotesMsg("worship",    "wo", "0-1");
   sMsg += ListEmotesMsg("yawn",       "yw", "" , "");
   //SendMessageToPC(oPC, sMsg);
   
   CSLInfoBox( oPC, "Emotes", "Dex Emotes", sMsg );
}