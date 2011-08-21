/** @file
* @brief Include File for Dex Gravestone System
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/




// FUNCTIONS FOR ALTAR OF LIFE, GRAVES, BINDS AND PORT STONES HERE
// ALSO HAS SOME TRANSITIONAL FUNCTIONS FOR ON ENTER/EXIT AREA

// handles a lot of dex specific code for our gravestones, fugue plane and teleportation
// needs to be rewritten

//#include "_SCUtility"
#include "seed_db_inc"

/*
void BindPlayerToObject(object oPC, object oBind=OBJECT_INVALID);
void CheckAreaSpellsDeactivated(object oArea, object oPC);
void CheckTransAbuse(object oPC);
void ClearAreaSpellsDeactivated(object oArea, object oPC);
void ClearTransAbuse(object oPC);
void CreateTownPortal(object oItem, object oPC);
void DoPortInEffect(object oPC);
void DoPortOut(object oPC, location lPortTo);
int DropDeathGold(object oKiller, object oKilled);
int DropDeathXP(object oPC);
int GetDeathGold(object oPC);
int GetDeathXP(object oPC);
object GetGrave(object oPC);
object GetGraveOwner(object oGrave);
string GetGraveOwnerName(object oGrave);
int GetHasPrayed(object oPC);
int GetIsTeleporting(object oPC);
int GetPortalsDeactivated(object oObject);
int GetSpellsDeactivated(object oArea);
void GiveGraveGold(object oPC, object oGrave);
void GiveGraveXP(object oPC, string sMsg);
int HasReturnPortal(object oPC);
int IsWarpAllowed(object oPC, object oTargetArea );
void MakeGrave(object oPC);
void PortFromEthereal(object oPC, location lLoc);
void PortToEthereal(object oPC);
void RandomBolt(location lLoc);
location RandomLocation(location Center, int Radius);
void SetDeathGold(object oPC, int nGold);
void SetDeathXP(object oPC, int nXP);
void SetHasPrayed(object oPC, int nPrayed=FALSE);
void SetIsTeleporting(object oPC, int nSet=TRUE);
void SetPortalsDeactivated(object oObject, int nSet=TRUE);
void SetSpellsDeactivated(object oObject, int nSet=TRUE);
void UseBindStone(object oPC);
void UsePortStone(object oPC, object oItem);
void UseReturnPortal(object oPC);
void UseTownPortal(object oPC);
*/

int GetSpellsDeactivated(object oArea)
{
	return GetLocalInt(oArea, "SPELLS_DEACTIVATED");
}

void SetSpellsDeactivated(object oObject, int nSet=TRUE)
{
	if (nSet) SetLocalInt(oObject, "SPELLS_DEACTIVATED", TRUE);
	else DeleteLocalInt(oObject, "SPELLS_DEACTIVATED");
}

void CheckAreaSpellsDeactivated(object oArea, object oPC)
{
	if (GetSpellsDeactivated(oArea))
	{
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectSpellFailure()), oPC);
	}
}

void ClearAreaSpellsDeactivated(object oArea, object oPC)
{
	if (GetSpellsDeactivated(oArea))
	{
		CSLRemoveEffectByType(oPC, EFFECT_TYPE_SPELL_FAILURE, SUBTYPE_EXTRAORDINARY);
	}
}

int GetPortalsDeactivated(object oObject)
{
	return GetLocalInt(oObject, "PORTS_DEACTIVATED");
}

void SetPortalsDeactivated(object oObject, int nSet=TRUE)
{
	if (nSet) SetLocalInt(oObject, "PORTS_DEACTIVATED", TRUE);
	else DeleteLocalInt(oObject, "PORTS_DEACTIVATED");
}

int GetIsTeleporting(object oPC)
{
	return GetLocalInt(oPC, "PC_TELEPORTING");
}

void SetIsTeleporting(object oPC, int nSet=TRUE)
{
	if (nSet) SetLocalInt(oPC, "PC_TELEPORTING", TRUE); // FOR PORT IN EFFECTS ON AREA ENTER
	else DeleteLocalInt(oPC, "PC_TELEPORTING");
}

