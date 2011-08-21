#include "_CSLCore_Messages"
#include "_CSLCore_Items"

int DoGem(object oPC, int iGold = 0, int iGemValue = 0, string sRef = "") {
   int i;
   int iTake = 0;
   int iGemCount = iGold / (iGemValue * 10);
   for (i=1; i<=iGemCount; i++) {
      CreateItemOnObject(sRef, oPC, 10);
      iTake = iTake + (iGemValue * 10);
   }
   iGold = iGold - iTake;
   iGemCount = iGold / iGemValue;
   if (iGemCount) {
      CreateItemOnObject(sRef, oPC, iGemCount);
      iTake = iTake + (iGemValue * iGemCount);
   }
   TakeGoldFromCreature(iTake, oPC);
   return iTake;
}

void MovePawnBuyToSell()
{
   object oMerchant = OBJECT_INVALID;
   object oStore = GetObjectByTag("PAWN_IN");
   object oItem = GetFirstItemInInventory(oStore);
   while (GetIsObjectValid(oItem))
   {
      if (!GetIdentified(oItem)) SetIdentified(oItem, TRUE);
      if (GetIsItemPropertyValid(GetFirstItemProperty(oItem))) {
         if (GetBaseItemType(oItem)==BASE_ITEM_ARROW || GetBaseItemType(oItem)==BASE_ITEM_BOLT ||
             GetBaseItemType(oItem)==BASE_ITEM_BULLET || GetBaseItemType(oItem)==BASE_ITEM_DART ||
             GetBaseItemType(oItem)==BASE_ITEM_SHURIKEN || GetBaseItemType(oItem)==BASE_ITEM_THROWINGAXE) {
             oMerchant = GetObjectByTag("store_loft_ranged");
         } else {
            int nLvl = CSLGetItemLevel(GetGoldPieceValue(oItem));
            if       (nLvl <= 5) oMerchant = GetObjectByTag("PAWN_OUT_1");
            else if (nLvl <= 10) oMerchant = GetObjectByTag("PAWN_OUT_2");
            else if (nLvl <= 15) oMerchant = GetObjectByTag("PAWN_OUT_3");
            else if (nLvl <= 20) oMerchant = GetObjectByTag("PAWN_OUT_3");
         }
      }
//SendMessageToPC(GetFirstPC(), "Store " + GetTag(oStore) + " has " + GetName(oItem) + " moving to " + GetTag(oMerchant));
      if (oMerchant!=OBJECT_INVALID) SetIdentified(CopyItem(oItem, oMerchant), TRUE);
      DestroyObject(oItem);
	oItem = GetNextItemInInventory(oStore);
// GetNExt is bugged for stores, use recursive call to move the items
     //DelayCommand(0.1, MovePawnBuyToSell());
     //return; // DUE TO A BUG, JUST EXIT
   }
}

void main( string sAction = "" )
{
	object oPC = GetPCSpeaker();
	//SendMessageToPC(oPC, "Running Action2="+sAction);
	object oItem;
	object oStore;
	if (sAction=="") 
	{
		sAction = GetTag(OBJECT_SELF);
	}
	if ( sAction=="SELL_TO_PAWN" )
	{
      //SendMessageToPC(oPC, "A");
		MovePawnBuyToSell();
		//SendMessageToPC(oPC, "B");
      oStore = GetObjectByTag("PAWN_IN", 0);
	  //SendMessageToPC(oPC, "C");
      OpenStore(oStore, oPC, 0 , 0);
	  //SendMessageToPC(oPC, "D");
	}
	else if ( sAction=="BUY_FROM_PAWN" )
	{
      MovePawnBuyToSell();
      oStore = GetObjectByTag(GetLocalString(OBJECT_SELF, "STORE")); // THERE ARE 4 BUY STORES, LVL's 5, 10, 15, 20
      OpenStore( oStore, oPC, 0, 0 );
   
	}
	else if ( sAction=="BUY_FROM_WHOLESALE" )
	{
      oStore = GetObjectByTag("pawn_wholesale");
      OpenStore(oStore, oPC, 0 , 0);
	}
	else if (sAction=="GEM_STORE")
	{
      oStore = GetObjectByTag("PAWN_GEMS");
	  SendMessageToPC(oPC, "The Store is closed until bugs are fixed.");
 
	  //if ( GetIsObjectValid( oStore ) )
	  //{
      	// OpenStore(oStore, oPC, 0 , 0);
	  //}
   }
   else if (sAction=="SELL_GEMS")
   {
      int nGold = 0;
      oItem = GetFirstItemInInventory(oPC);
      while (oItem != OBJECT_INVALID) { // LOOP THRU ITEM IN INVENTORY
         if (GetBaseItemType(oItem)==BASE_ITEM_GEM) {
            DestroyObject(oItem);
            nGold = nGold + GetGoldPieceValue(oItem);
         }
         oItem = GetNextItemInInventory(oPC);
      }
      GiveGoldToCreature(oPC, nGold);
   }
   else if (sAction=="BUY_GEMS")
   {
      int iGold = GetGold(oPC);
      iGold = GetGold(oPC) - 4000; // ALWAYS LEAVE SOME GOLD ON THE PLAYER FOR EXPENSES
      if (iGold > 0) {
         int iCharge = iGold/100 * 2;
       iGold = iGold - iCharge;
         TakeGoldFromCreature(iCharge, oPC);
         SendMessageToPC(oPC, "A 2% gem exchange rate was charged. Exchange cost " + IntToString(iCharge));
         if (iGold > 10000) iGold = iGold - DoGem(oPC, iGold, 10000, "gem_10000");
         if (iGold >  5000) iGold = iGold - DoGem(oPC, iGold,  5000, "cft_gem_13");
         if (iGold >  4000) iGold = iGold - DoGem(oPC, iGold,  4000, "cft_gem_15");
         if (iGold >  3000) iGold = iGold - DoGem(oPC, iGold,  3000, "cft_gem_09");
         if (iGold >  1000) iGold = iGold - DoGem(oPC, iGold,  1000, "nw_it_gem005");
         if (iGold >   500) iGold = iGold - DoGem(oPC, iGold,   500, "nw_it_gem013");
      } else {
         SendMessageToPC(oPC, "You don't have enough gold to change into gems.");
      }
   }
}