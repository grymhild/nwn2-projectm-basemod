//#include "inc_pw"

void main()
{
    object oCaster = GetLocalObject(OBJECT_SELF, "CASTER");
    if (!GetIsObjectValid(oCaster))
        return;
    object oObject = GetLocalObject(OBJECT_SELF, "TARGET");
    //LogObjectMessage(OBJECT_SELF, "spell_magehandhb: Caster is " + GetName(oCaster));
    if (GetIsObjectValid(oObject)) { // first we have to pick an item out of inventory
        //LogObjectMessage(OBJECT_SELF, "spell_magehandhb: Target is " + GetName(oObject));
        /// @todo After spell is set to be castable on itme , make sure to check for diff behavior of
        // items v object
        if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE && GetHasInventory(oObject)) {
            object oItem = GetFirstItemInInventory(oObject);
            if (!GetIsObjectValid(oItem)) {
                AssignCommand(OBJECT_SELF, ActionSpeakString("* spreads its hands as if to say, 'And...?' *"));
                DelayCommand(6.0, ActionDoCommand(DestroyObject(OBJECT_SELF)));
                return;
            }
            int nMax = 4;
            int nCount = 0;
            while (GetIsObjectValid(oItem) && nCount < nMax) {
                AssignCommand(OBJECT_SELF, ActionTakeItem(oItem, oObject));
                oItem = GetNextItemInInventory(oObject);
                nCount = nCount + 1; /// @todo ++ doesn't work with PRC compiler
            }
        } else if (GetObjectType(oObject) == OBJECT_TYPE_ITEM) {
            AssignCommand(OBJECT_SELF, ActionPickUpItem(oObject));
        }
        // Delete this so that next heartbteat, we know it's time to find our caster.
        DeleteLocalObject(OBJECT_SELF, "TARGET");
    } else {
        // We have the object, now bring it to master.
        float fDistance = GetDistanceToObject(oCaster);
        if (fDistance > 2.0 || fDistance == -1.0) {
            //LogObjectMessage(OBJECT_SELF, "Seeking: " + GetName(oCaster) + " who is " + FloatToString(fDistance) + " feet away.");
            AssignCommand(OBJECT_SELF, ActionForceMoveToObject(oCaster));
        } else {
            ClearAllActions(TRUE);
            object oItem = GetFirstItemInInventory(OBJECT_SELF);
            while (GetIsObjectValid(oItem)) {
                AssignCommand(OBJECT_SELF, ActionPutDownItem(oItem));
                oItem = GetNextItemInInventory(OBJECT_SELF);
            }
            AssignCommand(OBJECT_SELF, ActionDoCommand(GiveGoldToCreature(oCaster, GetGold())));
            AssignCommand(OBJECT_SELF, ActionDoCommand(DestroyObject(OBJECT_SELF)));
        }
    }
}

