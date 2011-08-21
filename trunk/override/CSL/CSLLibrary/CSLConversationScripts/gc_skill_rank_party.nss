// gc_skill_rank_party(int nSkill, int nRank)
/*
	Determine if anyone in the party has sufficient rank in a particular skill.

	Parameters:
		int nSkill 	= skill int to check
		int nRank	= minimum rank to return TRUE

	Remarks:
		skill ints
		0	APPRAISE
		1	BLUFF
		2	CONCENTRATION
		3	CRAFT ALCHEMY
		4	CRAFT ARMOR
		5	CRAFT WEAPON
		6	DIPLOMACY
		7	DISABLE DEVICE
		8	DISCIPLINE
		9	HEAL
		10	HIDE
		11	INTIMIDATE
		12	LISTEN
		13	LORE
		14	MOVE SILENTLY
		15	OPEN LOCK
		16	PARRY
		17	PERFORM
		18	RIDE
		19	SEARCH
		20	CRAFT TRAP
		21	SLEIGHT OF HAND
		22	SPELL CRAFT
		23	SPOT
		24	SURVIVAL
		25	TAUNT
		26	TUMBLE
		27	USE MAGIC DEVICE
*/	
//	TDE 10/3/08

#include "_CSLCore_Messages"
#include "_CSLCore_Info"

int StartingConditional(int nSkill, int nRank)
{
	object oPC = GetPCSpeaker();
	object oFactionMember = GetFirstFactionMember( oPC, FALSE );
	int nSkillVal = CSLGetSkillConstant(nSkill);

	while ( GetIsObjectValid(oFactionMember) )
	{
		if( GetIsRosterMember(oFactionMember) || GetIsOwnedByPlayer(oFactionMember) )
			if (GetSkillRank(nSkillVal, oFactionMember) >= nRank)
				return TRUE;

		oFactionMember = GetNextFactionMember( oPC, FALSE );
	}

	return FALSE;
}