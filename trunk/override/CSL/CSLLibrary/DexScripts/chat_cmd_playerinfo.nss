//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_faction"

void main()
{
	object oPC = CSLGetChatSender();
	object oGetInfoFrom = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	if ( !GetIsObjectValid(oGetInfoFrom) )
	{
		SendMessageToPC(oPC, "Please Select a valid Player via tell or targeting them.");
		return;
	}
	   //collect info
   int bSelfDMorAdmin = (CSLVerifyDMKey(oPC) || CSLVerifyAdminKey(oPC) || (oPC==oGetInfoFrom));
	string sMessage;
	
	if ( !GetIsPC( oGetInfoFrom ) && !bSelfDMorAdmin )
	{
		 string sMessage = "<color=orange>Player Information:</color>\n";
	   sMessage += "<color=orange>Name: </color><color=white>"+CSLGetMyName(oGetInfoFrom)+"</color>\n";
		
		SendMessageToPC(oPC, sMessage);
		return;
	}
	/*
	if ( !GetObjectType(oGetInfoFrom) != OBJECT_TYPE_CREATURE )
	{
		SendMessageToPC(oPC, "Please Select a valid Player via tell or targeting them.");
		return;
	}*/
	
   string sName = CSLGetMyName(oGetInfoFrom);
   string sPlayername = CSLGetMyPlayerName(oGetInfoFrom); //GetPCPlayerName(oGetInfoFrom);
   string sKey = CSLGetMyPublicCDKey(oGetInfoFrom); //GetPCPublicCDKey(oGetInfoFrom);
   string sIP = CSLGetMyIPAddress(oGetInfoFrom); //GetPCIPAddress(oGetInfoFrom);
   string sFactionMembers = "";
   string sClasses = CSLClassLevels(oGetInfoFrom, FALSE, bSelfDMorAdmin);
   int nGold = GetGold(oGetInfoFrom);
   int nGoldTotal, iValue, nX;
   if (bSelfDMorAdmin) { // DON'T SUM UP INVENTORY IF NOT GONNA SEE IT
      object oLeader = GetFactionLeader(oGetInfoFrom);
      object oMember = GetFirstFactionMember(oGetInfoFrom);
      while (GetIsObjectValid(oMember)) {
        if (oMember==oLeader) sFactionMembers = "<color=black>"+GetName(oMember)+"</color><color=cornflowerblue> [ Level "+IntToString(GetHitDice(oMember))+"] </color><color=orange> [Party Leader]</color>\n"+sFactionMembers;
        else sFactionMembers = sFactionMembers+"<color=black>"+GetName(oMember)+"</color><color=cornflowerblue> [Level "+IntToString(GetHitDice(oMember))+"] </color>\n";
        oMember = GetNextFactionMember(oGetInfoFrom);
      }
      object oItem = GetFirstItemInInventory(oGetInfoFrom);
      while (GetIsObjectValid(oItem))
      {
         iValue = GetGoldPieceValue(oItem);
         nGoldTotal += iValue;
         oItem = GetNextItemInInventory(oGetInfoFrom);
      }
      for (nX = 0; nX < 14; nX++)
      {
         oItem = GetItemInSlot(nX, oGetInfoFrom);
         iValue = GetGoldPieceValue(oItem);
         nGoldTotal += iValue;
      }
      nGoldTotal += nGold;
   }
   //string xxx = SDB_GetFMID(oPC);
   int iLevel = GetHitDice(oGetInfoFrom);
   string sSubrace = CSLGetFullRaceName(oGetInfoFrom);
   string sFaction = SDB_GetFAID(oGetInfoFrom);
   sFaction = (sFaction!="0") ? SDB_FactionGetName(sFaction) : "None";
   if (sSubrace=="") sSubrace = "None";
   int nXP = GetXP(oGetInfoFrom);
   int nNextXP = (( iLevel * ( iLevel + 1 )) / 2 * 1000 );
   int nXPForNextLevel = nNextXP - nXP;
   if (iLevel==30) nXPForNextLevel = 0;
   sMessage = "<color=orange>Player Information:</color>\n";
   sMessage += "<color=orange>Name: </color><color=black>"+sName+"</color>\n";
   sMessage += "<color=orange>Playername: </color><color=black>"+sPlayername+"</color>\n";
   sMessage += "<color=orange>Faction: </color><color=black>"+sFaction+"</color>\n";
   sMessage += "<color=orange>Total Levels</color>"+IntToString(iLevel)+"\n";
   sMessage += "<color=orange>Max Class: </color>"+sClasses+"\n";
   sMessage += "<color=orange>Subrace: </color><color=slateblue>"+sSubrace+"</color>\n";
   string sPKed = "  Killed: " + IntToString(GetLocalInt(oGetInfoFrom, SDB_PKED));
   string sPKer = "  Kills: " + IntToString(GetLocalInt(oGetInfoFrom, SDB_PKER));
   sMessage += "<color=orange>PvP:</color><color=palegreen>"+sPKer+"</color>" + "<color=indianred>"+sPKed+"</color>\n";
   if (bSelfDMorAdmin) {
      sMessage += "<color=orange>CD Key: </color><color=black>"+sKey+"</color>\n";
      sMessage += "<color=orange>IP: </color><color=black>"+sIP+"</color>\n";
      sMessage += "<color=orange>Experience: </color><color=yellow>"+IntToString(nXP)+"</color>\n";
      sMessage += "<color=orange>Experience Needed for Next Level: </color><color=indianred>"+IntToString(nXPForNextLevel)+"</color>\n";
      if ( CSLGetIsDM(oPC) || CSLVerifyAdminKey(oPC) )
      {
      	sMessage += "<color=orange>Area: </color><color=palegreen>"+GetName(GetArea(oGetInfoFrom))+"</color>\n";
      }
      sMessage += "<color=orange>Party: </color>"+sFactionMembers;
      sMessage += "<color=orange>Gold: </color><color=gold>"+IntToString(nGold)+"</color>\n";
      sMessage += "<color=orange>Net Worth: </color><color=gold>"+IntToString(nGoldTotal)+"</color>\n";
   }
   //SendMessageToPC(oPC, sMessage);
   
   CSLInfoBox( oPC, "Player Info", GetName(oGetInfoFrom)+ " Player Info", sMessage );

}