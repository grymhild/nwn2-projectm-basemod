//#include "inc_pw"
#include "x2_inc_spellhook"
void main()
{
    location lTarget = HkGetSpellTargetLocation();
    object oObject = HkGetSpellTarget();
    object oCaster = OBJECT_SELF;

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    // Then again, because it seems that 'can cast on item' check is broken (i.e., I've
    // updated des_crft_items.2da to contain this spell as one that can be cast on items, but it's still
    // not working...
    if (!X2PreSpellCastCode())
        return;
    if (!GetIsObjectValid(oObject))
        return;


    SignalEvent(oObject, EventSpellCastAt(oObject, 1520, FALSE));
    object oHands = CreateObject(OBJECT_TYPE_CREATURE, "magehands", lTarget, FALSE);
    LogObjectMessage(oHands, "doRetrieval: Hands created. Targetting " + GetName(oObject));
    int bSuccess = FALSE;

    if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE && GetHasInventory(oObject)) {
        LogObjectMessage(oHands, "doRetrieval: Object is a placeable with inventory.");
        if (!GetLocked(oObject)) {
            LogObjectMessage(oHands, "doRetrieval: Placeable is not locked.");
            // We have to open this first -- otherwise, scripts which create item 'on open'
            // won't fire.
            AssignCommand(oHands, DoPlaceableObjectAction(oObject, PLACEABLE_ACTION_USE));
            bSuccess = TRUE;
        }
    } else if (GetObjectType(oObject) == OBJECT_TYPE_ITEM) {
        LogObjectMessage(oHands, "doRetrieval: Object is a an item.");
        if (!GetIsObjectValid(GetItemPossessor(oObject))) {
            LogObjectMessage(oHands, "doRetrieval: Item is not in someone's inventory.");
            bSuccess = TRUE;
        }
    }
    if (!bSuccess) {
        AssignCommand(oHands, SpeakString("* spreads its hands as if to say, 'And...?' *"));
        DelayCommand(6.0, ActionDoCommand(DestroyObject(oHands)));
    } else {
        SetLocalObject(oHands, "CASTER", oCaster);
        SetLocalObject(oHands, "TARGET", oObject);
        // Give it 60 seconds to reach caster.
        DelayCommand(60.0, ActionDoCommand(DestroyObject(oHands)));
    }
}
