#include "seed_db_inc"


void main() {
   object oPC = GetLastOpenedBy();
   object oLocator = GetNearestObjectByTag("WP_DOLL", oPC);
   string sTag = "DOLL_" + SDB_GetPLID(oPC);
   object oDoll = GetObjectByTag(sTag);
   if (oDoll!=OBJECT_INVALID) return;
   oDoll = CopyObject(oPC, GetLocation(oLocator), OBJECT_INVALID, sTag);
   oDoll = GetObjectByTag(sTag);
   ChangeToStandardFaction(oDoll, STANDARD_FACTION_COMMONER);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSetScale(1.5,1.5,1.5), oDoll);
   FeatAdd(oDoll, FEAT_ARMOR_PROFICIENCY_LIGHT, FALSE);
   FeatAdd(oDoll, FEAT_ARMOR_PROFICIENCY_MEDIUM, FALSE);
   FeatAdd(oDoll, FEAT_ARMOR_PROFICIENCY_HEAVY, FALSE);
   FeatAdd(oDoll, FEAT_SHIELD_PROFICIENCY, FALSE);
   FeatAdd(oDoll, FEAT_TOWER_SHIELD_PROFICIENCY, FALSE);
   SetCreatureScriptsToSet(oDoll, SCRIPTSET_NPC_DEFAULT);
   SetImmortal(oDoll, TRUE);
   CSLDontDropGear(oDoll);
   SetLocalObject(oPC, "DOLL", oDoll);
   SetFirstName(oDoll, "Dummy " + GetFirstName(oDoll));
}