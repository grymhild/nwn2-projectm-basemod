#include "x2_inc_switches"
#include "_CSLCore_Items"
#include "seed_db_inc"
#include "_CSLCore_Player"
//#include "_inc_propertystrings"

const int DC_PER_LEVEL = 8;

void FloatLog(string sMsg, object oPC, int bFaction=FALSE) {
   FloatingTextStringOnCreature(sMsg, oPC, bFaction);
   //SDB_LogMsg("UMD", sMsg, oPC);
}

int ScrollSkillCheck(object oCaster, int nInnateLevel, int nSkillToUse=SKILL_USE_MAGIC_DEVICE) {
   int iDC = nInnateLevel * DC_PER_LEVEL;
   int nSkill = GetSkillRank(nSkillToUse, oCaster);
   int iLevel = 0;
   int iRoll = 0;
   string sRoll = "0";
   string sSkill;

   if (!GetIsInCombat(oCaster)) {
      iRoll = 20;
      sRoll = "Take 20";
   } else {
      if (nSkillToUse==SKILL_USE_MAGIC_DEVICE) {
         iRoll = d20();
         sRoll = IntToString(iRoll);
      } else {
         return FALSE;
      }
   }

   if (nSkillToUse == SKILL_USE_MAGIC_DEVICE) {
      sSkill = "UMD";
      iLevel  = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_BARD, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_ROGUE, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_WARLOCK, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oCaster)/2;
   }
   else if (nSkillToUse == SKILL_SPELLCRAFT) {
      sSkill = "SpellCraft";
      iLevel  = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_WARLOCK, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
      
      iLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
      iLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster);
      iLevel += (GetHitDice(oCaster) - iLevel) / 2; // SINCE ALL CLASSES GET CROSS CLASSED SPELL CRAFT, GIVE 50% OF THE REMAINING LEVELS
   }
   
   string sResult = "(Skill + Level / "+IntToString(nSkill)+" + "+IntToString(iLevel)+") " + IntToString(nSkill+iLevel) + " vs. "+IntToString(iDC)+" DC (Scroll Level " + IntToString(nInnateLevel) + " * " + IntToString(DC_PER_LEVEL) + ")";
   if (nSkill>0 && nSkill+iLevel>=iDC) {
      FloatLog(sSkill+" Success " + sResult, oCaster, FALSE);
      return TRUE;
   } else {
      FloatLog(sSkill+" Failure " + sResult, oCaster, FALSE);
      if (!GetIsInCombat(oCaster) && nSkillToUse==SKILL_USE_MAGIC_DEVICE && nSkill >= 5) { // CHECK IF CAN USE SC
         if (ScrollSkillCheck(oCaster, nInnateLevel, SKILL_SPELLCRAFT)) return TRUE;
      }
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_EVIL), oCaster);
      return FALSE;
   }
}

int GetMagicType(object oItem) {
   int iClass;
   int bArcane;
   int bDivine;
   itemproperty ip = GetFirstItemProperty(oItem);
   while (GetIsItemPropertyValid(ip)) {
      if (GetItemPropertyType(ip)==ITEM_PROPERTY_USE_LIMITATION_CLASS) {
         iClass=GetItemPropertySubType(ip);
         if (iClass==CLASS_TYPE_BARD || iClass==CLASS_TYPE_SORCERER || iClass==CLASS_TYPE_WIZARD) bArcane = TRUE;
         if (iClass==CLASS_TYPE_CLERIC || iClass==CLASS_TYPE_DRUID || iClass==CLASS_TYPE_PALADIN || iClass==CLASS_TYPE_RANGER) bDivine = TRUE;
      }
      ip = GetNextItemProperty(oItem);
   }
   if (bArcane && bDivine) return SC_SPELLTYPE_BOTH;
   if (bArcane) return SC_SPELLTYPE_ARCANE;
   if (bDivine) return SC_SPELLTYPE_DIVINE;
   return SC_SPELLTYPE_BOTH;
}

