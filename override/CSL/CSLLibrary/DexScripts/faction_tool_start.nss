#include "_SCInclude_faction"
//#include "dmfi_inc_conv"
#include "_SCInclude_DynamConvos"
//#include "x2_inc_switches"

void main() {
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();
   if (!GetIsPC(oTarget) || oPC == oTarget) { // Target needs to be PC and not self
      oTarget = OBJECT_INVALID;
   }
   if (GetIsDM(oPC)) {
      if (oTarget==OBJECT_INVALID) {
         SendMessageToPC(oPC, "Please select a valid target.");
         return;
      }
   }
   if (!SDB_FactionIsMember(oPC) && !GetIsDM(oPC)) {
      SendMessageToPC(oPC, "You're not in a faction. Removing faction token...");
      DestroyObject(GetItemActivated());
      return;
   }
   SetLocalObject(oPC, SDB_TOME_TARGET, oTarget);
  //CSLStartDlg(oPC,GetItemActivated(),"seed_factiontool",TRUE,FALSE);
   CSLOpenNextDlg(oPC, GetItemActivated(), "seed_factiontool", TRUE, FALSE);
}