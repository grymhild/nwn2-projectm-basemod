// ga_generic template
/*
   This script adds a spell to the PC.

   Parameters:
// sTarget is standard coversation paramters for a tag, or special keywords Default is OWNER.
// sSpell is the id of the spell
// sOptions can be Remove

*/
#include "_CSLCore_Messages"
#include "_HkSpell"

void main(string sTarget, string sSpell, string sOptions )
{
    //object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oTarget = CSLGetTarget(sTarget, CSLTARGET_OWNER);


	string sLevelofSpell, sSpellName, sClassSpellBook, sSpell, sOptions;
	int iSpellLevel, iMaxSpellLevel, iSlotNumber, iClass, iClassLevel, iSpell;
	
	//sSpell = CSLNth_GetNthElement( sParameters, 1, " ");
	//sOptions = CSLNth_GetNthElement( sParameters, 2, " ");
	
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
		SendMessageToPC(oTarget, "<color=indianred>"+"Please select a valid spell id, that spellid does not correlate to a spell!"+"</color>");
		return;
	}
	
	if ( sOptions == "Remove" && !GetSpellKnown( oTarget, iSpell) )
	{
		SendMessageToPC(oTarget, "<color=indianred>"+GetName(oTarget)+" already does not know "+sSpellName+" so it did not have to be removed!"+"</color>");
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
						SendMessageToPC(oTarget, "<color=indianred>"+"Removed spell "+ sSpellName+" from "+GetName(oTarget) + "!"+"</color>");
					}
					else
					{
						SetSpellKnown( oTarget, (iSlotNumber-1), iSpell, TRUE, FALSE );
						SendMessageToPC(oTarget, "<color=indianred>"+"Added spell "+ sSpellName+" to "+GetName(oTarget) + "!"+"</color>");
					}
					
					return;
				}
			}
		}
	}
	
	SendMessageToPC(oTarget, "<color=indianred>"+"Failed to add spell "+ sSpellName+" to "+GetName(oTarget) + " as no classes the character has are advanced enough learn it!"+"</color>");
}