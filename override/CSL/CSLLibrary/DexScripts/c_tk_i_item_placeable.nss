// Include file for the item placeables.
// 
//#include "_CSLCore_Items"
// Kivinen 2007-06-19

// Adjusted to handle the banners, removed handling of other item
 // Main     Item=NW_IT_bann201  Placeable=PLC_MC_bann201
 // PKR      Item=NW_IT_bann202  Placeable=PLC_MC_bann202
 // Order    Item=NW_IT_bann203  Placeable=PLC_MC_bann203
 // Legion   Item=NW_IT_bann204  Placeable=PLC_MC_bann204
 // TB       Item=NW_IT_bann205  Placeable=PLC_MC_bann205
 // Triad    Item=NW_IT_bann206  Placeable=PLC_MC_bann206
 // None     Item=NW_IT_bann207  Placeable=PLC_MC_bann207
 // Triangle Item=               Placeable=PLC_MC_bann208
 // Torn     Item=               Placeable=PLC_MC_bann209
 // Flag     Item=NW_IT_bann210  Placeable=PLC_MC_bann210
 // Pyramid  Item=NW_IT_bann211  Placeable=PLC_MC_bann211
 // Fallen  Item=NW_IT_bann212  Placeable=PLC_MC_bann212

// Get item on the ground and destroy the placeable. This is run either from
// the OnUsed, OnLeftClick or OnOpened script.
void C_GetItemFromGround(object oPC, object oPlc);

// Convert placeable resref to the item resref
string C_PlaceableResRefToItemResRef(object oPC, string sResRef);

// Remove plc_??_ prefix
string C_RemovePlcPrefix(string sResRef);

// Check if item is dropped on the ground, and if so create placeable on the
// ground.
void C_CreatePlaceableOnGround(object oPC, object oItem);

// Convert item base type to resref of the placeable. 
string C_GetItemBaseTypeResRef(object oItem);

// Play pickup animation. This needs to be delayed as the PC is still running
// when OnOpen and OnUsed scripts are run. The animation will be run when the
// PC has stopped, i.e. vLastPos and current position of PC are same. It will
// be delayed at max nTries times, and each operation is delayed by fDelay
// seconds. When the pickup animation is played the given sound is also played.
void C_PlayPickupAnimationWhenStopped(object oPC, vector vLastPos,
				      string sSound = "",
                                      int nTries = 10,
                                      float fDelay = 0.5);

// These are missing from the nwscript.nss
const int BASE_ITEM_STEIN		= 127;
const int BASE_ITEM_INK_WELL		= 130;
const int BASE_ITEM_LOOTBAG		= 131;
const int BASE_ITEM_PAN		= 133;
const int BASE_ITEM_POT		= 134;
const int BASE_ITEM_RAKE		= 135;
const int BASE_ITEM_SHOVEL		= 136;
const int BASE_ITEM_SMITHYHAMMER	= 137;
const int BASE_ITEM_SPOON		= 138;
const int BASE_ITEM_BOTTLE		= 139;

