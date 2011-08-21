/* Changelog 
=================================================================
DATE:		Author		Function			Changes
DD-MMM-YYYY										

=================================================================
/**/
// ga_give_item( string sTemplate, int nQuantity, int bAllPCs )
/*
	Creates item on PC(s)
	
	Parameters:
		string sTemplate = Item blueprint ResRef
		int    nQuantity = Stack size for item (default: 1)
		int    bAllPCs	 = If =1 create item on all player characters (MP)
*/
// FAB 9/30
// ChazM 10/19/05 - check if item is stackable and if not then give the quantity 1 at a time.
// EPF 7/27/06 -- complete rewrite to address a bug and a number of stylistic pet peeves.  Also
// 			      using a new method of tracking whether an item is stackable that Dan suggested.

//#include "ginc_debug"

void CreateItemsOnObject( string sTemplate, object oTarget=OBJECT_SELF, int nItems=1 );

void main( string sTemplate, int nQuantity, int bAllPCs, int iOnlyOnce )
{	
    object oPC = GetPCSpeaker();
	
	if( (iOnlyOnce) == 1 && (GetIsObjectValid(GetItemPossessedBy(oPC, sTemplate)) == TRUE) )
		return;
	
	if ( GetIsObjectValid(oPC) == FALSE ) 
	{
		oPC = OBJECT_SELF;
	}

	// default stack size
	if ( nQuantity < 1 )
	{
		nQuantity = 1;
	}

	if ( bAllPCs == FALSE )
	{
		CreateItemsOnObject( sTemplate, oPC, nQuantity );
	}
	else
	{
		oPC = GetFirstPC();
		while ( GetIsObjectValid(oPC) == TRUE )
		{
			CreateItemsOnObject( sTemplate, oPC, nQuantity );
			oPC = GetNextPC();
		}
	}
}

void CreateItemsOnObject( string sTemplate, object oTarget=OBJECT_SELF, int nItems=1 )
{
	
	int i = 1;
	while ( i <= nItems )
	{
		CreateItemOnObject( sTemplate, oTarget, 1 );
		i++;
	}
}