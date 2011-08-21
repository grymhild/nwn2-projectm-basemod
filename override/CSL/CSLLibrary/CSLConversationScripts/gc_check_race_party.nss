// gc_check_race_party
//
// returns TRUE if the race of anyone in the party corresponds with the race specified.
// race can be specified in two ways: by number or by string.  The number
// is still entered as a string, sRace.
// 	
// Here are the arguments you can use:
// 
// sRace		Alternative
// -----		-----------
// dwarf		1
// elf			2
// gnome		3
// halfelf		4
// halfling		5
// halforc		6
// human		7
// outsider 	8
// yuan-ti		9
//
// so gc_check_race_party("dwarf") and gc_check_race_dwarf("1") will do the same thing.

// You can also check subraces using this function:
// (Note: Shield Dwarves, Moon Elves, Lightfoot Halflings, and Rock Gnomes are the common varieties of their 
//  respective races.)
// (Note: half-elf, half-orc, and human are considered both races and subraces.  The subrace versions should
//  be prepended with "sr-" as written below, if you intend to check subrace rather than the race.)
//
// sRace			Alternative
// -----			-----------
// shielddwarf		11
// moonelf			12
// rockgnome		13
// sr-halfelf		14
// lightfoothalf	15
// sr-halforc		16
// sr-human			17
// golddwarf		18
// duergar			19
// drow				20
// sunelf			21
// woodelf			23
// svirfneblin		24
// stronghearthalf	26
// aasimar			27
// tiefling			28
// half-drow		29
// wild elf			30
// fire genasi		31
// watergenasi		32
// earthgenasi		33
// airgenasi		34
// grayorc			35
//
// civdwarves		41	-- this is all dwarf subraces, save duergar.
// civelves			42	-- all elf subraces, save drow and wild.
// civhalflings		43	-- all halfling subraces, save ghostwise
// civorcs			44	-- all orc subraces
// 
// bInConversation	- Check only among party members involved in the PC Speaker's conversation, 
//	 				  not the entire party.
//
// TDE 5/12/08
// TDE 7/29/08 - Added yuan-ti, grayorc and civorcs

#include "_CSLCore_Appearance"

int StartingConditional(string sRace, int bInConversation = 0)
{
	sRace = GetStringLowerCase(sRace);
	

	object oPC = GetPCSpeaker();
	object oPM;
	
	if ( bInConversation )
	{
		// SCRIPTER - When the GetNextInConversation function is added, replace it here
		oPM = GetFirstFactionMember(oPC, FALSE);
	}
	else 
	{
		oPM = GetFirstFactionMember(oPC, FALSE);
	}
	
    while (GetIsObjectValid(oPM) == TRUE)
    {
		if ( CSLCheckRace(sRace, oPM) )
		{	
			return TRUE;
		}

		if ( bInConversation )
		{
			// SCRIPTER - When the GetNextInConversation function is added, replace it here
			oPM = GetNextFactionMember(oPC, FALSE);
		}
		else 
		{
			oPM = GetNextFactionMember(oPC, FALSE);
		}
	}

	return FALSE;
}