int IsWarpAllowed(object oPC, object oTargetArea )
{
	object oArea = GetArea(oPC);
	//SendMessageToPC(oPC, "Warp Check to " + GetName(oTargetArea) + ".");
	if ( !CSLGetCanTeleport( oPC ) )
	{
		SendMessageToPC( oPC, "You are Dimensionally Anchored");
		return FALSE;
	}
	
	if (GetPortalsDeactivated(oArea))
	{
		SendMessageToPC(oPC, "Sorry, you cannot port out of " + GetName(oArea) + ".");
		return FALSE;
	}
	if ( !CSLPCCanEnterArea( oPC, oTargetArea ) )
	{
		SendMessageToPC(oPC, "Sorry, you are too high to enter " + GetName( oTargetArea ) + ".");
		return FALSE;
	}
	if (GetPortalsDeactivated(oPC)) {
		SendMessageToPC(oPC, "Sorry, you cannot port at this time.");
		return FALSE;
	}
	if (CSLGetIsEnemyClose(oPC, 25.0) || CSLGetIsHostilePCClose(oPC, 25.0))
	{
		SendMessageToPC(oPC, "A nearby enemy broke your concentration");
		return FALSE;
	}
	//SendMessageToPC(oPC, "Passed.");
	return TRUE;
}

void UseTownPortal(object oPC)
{
	object oPortal = OBJECT_SELF;
	location lWP = GetLocation(GetObjectByTag(GetLocalString(oPortal, "DESTINATION")));
	if ( IsWarpAllowed( oPC, GetAreaFromLocation( lWP ) ) )
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_teleport.sef"), oPC);
		
		location lPortal = GetLocation(oPortal);
		SetLocalLocation(oPC, "PORTAL_RETURN", lPortal);
		effect eDisappear = EffectNWN2SpecialEffectFile("fx_altargen");
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDisappear, lPortal, 5.0f);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), GetLocation(oPortal));
		AssignCommand(oPC, ActionJumpToLocation(lWP));
		int nUses = CSLDecrementLocalInt(oPortal, "USES", 1);
		if (nUses<1) DestroyObject(oPortal);
	}
}

void UseReturnPortal(object oPC)
{
	location lReturn = GetLocalLocation(oPC, "PORTAL_RETURN");
	SendMessageToPC(oPC, "Returning.");
	if ( IsWarpAllowed(oPC, GetAreaFromLocation( lReturn ) ) )
	{  
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_teleport.sef"), oPC);
		AssignCommand(oPC, JumpToLocation(lReturn));
		DeleteLocalLocation(oPC, "PORTAL_RETURN");
	}	
}

int HasReturnPortal(object oPC)
{
	location lReturn = GetLocalLocation(oPC, "PORTAL_RETURN");
	string sName = GetName(GetAreaFromLocation(lReturn));
	return (sName != "");
}

void DestroyPortal(object oPortal)
{
	if (oPortal==OBJECT_INVALID) return;
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_AOE_NECROMANCY), GetLocation(oPortal));
	DestroyObject(oPortal);
}

void CreateTownPortal(object oItem, object oPC)
{
	location lTP = GetItemActivatedTargetLocation();
	if ( IsWarpAllowed(oPC, GetAreaFromLocation( lTP ) ) )
	{  
		effect ePortalAppear = EffectNWN2SpecialEffectFile("fx_magical_explosion.sef");
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePortalAppear, lTP);
		object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, "townportal", lTP);
		SetLocalInt(oPortal, "USES", 3);
		SetLocalString(oPortal, "DESTINATION", "wp_" + GetResRef(oItem)); // READ RESREF OF SCROLL, THERE SHOULD BE A WP WITH THIS TAP AS THE ENDPOINT
		SetFirstName(oPortal, GetName(oItem));
		effect ePortal = EffectNWN2SpecialEffectFile("fx_song_portal.sef");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePortal, oPortal);
	  DelayCommand(15.0, DestroyPortal(oPortal));
	}
}

