// Create the specified object, and schedule it to disappear after fDelay if fDelay non zero
// sTarget - the target indicating the location to create this object, see ginc_param_const
//           or use a tag value of a nearby object.
// string sCheckForTag - if present, we'll check first for whether an object with the
//                       specied tag already exists
//                       also if present, we'll make sure the newly created object
//                       uses this tag. .

#include "_CSLCore_Messages"

void main(string sTarget, string sResRef,  float fDelay, string sCheckForTag = "")
{
    if (sCheckForTag != "") {
        object oDest = GetObjectByTag(sCheckForTag);
        if (GetIsObjectValid(oDest)) {
			if (DEBUGGING >= 4) { CSLDebug(  sResRef + " already exists, not creating."); }
            return;
        }
    }
    if (DEBUGGING >= 4) { CSLDebug(  "Creating " + sResRef + " for " + FloatToString(fDelay)); }
    object oTarget = CSLGetTarget(sTarget);
    if (!GetIsObjectValid(oTarget)) {
        if (DEBUGGING >= 4) { CSLDebug( "Could not find target: " + sTarget); }
        return;
    }
    object oNew = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, GetLocation(oTarget), FALSE, sCheckForTag);
    if (!GetIsObjectValid(oNew)) {
        if (DEBUGGING >= 4) { CSLDebug( "Could not create object: " + sResRef); }
        return;
    }
    if (fDelay > 0.0) {
        DestroyObject(oNew, fDelay);
    }


}
