//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

string ListColorMsg(string sColor, string sTrailing = "\n")
{
   return sColor+": <color="+sColor+">"+sColor+"</color> "+sTrailing;
}

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	string sMsg;
	sMsg += ListColorMsg("AliceBlue");
	sMsg += ListColorMsg("AntiqueWhite");
	sMsg += ListColorMsg("Aquamarine");
	sMsg += ListColorMsg("Aqua");
	sMsg += ListColorMsg("Azure");
	sMsg += ListColorMsg("Beige");
	sMsg += ListColorMsg("Bisque");
	sMsg += ListColorMsg("Black");
	sMsg += ListColorMsg("BlanchedAlmond");
	sMsg += ListColorMsg("BlueViolet");
	sMsg += ListColorMsg("Blue");
	sMsg += ListColorMsg("Brown");
	sMsg += ListColorMsg("BurlyWood");
	sMsg += ListColorMsg("CadetBlue");
	sMsg += ListColorMsg("Chartreuse");
	sMsg += ListColorMsg("Chocolate");
	sMsg += ListColorMsg("ColorName");
	sMsg += ListColorMsg("Coral");
	sMsg += ListColorMsg("CornflowerBlue");
	sMsg += ListColorMsg("Cornsilk");
	sMsg += ListColorMsg("Crimson");
	sMsg += ListColorMsg("Cyan");
	sMsg += ListColorMsg("DarkBlue");
	sMsg += ListColorMsg("DarkCyan");
	sMsg += ListColorMsg("DarkGoldenRod");
	sMsg += ListColorMsg("DarkGray");
	sMsg += ListColorMsg("DarkGreen");
	sMsg += ListColorMsg("DarkKhaki");
	sMsg += ListColorMsg("DarkMagenta");
	sMsg += ListColorMsg("DarkOliveGreen");
	sMsg += ListColorMsg("DarkOrange");
	sMsg += ListColorMsg("DarkOrchid");
	sMsg += ListColorMsg("DarkRed");
	sMsg += ListColorMsg("DarkSalmon");
	sMsg += ListColorMsg("DarkSeaGreen");
	sMsg += ListColorMsg("DarkSlateBlue");
	sMsg += ListColorMsg("DarkSlateGray");
	sMsg += ListColorMsg("DarkTurquoise");
	sMsg += ListColorMsg("DarkViolet");
	sMsg += ListColorMsg("DeepPink");
	sMsg += ListColorMsg("DeepSkyBlue");
	sMsg += ListColorMsg("DimGray");
	sMsg += ListColorMsg("DodgerBlue");
	sMsg += ListColorMsg("Feldspar");
	sMsg += ListColorMsg("FireBrick");
	sMsg += ListColorMsg("FloralWhite");
	sMsg += ListColorMsg("ForestGreen");
	sMsg += ListColorMsg("Fuchsia");
	sMsg += ListColorMsg("Gainsboro");
	sMsg += ListColorMsg("GhostWhite");
	sMsg += ListColorMsg("GoldenRod");
	sMsg += ListColorMsg("Gold");
	sMsg += ListColorMsg("Gray");
	sMsg += ListColorMsg("GreenYellow");
	sMsg += ListColorMsg("Green");
	sMsg += ListColorMsg("HoneyDew");
	sMsg += ListColorMsg("HotbarDisabled");
	sMsg += ListColorMsg("HotbarItmNoUse");
	sMsg += ListColorMsg("HotbarText");
	sMsg += ListColorMsg("HotPink");
	sMsg += ListColorMsg("IndianRed");
	sMsg += ListColorMsg("Indigo");
	sMsg += ListColorMsg("ItemNotUseable");
	sMsg += ListColorMsg("ItemUseable");
	sMsg += ListColorMsg("Ivory");
	sMsg += ListColorMsg("Khaki");
	sMsg += ListColorMsg("LavenderBlush");
	sMsg += ListColorMsg("Lavender");
	sMsg += ListColorMsg("LawnGreen");
	sMsg += ListColorMsg("LemonChiffon");
	sMsg += ListColorMsg("LightBlue");
	sMsg += ListColorMsg("LightCoral");
	sMsg += ListColorMsg("LightCyan");
	sMsg += ListColorMsg("LightGoldenRodYellow");
	sMsg += ListColorMsg("LightGreen");
	sMsg += ListColorMsg("LightGrey");
	sMsg += ListColorMsg("LightPink");
	sMsg += ListColorMsg("LightSalmon");
	sMsg += ListColorMsg("LightSeaGreen");
	sMsg += ListColorMsg("LightSkyBlue");
	sMsg += ListColorMsg("LightSlateBlue");
	sMsg += ListColorMsg("LightSlateGray");
	sMsg += ListColorMsg("LightSteelBlue");
	sMsg += ListColorMsg("LightYellow");
	sMsg += ListColorMsg("LimeGreen");
	sMsg += ListColorMsg("Lime");
	sMsg += ListColorMsg("Linen");
	sMsg += ListColorMsg("Magenta");
	sMsg += ListColorMsg("Maroon");
	sMsg += ListColorMsg("MediumAquaMarine");
	sMsg += ListColorMsg("MediumBlue");
	sMsg += ListColorMsg("MediumOrchid");
	sMsg += ListColorMsg("MediumPurple");
	sMsg += ListColorMsg("MediumSeaGreen");
	sMsg += ListColorMsg("MediumSlateBlue");
	sMsg += ListColorMsg("MediumSpringGreen");
	sMsg += ListColorMsg("MediumTurquoise");
	sMsg += ListColorMsg("MediumVioletRed");
	sMsg += ListColorMsg("MidnightBlue");
	sMsg += ListColorMsg("MintCream");
	sMsg += ListColorMsg("MistyRose");
	sMsg += ListColorMsg("Moccasin");
	sMsg += ListColorMsg("NavajoWhite");
	sMsg += ListColorMsg("Navy");
	sMsg += ListColorMsg("OldLace");
	sMsg += ListColorMsg("OliveDrab");
	sMsg += ListColorMsg("Olive");
	sMsg += ListColorMsg("OrangeRed");
	sMsg += ListColorMsg("Orange");
	sMsg += ListColorMsg("Orchid");
	sMsg += ListColorMsg("PaleGoldenRod");
	sMsg += ListColorMsg("PaleGreen");
	sMsg += ListColorMsg("PaleTurquoise");
	sMsg += ListColorMsg("PaleVioletRed");
	sMsg += ListColorMsg("PapayaWhip");
	sMsg += ListColorMsg("PeachPuff");
	sMsg += ListColorMsg("Peru");
	sMsg += ListColorMsg("Pink");
	sMsg += ListColorMsg("Plum");
	sMsg += ListColorMsg("PowderBlue");
	sMsg += ListColorMsg("Purple");
	sMsg += ListColorMsg("Red");
	sMsg += ListColorMsg("RosyBrown");
	sMsg += ListColorMsg("RoyalBlue");
	sMsg += ListColorMsg("SaddleBrown");
	sMsg += ListColorMsg("Salmon");
	sMsg += ListColorMsg("SandyBrown");
	sMsg += ListColorMsg("SeaGreen");
	sMsg += ListColorMsg("SeaShell");
	sMsg += ListColorMsg("Sienna");
	sMsg += ListColorMsg("Silver");
	sMsg += ListColorMsg("SkyBlue");
	sMsg += ListColorMsg("SlateBlue");
	sMsg += ListColorMsg("SlateGray");
	sMsg += ListColorMsg("Snow");
	sMsg += ListColorMsg("SpringGreen");
	sMsg += ListColorMsg("SteelBlue");
	sMsg += ListColorMsg("Tan");
	sMsg += ListColorMsg("Teal");
	sMsg += ListColorMsg("TextNegative");
	sMsg += ListColorMsg("TextNeutral");
	sMsg += ListColorMsg("TextPositive");
	sMsg += ListColorMsg("Text");
	sMsg += ListColorMsg("Thistle");
	sMsg += ListColorMsg("Tomato");
	sMsg += ListColorMsg("Turquoise");
	sMsg += ListColorMsg("Unidentified");
	sMsg += ListColorMsg("V2.0");
	sMsg += ListColorMsg("VioletRed");
	sMsg += ListColorMsg("Violet");
	sMsg += ListColorMsg("Wheat");
	sMsg += ListColorMsg("WhiteSmoke");
	sMsg += ListColorMsg("White");
	sMsg += ListColorMsg("YellowGreen");
	sMsg += ListColorMsg("Yellow", "");
	SendMessageToPC(oPC, sMsg );
	//SendMessageToPC(oPC, "X"+"X");
	CSLInfoBox( oPC, "Emotes", "Available Emotes", sMsg );
}