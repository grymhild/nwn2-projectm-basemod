//Script obtained from Obsidian Boards post by Mithdradates.
// The_Puppeteer 01-13-10  Edited to use GetNearestCreature in place of GetFirstPC.

//#include "ginc_ai"
//#include "sod_ai_i"
#include "_SCInclude_AI"
#include "_HkSpell"

void main()
{
	object oPC=GetFirstPC();
	object oTarget=GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

//The_Puppeteer 11-28-10  Checks to see if creatures flee.  Variables are described in sod_ai_i
//********************************************************************************************
	object oCreature = OBJECT_SELF;
	
	int iAIMasterFlag = CSLGetAIMasterFlag( oCreature );
	if ( iAIMasterFlag & CSL_FLAG_FLEE )
	{
		if ( !GetLocalInt(oCreature, "flee_spooked") )
		{
			// SpeakString("I'm a coward!");  //Debugging lines  The_Puppeteer
			SOD_FleeAllHostiles(oCreature);
		}
		return;
	}
//End of The_Puppeteer additions
//*************************************************************************************************8

	float  fDistance, fClosest=100000000.0;
	object oClosest=OBJECT_INVALID;
	while (GetIsObjectValid(oTarget))
	{
		if (GetObjectSeen(oTarget)||GetObjectHeard(oTarget))
		{
			fDistance=GetDistanceBetween(oTarget, oCreature);
			if (fDistance<fClosest)
			{
				oClosest=oTarget;
				fClosest=fDistance;
			}
		}
		oTarget=GetNextFactionMember(oPC,FALSE);
	};
	if (!GetIsObjectValid(oClosest)) return;
	
	ClearAllActions(TRUE);
	SCWrapperActionAttack(oClosest);
	SetCreatureOverrideAIScriptFinished();
	return;
}