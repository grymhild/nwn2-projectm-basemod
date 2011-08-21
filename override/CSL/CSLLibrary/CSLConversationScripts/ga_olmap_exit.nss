//ka_olmap_exit 
//script to run OnExit() of OL Map

#include "_SCInclude_Overland"

void main()
{
	object oExit = GetExitingObject();
	if( GetIsPC(oExit) )
		ExitOverlandMap(oExit);
}