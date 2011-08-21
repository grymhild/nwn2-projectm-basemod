#include "_CSLCore_Magic"
//#include "_CSLCore_Messages"

void main() {
   object oPC = GetExitingObject();
   DeleteLocalInt(oPC, "UNDERWATER");
   CSLRemoveEffectByType(oPC, EFFECT_TYPE_MOVEMENT_SPEED_DECREASE, SUBTYPE_SUPERNATURAL, OBJECT_SELF);
   SendMessageToPC(oPC, "You have exited deep water");
}