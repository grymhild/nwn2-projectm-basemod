void main() {
	DelayCommand(10.0, ActionCloseDoor(OBJECT_SELF));
	if (GetLockKeyRequired(OBJECT_SELF)) SetPlotFlag(OBJECT_SELF, FALSE);
	//if(GetLockLockable(OBJECT_SELF) || GetLockKeyRequired(OBJECT_SELF)) SetLocked(OBJECT_SELF,1);
}