void BindPlayerToObject(object oPC, object oBind=OBJECT_INVALID)
{
	SDB_OnPCBind(oPC, oBind); // SAVE TO DATABASE
	effect ePoof = EffectNWN2SpecialEffectFile("fx_magical_explosion.sef");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePoof, GetLocation(oPC));
	AssignCommand(oPC, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
	DelayCommand(2.5, FloatingTextStringOnCreature("You are now bound in "+GetName(GetArea(oPC)), oPC, FALSE));
}

void DoPortInEffect(object oPC)
{
	if (GetIsTeleporting(oPC))
	{
		string sSEF = "sp_summon_creature_1.sef";
		switch (GetAlignmentGoodEvil(oPC))
		{
			case ALIGNMENT_EVIL:
				sSEF = "portin_evil.sef";
				break;
			case ALIGNMENT_GOOD:
				sSEF = "portin_good.sef";
				break;
			case ALIGNMENT_NEUTRAL:
				sSEF = "portin_neutral.sef";
				break;
		}
		DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sSEF), GetLocation(oPC)));
		SetIsTeleporting(oPC, FALSE);
	}
}

void DoPortOut(object oPC, location lPortTo) {
	
	if (IsWarpAllowed(oPC, GetAreaFromLocation( lPortTo ) ))
	{
		SetIsTeleporting(oPC, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_teleport.sef"), oPC);
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 5.0));
		DelayCommand(1.0, AssignCommand(oPC, JumpToLocation(lPortTo)));
	}
}

void UsePortStone(object oPC, object oItem)
{
	//SendMessageToPC(oPC, "Using Port Stone");
	string sTag = GetResRef(oItem); //GetLocalString(oItem, "DESTINATION");
	object oWP = GetObjectByTag(sTag); // MAKE A WAYPOINT WITH A TAG = RESREF OF STONE SINCE VARIABLE DON"T WORK
	location lPortTo = GetLocation(oWP);
	DoPortOut(oPC, lPortTo);
}

void UseBindStone(object oPC)
{
	DoPortOut(oPC, SDB_GetBind(oPC));
}

int GetHasPrayed(object oPC)
{
	return GetLocalInt(oPC, "ALTARPRAYED");
}

void SetHasPrayed(object oPC, int nPrayed=FALSE) {
	SetLocalInt(oPC, "ALTARPRAYED", nPrayed);
}

object GetGrave(object oPC)
{
	return GetLocalObject(oPC, "GRAVE");
}

int GetDeathGold(object oObject)
{
	return GetLocalInt(oObject, "DEATHGOLD");
}

void SetDeathGold(object oObject, int nGold)
{
	if (nGold) SetLocalInt(oObject, "DEATHGOLD", nGold);
	else DeleteLocalInt(oObject, "DEATHGOLD");
}

int GetDeathXP(object oObject)
{
	return GetLocalInt(oObject, "DEATHXP");
}

void SetDeathXP(object oObject, int nXP)
{
	if (nXP) SetLocalInt(oObject, "DEATHXP", nXP);
	else DeleteLocalInt(oObject, "DEATHXP");
}


int DropDeathXP(object oPC)
{
	int nXPTaken = 0;
	int iHD = CSLGetRealLevel(oPC);
	if (iHD>=5) { // OVER LEVEL 5 LOSES XP ON DEATH
		int nXP = GetXP(oPC);
		int nXPMinLevel = CSLGetXPByLevel(iHD); // CANNOT DROP BELOW LAST TAKEN LEVEL
		nXPTaken = 50 * iHD;
		if (GetIsPC(GetLocalObject(oPC, "LASTKILLER"))) nXPTaken /= 2;
		nXPTaken = CSLGetMin(nXPTaken, nXP - nXPMinLevel);
		if (nXPTaken) {
			SetXP(oPC, nXP - nXPTaken);
			FloatingTextStrRefOnCreature(58299, oPC, FALSE);
		}
	}
	return nXPTaken;
}

