// ga_compshift // revamped based on ga_influence
/*
    This is the companion shift script that adjusts a companion's
    reaction to the PC
        nCompanion  = This is the integer value of the companion in question
        nChange     = This is the amount their reaction is adjusted
        nOverride   = If this isn't equal to 0, the companions reaction is
                      set to this amount. Use with caution.
*/
// FAB 10/4
#include "_CSLCore_Messages"
 /*
void main(int sCompanion, int nChange, int nOverride )
{

   
    
    
    
        This is a temp script - a real script will be added later

        nCompanion
        1:  Khelgar

        nChange
        -3:     Strong negative change
        -2:     Medium negative change
        -1:     Small negative change
        +1:     Small positive change
        +2:     Medium positive change
        +3:     Strong positive change
   

}
*/

#include "_SCInclude_Group"
#include "_CSLCore_Messages"

const int	STRING_REF_LOST_INFLUENCE 	= 178842;
const int	STRING_REF_GAINED_INFLUENCE = 178841;

int GetCompanionNameStringRef( int nCompanion )
{
	// companions str refs are 178843 - 178855
	return ( 178842 + nCompanion );
}

void main( string sCompanion, int nChange )
{
	if ( nChange == 0 )
	{
		//PrettyError( "ga_influence: companion " + IntToString(nCompanion) + " no influence change" );
		return;
	}
	
	int nCompanion = GetCompanionNumberByTag(sCompanion);
	
	int nOldInfluence = GetInfluenceByNumber( nCompanion );
	IncInfluenceByNumber( nCompanion, nChange );
	int nNewInfluence = GetInfluenceByNumber( nCompanion );
	
	string sOut;
	int nDelta = nNewInfluence - nOldInfluence; //nChange; // Actual nDelta may not == nChange
	if ( nDelta > 0 )
	{
		sOut = GetStringByStrRef( STRING_REF_GAINED_INFLUENCE );
	}
	else
	{
		sOut = GetStringByStrRef( STRING_REF_LOST_INFLUENCE );
	}
	sOut += " " + GetStringByStrRef(GetCompanionNameStringRef(nCompanion)) + ": " + IntToString(nDelta);
	
    object oPC = ( GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker() );
	SendMessageToPC( oPC, sOut );
	//PrettyDebug( sOut );
	//PrettyDebug("Total influence with " + GetStringByStrRef(GetCompanionNameStringRef(nCompanion)) + " = " + IntToString(nNewInfluence));
}