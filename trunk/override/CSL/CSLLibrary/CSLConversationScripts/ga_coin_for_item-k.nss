#include "_CSLCore_Messages"

void main(string sResref, int nPrice, int nStackSize)
{
    object oPC = GetPCSpeaker();
    if  (GetIsObjectValid(oPC)) {
        /// @todo need to modfy to use money system!
        if (GetGold(oPC) >= nPrice) {
            object oItem = CreateItemOnObject(sResref, oPC, nStackSize);
            if (GetIsObjectValid(oItem)) {
                TakeGoldFromCreature(nPrice, oPC, FALSE);
            } else {
                SendMessageToPC(oPC, "An error has occurred. Please report this.");
                if (DEBUGGING >= 4) { CSLDebug( "Could not create iitem in ga_coin_for_item: " + sResref ); }
            }
        }
    }
}