void MakeGrave(object oPC)
{
	int nXP = DropDeathXP(oPC);
	string sName = GetName(oPC);
	DestroyObject(GetGrave(oPC));// DESTROY OLD GRAVE
	object oGrave = CreateObject(OBJECT_TYPE_PLACEABLE, "dp_gravestone", GetLocation(oPC), FALSE); // CREATE NEW GRAVE
	SetFirstName(oGrave, "R.I.P. " + sName);
	SetLocalObject(oGrave, "OWNER", oPC); // SAVE PLAYER NAME ON GRAVE
	SetLocalString(oGrave, "OWNERNAME", sName); // SAVE PLAYER NAME ON GRAVE
	SetDeathGold(oGrave, GetDeathGold(oPC) / 2); // CAN RECOVER 1/2 GOLD
	SetDeathXP(oPC, nXP / 2); // CAN RECOVER 1/2 XP
	SetLocalObject(oPC, "GRAVE", oGrave); // SAVE GRAVE ON PC
	SetHasPrayed(oPC, FALSE); // CAN PRAY AT ALTAR OF LIFE AGAIN
}

string GetGraveOwnerName(object oGrave)
{
	return GetLocalString(oGrave, "OWNERNAME");
}

object GetGraveOwner(object oGrave)
{
	return GetLocalObject(oGrave, "OWNER");
}

void GiveGraveXP(object oPC, string sMsg)
{
	int nDeathXP = GetDeathXP(oPC);
	if (nDeathXP > 0)
	{
		SetXP(oPC, GetXP(oPC)+nDeathXP);
		FloatingTextStringOnCreature(sMsg, oPC);
		FloatingTextStringOnCreature(IntToString(nDeathXP)+" XP", oPC);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oPC);
		DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
	}
}

void GiveGraveGold(object oPC, object oGrave)
{
	int nGold = GetDeathGold(oGrave);
	if (nGold > 0) {
		GiveGoldToCreature(oPC, nGold);
		FloatingTextStringOnCreature("You recovered " + IntToString(nGold) + " gold.", oPC);
	}
}

location RandomLocation(location Center, int Radius){
	 vector vCenterXYZ = GetPositionFromLocation(Center);
	 object LArea = GetAreaFromLocation(Center);
	 float RandomX = IntToFloat(Random(Radius)) / 10;
	 float RandomY = IntToFloat(Random(Radius)) / 10;
	 if (d2()==1) RandomX = -(RandomX);
	 if (d2()==1) RandomY = -(RandomY);
	 float vX = vCenterXYZ.x + RandomX;
	 float vY = vCenterXYZ.y + RandomY;
	 vector VLoc = Vector(vX, vY, 0.0);
	 float Pos = IntToFloat(Random(359) + 1);
	 return Location(LArea, VLoc, Pos);
}

void RandomBolt(location lLoc){
	 ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), RandomLocation(lLoc, 100));
}

void PortToEthereal(object oPC) {
	location lLoc = GetLocation(GetObjectByTag("EtherealPlaneEntry"));
	AssignCommand(oPC, JumpToLocation(lLoc));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
	CloseGUIScreen( oPC, GUI_DEATH );
		CloseGUIScreen( oPC, GUI_DEATH_HIDDEN );
		CSLEnviroRemoveEffects( oPC, TRUE );
	
}

