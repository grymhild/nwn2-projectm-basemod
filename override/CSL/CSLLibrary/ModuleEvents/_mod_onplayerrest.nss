#include "seed_db_inc"
#include "_SCInclude_faction"

//#include "_SCUtility"
//#include "_SCInclude_Saveuses"
#include "_SCInclude_Arena"
#include "_SCInclude_Necromancy"
#include "_SCInclude_Summon"
#include "_SCInclude_Events"




void main()
{
  // Script Settings (Variable Declaration)
  int nLevelAffected = 5;   // The min. PC Level at which the Rest-restrictions will be applied
  int nRestDelay = 2;       // The ammount of hours a player must wait between Rests
  int nHostileRange = 20;   // The radius around the players that must be free of hostiles in order to rest.

   // Variable Declarations
   object oPC = GetLastPCRested(); // THIS SCRIPT ONLY AFFECTS PLAYER CHARACTERS. FAMILIARS, SUMMONED CREATURES AND PROBABLY HENCHMEN WILL REST!
   object oMod = GetModule();
   string sName=GetName(oPC);
   int iLevel = GetHitDice(oPC);
   
   int iCharState = GetLocalInt(oPC, "CSL_CHARSTATE");
   int iAreaState = GetLocalInt(oPC, "CSL_ENVIRO");
   
   
   
	if ( !GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))) )
	{
		SCStopResting(oPC, "Invalid Area.");
		return;
	}

   

   if ( CSLGetIsInTown(oPC) || SCGetIsInArena(oPC))
   {
      DeleteLocalInt (oPC, "LASTREST");
   }
   else if (iLevel >= nLevelAffected) // CHECK IF REST-RESTRICTIONS APPLY TO THE PLAYER
   {
		if (GetLastRestEventType()==REST_EVENTTYPE_REST_STARTED)
		{
         
			if ( iCharState & CSL_CHARSTATE_SUBMERGED && GetLocalInt(oPC, "CSL_HOLDBREATH") )
			{
				SCStopResting(oPC, "You cannot rest when you cannot breathe.");
				return;
			}

			int nCurrentCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION);
			int nBaseCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
			int nHD = GetHitDice(oPC);
			int nHeal = nHD * ((nCurrentCon - nBaseCon) / 2);
			if (nHeal > 0)
			{
				int nCurrentHP = GetCurrentHitPoints(oPC);
				if (nCurrentHP < (nHeal + 1) )
				{
					int nHealVal = nHeal - nCurrentHP + 1;
					effect eHeal = EffectHeal(nHealVal);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
					SetLocalInt(oPC, "HealFixValue", nHealVal);			
				}
			}
         
         
         nRestDelay = iLevel / 5; // 5=1, 10=2, 15=3, 20=4, 25=5, 30=6
         int nNow = CSLTimeStamp();
         int nLastRest = CSLGetLastRest(oPC);
         int nNextRest = nLastRest + nRestDelay;
         if ((nNow < nNextRest)) // RESTING IS NOT ALLOWED // LASTREST IS 0 WHEN THE PLAYER ENTERS THE MODULE
         {
            nNextRest = nNextRest - nNow;
            SCStopResting(oPC, "You must wait " + IntToString(nNextRest) + CSLAddS(" hour", nNextRest) + " before resting again.");
            return;
         }
         else// ENOUGH TIME HAS PASSED TO REST AGAIN
         {
            object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
            if (GetDistanceToObject(oCreature)<=IntToFloat(nHostileRange)) { // IF NO HOSTILES WITHIN HOSTILE RADIUS: INITIATE RESTING
               CSLSetLastRest(oPC, nNow); // SUCCESS!! SET LAST REST TIME
            } else { // Resting IS NOT allowed
               SCStopResting(oPC, "A nearby enemy prevents you from resting.");
               return;
            }
         }
      }
   }
   
   DeleteLocalInt(oPC, "AOESTACK"); // CLEAR THE STACK WHEN RESTING

   DelayCommand(1.0f, SCDestroyUndead(oPC, TRUE) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
   DelayCommand(0.5f, SCSummonsExecuteScript(oPC) ); // CLEAR ANY UNDEAD THEY MAY HAVE ON THEM
   
   if (GetLastRestEventType()==REST_EVENTTYPE_REST_CANCELLED)
   {
     if (GetLocalInt(oPC, "STOPREST")) { // WE FORCED THEM TO STOP
        DeleteLocalInt(oPC, "STOPREST");
        return;
      }
      
      int nHealFixValue = GetLocalInt(oPC, "HealFixValue");

			if (nHealFixValue > 0)
			{
				effect eBadPlayerSlap = EffectDamage(nHealFixValue, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
    			ApplyEffectToObject(DURATION_TYPE_INSTANT, eBadPlayerSlap, oPC);
				SetLocalInt(oPC, "HealFixValue", 0);	
			}
      
      
      object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);
      if (oCreature!=OBJECT_INVALID)
      {
         if (GetDistanceBetween(oPC, oCreature) <= 25.0)
         {
            return; // NO PENALTY FOR CANCLING REST IF ENEMY APPROACHING
         }
      }
	  DelayCommand( 1.5, CSLRemoveAllEffects( oPC ) );
   }
   
	
	
   //return;
   if (GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
   {
		SetLocalInt(oPC, "HealFixValue", 0);
		SetLocalInt(oPC, "PARTY_PORT", FALSE); 
		DeleteLocalInt(oPC, "TRANS");
		SDB_OnPCRest(oPC);
		SDB_FactionOnPCRest(oPC);
		SetLocalInt( oPC, "SC_HitDice", 0 );
		
		// some kaedrin item fixes here of some sort, need to review
		object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		CSLRemoveTemporaryItemProperties(oItem);
		oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
		CSLRemoveTemporaryItemProperties(oItem);	
		oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);	
		CSLRemoveTemporaryItemProperties(oItem);
	
		if ( CSLGetPreferenceSwitch("UseSacredFistFix",FALSE) )
		{
			//This fixes characters who were incorrectly given the feat.
			if ( (GetLevelByClass(CLASS_TYPE_SACREDFIST) == 0) && (GetHasFeat(FEAT_SACREDFIST_CODE_OF_CONDUCT, oPC)) )
			{
				FeatRemove(oPC, FEAT_SACREDFIST_CODE_OF_CONDUCT);
			}
		}
		
		
	if ((GetSubRace(OBJECT_SELF) == RACE_DEEP_IMASKARI) && (GetHitDice(OBJECT_SELF) == 1) )
	{	
		int iFirstClass = GetClassByPosition(1, OBJECT_SELF);
		if (iFirstClass == CLASS_TYPE_WIZARD)
			FeatAdd(OBJECT_SELF, FEAT_EXTRA_SLOT_WIZARD_LEVEL1, FALSE, TRUE,TRUE);
		else
		if (iFirstClass == CLASS_TYPE_SORCERER)
			FeatAdd(OBJECT_SELF, FEAT_EXTRA_SLOT_SORCERER_LEVEL1, FALSE, TRUE,TRUE);	
		else
		if (iFirstClass == CLASS_TYPE_BARD)
			FeatAdd(OBJECT_SELF, FEAT_EXTRA_SLOT_BARD_LEVEL1, FALSE, TRUE,TRUE);
		else
		if (iFirstClass == CLASS_TYPE_CLERIC)
			FeatAdd(OBJECT_SELF, FEAT_EXTRA_SLOT_CLERIC_LEVEL1, FALSE, TRUE,TRUE);
		else
		if (iFirstClass == CLASS_TYPE_FAVORED_SOUL)
			FeatAdd(OBJECT_SELF, 2070, FALSE, TRUE,TRUE);
		else
		if (iFirstClass == CLASS_TYPE_DRUID)
			FeatAdd(OBJECT_SELF, FEAT_EXTRA_SLOT_DRUID_LEVEL1, FALSE, TRUE,TRUE);
		else
		if (iFirstClass == CLASS_TYPE_PALADIN)
			FeatAdd(OBJECT_SELF, FEAT_EXTRA_SLOT_PALADIN_LEVEL1, FALSE, TRUE,TRUE);					
		else
		if (iFirstClass == CLASS_TYPE_RANGER)
			FeatAdd(OBJECT_SELF, FEAT_EXTRA_SLOT_RANGER_LEVEL1, FALSE, TRUE,TRUE);
		else
		if (iFirstClass == CLASS_TYPE_SPIRIT_SHAMAN)
			FeatAdd(OBJECT_SELF, 2005, FALSE, TRUE,TRUE);			
																				
	}
	
	
		object oPoly = GetItemPossessedBy(oPC, "cmi_cursedpoly");
		DestroyObject(oPoly, 0.1f, FALSE);
		
		if(GetLevelByClass(CLASS_SKULLCLAN_HUNTER, oPC) > 1)
		{
			DelayCommand(1.0f, ExecuteScript("EQ_deathsruin",oPC));		
		}
		
		if (GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 9)
		{
			effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
			effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);		
			effect ePM = EffectLinkEffects(eCrit, eSneak);
			ePM = SetEffectSpellId(ePM, PM_IMMUNITY);
			ePM = SupernaturalEffect(ePM);
			//RemoveSpellEffects(PM_IMMUNITY, oPC, oPC);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, PM_IMMUNITY );	
			DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePM, oPC, HoursToSeconds(48)));		
		}	
		
		
	//New Parry AC code. Needs a cmi_option wrapper.
	/*		
	{
		RemoveSpellEffects(PARRY_AC_BONUS, OBJECT_SELF, OBJECT_SELF);	
		int nParry = GetSkillRank(SKILL_PARRY);
		nParry = nParry / 5;
		if (nParry > 12)
			nParry = 12;
		effect eParryAC = EffectACIncrease(nParry, AC_DEFLECTION_BONUS);
		eParryAC = SetEffectSpellId(eParryAC, PARRY_AC_BONUS);
		eParryAC = SupernaturalEffect(eParryAC);		
		DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParryAC, OBJECT_SELF, HoursToSeconds(48)));			

	}
	*/
	
	// New Uncanny Dodge code. Needs a cmi_option wrapper.
	if (GetLocalInt(GetModule(), "UncannyDodgeImprovement") == 1)
	{
		int nReflex = 0;
		if (GetHasFeat(FEAT_UNCANNY_DODGE))
		{
			if (GetHasFeat(FEAT_IMPROVED_UNCANNY_DODGE))
				nReflex = 2;
			else 
				nReflex = 1;
		}
		
		if (nReflex > 0)
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, UNCANNY_DODGE_BONUS );	
			effect eUncanny = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nReflex);
			eUncanny = SetEffectSpellId(eUncanny, UNCANNY_DODGE_BONUS);
			eUncanny = SupernaturalEffect(eUncanny);		
			DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUncanny, OBJECT_SELF, HoursToSeconds(48)));			
		}
	}
	
	// New Scout fix code.
	{
		int nDodge = 0;
		int nScout = GetLevelByClass(CLASS_SCOUT);
		if (nScout > 0)
		{
			nScout = (nScout + 1) / 4;
		}
		int nWildStalk = GetLevelByClass(CLASS_WILD_STALKER);		
		if (nWildStalk > 0)
		{
			nWildStalk = nWildStalk / 4;
		}
		nDodge = nScout + nWildStalk;
		
		if (nDodge == 7)
			nDodge--;  //Epic Skirmish already provides 1 point of Dodge AC.
		if (nDodge > 0)
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SCOUT_FIX_BONUS );	
			effect eScoutAC = EffectACIncrease(nDodge);
			eScoutAC = SetEffectSpellId(eScoutAC, SCOUT_FIX_BONUS);
			eScoutAC = SupernaturalEffect(eScoutAC);		
			DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eScoutAC, OBJECT_SELF, HoursToSeconds(48)));			
		}
	}	
		
		//DelayCommand( 1.0, StoreUses(oPC) );
   }
   
   
}