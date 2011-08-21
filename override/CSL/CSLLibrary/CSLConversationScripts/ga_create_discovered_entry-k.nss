// Creates a discovered entry that will disappear after a set time.
// sTarget - the target indicating the location to create this object, see ginc_param_const
//           or use a tag value of a nearby object.
// sDestTag - object tag that this portal will go to.
// fDuration   - how long should the portal remain?
// bSparkle    - play a sparkly vfx.
// sName        - use-friendly name to display when player mouses over the transition object
// fScale       - scale to use on transition object, to make it bigger or smaller.
// If this portal already exists for this destination, it will not be created again.
//

#include "_CSLCore_Messages"

void main(string sTarget, string sDestTag, float fDuration, int bSparkle = 0, string sName = "Entrance", float fScale = 0.0f)
{
    object oTarget = CSLGetTarget(sTarget);
    if (!GetIsObjectValid(oTarget))
    {
        if (DEBUGGING >= 4) { CSLDebug(  "Could not find target: " + sTarget); }
        return;
    }
    string sResRef = "hidden_entry";
    if (bSparkle) {
        sResRef = sResRef + "_sp";
    }
    string sNewTag = sResRef + sDestTag;
    object oDest = GetObjectByTag(sNewTag);
    if (GetIsObjectValid(oDest)) {
        if (DEBUGGING >= 4) { CSLDebug(  sNewTag + " already exists, not creating."); }
        return;
    }

    if (DEBUGGING >= 4) { CSLDebug(  "Creating " + sResRef + " for " + FloatToString(fDuration) + " which goes to " + sDestTag); }
    object oNew = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, GetLocation(oTarget), FALSE, sNewTag);
    if (!GetIsObjectValid(oNew)) {
        if (DEBUGGING >= 4) { CSLDebug(  "Could not create object: " + sResRef); }
        return;
    }
    SetFirstName(oNew, sName);
    SetLocalString(oNew, "JUMP_TARGET", sDestTag);
    if (fScale != 1.0f && fScale > 0.0f) {
        SetScale(oNew, fScale, fScale, fScale);

    }
    if (fDuration > 0.0) {
        DestroyObject(oNew, fDuration);
    }
}