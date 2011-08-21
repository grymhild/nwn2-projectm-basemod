/**************************************************
//DMFI
//gui_dmfi_trgtool por Qk
	A lot of new functions 
// 08/10/07
****************************************************/
#include "_SCInclude_DMFI"

void main(string sValue, int n = 0)
{
	object oPC = OBJECT_SELF;
	object oTarget = GetPlayerCurrentTarget(OBJECT_SELF);
	if (!CSLGetIsDM(oPC))
	{
		return;
	}
	
	if (sValue == "close")
	{
		CloseGUIScreen(oPC, SCREEN_DMFI_TRGTOOL);
	}
	else if (sValue == "SERVER_TOOL")
	{
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT1",TRUE);
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT2",FALSE);
	}
	else if (sValue == "OBJECT_TOOL")
	{
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT2",TRUE);
		SetGUIObjectHidden(oPC,SCREEN_DMFI_TRGTOOL,"DMFI_ROOT1",FALSE);
	}
	else if (sValue == "REPORT_LOCATION")
	{
		SeeParty(oPC);
	}
	else if (sValue == "MNGR_TOOL")
	{
		DisplayGuiScreen(oPC,SCREEN_DMFI_MNGRTOOL,FALSE,"dmfimngrtool.xml");
	}
	else if (sValue =="GET_OUT")
	{
		ExecuteScript("gr_outofmyway",oPC);
	}
	else if (sValue =="PORTAL_A")
	{
		DoPortal(GetLocation(oTarget),1);
	}
	else if (sValue =="PORTAL_B")
	{
		DoPortal(GetLocation(oTarget),0);
	}
	else if (sValue =="DESTROY_PORT")
	{
		DestroyPortals();
	}
	else if (sValue =="MSGALL_POPUP")
	{
		SetLocalInt(oPC,"DMFIPOPUPMODE",0);
		DisplayGuiScreen(oPC,SCREEN_DMFI_DESC,FALSE,"dmfitextdesc.xml");
	}
	else if (sValue =="MSGPARTY_POPUP")
	{
		SetLocalInt(oPC,"DMFIPOPUPMODE",1);
		DisplayGuiScreen(oPC,SCREEN_DMFI_DESC,FALSE,"dmfitextdesc.xml");
	}
	else if (sValue == "JUMP_PARTY")
	{
		JumpParty(oTarget,oPC);
	}
	else if (sValue == "JUMP_ALLPLAYERS")
	{
		JumpAllPlayers(oPC);
	}
	else if (sValue == "JUMP_TOLEADER")
	{
		ExecuteScript("gr_jumpleader",oTarget);
	}
	else if (sValue == "DESTROY_PLAC")
	{
		if (GetObjectType(oTarget)!=64) return;
		DestroyPlaceables(oTarget);
	}
	else  //POPUP OPTIONS
	{
		string sText = DMFI_POPUPMESSAGE+sValue;
		SetGUIObjectText(oPC,SCREEN_DMFI_DESC, "inputdescbox", -1, "");
		CloseGUIScreen(oPC,SCREEN_DMFI_DESC);
		int iMode = GetLocalInt(oPC,"DMFIPOPUPMODE");
		DeleteLocalInt(oPC,"DMFIPOPUPMODE");
		if(iMode == 0)
		{
			SendPopupAllPlayers(sText);
		}
		else if(iMode ==1)
		{
			SendPopupParty(sText,oTarget);
		}
	}
}