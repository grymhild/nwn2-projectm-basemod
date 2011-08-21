//#include "x2_i0_spells"
#include "seed_db_inc"

#include "_CSLCore_Items"


#include "_SCInclude_Events"



void main()
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	object oPC = GetModuleItemLostBy();
	object oItem = GetModuleItemLost();
	
	//if (DEBUGGING >= 2) { SendMessageToPC(oPC, "unacquire 2"); }
	
	if ( GetLocalInt(oItem, "ItemDestroyed") )
	{
		// ignore this, is being dropped/removed via a special script
		return;
	}
	/*
	if ( !GetIsPC(oPC) )
	{
		if ( GetLocalInt( GetArea(oPC), "SC_AREABASH" ) == 1 && !CSLGetIsDM( oPC ) )
		{
			DestroyObject(oItem);
		}
		return;
	}
	*/

   
   object oFinder = GetItemPossessor(oItem);
   object oWeapon = GetLastWeaponUsed(oPC);

   int bBarter = oItem!=OBJECT_INVALID && oFinder==OBJECT_INVALID; // VALID ITEM BUT NOT VALID FINDER, MUST BE BARTER WINDOW

   if (GetLocalInt(oItem, "TENSORS_SWORD")) {
      DestroyObject(oItem);
      SDB_LogMsg("TENSOR", "destroyed tensor sword", oPC);
      return;
   }
   if ( GetTag(oItem) == "dmfi_exe_tool" ||
   		GetResRef(oItem) == "dmfi_exe_tool" ||
		GetTag(oItem) == "dmsco" ||
		GetTag(oItem) ==  "dmrco" ||
		GetTag(oItem) ==  "cmi_cursedpoly"
   )
   {
      SetPlotFlag(oItem, FALSE);
      DestroyObject(oItem);
      return;
   }
   

   if (GetBaseItemType(oItem)==BASE_ITEM_CREATUREITEM)
   { // LOST CREATURE SKIN, THEY HAVE UNSHIFTED
      CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELL_TENSERS_TRANSFORMATION, SPELL_NATURE_AVATAR);
      //RemoveEffectsFromSpell(oPC, SPELL_SHAPECHANGE);
      //RemoveEffectsFromSpell(oPC, SPELLABILITY_WILD_SHAPE);
      //RemoveEffectsFromSpell(oPC, SPELL_I_WORD_OF_CHANGING);
      //RemoveEffectsFromSpell(oPC, SPELL_POLYMORPH_SELF);
   }

   if (bBarter) {
      if (oItem==GetLocalObject(oPC, "CRAFTER_LIST_COPY")) { // UNACQUIRED AN ITEM CURRENTLY BEING CRAFTED, BAD BOY!
         if (IsInConversation(oPC)) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(50, DAMAGE_TYPE_MAGICAL), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
            SendMessageToPC(oPC, "Your slight of hand has not gone unnoticed. You anger me when you try to steal...");
            SDB_LogMsg("CRAFTBARTER", "put " + GetName(oItem) + " in barter window.", oPC);
            DestroyObject(oItem);
            return;
         }
         DeleteLocalObject(oPC, "CRAFTER_LIST_COPY");
         DeleteLocalInt(oPC, "CRAFTER_LIST_COPY");;
      }
      SetLocalObject(oItem, "BARTER_FROM", oPC); // SAVE THE ORIGINAL OWNER
      SetLocalString(oItem, "BARTER_PLID", SDB_GetPLID(oPC));
   } else { // NOT BARTERING, SAVE THE PC NOW
      SDB_UpdatePlayerStatus(oPC, "1", FALSE); // SAVE PC STATUS - FALSE MEANS DON'T SHOW SAVE MESSAGE IF LOSING AN ITEM
   }

   if (GetIsInCombat(oPC)) {
      if (CSLItemGetIsAWeapon(oItem)) {
         if (GetStolenFlag(oItem)) {
            SendMessageToPC(oPC, "This disarmed weapon was flagged as stolen. Please tell Seed!!");
            SDB_LogMsg("DISARM", GetName(oItem) + ": Disarmed weapon flagged as stolen. Owner was " + GetName(oPC), oFinder);
            DelayCommand(300.0, SetStolenFlag(oItem, FALSE));
         } else {
            DelayCommand(1.0, SCItemSoldCheck(oItem, oPC));
            effect eVis = EffectNWN2SpecialEffectFile("seed_disarm.sef");
            effect eABLoss = EffectAttackDecrease(5);
            effect eSpeed = EffectMovementSpeedDecrease(50);
            effect eLink = EffectLinkEffects(eABLoss, eVis);
            eLink = EffectLinkEffects(eLink, eSpeed);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 12.0);
            FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC);
            DelayCommand(3.0, FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC));
            DelayCommand(6.0, FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC));
            DelayCommand(9.0, FloatingTextStringOnCreature("<color=pink>Disarmed!!</color>", oPC));
            return;
         }
      }
   }

   if (GetStolenFlag(oItem) && GetIsPC(oFinder) && !GetIsDM(oFinder)) {
      if (GetDroppableFlag(oItem)) {
         int nSkill = GetSkillRank(SKILL_SLEIGHT_OF_HAND, oFinder);
         int nWeight = CSLGetMin(50, GetWeight(oItem));
         int iRoll = nSkill > 0 ? d20(1) : 1; // IF NO SKILL, ALWAYS CRITICAL FAILURE
         if (iRoll==20 && nWeight>20) iRoll = d20(); // IF NAT 20 ON HEAVY ITEM, ROLL IT AGAIN
         if (iRoll==1) {
            SendMessageToPC(oFinder, "Pick Pocket critical failure.");
            SendMessageToPC(oPC, "You feel a hand in your pocket.");
            object oItem2 = CopyItem(oItem, oPC, TRUE);
            SetIdentified(oItem2, TRUE);
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);
         } else if (iRoll==20) {
            SendMessageToPC(oFinder, "Pick Pocket finesse! You acquired "+GetName(oItem)+".");
         } else {
            int nLvl = GetHitDice(oPC);
            int nSpot = GetSkillRank(SKILL_SPOT, oPC);
            int nStack = GetItemStackSize(oItem);
            int iDC = nLvl + nSpot + nWeight + nStack;
            int iClass = GetLevelByClass(CLASS_TYPE_ROGUE, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_BARD, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_ASSASSIN, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_HARPER, oFinder);
            iClass += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oFinder);
            string sMsg = "Pick Pocket [skill "+IntToString(nSkill)+"+class "+IntToString(iClass)+"+roll "+IntToString(iRoll)+"] = " + IntToString(iRoll+nSkill+iClass) + " VS DC "+IntToString(iDC)+" [level " + IntToString(nLvl) + "+spot "+IntToString(nSpot) + "+weight "+IntToString(nWeight) + "+stack "+IntToString(nStack) + "]";
            if (nSkill+iRoll+iClass >= iDC) {
               sMsg = "<color=limegreen>*Success* " + sMsg;
            } else {
               sMsg = "<color=pink>*Failure* " + sMsg;
               object oItem2 = CopyItem(oItem, oPC, TRUE);
               SetIdentified(oItem2, TRUE);
               SetPlotFlag(oItem, FALSE);
               DestroyObject(oItem);
            }
            SendMessageToPC(oFinder, sMsg);
         }
      }
	  
      return;
	  
   }
   
	if ( GetBaseItemType(oItem) == BASE_ITEM_BOOK )
	{
		if ( CSLBookUnacquire( oItem, oPC) )
		{
   			return;
		}
	}
	
	SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_UNACQUIRE );
   
	CSLDropItemAndMakePlaceable(oPC, oItem);

}