// Get item on the ground and destroy the placeable. This is run either from
// the OnUsed, OnLeftClick or OnOpened script.
void C_GetItemFromGround(object oPC, object oPlc)
{
  object oItem = GetFirstItemInInventory(oPlc);
  int nDoAnimation = 0;
  object oNewItem;

  if (!GetIsObjectValid(oItem))
  {
    string sResRef, sDesc, sFirstName, sLastName;
    int nStackSize;

    // If we have already destroyed this placable, do not do anything.
    if (GetLocalInt(oPlc, "ItemPlaceableDestroyed")) {
      return;
    }
	
    // No item inside, check variables.
    sResRef = GetLocalString(oPlc, "item_resref");
	if (sResRef == "")
	{
      sResRef = GetTag(oPlc);
	  sResRef = C_PlaceableResRefToItemResRef(oPC, sResRef);
    }
	
	sDesc = GetLocalString(oPlc, "item_description");
    if (sDesc == "") {
      sDesc = GetDescription(oPlc);
    }
    sFirstName = GetLocalString(oPlc, "item_first_name");
    if (sFirstName == "")
	{
      sFirstName = GetFirstName(oPlc);
    }
    sLastName = GetLocalString(oPlc, "item_last_name");
    if (sLastName == "")
	{
      sLastName = GetLastName(oPlc);
    }
	
	 SendMessageToPC(oPC, "Getting: " + sResRef + "--" + sFirstName + "--" + sLastName +", 1");
    
	SendMessageToPC(oPC, "Getting: " + sResRef + "--" + sFirstName + "--" + sLastName +", 3");
    // sResRef = C_RemovePlcPrefix(sResRef);
    nStackSize = GetLocalInt(oPlc, "item_stacksize");
    if (nStackSize == 0) {
      nStackSize = 1;
    }

	oNewItem = CreateItemOnObject(sResRef, oPC, nStackSize ) ;
	
	SetDescription(oNewItem, sDesc);
    SetFirstName(oNewItem, sFirstName);
    SetLastName(oNewItem, sLastName);
	
	SendMessageToPC(oPC, "Getting: " + sResRef + "--" + sFirstName + "--" + sLastName +", 4");
                                //  GetLocalString(oPlc, "item_tag"));
    if (!GetIsObjectValid(oNewItem))
	{
    	SendMessageToPC(oPC, "Getting: " + sResRef + "--" + sFirstName + "--" + sLastName +", 1");  
	// Could not create item, create generic item for the placeable.
	  	//SendMessageToPC(oPC, "Placing: " + sResRef + ", 2");
      //sResRef = GetResRef(oPlc);
      sResRef = C_PlaceableResRefToItemResRef(oPC, sResRef);
	  //	SendMessageToPC(oPC, "Placing: " + sResRef + ", 3");
      if (sResRef == "") {
        return;
      }
      oNewItem = CreateItemOnObject(sResRef, oPC, nStackSize,
                                    GetLocalString(oPlc, "item_tag"));
      if (!GetIsObjectValid(oNewItem))
	  {
        //SendMessageToPC(oPC, "Could not create item sResRef = " + sResRef);
        return;
      }
    }
    nDoAnimation = 1;
    // Set description and name
    
    SetDescription(oNewItem, sDesc);
    SetFirstName(oNewItem, sFirstName);
    SetLastName(oNewItem, sLastName);
  } 
  else
  {
    // Copy items to the user, and destroy them
	/*
    while (GetIsObjectValid(oItem)) {
      // Skip items which have already been processed and destroyed.
      if (!GetLocalInt(oItem, "ItemPlaceableDestroyed")) {
        oNewItem = CopyItem(oItem, oPC, TRUE);
        if (GetIsObjectValid(oNewItem)) {
          // Managed to create item
          // Copy description and name
          SetDescription(oNewItem, GetDescription(oItem));
          SetFirstName(oNewItem, GetFirstName(oItem));
          SetLastName(oNewItem, GetLastName(oItem));
          SetLocalInt(oItem, "ItemPlaceableDestroyed", 1);
          DestroyObject(oItem);
          nDoAnimation = 1;
        } else {
          // Could not copy item, do not destroy placeable
          //SendMessageToPC(oPC, "Copying item failed, tag = " + tTag(oItem));
          return;
        }
      }
      oItem = GetNextItemInInventory(oPlc);
    }
	*/
  }
  
  if (nDoAnimation) {
    int nInvSoundType, nBaseType;
    string sSound;

    nBaseType = GetBaseItemType(oNewItem);
    nInvSoundType = StringToInt(Get2DAString("baseitems", "InvSoundType", nBaseType));
    sSound = Get2DAString("inventorysnds", "InventorySound", nInvSoundType);
    AssignCommand(oPC,
		  DelayCommand(0.5,
			       C_PlayPickupAnimationWhenStopped(oPC,
								GetPosition(oPC),
								sSound)));
    AssignCommand(oPC, ActionWait(1.0));
  }
  SetLocalInt(oPlc, "ItemPlaceableDestroyed", 1);
  DestroyObject(oPlc);
}

