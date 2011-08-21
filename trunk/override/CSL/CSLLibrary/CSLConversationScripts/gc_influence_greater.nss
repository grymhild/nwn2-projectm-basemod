// gc_influence_greater( int nCompanion1, int nCompanion2 )
/*
	This checks if nCompanion1 is greater than nCompanion2's influence rating with the PC.

	Parameters:
		int nCompanion1	= This is the integer value of the first companion. 
		int nCompanion2 = This is the integer value of the second companion.

	1	Khelgar
	2	Neeshka
	3	Elanee
	4	Qara
	5	Sand
	6	Grobnar
	7	Casavir
	8	Bishop
	9	ShandraJerro
	10	Construct
	11	Zhjaeve
	12	AmmonJerro
	13  Bevil
*/
// BMA-OEI 12/05/05
// TDE 2/14/04 - Added companion ID table
// BMA-OEI 7/10/06 -- Updated to use GetInfluenceByNumber()
		
#include "_SCInclude_Group"

int StartingConditional( int nCompanion1, int nCompanion2 )
{
	int nValue1 = GetInfluenceByNumber( nCompanion1 );
	int nValue2 = GetInfluenceByNumber( nCompanion2 );
	int nReturn = ( nValue1 > nValue2 );

	//CSLMessage_PrettyMessage("gc_influence_greater: " + sVar1 + ">" + sVar2 + " = " + IntToString(nValue1) + ">" + IntToString(nValue2) + ":" + IntToString(nReturn));
	return ( nReturn );
}