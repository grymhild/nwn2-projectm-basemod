//ga_set_weapon_visibility
// Conversation script wrapper for SetWeaponVisibility() command.
//
//   sTarget  - tag of creature to set weapon visibilty - default is conversation owner.
//   bVisible - 1 for always visible, 0 for always invisible, 4 to turn off the override.
//   nType    - NOT CURRENTLY USED see nwscript.nss for more information, this is the nType parameter in SetWeaponVisibility()
//   bForWholeGroup  - Sets weapon visibility for the whole group of sTarget.
//   bForWholeFaction  - Sets weapon visibility for the whole faction of sTarget.


// DBR 6/22/06

#include "_CSLCore_Messages"
#include "_SCInclude_Group"


void main(string sTarget, int bVisible, int nType=0, int bForWholeGroup=0, int bForWholeFaction=0)
{
	object oTarget = CSLGetTarget(sTarget);
	object oMember;
	string sGroup;
	
	if (GetIsObjectValid(oTarget))
	{
		SetWeaponVisibility(oTarget, bVisible, nType);
		if (bForWholeGroup)			//Group-Wide
		{
			sGroup = SCGetGroupName(oTarget);
			oMember = SCGetFirstInGroup(sGroup);
			while (GetIsObjectValid(oMember))
			{
				SetWeaponVisibility(oMember, bVisible, nType);
				oMember = SCGetNextInGroup(sGroup);			
			}		
		}
		if (bForWholeFaction)			//Faction-Wide
		{
			oMember = GetFirstFactionMember(oTarget, FALSE);
			while (GetIsObjectValid(oMember))
			{
				SetWeaponVisibility(oMember, bVisible, nType);
				oMember = GetNextFactionMember(oTarget,FALSE);			
			}		
		}	
	}
}