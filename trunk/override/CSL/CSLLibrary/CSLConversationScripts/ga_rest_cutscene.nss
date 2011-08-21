/*
This is a SP Official campaign script for features in the single player game
*/
//#include "ginc_misc"
#include "_SCInclude_Group"
#include "_SCInclude_AI"


//// Functions	
	
void PlayRestAnimations();
void RestEntireParty();
void FadePartyToBlack();
void FadePartyFromBlack();
void RestedMessage();
void FreezeParty();
void PartyFollowingOff();

////

void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oCamp = OBJECT_SELF;
	object oTarget = OBJECT_SELF;

	{
		PartyFollowingOff();
		SCGroupSetCircleFormation((SCGetPartyGroup(oPC)), FORMATION_HUDDLE_FACE_IN, 3.0f);	
		SCGroupSetNoise(PARTY_GROUP_NAME, 1.0f, 10.0f, 1.0f);
		SCGroupMoveToObject(PARTY_GROUP_NAME, oTarget, MOVE_WALK);	
		AssignCommand(oPC, ActionDoCommand(SCGroupMoveToObject(PARTY_GROUP_NAME, oTarget, MOVE_WALK)));
		AssignCommand(oPC, ActionDoCommand(PlayRestAnimations()));
		AssignCommand(oPC, ActionWait(4.0));
		AssignCommand(oPC, ActionDoCommand(FadePartyToBlack()));
		AssignCommand(oPC, ActionWait(3.0));
		AssignCommand(oPC, ActionDoCommand(RestEntireParty()));
		AssignCommand(oPC, ActionDoCommand(FadePartyFromBlack()));
		AssignCommand(oPC, ActionDoCommand(RestedMessage()));
		AssignCommand(oPC, FreezeParty());
		return;
	}
}
	
void PlayRestAnimations()
{
	object oPC = GetFirstPC();
	object oPartyMember = GetFirstFactionMember(oPC, FALSE);

	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		AssignCommand(oPartyMember, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 6.0));	
		oPartyMember = GetNextFactionMember(oPC, FALSE);
	}
}

void RestEntireParty()
{
	object oPC = GetFirstPC();
	object oPartyMember = GetFirstFactionMember(oPC, FALSE);

	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		AssignCommand(oPC, ForceRest(oPartyMember));
		oPartyMember = GetNextFactionMember(oPC, FALSE);
	}
}

void FadePartyToBlack()
{
	object oPC = GetFirstPC();
	object oPartyMember = GetFirstFactionMember(oPC, FALSE);

	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		FadeToBlack(oPartyMember, 2.0);
		oPartyMember = GetNextFactionMember(oPC, FALSE);
	}
}

void FadePartyFromBlack()
{
	object oPC = GetFirstPC();
	object oPartyMember = GetFirstFactionMember(oPC, FALSE);

	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		FadeFromBlack(oPartyMember, 2.0);
		oPartyMember = GetNextFactionMember(oPC, FALSE);
	}
}

void RestedMessage()
{
	object oPC = GetFirstPC();
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);	
	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		DisplayMessageBox(oPartyMember, 0, "Your party awakes fully healed and restored.", "gui_rest_success_confirm", "", FALSE, "", 0, "Ok", 0, "");
		oPartyMember = GetNextFactionMember(oPC, TRUE);
	}
}

void FreezeParty()
{
	object oPC = GetFirstPC();
	object oPartyMember = GetFirstFactionMember(oPC, FALSE);	
	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		SetCommandable(FALSE, oPartyMember);
		oPartyMember = GetNextFactionMember(oPC, FALSE);
	}
}

void PartyFollowingOff()
{
	object oPC = GetFirstPC();
	object oPartyMember = GetFirstFactionMember(oPC, FALSE);	
	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		AssignCommand(oPartyMember, ClearAllActions(TRUE));
		AssignCommand(oPartyMember, CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, TRUE));
		AssignCommand(oPartyMember, ClearAllActions(TRUE));
		oPartyMember = GetNextFactionMember(oPC, FALSE);
	}
}