int Seedy_UMD()
{
   int    iSpellId   = GetSpellId();
   object oCaster    = OBJECT_SELF;
   object oItem      = GetSpellCastItem();
   int    bItem      = GetIsObjectValid(oItem);
   int    nBaseItem  = GetBaseItemType(oItem);
   string sName      = CSLGetSpellDataName(iSpellId);
   int    iCasterLevel = GetCasterLevel(oCaster);
   string sLvl       = IntToString(iCasterLevel);

   // SAVE THE CASTER LEVEL ON THE TARGET TO RETRIEVE ON DISPELL
   object oTarget = GetSpellTargetObject();
   int nSpellCnt = CSLIncrementLocalInt_Timed(oCaster, "SC", 6.0);
   string sMsg = "<color=PaleTurquoise>"+GetName(oCaster) + "</color><color=violet> casts <color=hotpink>" + CSLGetMetaMagicName(GetMetaMagicFeat()) + "<color=violet>" + sName + " <color=YellowGreen>(" + sLvl + ") <color=violet>on <color=pink>" + GetName(oTarget) + "<color=YellowGreen> (" + IntToString(nSpellCnt) + ")";
   if (oTarget==OBJECT_INVALID) oTarget = oCaster; // NO TARGET, USE SELF
   if (oTarget!=oCaster) SendMessageToPC(oTarget, sMsg);
   SendMessageToPC(oCaster, sMsg);
   SetLocalInt(oTarget, "SCL_" + IntToString(iSpellId), iCasterLevel);
   
   SetLocalInt(oCaster, "LASTSPELL", iSpellId);

   if (GetIsSinglePlayer()) return TRUE;

   if (FALSE) { // LOG THIS INTO THE SPELLCAST TABLE
      string sSPID = IntToString(iSpellId);
      string sSEID = SDB_GetSEID();
      string sPLID = SDB_GetPLID(oCaster);
      string sTPLID = "0";
      string sMOID = "0";
      string sTLvl = "0";
      if (oTarget!=OBJECT_INVALID && oTarget!=oCaster) {
         if (GetIsPC(oTarget)) {
            sTPLID = SDB_GetPLID(oTarget);
            sTLvl = IntToString(GetHitDice(oTarget));
         } else if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE && GetMaster(oTarget)==OBJECT_INVALID) {
            sMOID = SDB_GetMOID(oTarget);
            sTLvl = IntToString(FloatToInt(CSLGetChallengeRating(oTarget)));
         }
      }
      string sBase = IntToString(nBaseItem);
      string sCombat = IntToString(GetIsInCombat(oCaster));
      string sSQL = "insert into spellcast (sc_spid, sc_seid, sc_plid, sc_level, sc_baseitem, sc_combat, sc_tplid, sc_tlevel, sc_moid) " +
                    " values (" + CSLDelimList(sSPID, sSEID, sPLID, sLvl, sBase, sCombat, sTPLID, sTLvl, sMOID) + ")";
      CSLNWNX_SQLExecDirect(sSQL);
      
      /*
      
      sc_spid, sc_seid, sc_plid, sc_level, sc_baseitem, sc_combat, sc_tplid, sc_tlevel, sc_moid
      CREATE TABLE `spellcast` (
  `sc_scid` mediumint(8) unsigned NOT NULL auto_increment,
  `sc_spid` mediumint(8) unsigned default '0',
  `sc_seid` mediumint(8) unsigned default '0',
  `sc_plid` mediumint(8) unsigned default '0',
  `sc_level` mediumint(8) unsigned default '0',
  `sc_baseitem` smallint(5) unsigned default '0',
  `sc_combat` tinyint(1) default '0',
  `sc_tplid` mediumint(8) unsigned default '0',
  `sc_tlevel` mediumint(8) unsigned default '0',
  `sc_moid` mediumint(8) unsigned default '0',
  `sc_added` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`sc_scid`),
  KEY `sc_plid` (`sc_plid`),
  KEY `sc_tplid` (`sc_tplid`),
  KEY `sc_moid` (`sc_moid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1
      
      
      */
      
      
   }
   string sSQL = "update spells set sp_count=sp_count+1, sp_dlcast=now() where sp_spid= " +  IntToString(iSpellId);
   CSLNWNX_SQLExecDirect(sSQL);

   if  (!bItem) return TRUE; // SPELL NOT CAST BY ITEM, UMD NOT REQUIRED - EXIT NOW
   if (nBaseItem!=BASE_ITEM_SPELLSCROLL) return TRUE; // ONLY SCROLLS ARE SUBJECT TO UMD CHECK
   if (!CSLItemGetHasUseLimitation(oItem)) return TRUE; // IGNORE SCROLLS THAT HAVE NO USE LIMITATIONS (I.E. RAISE DEAD)

   int nInnateLevel = StringToInt(CSLGetSpellDataLevel(iSpellId));
   string sDesc =  GetName(oItem) + " (" + IntToString(nInnateLevel) + ")";

   if (GetHasSpell(iSpellId)>0) { // I KNOW THIS SPELL, SO OBVIOUSLY I CAN CAST IT
      FloatLog("<color=limegreen>Spell Known!</color> You can cast " + sDesc, oCaster, FALSE);
      return TRUE;
   }

   // PRESTIGE MODIFIERS
   int nAT = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);                 // Arcane Trickster levels count as ARCANE: LEVEL
   int nEK = GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster); if (nEK) nEK--; // Eldritch Knight levels count as ARCANE: LEVEL - 1
   int nHS = GetLevelByClass(CLASS_TYPE_HARPER, oCaster); if (nHS) nHS--;          // Harper levels count as BOTH: LEVEL - 1
   int nPM = GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster)/2;                    // Palemaster levels count as ARCANE: LEVEL/2
   int nWP = GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster)/2;                     // Warpriest levels count as DIVINE: LEVEL/2
   
   int nAS = GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCaster);                 // Arcane Scholar levels count as ARCANE: LEVEL
   int nRW = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);                     // Red Wizard levels count as ARCANE: LEVEL
   int nSF = GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster); if (nSF>=8) nSF--; if (nSF>=4) nSF--; // Scared Fist levels count as DIVINE: LEVEL except levels 4 & 8
   int nSL = GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);                      // Storm Lord levels count as DIVINE: LEVEL 
   
   // SUM PRESTIGE MODIFIERS BY CLASS
   int nArcane = nAT + nEK + nHS + nPM + nAS;
   int nDivine = nHS + nWP + nSF + nSL;
   // CALC EFFECTIVE LEVELS BY CLASS
   int nBard         = GetLevelByClass(CLASS_TYPE_BARD         , oCaster);
   int nCleric       = GetLevelByClass(CLASS_TYPE_CLERIC       , oCaster);
   int nDruid        = GetLevelByClass(CLASS_TYPE_DRUID        , oCaster);
   int nPaladin      = GetLevelByClass(CLASS_TYPE_PALADIN      , oCaster);
   int nRanger       = GetLevelByClass(CLASS_TYPE_RANGER       , oCaster);
   int nSorcerer     = GetLevelByClass(CLASS_TYPE_SORCERER     , oCaster);
   int nWizard       = GetLevelByClass(CLASS_TYPE_WIZARD       , oCaster);

   int nFavoredSoul  = GetLevelByClass(CLASS_TYPE_FAVORED_SOUL , oCaster);
   int nSpiritShaman = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);

   if (nBard)     nBard += nArcane;
   if (nSorcerer) nSorcerer += nArcane;
   if (nWizard)   nWizard += nArcane + nRW;

   if (nCleric)       nCleric += nDivine;
   if (nDruid)        nDruid += nDivine;
   if (nPaladin)      nPaladin += nDivine;
   if (nRanger)       nRanger += nDivine;
   if (nFavoredSoul)  nFavoredSoul += nDivine;
   if (nSpiritShaman) nSpiritShaman += nDivine;

   int nMagicType = GetMagicType(oItem);

   // FIND MAX ARCANE LEVEL
   nArcane = nBard + nSorcerer + nWizard; // HAVE YOU ANY ARCANE LEVELS?
   if (nArcane && (nMagicType==SC_SPELLTYPE_ARCANE || nMagicType==SC_SPELLTYPE_BOTH)) { // NEED TO CALC ARCANE LEVEL
      int nIntLvl = GetAbilityScore(oCaster, ABILITY_INTELLIGENCE) - 9; // MAX SPELL LEVEL BASED ON INT - CONSIDERS LEVEL 0 SPELL AS 1 SPELL LEVEL SO -9 SINCE INT 10 CAN CAST CANTRIPS OR 1 SPELL LEVEL
      int nChaLvl = GetAbilityScore(oCaster, ABILITY_CHARISMA) - 9;     // MAX SPELL LEVEL BASED ON CHARISMA
      if (nChaLvl>0 && nBard)     nBard     = CSLGetMin(nChaLvl, StringToInt(Get2DAString("cls_spgn_bard", "NumSpellLevels", nBard - 1))); else nBard=0;
      if (nChaLvl>0 && nSorcerer) nSorcerer = CSLGetMin(nChaLvl, StringToInt(Get2DAString("cls_spgn_sorc", "NumSpellLevels", nSorcerer - 1))); else nSorcerer=0;
      if (nIntLvl>0 && nWizard)   nWizard   = CSLGetMin(nIntLvl, StringToInt(Get2DAString("cls_spgn_wiz", "NumSpellLevels", nWizard - 1))); else nWizard=0;
      nArcane = CSLGetMax(CSLGetMax(nBard, nSorcerer), nWizard);
      if (nArcane) nArcane--;
   } else {
      nArcane = 0;
   }
   if (nMagicType==SC_SPELLTYPE_ARCANE && nArcane>=nInnateLevel) { // ARCANE ONLY, IF WE CHECK OUT WE CAN EXIT
      FloatLog("EACL " + IntToString(nArcane) + ": You can cast " + sDesc, oCaster, FALSE);
      return TRUE; // THEY CAN CAST ARCANE SPELLS OF THIS LEVEL
   }
   // FIND MAX DIVINE LEVEL
   nDivine = nCleric + nDruid + nPaladin + nRanger; // ARE YOU DEVOTE ENOUGH?
   if (nDivine > 0 && (nMagicType==SC_SPELLTYPE_DIVINE || nMagicType==SC_SPELLTYPE_BOTH)) { // NEED TO CALC DIVINE LEVEL
      int nWisLvl = GetAbilityScore(oCaster, ABILITY_WISDOM); // MAX SPELL LEVEL BASED ON WISDOM
      if (nWisLvl>0) { // CAN'T CAST ANY DIVINE SPELLS, SKIP THIS CHECK
         if (nCleric>0)       nCleric       = StringToInt(Get2DAString("cls_spgn_cler", "NumSpellLevels", nCleric - 1));
         if (nDruid>0)        nDruid        = StringToInt(Get2DAString("cls_spgn_dru", "NumSpellLevels", nDruid - 1));
         if (nPaladin>0)      nPaladin      = StringToInt(Get2DAString("cls_spgn_pal", "NumSpellLevels", nPaladin - 1));
         if (nRanger>0)       nRanger       = StringToInt(Get2DAString("cls_spgn_rang", "NumSpellLevels", nRanger - 1));
         if (nFavoredSoul>0)  nFavoredSoul  = StringToInt(Get2DAString("cls_spgn_cler", "NumSpellLevels", nFavoredSoul - 1));
         if (nSpiritShaman>0) nSpiritShaman = StringToInt(Get2DAString("cls_spgn_dru", "NumSpellLevels", nSpiritShaman - 1));
         nDivine = CSLGetMax(CSLGetMax(CSLGetMax(CSLGetMax(CSLGetMax(nCleric, nDruid), nPaladin), nRanger), nFavoredSoul), nSpiritShaman) ;
         if (nDivine) nDivine--;
      } else {
         nDivine = 0;
      }
   } else {
      nDivine = 0;
   }
   if (nMagicType==SC_SPELLTYPE_DIVINE && nDivine>=nInnateLevel) { // DIVINE ONLY, IF WE CHECK OUT WE CAN EXIT
      FloatLog("EDCL " + IntToString(nDivine) + ": You can cast " + sDesc, oCaster, FALSE);
      return TRUE; // THEY CAN CAST DIVINE SPELLS OF THIS LEVEL
   }

   if (nMagicType==SC_SPELLTYPE_BOTH && CSLGetMax(nArcane, nDivine)>=nInnateLevel) { // EITHER ONE WORKS, CHECK THE LARGER AGAINST THE INNATE LVL
      if (nArcane>nDivine) FloatLog("ECLa " + IntToString(nArcane) + ": You can cast " + sDesc, oCaster, FALSE);
      else FloatLog("ECLd " + IntToString(nDivine) + ": You can cast " + sDesc, oCaster, FALSE);
      return TRUE; // THEY CAN CAST SPELLS OF THIS LEVEL AND TYPE
   }

   if (!GetHasSkill(SKILL_USE_MAGIC_DEVICE, oCaster)) {
      int nECL = CSLGetMax(nArcane, nDivine);
      if (nArcane+nDivine>0)
	  {
         FloatLog("You can only use scrolls up to level " + IntToString(nECL) + ". You cannot cast " + sDesc, oCaster, FALSE);
         return FALSE;
      }
   }
   return ScrollSkillCheck(oCaster, nInnateLevel);
}

void main() {
   object oCaster = OBJECT_SELF;
   
   object oTarget = GetSpellTargetObject();
   if (oTarget!=OBJECT_INVALID && GetIsEnemy(oTarget, oCaster))
   {
      CSLRemoveEffectByType( oCaster, EFFECT_TYPE_ETHEREAL );
      CSLRemoveEffectByType( oCaster, EFFECT_TYPE_SANCTUARY );      
   }

   //--------------------------------------------------------------------------
   // Reset
   //--------------------------------------------------------------------------
   int bCE = GetActionMode(oCaster, ACTION_MODE_COMBAT_EXPERTISE);
   int bICE = GetActionMode(oCaster, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE);
   if (bCE || bICE) {
      SendMessageToPC(oCaster, "<color=pink>Spell Failure!</color> You cannot cast spells with Combat Expertise Active.");
      SetExecutedScriptReturnValue (FALSE);
      return;
   }
   //SetActionMode(oCaster, ACTION_MODE_COMBAT_EXPERTISE, FALSE);
   //SetActionMode(oCaster, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, FALSE);
   //--------------------------------------------------------------------------
   // Do use magic device check
   int nRet = Seedy_UMD();
   SetExecutedScriptReturnValue (nRet);
}