////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////

#include "_CSLCore_Player"

int IsTransAllowed(object oPC, object oTarget)
{ 
	object oArea = GetArea(oTarget);
	object oAreaOld = GetArea(oPC);
	if (!CSLPCCanEnterArea(oPC, oArea))
	{
		int nMax = GetLocalInt(oArea, "MAXLEVEL");
		int nOldMax = GetLocalInt(oAreaOld, "MAXLEVEL");
		if ( nOldMax == 0 || nMax <  nOldMax )
		{
			PlaySound("vs_favhen4m_no");
			FloatingTextStringOnCreature("You're Too High!", oPC, FALSE);
			SendMessageToPC(oPC, "Sorry, this leads to a special section of the module that is restricted to Levels " + IntToString(nMax) + " and under.");
			return FALSE;
		}
		else // exception since both areas are the same
		{
			SetLocalInt(oPC, "SC_DMPORT", TRUE);
			DelayCommand( 20.0f, SetLocalInt(oPC, "SC_DMPORT", FALSE) );
		}
	}
	if (GetAttemptedAttackTarget()!=OBJECT_INVALID)
	{
		SendMessageToPC(oPC, "Target Lock! Valid Transition.");
		//      FloatingTextStringOnCreature("Target Lock! Valid Transition", oPC, FALSE);
		return TRUE;
	}
	if (CSLGetIsHostilePCClose(oPC, 10.0, 4))  // HOSTILE PC WITHIN 4 LEVELS IS CLOSER THAN 10 METERS
	{
		SendMessageToPC(oPC, "A worthy opponent blocks your transition...");
		return FALSE; 
	}
	if (GetLocalInt(oPC, "TRANS"))
	{
		SendMessageToPC(oPC, "You may only transition once every 12 seconds.");
		return FALSE;
	}
	return TRUE;
}

void main()
{
	object oPC = GetClickingObject();
	object oTarget = GetTransitionTarget(OBJECT_SELF);
	object oArea = GetArea(oTarget);
	if (!IsTransAllowed(oPC, oTarget))
	{
		return;
	}
	//int iActionMode = GetActionMode(object oCreature, int nMode);
	// Gets the status of ACTION_MODE_* modes on a creature.
//int GetActionMode(object oCreature, int nMode);

// Sets the status of modes ACTION_MODE_* on a creature.
//void SetActionMode(object oCreature, int nMode, int nStatus);
	
	SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
	SetLocalInt(oPC, "TRANSING", TRUE );
	//SetLocalInt( oPC, "TRANSITION", TRUE );
	AssignCommand(oPC, JumpToObject(oTarget));
}