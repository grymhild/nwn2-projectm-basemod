#include "_SCInclude_MagicStone"
#include "_SCInclude_Events"
#include "seed_db_inc"
#include "_SCInclude_Language"

void main()
{
	// DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   object oPC = GetModuleItemAcquiredBy();
   
   if (!GetIsPC(oPC)) { return; }
   if (!GetLocalInt(oPC, "LOADED")) { return; }

   object oItem = GetModuleItemAcquired();

   StoneOnAcquired(oPC, oItem); // RECORD WHO PICKED UP THE STONE
   
   CSLDollEquipItem( oItem, oPC );

   if (GetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM"))
   {
      DeleteLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM");
   }
   
   if (GetLocalInt(oItem, "CRAFTING"))
   {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(50, DAMAGE_TYPE_MAGICAL), oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
      TakeGoldFromCreature(GetGoldPieceValue(oItem), oPC, TRUE);
      SDB_LogMsg("CRAFTSTEAL", "Item marked with CRAFTING flag. Value=" + IntToString(GetGoldPieceValue(oItem)), oPC);
      SendMessageToPC(oPC, "Your slight of hand has not gone unnoticed. You anger me when you try to steal...");
      DestroyObject(oItem);     
   }

   CSLRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY);

   object oBartered = GetLocalObject(oItem, "BARTER_FROM");
   if (oBartered!=OBJECT_INVALID)
   {
      SDB_UpdatePlayerStatus(oBartered); // SAVE PC STATUS OF PERSON WHO BARTERED THIS ITEM      
   }
   DeleteLocalObject(oItem, "BARTER_FROM");
   DeleteLocalInt(oItem, "BARTER_PLID");

   string sItem = GetName(oItem);

	if ( GetLocalInt(oPC, "LOADING") )
	{
		return; // DON'T SHOW ACQUIRE TELLS IF CLIENT JUST JOINED MODULE
	}
	else // SAVE PC STATUS
	{
		SDB_UpdatePlayerStatus(oPC);
	}
	
	if ( CSLGetIsInTown(oPC) ) // DON'T SHOW ACQUIRE TELLS IN TOWN
	{
		return;
	}
	
	if ( IsInConversation(oPC) )  // COULD BE CRAFTING
	{
		return;
	}
	
	if (sItem=="")  // DON'T SHOW ACQUIRE TELLS IF WE CAN'T TELL WHAT WAS ACQUIRED (GOLD FOR EXAMPLE)
	{
		return;
	}
	
	int nStack = GetItemStackSize(oItem);
	if ( nStack > 1 )
	{
		sItem += " (" + IntToString(nStack) + ")";
	}
	
	
	if ( GetBaseItemType(oItem) == BASE_ITEM_BOOK )
	{
		if ( CSLBookAcquire( oItem, oPC) )
		{
   			return;
		}
	}
	
	SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_ACQUIRE );
	
	object oMember = GetFirstFactionMember(oPC);
	while (GetIsObjectValid(oMember))
	{
		if (oPC==oMember)
		{
			SendMessageToPC(oMember, "You picked up " + sItem);
		}
		else if (GetDistanceBetween(oPC, oMember) <= 15.0)
		{
			SendMessageToPC(oMember, "You see " + GetName(oPC) + " pick up " + sItem);
		}
		oMember = GetNextFactionMember(oPC);
	}
}