// Convert placeable resref to the item resref
string C_PlaceableResRefToItemResRef(object oPC, string sResRef)
{
  string sRetResRef;
  string sNum;
  // Simplifying code, which will result in more items having to be coded,
  // but revamping so this only affects the 11 banners
  // the dropping of items will have to have the script always triggered,
  // but it only has to be called on placeables so often
  // Probably will add code to make it so enemy factions cannot take banner as well
  // They will have to attack a placed banner to get it off the field
   
  //sResRef = C_RemovePlcPrefix(sResRef);

  //sNum = GetStringRight(sResRef, 2);
  //if (sNum == "00" || StringToInt(sNum) != 0) {
    // Remove number suffix
  //  sResRef = GetStringLeft(sResRef, GetStringLength(sResRef) - 2);
  //}
  

 
  if (sResRef == "PLC_MC_bann201") { sRetResRef = "NW_IT_bann201"; }
  else if (sResRef == "PLC_MC_bann202") { sRetResRef = "NW_IT_bann202"; }
  else if (sResRef == "PLC_MC_bann203") { sRetResRef = "NW_IT_bann203"; }
  else if (sResRef == "PLC_MC_bann204") { sRetResRef = "NW_IT_bann204"; }
  else if (sResRef == "PLC_MC_bann205") { sRetResRef = "NW_IT_bann205"; }
  else if (sResRef == "PLC_MC_bann206") { sRetResRef = "NW_IT_bann206"; }
  else if (sResRef == "PLC_MC_bann207") { sRetResRef = "NW_IT_bann207"; }
  else if (sResRef == "PLC_MC_bann210") { sRetResRef = "NW_IT_bann210"; }
  else if (sResRef == "PLC_MC_bann211") { sRetResRef = "NW_IT_bann211"; }
  else if (sResRef == "PLC_MC_bann212") { sRetResRef = "NW_IT_bann212"; }

    else {
  	// This is going to fire all the time, but i only want it to affect placeables
    //SendMessageToPC(oPC, "Unknown placeable: " + sResRef + ", don't know how to map that to item");
    sRetResRef = "";
  }
  return sRetResRef;
}
/*
  //if (sResRef == "w_ssword") { sRetResRef = "nw_wswss001"; }
  //else if (sResRef == "w_lsword") { sRetResRef = "nw_wswls001"; }
  //else if (sResRef == "w_baxe") { sRetResRef = "nw_waxbt001"; }
  //else if (sResRef == "w_bsword") { sRetResRef = "nw_wswbs001"; }
  //else if (sResRef == "w_flail") { sRetResRef = "nw_wblfl001"; }
  //else if (sResRef == "w_whamr") { sRetResRef = "nw_wblhw001"; }
  //else if (sResRef == "w_crsbh") { sRetResRef = "nw_wbwxh001"; }
  //else if (sResRef == "w_crsbl") { sRetResRef = "nw_wbwxl001"; }
  //else if (sResRef == "w_lbow") { sRetResRef = "nw_wbwln001"; }
 // else if (sResRef == "w_mace") { sRetResRef = "nw_wblml001"; }
 // else if (sResRef == "w_halbd") { sRetResRef = "nw_wplhb001"; }
 // else if (sResRef == "w_sbow") { sRetResRef = "nw_wbwsh001"; }
 // else if (sResRef == "w_gsword") { sRetResRef = "nw_wswgs001"; }
 // else if (sResRef == "w_she_small") { sRetResRef = "nw_ashsw001"; }
 // else if (sResRef == "w_torch") { sRetResRef = "nw_it_torch001"; }
 // else if (sResRef == "w_gaxe") { sRetResRef = "nw_waxgr001"; }
 // else if (sResRef == "w_arrow") { sRetResRef = "nw_wamar001"; }
 // else if (sResRef == "w_dag") { sRetResRef = "nw_wswdg001"; }
 // else if (sResRef == "w_bolt") { sRetResRef = "nw_wambo001"; }
 // else if (sResRef == "w_club") { sRetResRef = "nw_wblcl001"; }
 // else if (sResRef == "w_dart") { sRetResRef = "nw_wthdt001"; }
 // else if (sResRef == "w_dmace") { sRetResRef = "nw_wdbma001"; }
 // else if (sResRef == "w_lham") { sRetResRef = "nw_wblhl001"; }
 // else if (sResRef == "w_haxe") { sRetResRef = "nw_waxhn001"; }
 // else if (sResRef == "w_kama") { sRetResRef = "nw_wspka001"; }
 // else if (sResRef == "w_kat") { sRetResRef = "nw_wswka001"; }
 // else if (sResRef == "w_kukri") { sRetResRef = "nw_wspku001"; }
 // else if (sResRef == "w_mstar") { sRetResRef = "nw_wblms001"; }
 // else if (sResRef == "w_staff") { sRetResRef = "nw_wdbqs001"; }
 // else if (sResRef == "w_rapr") { sRetResRef = "nw_wswrp001"; }
 // else if (sResRef == "w_scimt") { sRetResRef = "nw_wswsc001"; }
 // else if (sResRef == "w_scyth") { sRetResRef = "nw_wplsc001"; }
 // else if (sResRef == "w_she_large") { sRetResRef = "nw_ashlw001"; }
 // else if (sResRef == "w_she_towr") { sRetResRef = "nw_ashto001"; }
 // else if (sResRef == "w_shurkn") { sRetResRef = "nw_wthsh001"; }
 // else if (sResRef == "w_sickle") { sRetResRef = "nw_wspsc001"; }
 // else if (sResRef == "w_sling") { sRetResRef = "nw_wbwsl001"; }
  //else if (sResRef == "w_taxe") { sRetResRef = "nw_wthax001"; }
 // else if (sResRef == "w_bullet") { sRetResRef = "nw_wambu001"; }
 // else if (sResRef == "w_dwarax") { sRetResRef = "x2_wdwraxe001"; }
 // else if (sResRef == "w_falchn") { sRetResRef = "n2_wswfl001"; }
 // else if (sResRef == "w_spear") { sRetResRef = "nw_wplss001"; }
 // else if (sResRef == "i_drum") { sRetResRef = "n2_it_drum"; }
 // else if (sResRef == "i_flute") { sRetResRef = "n2_it_flute"; }
 // else if (sResRef == "i_mandolin") { sRetResRef = "n2_it_lute"; }
 // else if (sResRef == "i_beerstein") { sRetResRef = "n2_it_stein"; }
 // // else if (sResRef == "i_ink_well") { sRetResRef = "n2_it_"; }
 // // else if (sResRef == "i_lootbag") { sRetResRef = "n2_it_"; }
 // // else if (sResRef == "i_pan") { sRetResRef = "n2_it_"; }
 // // else if (sResRef == "i_pot") { sRetResRef = "n2_it_"; }
 // // else if (sResRef == "i_rake") { sRetResRef = "n2_it_"; }
 // // else if (sResRef == "i_shovel") { sRetResRef = "n2_it_"; }
 // // else if (sResRef == "i_smithyhammer") { sRetResRef = "n2_it_"; }
 // else if (sResRef == "i_spoon") { sRetResRef = "n2_it_spoon"; }
 // else if (sResRef == "i_wine_bottle") { sRetResRef = "nw_it_mpotion023"; }
  // else if (sResRef == "w_whip") { sRetResRef = "nw_w"; }
  // else if (sResRef == "w_trock") { sRetResRef = "nw_w"; }
  // else if (sResRef == "w_mstaff") { sRetResRef = "nw_w"; }
  // else if (sResRef == "w_gclub") { sRetResRef = "nw_w"; }
*/


