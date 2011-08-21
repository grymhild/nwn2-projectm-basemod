int StartingConditional()
{
	object oItem, oPC=GetPCSpeaker();
	int CSLHasItemByTag;

	//Item is already registered.  Registered immediately when PC places it into the craftsman's workbench.
	//See script moduleitemlost.
	if (GetIsOwnedByPlayer(oPC)==FALSE) oPC=GetOwnedCharacter(oPC);
	oItem=GetLocalObject(oPC, "Forge_Item");

	if (oItem==OBJECT_INVALID)
	{
		CSLHasItemByTag=FALSE;
	}
	else
	{
		SetLocalInt(oPC, "Forge_ItemOriginalCost", GetGoldPieceValue(oItem));
		SetCustomToken(100, GetName(oItem));
		CSLHasItemByTag=TRUE;
	}
   return CSLHasItemByTag;
}