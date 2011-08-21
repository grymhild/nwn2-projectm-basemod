// ga_remove_effects
//
// Remove all effects from sTarget. If sTarget is left blank, this script removes all effects from the party.

// EPF 7/11/07

#include "_CSLCore_Messages"
#include "_CSLCore_Magic"
//#include "ginc_cutscene"


void RemoveAllEffectsFromParty()
{
	object oPC = GetPCSpeaker();
	
	if(!GetIsObjectValid(oPC))
	{
		oPC = GetFirstPC();
	}	
	
	object oFM = GetFirstFactionMember(oPC,FALSE);
	while(GetIsObjectValid(oFM))
	{
		CSLRemoveAllEffects(oFM,FALSE);
		oFM = GetNextFactionMember(oPC,FALSE);
	}
}

void main(string sTarget)
{
	if(sTarget != "")
	{
		object oTarget = CSLGetTarget(sTarget);
		if(GetIsObjectValid(oTarget))
		{
			CSLRemoveAllEffects(oTarget, FALSE);
		}
	}
	else
	{
		RemoveAllEffectsFromParty();
	}
}