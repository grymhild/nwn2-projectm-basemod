//#include "gen_inc_color"
#include "seed_db_inc"
//#include "dmfi_inc_sendtex"
//#include "cmi_player_levelup"
//#include "_HkSpell"
#include "_SCInclude_Class"
#include "_CSLCore_Items"
//#include "nw_i0_plot"
#include "_SCInclude_Events"


void main()
{
   object oPC = GetPCLevellingUp();
   SetLocalInt( oPC, "SC_HitDice", 0 );
   
   int iLevel = GetHitDice(oPC);
	
   SDB_OnPCLevelUp(oPC);
	
   cmi_levelup( oPC );
   
   string sMsg = CSLColorText(GetName(oPC)+" has advanced to level "+ IntToString(iLevel), COLOR_GREEN);
   FloatingTextStringOnCreature(sMsg, oPC);
   if ( GetHitDice(oPC)==30-CSLGetRaceDataECLCap( GetSubRace(oPC) ))
   {
      int nXP = SDB_GetPCBankXP(oPC);
      sMsg = CSLSexString(oPC, "He", "She");
      sMsg = CSLColorText("All Hail " + GetName(oPC)+" the " + CSLGetSubraceName(GetSubRace(oPC)) + "! " + sMsg + " has attained max level " + IntToString(iLevel) + " and claimed " + IntToString(nXP) + " cached XP.", COLOR_CYAN);
      CSLShoutMsg(sMsg);
   }
   else if (iLevel % 5 == 0)
   {
      CSLShoutMsg(sMsg);
   }
	
	/*
	if ( iLevel == 13 && !CSLHasItemByTag(oPC, "dex_skullhelm") )
	{
		SendMessageToPC(oPC, "HAPPY HALLOWEEN! You have hit the unlucky level, and as such get a special halloween mask on this unlucky day.");
		
		object oMask = CreateItemOnObject("dex_skullhelm", oPC, 1);    // Skull Helm
		SetIdentified(oMask, TRUE);
		DelayCommand( 6.0f, AssignCommand(oPC, ActionEquipItem(oMask, INVENTORY_SLOT_HEAD)));
	
	}
	*/
	
	// ExecuteScript( "cmi_player_levelup", OBJECT_SELF );
	
	
   if (!GetHasFeat(FEAT_EPITHET_SHADOWTHIEFAMN, oPC))
   {
      int nBluff = GetSkillRank(SKILL_BLUFF, oPC, TRUE);
      int nHide = GetSkillRank(SKILL_HIDE, oPC, TRUE);
      int nMoveSilent = GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE);
      int nInitimidate = GetSkillRank(SKILL_INTIMIDATE, oPC, TRUE);
      int bStealthy = GetHasFeat(FEAT_STEALTHY, oPC);
      if (nBluff>=3 && nHide>=8 && nMoveSilent>=3 && nInitimidate>=3 && bStealthy)
      {
         FeatAdd(oPC, FEAT_EPITHET_SHADOWTHIEFAMN, FALSE);
         FloatingTextStringOnCreature("You have been contacted by the Shadow Thieves about joining the guild.", oPC);
      }
   }
   

	SCGrantHolyItems(oPC);
	
	if ( iLevel > 1 ) // this only happens on level 2 and above, it uses init on the first time when it inits
	{
		DelayCommand(0.05, ExecuteScript("_mod_onlanguagelevelup", oPC));
	}
}