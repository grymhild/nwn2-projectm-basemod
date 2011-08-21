#include "_SCInclude_Encounter"

void main() {
   object oEnc = OBJECT_SELF;
   float nDelay = BOSS_SPAWN_DELAY * 60.0;
   if (GetSpawnState(oEnc)==SPAWN_STATE_ACTIVE) { // IN JUST FIRED MODE
      SetSpawnState(oEnc, SPAWN_STATE_WAITING); // SET TO WAIT MODE
      AssignCommand(GetModule(), DelayCommand(nDelay, SetSpawnState(oEnc, SPAWN_STATE_READY))); // RESET TO READY IN 15 MINUTES
   }
} 