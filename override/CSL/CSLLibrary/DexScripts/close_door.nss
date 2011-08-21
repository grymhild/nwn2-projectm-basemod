void main() { 
   DelayCommand(3.0, ActionCloseDoor(OBJECT_SELF)); 
   if (GetLockLockable(OBJECT_SELF)) SetLocked(OBJECT_SELF,1); 
} 