// Remove plc_??_ prefix
string C_RemovePlcPrefix(string sResRef)
{
  // sabotaging this, im using the full tag of the item in my variation  
   return sResRef;
  string sTmp;
  if (GetStringLeft(sResRef, 4) == "plc_") {
    sTmp = GetSubString(sResRef, 4, 3);
    if (sTmp == "fl_" ||
        sTmp == "dn_" || sTmp == "up_" || 
        sTmp == "dl_" || sTmp == "ul_" || 
        sTmp == "dw_" || sTmp == "uw_") {
      return GetSubString(sResRef, 7, -1);
    }
  }
  return sResRef;
}

// Check if item is dropped on the ground, and if so create placeable on the
// ground.
void C_CreatePlaceableOnGround(object oPC, object oItem)
{
  object oArea;
  string sRef;

  // Check if it was dropped on the ground
  oArea = GetArea(oItem);
  if (!GetIsObjectValid(oArea)) {
    // No area, thus not dropped on the ground, return
    return;
  }

  sRef = C_GetItemBaseTypeResRef(oItem);
  if (sRef != "") {
    object oPlc, oNewItem;
    string sNewRef;
    location lLoc;
    vector vVec;
    float fFace;

    lLoc = GetLocation(oItem);
    vVec = GetPositionFromLocation(lLoc);
    // The item placed on the ground seems to be bit high up, so adjust
    // it down a bit
    vVec.z -= 0.1;
    fFace = GetFacing(oPC);
    lLoc = Location(oArea, vVec, fFace);
    
    // Removing this, soas to just use the real tag name
	// sRef = "plc_fl_" + sRef;
    
	// Note that GetItemAppearance nType and nIndex defines do not match the
    // real use. To get weapon blade model you need to set nType = 1 and
    // nIndex = 0.
    //sNewRef = sRef +
    //  GetStringRight("00" +
    //                 IntToString(GetItemAppearance(oItem,
    //                                               1, 0)), 2);
    oPlc = CreateObject(OBJECT_TYPE_PLACEABLE, sRef,
                        lLoc, FALSE);
    //removing the following since i am using hard coded items only
	//if (!GetIsObjectValid(oPlc)) {
    //  // Didn't work, so we do not have matching model, create base model.
    //  sNewRef = sRef + "01";
    //  oPlc = CreateObject(OBJECT_TYPE_PLACEABLE, sNewRef,
    //                      lLoc, FALSE);
    //}

    if (GetIsObjectValid(oPlc)) {
      // If you want to use locked placeables instead of the placeables doing
      // their magic on Open too, change the if (0) to if (1)
      if (0) {
        SetKeyRequiredFeedbackMessage(oPlc, "*Use this item to pick it up*");
        SetLocked(oPlc, TRUE);
      } else {
        // New version. We do not lock the placeable anymore, but do the same
        // thing on the OnOpen, OnUsed, and OnClosed events.
        SetLocked(oPlc, FALSE);
      }

      oNewItem = CopyItem(oItem, oPlc, TRUE);
      
      if (GetIsObjectValid(oNewItem)) {
        // Managed to create placeable and copy item there
        // Copy description and name
       // if (GetIdentified(oItem)) {
          // Only show the name and description if identified
          SetDescription(oPlc, GetDescription(oItem));
          SetFirstName(oPlc, GetFirstName(oItem));
          SetLastName(oPlc, GetLastName(oItem));
      //  } else {
       //   // Show generic name otherwise.
       //   string sName;
      //    sName = Get2DAString("baseitems", "Name", GetBaseItemType(oItem));
       //   sName = GetStringByStrRef(StringToInt(sName));
       //   SetFirstName(oPlc, sName);
      //    SetLastName(oPlc, "");
      //    SetDescription(oPlc, "");
      //  }
        SetDescription(oNewItem, GetDescription(oItem));
        SetFirstName(oNewItem, GetFirstName(oItem));
        SetLastName(oNewItem, GetLastName(oItem));
        DestroyObject(oItem);
      } else {
        // Failed to copy item, destroy placeable
        //SendMessageToPC(oPC, "Copying item failed, tag = " + GetTag(oItem));
        DestroyObject(oPlc);
      }
    } // if (GetIsObjectValid(oPlc))
    //else {
    // // SendMessageToPC(oPC, "Creating placeable failed, sRef = " + sRef);
    //}
  } // if (sRef != "")
}

