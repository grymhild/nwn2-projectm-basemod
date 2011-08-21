void main() {
   object oDoor = GetNearestObject(OBJECT_TYPE_DOOR, OBJECT_SELF);
   SetLocked(oDoor, FALSE);
   ActionOpenDoor(oDoor);   
}