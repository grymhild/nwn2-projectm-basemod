/** @file
* @brief Include for Dex Ammo Box System
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



//#include "_inc_helper_functions"
//#include "_inc_propertystrings"

#include "_HkSpell"
#include "_CSLCore_Items"
#include "_CSLCore_Config_c"

// CREATES AMMO BASED ON THE TAG OF THE AMMOBOX
void SCUseAmmoBox(object oPC, object oBox)
{
	/// DEBUGGING  = 5;
	string sList = GetTag(oBox);
	
	if (DEBUGGING >= 5) { CSLDebug(  "Ammo Box"+sList, oPC ); }
	
	//SendMessageToPC(oPC, "Working with data Tag "+sList);
	sList = GetLastName(oBox);   
	//SendMessageToPC(oPC, "Working with Last Name "+sList);
	string sValue = "";
	object oItem;
	string sResRef = "";
	string sName;
	int nBaseItem;
	//int nBaseItemCategory = 0;
	int nProp;
	int nPropSub;
	int iBonus;
	int nCount = 0;
	string sDamageList;
	int bIsVamp = FALSE;
	int bIsMighty = FALSE;
	
	int nStack = 0;
	sList = CSLNth_Shift(sList, "_"); // TAKES THE FIRST VALUE OFF LIST AND RETURNS TRUNCATED LIST
	sValue = CSLNth_GetLast(); // FIRST ELEMENT IDENTIFIES ITEM AS AN AMMOBOX
	if (DEBUGGING >= 5) { CSLDebug(  "Ammo Box 1 sValue="+sValue, oPC ); }
	if (sValue=="AB")
	{
		sList = CSLNth_Shift(sList, "_");
		sValue = CSLNth_GetLast(); // SECOND ELEMENT IS THE BASEITEM 2DA ID
		if (DEBUGGING >= 5) { CSLDebug(  "Ammo Box 2 sValue="+sValue, oPC ); }
		nBaseItem = StringToInt(sValue);
		//nBaseItemCategory = CSLGetBaseItemCategory( nBaseItem );
		int iBaseItemProps = CSLGetBaseItemProps( nBaseItem );
		nStack = ( iBaseItemProps & ITEM_ATTRIB_AMMO ) ? 99 : 500;
		
		if ( iBaseItemProps & ITEM_ATTRIB_AMMO || iBaseItemProps & ITEM_ATTRIB_WEAPON )
		{
			sResRef = CSLGetBaseItemResRef(nBaseItem); // GET THE RESREF OF THE ITEM TO CREATE
		}
      	if (DEBUGGING >= 5) { CSLDebug(  "Ammo Box 2 sResRef="+sResRef+" nStack="+IntToString(nStack), oPC ); }
		
		//SendMessageToPC(oPC, "Creating items based on "+sResRef+" from the base item of "+IntToString( nBaseItem ) );
		if ( sResRef != "" )
		{
			oItem = CreateItemOnObject(sResRef, oPC, nStack);
			sList = CSLNth_Shift(sList, "_"); // POP THE FIRST PROP TYPE
			sValue = CSLNth_GetLast();
			if (DEBUGGING >= 5) { CSLDebug(  "Ammo Box 3 sValue="+sValue, oPC ); }
			while (sValue!="" && nCount < 8)  // LOOP OVER THE PROP LIST, MAX OF 8 PROPERTIES
			{
				if (DEBUGGING >= 5) { CSLDebug(  "Ammo Box loop sValue="+sValue, oPC ); }
				nProp = StringToInt(sValue); // SAVE THE FIRST PROP TYPE
				sList = CSLNth_Shift(sList, "_");        // POP THE SUBPROP TYPE
				if (nProp==ITEM_PROPERTY_DAMAGE_BONUS) // ONLY DAMAGE HAS SUBPROPS, WE DON"T SAVE IT OTHERWISE TO SAVE SPACE IN THE TAG
				{
					nPropSub = StringToInt(CSLNth_GetLast());  // SAVE THE SUBPROP TYPE
					sList = CSLNth_Shift(sList, "_");        // POP THE BONUS AMOUNT
				}   
				iBonus = StringToInt(CSLNth_GetLast());    // SAVE BONUS AMOUNT
				CSLSafeAddItemProperty(oItem, CSLCreateItemProperty(nProp, nPropSub, iBonus));
				switch (nProp) // ADD THE PROPERTY
				{
					case ITEM_PROPERTY_DAMAGE_BONUS:
						if (sDamageList!="") sDamageList +="/";
						sDamageList += CSLIPDamagetypeToString(nPropSub);
						break;
					case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
						bIsVamp = TRUE;
						break;
					case ITEM_PROPERTY_MIGHTY:
						bIsMighty = TRUE;
						break;
				}        
				nCount++;
				sList = CSLNth_Shift(sList, "_"); // POP THE NEXT PROP
				sValue = CSLNth_GetLast();
				
			}
		}
		if ( GetIsObjectValid(oItem) )
		{
			sName = GetFirstName(oItem) + "s";
			if (bIsVamp) sName = "Vampiric " + sName;
			if (bIsMighty) sName = "Mighty " + sName;
			if (sDamageList!="") sName += " of " + sDamageList;
			SetFirstName(oItem, sName);
			nStack = GetItemCharges(oBox);
			SendMessageToPC(oPC, "You removed 1 stack of " + sName + " from the Ammo Box. You have " + IntToString(nStack) + CSLAddS(" stack", nStack) + " remaining.");
			SetFirstName(oBox, "Ammo Box with " + IntToString(nStack) + CSLAddS(" stack", nStack) + " of " + sName);
		}
	}
}