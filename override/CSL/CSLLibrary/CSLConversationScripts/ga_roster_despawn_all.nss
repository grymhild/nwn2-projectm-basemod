// ga_roster_despawn_all( int bExcludeParty )
/*
	Despawn all roster members, option to exclude members in PC party
*/
// BMA-OEI 7/28/06

#include "_SCInclude_AI"

void main( int bExcludeParty )
{
	SCDespawnAllRosterMembers( bExcludeParty );
}