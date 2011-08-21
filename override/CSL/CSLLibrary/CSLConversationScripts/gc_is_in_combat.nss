// gc_is_in_combat
//
// Returns true if sTarget is in combat

// EPF 1/30/06

#include "_CSLCore_Combat"
		
int StartingConditional(string sTarget)
{
	return GetIsInCombat(CSLGetTarget(sTarget));
}