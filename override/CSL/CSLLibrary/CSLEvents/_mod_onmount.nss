/*
This is a basic trigger
*/
#include "_CSLCore_Environment"

void main()
{
	object oPC =  OBJECT_SELF; 
	if( !GetIsObjectValid( oPC ) )
	{
		return;
	}
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
	if( !GetIsObjectValid(oItem) || GetBaseItemType(oItem) != BASE_ITEM_CLOAK || !CSLStringStartsWith( GetTag(oItem), "steed", FALSE ) )
	{
		CSLAnimationOverride( oPC, CSL_ANIMATEOVERRIDE_NONE );
		SendMessageToPC( oPC, "You dismount"  );
		return;
	}
	
	
	if ( GetBaseItemType(oItem) == BASE_ITEM_CLOAK && CSLStringStartsWith( GetTag(oItem), "steed", FALSE )  )
	{
		CSLAnimationOverride( oPC, CSL_ANIMATEOVERRIDE_RIDING ); // modify as needed to use correct mode in relation to this item
		
		SendMessageToPC( oPC, "You started riding"  );
	}
}