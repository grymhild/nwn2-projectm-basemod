// ga_party_freeze()
/*
	Freeze PC party for cutscene. Temporarily save CSL_ASC_MODE_STAND_GROUND state.
	Use ga_party_unfreeze() to restore CSL_ASC_MODE_STAND_GROUND state.
*/
// BMA-OEI 3/7/06

#include "_SCInclude_Overland"	
	
void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		// Save current stand ground state
		SaveStandGroundState(oMember);

		// Force all members to stand ground
		CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, TRUE, oMember);

		// Clear action queue and combat state
		AssignCommand(oMember, ClearAllActions(TRUE));

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}