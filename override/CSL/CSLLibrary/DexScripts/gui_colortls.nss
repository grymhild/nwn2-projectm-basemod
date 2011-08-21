//*/////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------ 
// gui_color_tls - Elechos - Script de GUI : Calcule une couleur RGB grace 
//								aux valeurs envoyé en TLS
// Scripteur:  Tyrnis
// Dernière Modification : 08 / 12 / 2007
//------------------------------------------------------------------------------
//*/////////////////////////////////////////////////////////////////////////////


#include "nwnx_craft_system"

void main (int iTint, int iLuminosity, int iSaturation )
{
	//XPCraft_Debug(OBJECT_SELF,"TLS : \n T = " + IntToString(iTeinte) + "\n L = " + IntToString(iLuminosite) + "\n S = " + IntToString(iSaturation));
	object oPC = OBJECT_SELF;
	// SendMessageToPC(GetFirstPC(), "value of color set to \n"+ "TLS : \n T = " + IntToString(iTeinte) + "\n L = " + IntToString(iLuminosite) + "\n S = " + IntToString(iSaturation) ); 
	SpeakString("Running Script Color"); //value of color set to \n"+ "TLS : \n T = " + IntToString(iTeinte) + "\n L = " + IntToString(iLuminosite) + "\n S = " + IntToString(iSaturation) ); 
	SendMessageToPC(oPC, "Running Script Color");
	struct strTint strMyTint = XPCraft_HLSToTintStruct(iTint, iLuminosity, iSaturation);
	int iNewColorValue =  XPCraft_strTintToInt(strMyTint);
	SetLocalObject(oPC, "XC_ITEM_TO_CRAFT", XPCraft_ActionChangeColor(oPC, iNewColorValue));
		
}