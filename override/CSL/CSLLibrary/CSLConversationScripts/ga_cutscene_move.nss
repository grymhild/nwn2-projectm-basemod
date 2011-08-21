// ga_cutscene_move
//
// Move and delay the advancing of the conversation for a maximum of nMilliseconds.
// Conversation will also advance if the move completes.
// "" for sMoverTag -> OBJECT_SELF

//
#include "_CSLCore_Messages"	
	
void main(string sWPTag, int nMilliseconds, int bRun, string sMoverTag)
{
	object oTarget; 
	if(sMoverTag == "")
	{
		oTarget = OBJECT_SELF;
	}
	else
	{
		oTarget = CSLGetTarget(sMoverTag);
	}
	
	ActionPauseCutscene(nMilliseconds);
	AssignCutsceneActionToObject(oTarget, ActionMoveToObject(CSLGetTarget(sWPTag), bRun));
}