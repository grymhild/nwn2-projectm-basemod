/** @file
* @brief Include file for Dex Arena scripts
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_SCInclude_Graves"
//#include "dmfi_inc_conv"

const string TEAM1_LIST = "TEAM_1";
const string TEAM2_LIST = "TEAM_2";
const string TEAMS_LIST = "TEAM_BOTH";
object oLIST_OWNER = GetModule();

string SCTeamGetList(string sTeam)
{
   if (sTeam=="1") return TEAM1_LIST;
   return TEAM2_LIST;
}

void SCTeamClear(string sTeam)
{
   CSLDataArray_DeleteEntire( oLIST_OWNER, SCTeamGetList(sTeam) );
}

void SCTeamAdd(object oPC, string sTeam)
{
   CSLDataArray_PushObject( oLIST_OWNER, SCTeamGetList(sTeam), oPC  );
   CSLDataArray_PushObject( oLIST_OWNER, TEAMS_LIST, oPC );
   SetLocalString(oPC, TEAMS_LIST, sTeam);
}

string SCTeamGetColor(string sTeam)
{
   if (sTeam=="1") return "<color=pink>";
   return "<color=limegreen>";
}

int SCTeamIsMember(object oPC, string sTeam)
{
	object oCheck = CSLDataArray_FirstObject( oLIST_OWNER, SCTeamGetList(sTeam) );
	while (GetIsObjectValid(oCheck))
	{
      if (oCheck==oPC) return TRUE;
      oCheck = CSLDataArray_NextObject(oLIST_OWNER, SCTeamGetList(sTeam));
	}
	return FALSE;
}

string SCTeamPlayerInfo(object oPC, string sTeam)
{
	string sText = "";
	sText += SCTeamGetColor(sTeam) + GetName(oPC) + "</color>";
	sText += "AC " + IntToString(GetAC(oPC));
	sText += " / HP " + IntToString(GetMaxHitPoints(oPC));
	sText += " / AB " + IntToString(GetTRUEBaseAttackBonus(oPC));
	sText += " " + CSLClassLevels(oPC, TRUE, FALSE);
	sText += " <color=brown>" + CSLGetSubraceName(GetSubRace(oPC));
	sText += " " + IntToString(GetHitDice(oPC)) + "</color>";
	return sText;
}

string SCTeamList(string sTeam, string sIndent="")
{
   object oPC = CSLDataArray_FirstObject( oLIST_OWNER, SCTeamGetList(sTeam));
   string sText = "";
   while (GetIsObjectValid(oPC))
   {
      sText += sIndent + SCTeamPlayerInfo(oPC, sTeam ) + "\n";
      oPC = CSLDataArray_NextObject( oLIST_OWNER, SCTeamGetList(sTeam) );
   }
   return sText;
}

void SCSpeakIt(object oPC, string sMsg)
{
	AssignCommand(oPC, SpeakString(sMsg));
	SendMessageToPC(oPC, sMsg);
}

void SCTeamPort(object oDM, string sTeam, string sArenaSide, int iVFX, string sAura)
{
	object oPortal = GetObjectByTag("ARENA_TEAM_" + sTeam + "_START");
	object oDest = GetObjectByTag("ARENA_TEAM_" + sTeam + "_" + sArenaSide + "_WP");
	SCTeamClear(sTeam);
	location lPortal = GetLocation(oPortal);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iVFX), lPortal);
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPortal);
	while (GetIsObjectValid(oPC))
	{
		SCTeamAdd(oPC, sTeam);
		AssignCommand(oPC, ClearAllActions(TRUE));
		AssignCommand(oPC, JumpToObject(oDest));
		SCSpeakIt(oDM, "     " + SCTeamPlayerInfo(oPC, sTeam));
		SetLocalLocation(oPC, "ARENA_PORTAL", lPortal);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectNWN2SpecialEffectFile(sAura), oPC);
		oPC = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPortal);
   }
}

void SCStartBattle(string sArenaSide="1") {
	object oSwitch = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	if (!GetIsDM(oPC))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM), oPC);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oPC);
		return;
	}
   CSLToggleOnOff(OBJECT_SELF, TRUE);
   DelayCommand(10.0, CSLToggleOnOff(OBJECT_SELF, FALSE)); //TURN OFF IN 10 SECS

   SCSpeakIt(oPC, "Team 1:");
   SCTeamPort(oPC, "1", sArenaSide, VFX_FNF_SUMMON_GATE, "fx_arena_blue_team.sef");
   SCSpeakIt(oPC, "Team 2:");
   SCTeamPort(oPC, "2", sArenaSide, VFX_FNF_SUMMON_UNDEAD, "fx_arena_red_team.sef");

   PlaySound("as_cv_bell2");

}

int SCGetIsInArena(object oPC) {
   return GetLocalInt(GetArea(oPC), "ARENA");
}

void SCShowArenaDeathScreen(object oPC) {
   object oKiller = CSLGetKiller(oPC);
   string sMsg = GetName(oKiller);
   if (sMsg!="") sMsg = " by " + sMsg;
   sMsg = "You have been killed" + sMsg + ".\nThere is no penalty for death in " + GetName(GetArea(oPC)) + ".";
   SetGUIObjectText(oPC, GUI_DEATH, "MESSAGE_TEXT", -1, sMsg);
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_LOAD_GAME", TRUE);
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_EXIT", TRUE);
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_WAIT_FOR_HELP", TRUE);
   DisplayGuiScreen(oPC, GUI_DEATH, FALSE); // DISPLAY POP-UP NON-MODAL
}

void SCShowBashDeathScreen(object oPC) {
   object oKiller = CSLGetKiller(oPC);
   string sMsg = GetName(oKiller);
   if (sMsg!="") sMsg = " by " + sMsg;
   sMsg = "You have been killed" + sMsg + ".\nHowever this is a Bash, so you will be raised in 60 seconds.";

   sMsg = "The Bash Killed You, You'll Be Raised In 60 Seconds";
   
   
   // You have been killed" + sMsg + ".\nHowever this is a Bash, so you will be raised in 60 seconds.";

	  
   SetGUIObjectText(oPC, GUI_DEATH, "MESSAGE_TEXT", -1, sMsg);
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_LOAD_GAME", TRUE);
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_EXIT", TRUE);
   //
   /*
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_WAIT_FOR_HELP", TRUE);
   */
   DisplayGuiScreen(oPC, GUI_DEATH, FALSE); // DISPLAY POP-UP NON-MODAL
}

