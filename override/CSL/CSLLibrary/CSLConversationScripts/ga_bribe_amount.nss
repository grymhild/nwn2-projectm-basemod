/*
This is a SP Official campaign script for features in the single player game
*/
//ga_bribe_amount
//sets the custom token for the bribe amount.
#include "_SCInclude_Overland"

void main()
{
	object oEncounter = OBJECT_SELF;
	SetEncounterBribeValue(oEncounter);
}