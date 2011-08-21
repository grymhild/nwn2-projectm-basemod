#include "_HkSpell"
#include "_CSLCore_Items"
#include "_SCInclude_Class"
#include "_SCInclude_Events"

void main()
{
//return;
	
   object oItem = GetPCItemLastUnequipped();
   object oPC = GetPCItemLastUnequippedBy();

   if (GetLocalInt(oPC, "LOADING")) return; // SKIP THIS IN THE PC-LOAD PHASSE
   
   	if (GetLocalInt(GetModule(), "UnequipLosesTempProperties") == 1)
	{
		CSLRemoveTemporaryItemProperties(oItem);
	}
   // fix for missing hide attributes from items
	//CSLApplyItemProperties( oPC, oItem );
	DeleteLocalInt( oPC, "SC_ITEM_CACHED");
	DelayCommand( 0.5f, CSLCacheCreatureItemInformation( oPC ) );
	
	
   if (GetBaseItemType(oItem)==BASE_ITEM_RING)
   {
      if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N))
      {
	     SetLocalInt(oItem, "SPELLRING", GetGoldPieceValue(oItem));
	  }
   }
   
   
	if ( GetBaseItemType(oItem) == BASE_ITEM_ARMOR && GetSubRace(oPC) == RACIAL_SUBTYPE_MINOTAUR )
	{
		DelayCommand( 3.0f, CSLForceItem( oPC, "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "nw_cloth015", TRUE ) );
	}
	
	if ( GetBaseItemType(oItem) == BASE_ITEM_CLOAK && CSLStringStartsWith( GetTag(oItem), "steed", FALSE ) )
	{
		DelayCommand( 0.5f, ExecuteScript("_mod_onmount", oPC ));
		return;
	}
	
	
	
	
	cmi_player_unequip(oPC);
	
	CSLEnviroUnequip( oItem, oPC );
	
	SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_UNEQUIP );
	//ExecuteScript("cmi_player_unequip", OBJECT_SELF);
}