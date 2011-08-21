/*
This is a SP Official campaign script for features in the single player game
*/
//ga_reveal_location
//reveals the location placeable with the resref sLocationResRef on the OL map

void main( string sLocationResRef )
{
	SetGlobalInt(sLocationResRef + "_DISCOVERED", TRUE);
} 