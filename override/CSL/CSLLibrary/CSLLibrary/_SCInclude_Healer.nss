/** @file
* @brief Include File for Dex Healer
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/


#include "_CSLCore_Magic"


const int HEALER_COST_HEAL      = 100;
const int HEALER_COST_LEVELS    = 500;
const int HEALER_COST_STAT      = 200;
const int HEALER_COST_DISEASE   = 80;
const int HEALER_COST_BLINDDEAF = 80;
const int HEALER_COST_POISON    = 80;
const int HEALER_COST_CURSE     = 100;

int PayPiper(object oPC, int nCost) {
   if (GetGold(oPC) < nCost) {
      ActionSpeakString("Sorry, you cannot afford my services!");
	  return FALSE;
   }
   TakeGoldFromCreature(nCost, oPC);
   ActionSpeakString("Praise Lathander!");
   ActionCastFakeSpellAtObject(SPELL_HEAL, oPC);
   DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oPC));
   return TRUE;
}

int DoHealer(string sAction, int bCheckOnly = FALSE) {
   object oPC = GetPCSpeaker(); 
   int nCost;
   if (sAction == "HEALER_INIT") {
      SetCustomToken(142, IntToString(HEALER_COST_HEAL));
      SetCustomToken(143, IntToString(HEALER_COST_LEVELS));
      SetCustomToken(144, IntToString(HEALER_COST_STAT));
      SetCustomToken(145, IntToString(HEALER_COST_DISEASE));
      SetCustomToken(146, IntToString(HEALER_COST_BLINDDEAF));
      SetCustomToken(147, IntToString(HEALER_COST_POISON));
      SetCustomToken(148, IntToString(HEALER_COST_CURSE));   
   } else if (sAction == "HEALER_HEAL") {
      if (bCheckOnly) return (GetCurrentHitPoints(oPC) < GetMaxHitPoints(oPC));
	  if (!PayPiper(oPC, HEALER_COST_HEAL)) return FALSE; 
      ActionCastFakeSpellAtObject(SPELL_HEAL,oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC)), oPC);
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_WOUNDING);
	  
   } else if (sAction == "HEALER_LEVELS") {
      if (bCheckOnly) return CSLGetHasEffectType( oPC, EFFECT_TYPE_NEGATIVELEVEL );
	  if (!PayPiper(oPC, HEALER_COST_LEVELS)) return FALSE; 
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_NEGATIVELEVEL); 
	  
   } else if (sAction == "HEALER_STAT") {
      if (bCheckOnly) return CSLGetHasEffectType( oPC, EFFECT_TYPE_ABILITY_DECREASE );
	  if (!PayPiper(oPC, HEALER_COST_STAT)) return FALSE; 
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_ABILITY_DECREASE);
	  
   } else if (sAction == "HEALER_DISEASE") {
      if (bCheckOnly) return CSLGetHasEffectType( oPC, EFFECT_TYPE_DISEASE );
	  if (!PayPiper(oPC, HEALER_COST_DISEASE)) return FALSE; 
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_DISEASE);
	  
   } else if (sAction == "HEALER_BLINDDEAF") {
      if (bCheckOnly) return (CSLGetHasEffectType( oPC, EFFECT_TYPE_DEAF ) || CSLGetHasEffectType( oPC, EFFECT_TYPE_BLINDNESS ));
	  if (!PayPiper(oPC, HEALER_COST_BLINDDEAF)) return FALSE; 
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_BLINDNESS);
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_DEAF);
	  
   } else if (sAction == "HEALER_POISON") {
      if (bCheckOnly) return CSLGetHasEffectType( oPC, EFFECT_TYPE_POISON );
	  if (!PayPiper(oPC, HEALER_COST_POISON)) return FALSE; 
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_ABILITY_DECREASE);
	  
   } else if (sAction == "HEALER_CURSE") {
      if (bCheckOnly) return CSLGetHasEffectType( oPC, EFFECT_TYPE_CURSE );
	  if (!PayPiper(oPC, HEALER_COST_CURSE)) return FALSE; 
	  CSLRemoveEffectByType(oPC, EFFECT_TYPE_ABILITY_DECREASE);

   } else if (sAction == "HEALER_STORE") {
      OpenStore(GetObjectByTag(GetLocalString(OBJECT_SELF, "STORE")), GetLastSpeaker());
	  
   } else if (sAction == "HEALER_STORE2") {
     OpenStore(GetObjectByTag(GetLocalString(OBJECT_SELF, "STORE2")), GetLastSpeaker());
   }
   return TRUE;
}