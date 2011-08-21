#include "_CSLCore_Messages"
#include "_SCInclude_DynamConvos"
//#include "x2_inc_switches"

void main() {
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();
   if (!GetIsPC(oTarget)) { // Target needs to be PC and not self
      oTarget = OBJECT_INVALID;
   }
   if (GetIsDM(oPC)) {
      if (oTarget==OBJECT_INVALID) {
         SendMessageToPC(oPC, "Please select a valid target.");
         return;
      }
   }
   SetLocalObject(oPC, "DM_STRIP", oTarget);
   CSLOpenNextDlg(oPC, GetItemActivated(), "dm_propstrip", TRUE, FALSE);
}