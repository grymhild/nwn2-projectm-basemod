// ga_faction_join
/*
    This script makes sTarget join a new faction.
	sTarget - The target who's faction will change (see Target's note).
	sTargetFaction - Either one of the 4 standard factions $COMMONER, $DEFENDER, $HOSTILE, $MERCHANT or
				a target who's faction is to be joined (must be a creature)
*/
//  ChazM 2/25/05
// DBR 11/09/06 - TargetFactionMember was using wrong target string

#include "_CSLCore_Messages"
#include "_CSLCore_Combat"
//#include "nw_i0_generic"


void main(string sTarget, string sTargetFaction) 
{
	object oTarget = CSLGetTarget(sTarget);
	int iFaction = CSLGetStandardFaction(sTargetFaction);
	
	if (iFaction != -1) {
		ChangeToStandardFaction(oTarget, iFaction);
		//PrintString ("Changed to standard faction " + sTargetFaction );
	}		
	else {
		object oTargetFactionMember = CSLGetTarget(sTargetFaction);
 		ChangeFaction(oTarget, oTargetFactionMember);
		//PrintString ("Changed to same faction as " + GetName(oTarget));
	}
	CSLDetermineCombatRound( oTarget );
}