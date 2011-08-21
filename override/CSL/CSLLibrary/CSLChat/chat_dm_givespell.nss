//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
/*
	This code assumes a player does not have a really complicated builds, and will focus on the first class they took which can actually use the given spell which makes they syntax very easy.
*/
#include "_SCInclude_Chat"
#include "_HkSpell"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = GetStringLowerCase(CSLGetChatParameters());
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	if ( sParameters == "" || sParameters == "help" )
	{
		SendMessageToPC( oDM, "Type in: DM_givespell [999] where [999] is a valid spell id, use DM_ListSpell to get a valid spell id." );
		return;
	}
	
	
	if ( !GetIsObjectValid( oTarget ) )
	{
		SendMessageToPC( oDM, "Select a valid target, via a tell or setting them as your current target." );
		return;
	}
	
	
	string sLevelofSpell, sSpellName, sClassSpellBook, sSpell, sOptions;
	int iSpellLevel, iMaxSpellLevel, iSlotNumber, iClass, iClassLevel, iSpell;
	
	sSpell = CSLNth_GetNthElement( sParameters, 1, " ");
	sOptions = CSLNth_GetNthElement( sParameters, 2, " ");
	
	if ( GetStringLeft(sSpell,1) == "-" )
	{
		sOptions = "Remove";
	}
	//string 
	if ( CSLGetIsNumber( sSpell ) )
	{
		iSpell = StringToInt( sSpell );
	}
	
	sSpellName = CSLGetSpellDataName( iSpell );
	
	if ( sSpellName == "" )
	{
		SendMessageToPC(oDM, "<color=indianred>"+"Please select a valid spell id, that spellid does not correlate to a spell!"+"</color>");
		return;
	}
	
	if ( sOptions == "Remove" && !GetSpellKnown( oTarget, iSpell) )
	{
		SendMessageToPC(oDM, "<color=indianred>"+GetName(oTarget)+" already does not know "+sSpellName+" so it did not have to be removed!"+"</color>");
		return;
	}
	
	
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oTarget );
		if ( iClass == 255 )
		{
			continue;
		}
		iClassLevel = GetLevelByClass( iClass, oTarget );
		sClassSpellBook = CSLGetSpellBookNameByClass( iClass );
		if ( iClassLevel > 0 && sClassSpellBook != "" )
		{
			string sLevelofSpell = Get2DAString ("spells", sClassSpellBook, iSpell);
			if ( sLevelofSpell != "" ) // make sure spell is available for this class
			{
				iSpellLevel = StringToInt(sLevelofSpell);
				iMaxSpellLevel = HkGetCasterMaxSpellLevel( oTarget, iClass );
				if ( iMaxSpellLevel >= iSpellLevel )
				{
					if ( sOptions == "Remove" )
					{
						SetSpellKnown( oTarget, (iSlotNumber-1), iSpell, FALSE, FALSE );
						SendMessageToPC(oDM, "<color=indianred>"+"Removed spell "+ sSpellName+" from "+GetName(oTarget) + "!"+"</color>");
					}
					else
					{
						SetSpellKnown( oTarget, (iSlotNumber-1), iSpell, TRUE, FALSE );
						SendMessageToPC(oDM, "<color=indianred>"+"Added spell "+ sSpellName+" to "+GetName(oTarget) + "!"+"</color>");
					}
					
					return;
				}
			}
		}
	}
	

	
	
	SendMessageToPC(oDM, "<color=indianred>"+"Failed to add spell "+ sSpellName+" to "+GetName(oTarget) + " as no classes the character has are advanced enough learn it!"+"</color>");
	

}