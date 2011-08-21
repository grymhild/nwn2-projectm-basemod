/*
This is a SP Official campaign script for features in the single player game
*/
//ga_revive_encounter
//re-enables the encounter with resref sEncResRef
//NLC 6/18/08

void main(string sEncResRef)
{
	SetGlobalInt(sEncResRef +"_FIRED", FALSE);
}