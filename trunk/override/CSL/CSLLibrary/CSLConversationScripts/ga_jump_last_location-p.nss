void main()
{
  	location lLoc;
	object oPC=GetPCSpeaker();
	lLoc=GetLocalLocation(oPC,"locStart");
	DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(lLoc)));
	DelayCommand(0.7, AssignCommand(oPC, SetFacing(GetFacingFromLocation(lLoc))));
}