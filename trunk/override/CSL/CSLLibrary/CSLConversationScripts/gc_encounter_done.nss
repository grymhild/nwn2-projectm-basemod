//gc_encounter_done
//Returns TRUE if the encounter is all dead. Returns FALSE if any creatures are still alive in the encounter.
#include "_SCInclude_Overland"
#include "_SCInclude_Group"

int IsGroupHostile(string sGroupName)
{
	object oGroupMember = SCGetFirstInGroup(sGroupName);
	while(GetIsObjectValid(oGroupMember))
	{
		if(!GetIsReactionTypeHostile(GetFirstPC(), oGroupMember))
			return FALSE;
			
		oGroupMember = SCGetNextInGroup(sGroupName);
	}
	
	return TRUE;
}

int StartingConditional()
{
	if(SCGetIsGroupValid(ENC_GROUP_NAME_1, TRUE) && IsGroupHostile(ENC_GROUP_NAME_1))
		return FALSE;
	
	if(SCGetIsGroupValid(ENC_GROUP_NAME_2, TRUE) && IsGroupHostile(ENC_GROUP_NAME_2))
		return FALSE;
	
	if(SCGetIsGroupValid(ENC_GROUP_NAME_3, TRUE) && IsGroupHostile(ENC_GROUP_NAME_3))
		return FALSE;
	
	if(SCGetIsGroupValid(ENC_GROUP_NAME_4, TRUE) && IsGroupHostile(ENC_GROUP_NAME_4))
		return FALSE;

	if(SCGetIsGroupValid(ENC_GROUP_NAME_5, TRUE) && IsGroupHostile(ENC_GROUP_NAME_5))
		return FALSE;
	
	if( GetLocalInt(GetArea(OBJECT_SELF), "bMated") )
	{
		if(SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_1, TRUE) && IsGroupHostile("COMBATANT_2" + ENC_GROUP_NAME_1))
			return FALSE;
	
		else if(SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_2, TRUE) && IsGroupHostile("COMBATANT_2" + ENC_GROUP_NAME_2))
			return FALSE;
	
		else if(SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_3, TRUE) && IsGroupHostile("COMBATANT_2" + ENC_GROUP_NAME_3))
			return FALSE;
		
		else if(SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_4, TRUE) && IsGroupHostile("COMBATANT_2" + ENC_GROUP_NAME_4))
			return FALSE;
	
		else if(SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_5, TRUE) && IsGroupHostile("COMBATANT_2" + ENC_GROUP_NAME_5))
			return FALSE;
	}
	
	return TRUE;
}