/*
SetGUIObjectText(oPC, GUI_DEATH, "MESSAGE_TEXT", -1, sMsg);
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_LOAD_GAME", TRUE);
   SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_EXIT", TRUE);
   DisplayGuiScreen(oPC, GUI_DEATH, FALSE); // DISPLAY POP-UP NON-MODAL
*/


void SCPortToArenaStart(object oPC)
{
   location lLoc = GetLocation(GetObjectByTag("WP_ARENA_ENTRY"));
   AssignCommand(oPC, ClearAllActions());
   AssignCommand(oPC, JumpToLocation(lLoc));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
   CloseGUIScreen( oPC, GUI_DEATH );
   CloseGUIScreen(oPC, GUI_DEATH_HIDDEN);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
}

void SCPortPCToArena(object oPC)
{
   object oLock = GetObjectByTag("ARENA_PORT_DISABLE");
   if (CSLGetOnOff(oLock)) { // DM HAS AREA LOCKED, CHECK IF HE IS STILL THERE
      object oArea = GetArea(oLock);
      object oDM = GetFirstObjectInArea(oArea);
      while (oDM!=OBJECT_INVALID) {
         if (GetObjectType(oDM)==OBJECT_TYPE_CREATURE && GetIsDM(oDM)) {
            SendMessageToPC(oPC, "Sorry, a DM has the Arena locked and you cannot port in.");
           return;
         }
         oDM = GetNextObjectInArea(oArea);
      }
     CSLToggleOnOff(oLock, FALSE); // NO DM IN AREA, UNLOCK IT
   }
   object oLocator = GetObjectByTag("WP_ARENA_ENTRY");
   location lLoc = GetLocation(oLocator);
   DoPortOut(oPC, lLoc);
}

void SCPortPCToArea1(object oPC)
{
   string sWP;   
   sWP = "WP_Area1_DB";
   object oLocator = GetObjectByTag(sWP);
   location lLoc = GetLocation(oLocator);
   DoPortOut(oPC, lLoc);
}

void SCPortPCToBattlefield(object oPC) {
   string sWP;   
   sWP = "WP_BATTLEFIELD" + IntToString(d4());
   object oLocator = GetObjectByTag(sWP);
   location lLoc = GetLocation(oLocator);
   DoPortOut(oPC, lLoc);
}