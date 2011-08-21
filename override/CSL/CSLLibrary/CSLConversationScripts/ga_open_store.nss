/*
This is a SP Official campaign script for features in the single player game
*/
// ga_open_store
/* 
	Opens store with tag sTag for the PC Speaker.  
	nMarkUp/nMarkDown are a percentage value that modifies the base price for an item.
	Function also adds or subtracts numbers to the markup and markdown values depending on the result of the appraise skill check.
*/
// ChazM 5/9/06 - changed to gplotAppraiseOpenStore
// ChazM 8/30/06 - new appraise open store function used.
// NLC 10/16/08 - Recompiled for NX2 Changes.
//#include "ginc_misc"
//#include "nw_i0_plot"
#include "_CSLCore_Messages"
#include "_CSLCore_Items"
	
void main(string sTag, int nMarkUp, int nMarkDown)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	//OpenStore(GetTarget(sTag), oPC, nMarkUp, nMarkDown);
	CSLItemRecreateFromBlueprint(CSLGetTarget(sTag));
	CSLStoreAppraiseOpenStore(CSLGetTarget(sTag), oPC, nMarkUp, nMarkDown);
	
}