// Convert item base type to resref of the placeable. 
string C_GetItemBaseTypeResRef(object oItem)
{
  string sRef;
  string sItemTag;
  int nBaseItem;

  
  // Simplifying to it works off of the tag of the item
  sItemTag = GetTag( oItem );
  if (sItemTag == "NW_IT_bann201") { sRef = "PLC_MC_bann201"; }
  else if (sItemTag == "NW_IT_bann202") { sRef = "PLC_MC_bann202"; }
  else if (sItemTag == "NW_IT_bann203") { sRef = "PLC_MC_bann203"; }
  else if (sItemTag == "NW_IT_bann204") { sRef = "PLC_MC_bann204"; }
  else if (sItemTag == "NW_IT_bann205") { sRef = "PLC_MC_bann205"; }
  else if (sItemTag == "NW_IT_bann206") { sRef = "PLC_MC_bann206"; }
  else if (sItemTag == "NW_IT_bann207") { sRef = "PLC_MC_bann207"; }
  else if (sItemTag == "NW_IT_bann210") { sRef = "PLC_MC_bann210"; }
  else if (sItemTag == "NW_IT_bann211") { sRef = "PLC_MC_bann211"; }
   else if (sItemTag == "NW_IT_bann212") { sRef = "PLC_MC_bann212"; }
  else { sRef = "";}

  
  // This switch could also be replaced with
  // 
  // sRef = GetStringLowerCase(Get2DAString("baseitems",
  //                           "ItemClass", nBaseItem));
  //
  // But then bolts on the ground would look like arrows, and
  // both bullets and grande type items would use "trock" model.
  // On the other hand then we could make placeable models for
  // other things like Stein, Inkwell, bag, pan, pot, rake, shovel,
  // spoon, bottle etc. We can of course add those base item type
  // numbers to the switch below, but there is no definitions for
  // them in the nwscript.nss
  //
  // Also doing 2DA lookup here might be too slow..
  //
  
  /*
   nBaseItem = GetBaseItemType(oItem);
   
  switch (nBaseItem) {
  case BASE_ITEM_SHORTSWORD: sRef = "w_ssword"; break;
  case BASE_ITEM_LONGSWORD: sRef = "w_lsword"; break;
  case BASE_ITEM_BATTLEAXE: sRef = "w_baxe"; break;
  case BASE_ITEM_BASTARDSWORD: sRef = "w_bsword"; break;
  case BASE_ITEM_LIGHTFLAIL: sRef = "w_flail"; break;
  case BASE_ITEM_WARHAMMER: sRef = "w_whamr"; break;
  case BASE_ITEM_HEAVYCROSSBOW: sRef = "w_crsbh"; break;
  case BASE_ITEM_LIGHTCROSSBOW: sRef = "w_crsbl"; break;
  case BASE_ITEM_LONGBOW: sRef = "w_lbow"; break;
  case BASE_ITEM_LIGHTMACE: sRef = "w_mace"; break;
  case BASE_ITEM_HALBERD: sRef = "w_halbd"; break;
  case BASE_ITEM_SHORTBOW: sRef = "w_sbow"; break;
  case BASE_ITEM_GREATSWORD: sRef = "w_gsword"; break;
  case BASE_ITEM_SMALLSHIELD: sRef = "w_she_small"; break;
  case BASE_ITEM_TORCH: sRef = "w_torch"; break;
  case BASE_ITEM_GREATAXE: sRef = "w_gaxe"; break;
  case BASE_ITEM_ARROW: sRef = "w_arrow"; break;
  case BASE_ITEM_DAGGER: sRef = "w_dag"; break;
  case BASE_ITEM_BOLT: sRef = "w_bolt"; break;
  case BASE_ITEM_BULLET: sRef = "w_trock"; break;
  case BASE_ITEM_CLUB: sRef = "w_club"; break;
  case BASE_ITEM_DART: sRef = "w_dart"; break;
  case BASE_ITEM_DIREMACE: sRef = "w_dmace"; break;
  case BASE_ITEM_HEAVYFLAIL: sRef = "w_flail"; break;
  case BASE_ITEM_LIGHTHAMMER: sRef = "w_lham"; break;
  case BASE_ITEM_HANDAXE: sRef = "w_haxe"; break;
  case BASE_ITEM_KAMA: sRef = "w_kama"; break;
  case BASE_ITEM_KATANA: sRef = "w_kat"; break;
  case BASE_ITEM_KUKRI: sRef = "w_kukri"; break;
  case BASE_ITEM_MAGICSTAFF: sRef = "w_mstaff"; break;
  case BASE_ITEM_MORNINGSTAR: sRef = "w_mstar"; break;
  case BASE_ITEM_QUARTERSTAFF: sRef = "w_staff"; break;
  case BASE_ITEM_RAPIER: sRef = "w_rapr"; break;
  case BASE_ITEM_SCIMITAR: sRef = "w_scimt"; break;
  case BASE_ITEM_SCYTHE: sRef = "w_scyth"; break;
  case BASE_ITEM_LARGESHIELD: sRef = "w_she_large"; break;
  case BASE_ITEM_TOWERSHIELD: sRef = "w_she_towr"; break;
  case BASE_ITEM_SHURIKEN: sRef = "w_shurkn"; break;
  case BASE_ITEM_SICKLE: sRef = "w_sickle"; break;
  case BASE_ITEM_SLING: sRef = "w_sling"; break;
  case BASE_ITEM_THROWINGAXE: sRef = "w_taxe"; break;
  case BASE_ITEM_GRENADE: sRef = "w_bullet"; break;
  case BASE_ITEM_DWARVENWARAXE: sRef = "w_dwarax"; break;
  case BASE_ITEM_WHIP: sRef = "w_whip"; break;
  case BASE_ITEM_MACE: sRef = "w_mace"; break;
  case BASE_ITEM_FALCHION: sRef = "w_falchn"; break;
  case BASE_ITEM_FLAIL: sRef = "w_flail"; break;
  case BASE_ITEM_SPEAR: sRef = "w_spear"; break;
  case BASE_ITEM_GREATCLUB: sRef = "w_gclub"; break;
  case BASE_ITEM_TRAINING_CLUB: sRef = "w_club"; break;
  case BASE_ITEM_WARMACE: sRef = "w_dmace"; break;
  case BASE_ITEM_STEIN: sRef = "i_beerstein"; break;
  case BASE_ITEM_DRUM: sRef = "i_drum"; break;
  case BASE_ITEM_FLUTE: sRef = "i_flute"; break;
  case BASE_ITEM_INK_WELL: sRef = "i_ink_well"; break;
  case BASE_ITEM_LOOTBAG: sRef = "i_lootbag"; break;
  case BASE_ITEM_MANDOLIN: sRef = "i_mandolin"; break;
  case BASE_ITEM_PAN: sRef = "i_pan"; break;
  case BASE_ITEM_POT: sRef = "i_pot"; break;
  case BASE_ITEM_RAKE: sRef = "i_rake"; break;
  case BASE_ITEM_SHOVEL: sRef = "i_shovel"; break;
  case BASE_ITEM_SMITHYHAMMER: sRef = "i_smithyhammer"; break;
  case BASE_ITEM_SPOON: sRef = "i_spoon"; break;
  case BASE_ITEM_BOTTLE: sRef = "i_wine_bottle"; break;
  case BASE_ITEM_CGIANT_SWORD: sRef = "w_gsword"; break;
  case BASE_ITEM_CGIANT_AXE: sRef = "w_gaxe"; break;
  case BASE_ITEM_ALLUSE_SWORD: sRef = "w_lsword"; break;
  }
  */
  return sRef;
}

