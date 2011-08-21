void main()
{
   object oPC = GetClickingObject();
   object oTarget = GetTransitionTarget(OBJECT_SELF);
   AssignCommand(oPC, JumpToObject(oTarget));
   DelayCommand(6.0, AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF)));
   SetLocked(OBJECT_SELF, 1);
}