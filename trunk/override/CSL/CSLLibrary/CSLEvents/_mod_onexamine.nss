//#include "_CSLCore_Messages"
//#include "_CSLCore_Time"
//#include "_SCInclude_Events"
//#include "_CSLCore_Player"
#include "_SCInclude_Language"
void main()
{
  	object oChar = GetControlledCharacter(OBJECT_SELF);
  	
  	
  	if ( GetIsObjectValid(oChar) )
  	{
		object oTarget = GetPlayerCreatureExamineTarget( oChar );
		if ( !GetIsObjectValid(oTarget) )
		{
			oTarget = GetLocalObject(oChar, "CSL_EXAMINE_TARGET"); // this is set on a script for a second after examining an item
		}
		
		if ( !GetIsObjectValid(oTarget) )
		{
			oTarget = GetPlayerCurrentTarget(oChar);
		}
		
		
		if ( GetIsObjectValid(oTarget) )
		{
			// do whatever has to happen on a target now
			// intercepts the normal examine event, closes it, and shows the book interface instead
			if ( GetBaseItemType(oTarget) == BASE_ITEM_BOOK || GetBaseItemType(oTarget) == BASE_ITEM_SPELLSCROLL || GetBaseItemType(oTarget) == BASE_ITEM_BLANK_SCROLL || GetBaseItemType(oTarget) == BASE_ITEM_ENCHANTED_SCROLL )
			{
				if( GetLocalInt(oTarget, "CSLBOOK_BOOK" )) // only items configured as books will receive this at this point
				{
					// so lets close the examine interface, and show the book interface instead
					
					// i'd like to set up a on-examine event as well instead, which might be pretty easy to accomodate
					CloseGUIScreen( oChar, "SCREEN_EXAMINE");
					SCBook_Display( oTarget, oChar );
					return;
				}
			}
		}
  	}
  	//sMessage = GetStringLeft( sMessage,900);
}