void PortFromEthereal(object oPC, location lLoc)
{
	location lPC = GetLocation(oPC);
	CSLSetLastRest(oPC, 0); // CLEAR REST FLAG
	AssignCommand(GetNearestObjectByTag("nullcaster"), ActionCastFakeSpellAtLocation(SPELL_EARTHQUAKE, lPC));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_SPELL_DUR_CALL_LIGHTNING), oPC, 3.0);
	DelayCommand(0.5, AssignCommand(oPC, ClearAllActions()) );
	int i;
	for (i=0;i<3;i++) //random lightning
	{
		DelayCommand(IntToFloat(Random(300)) / 100, RandomBolt(lPC));
	}
	DelayCommand(2.0, RandomBolt(lPC));
	DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oPC));
	DelayCommand(2.8, RandomBolt(lPC));
	DelayCommand(2.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)-10, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPC));
	DelayCommand(3.0, AssignCommand(oPC, JumpToLocation(lLoc)));
	 DelayCommand(1.0, CSLEnviroRemoveEffects( oPC, TRUE ) );
}



int DropDeathGold(object oKiller, object oKilled)
{
	int nGoldTaken = 0;
	int iHD = CSLGetRealLevel(oKilled);
	if (iHD>=5) { // OVER LEVEL 5 LOSES GOLD ON DEATH
		nGoldTaken = CSLGetMin(iHD * 500, FloatToInt(0.10 * GetGold(oKilled))); // * MAX 500GP PER LEVEL TAKEN
		if (nGoldTaken)
		{
			TakeGoldFromCreature(nGoldTaken, oKilled, TRUE);
			FloatingTextStrRefOnCreature(58300, oKilled, FALSE);
			if (GetIsPC(oKiller) || GetLocalInt(oKiller, "BOSS"))  // IF PC OR BOSS KILLED YOU, THEY GET YOUR GOLD
			{
				GiveGoldToCreature(oKiller, nGoldTaken);
				nGoldTaken = 0;
			}
		}
	}
	SetDeathGold(oKilled, nGoldTaken); // SAVE THE GOLD LOST FOR USE IN THE GRAVE SCRIPT
	return nGoldTaken;
}



// Display death pop-up to oPC
void ShowDeathScreen(object oPC)
{
	int nDeaths = GetLocalInt(oPC, SDB_DEATHS);
	object oKiller = CSLGetKiller(oPC);
	string sMsg = GetName(oKiller);
	if (sMsg!="") sMsg = " by " + sMsg;
	sMsg = "You have been killed" + sMsg + ".\n";
	if (GetIsPC(oKiller))
	{
		string sKPLID = SDB_GetPLID(oKiller);
		string sDPLID = SDB_GetPLID(oPC);
		string sKCnt = "(pp_kplid=" + sKPLID + " and pp_plid=" + sDPLID + ")";
		string sPCnt = "(pp_plid=" + sKPLID + " and pp_kplid=" + sDPLID + ")";
		string sSQL = "select sum"+sKCnt+", sum"+sPCnt+" from playervsplayer where "+sKCnt+" or "+sPCnt;
		CSLNWNX_SQLExecDirect(sSQL);
		if (CSLNWNX_SQLFetch()!= CSLSQL_ERROR)
		{
			sKCnt = CSLNWNX_SQLGetData(1);
			sPCnt = CSLNWNX_SQLGetData(2);
			string sSex = GetGender(oKiller)==GENDER_MALE ? "He" : "She";
			FloatingTextStringOnCreature(sSex + " has killed you " + sKCnt + CSLAddS(" time", StringToInt(sKCnt)) + ".", oPC);
			sSex = GetGender(oKiller)==GENDER_MALE ? "Him" : "Her";
			FloatingTextStringOnCreature("You have killed " + sSex + " " + sPCnt + CSLAddS(" time", StringToInt(sPCnt)) + ".", oPC);
		}
	}
	if (nDeaths) sMsg += " You have died " + IntToString(nDeaths) + CSLAddS(" time", nDeaths) + ".";
	SetGUIObjectText(oPC, GUI_DEATH, "MESSAGE_TEXT", -1, sMsg);
	SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_LOAD_GAME", TRUE);
	SetGUIObjectHidden(oPC, GUI_DEATH, "BUTTON_EXIT", TRUE);
	DisplayGuiScreen(oPC, GUI_DEATH, FALSE, "partydeath.xml"); // DISPLAY POP-UP NON-MODAL
}