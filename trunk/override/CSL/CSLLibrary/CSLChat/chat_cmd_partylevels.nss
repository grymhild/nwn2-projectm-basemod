//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_HkSpell"

void main()
{
	object oPC = CSLGetChatSender();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}
	
	string sText;
	int bIsADm = CSLGetIsDM(oPC);
	int bSelfDMorAdmin = (CSLVerifyDMKey(oPC) || CSLVerifyAdminKey(oPC));
	object oParty = bIsADm ? GetFirstPC() : GetFirstFactionMember(oPC, TRUE);
	while (GetIsObjectValid(oParty))
	{
		if (oParty!=oPC)
		{
			sText += "<color=pink>" + GetName(oParty) + "</color>";
			sText += " (" + GetName(GetArea(oParty)) + ") ";
			sText += "AC " + IntToString(GetAC(oParty));
			sText += " / HP " + IntToString(GetMaxHitPoints(oParty));
			sText += " / AB " + IntToString(GetTRUEBaseAttackBonus(oParty));
			sText += " <color=brown>" + CSLClassLevels(oParty, TRUE, bSelfDMorAdmin);
			sText += " " + CSLGetSubraceName(GetSubRace(oParty));
			sText += " " + IntToString(GetHitDice(oParty)) + "</color>\n";
		}
		oParty = bIsADm ? GetNextPC() : GetNextFactionMember(oPC, TRUE);
	}
	if (sText=="")
	{
		sText = "You aren't partying.";
	}
	else
	{
		CSLInfoBox( oPC, "Party Levels", "Party Levels", sText );
	}
	SendMessageToPC(oPC, sText);
	
	
}