// Play pickup animation. This needs to be delayed as the PC is still running
// when OnOpen and OnUsed scripts are run. The animation will be run when the
// PC has stopped, i.e. vLastPos and current position of PC are same. It will
// be delayed at max nTries times, and each operation is delayed by fDelay
// seconds. When the pickup animation is played the given sound is also played.
void C_PlayPickupAnimationWhenStopped(object oPC, vector vLastPos,
				      string sSound = "",
                                      int nTries = 10,
                                      float fDelay = 0.5)
{
  vector vPos;
  vPos = GetPosition(oPC);
  //  SendMessageToPC(oPC, "Trying to play animation, vLastPos = ["
  //                  + FloatToString(vLastPos.x, 1, 2) + ", "
  //                  + FloatToString(vLastPos.y, 1, 2) + ", "
  //                  + FloatToString(vLastPos.z, 1, 2) + "], vPos = ["
  //                  + FloatToString(vPos.x, 1, 2) + ", "
  //                  + FloatToString(vPos.y, 1, 2) + ", "
  //                  + FloatToString(vPos.z, 1, 2) + "], dist = "
  //                  + FloatToString(fabs(VectorMagnitude(vPos - vLastPos)),
  //                                  1, 2));
                  
  if (fabs(VectorMagnitude(vPos - vLastPos)) < 0.01) {
    // Stopped, run animation
    if (sSound != "") {
      PlaySound(sSound);
    }
    PlayCustomAnimation(oPC, "getground", 0);
    return;
  }
  nTries--;
  if (nTries <= 0) {
    //    SendMessageToPC(oPC, "PC didn't stop, so pickup animation not run");
    return;
  }
  DelayCommand(0.5, C_PlayPickupAnimationWhenStopped(oPC, vPos, sSound,
                                                     nTries, fDelay));
}