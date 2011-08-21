#include "seed_db_inc"
#include "_SCInclude_UnlimitedAmmo"
#include "_CSLCore_Items"
#include "_SCInclude_Class"
#include "_SCInclude_Events"

// ADDED ginc_item TO FACILITATE SACRED FLAMES SCRIPT FIX BY PAIN
//const int SPELLABILITY_SACRED_FLAMES = 1123;




void main()
{
	//OBJECT_SELF is assumed to be the module
	object oItem = GetPCItemLastEquipped();
	object oPC   = GetPCItemLastEquippedBy();
	int iQuiet = GetLocalInt( oPC, "SC_QUIETMODE" );
	
	SCUnlimAmmo_Equip(oPC, oItem);
	
	if (GetLocalInt(oPC, "LOADING")) return; // SKIP THIS IN THE PC-LOAD PHASE & WHEN POLYMORPHING
	
	DoStormWeapon(oPC, oItem);
     
     CSLBulletCastingCheck( oItem, oPC );
     
   	if ( GetBaseItemType(oItem) == BASE_ITEM_CLOAK && CSLStringStartsWith( GetTag(oItem), "steed", FALSE ) )
	{
		ExecuteScript("_mod_onmount", oPC );
		return;
	}
	
	if ( GetBaseItemType(oItem) == BASE_ITEM_ARMOR && GetSubRace(oPC) == RACIAL_SUBTYPE_MINOTAUR )
	{
		//AssignCommand( oPC, ActionUnequipItem(oItem) );
		CSLForceItem( oPC, "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "NW_CLOTH001", TRUE );
	}
   
   if ( CSLGetItemPropertyExists(oItem, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON))
   {
      int nHP = GetCurrentHitPoints(oPC);
      int nMaxHP = GetMaxHitPoints(oPC);
      if (nHP>nMaxHP * 3/2) {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nMaxHP, DAMAGE_TYPE_MAGICAL), oPC);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
         SDB_LogMsg("MAXHP", "Too Many Hitpoints: max " + IntToString(nMaxHP) + " / cur " + IntToString(nHP), oPC);
         SendMessageToPC(oPC, "Your hitpoints are too high.");
      }
   }

   CSLSacredFlamesWeaponCheck( oItem, oPC );
   
   // end sacred fist exception 
   cmi_player_equip( oPC );
   //ExecuteScript("cmi_player_equip", OBJECT_SELF);
   
   // fix for missing hide attributes from items
   //CSLApplyItemProperties( oPC );
   DeleteLocalInt( oPC, "SC_ITEM_CACHED");
	DelayCommand( 0.5f, CSLCacheCreatureItemInformation( oPC ) );
   
   
   CSLEnviroEquip( oItem, oPC );
   
   SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_EQUIP );

}