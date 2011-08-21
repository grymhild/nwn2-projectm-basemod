#include "_SCInclude_AI_IntellDev"

//Checks to see how the intellect devourer should merge
void main()
{
	//SendMessageToPC(GetFirstPC(), "RUNNING_1");
	object oKiller=GetLastKiller();
	CS_IntellectDevourer( oKiller );
}