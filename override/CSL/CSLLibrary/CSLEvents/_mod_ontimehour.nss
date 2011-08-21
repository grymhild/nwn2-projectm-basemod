//#include "_SCInclude_Summon"

void main()
{
  object oModule = GetModule();
  int iElapsedHours = GetLocalInt( oModule, "CSL_CURRENT_ROUND" )/600;
}