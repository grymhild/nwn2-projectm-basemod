// ga_clear_comp()
/* 
   Removes all roster members from the PC party. Removed roster members are not despawned.
*/
// BMA-OEI 7/20/05
// EPF 1/9/06 -- added RemoveAllCompanions call.
// TDE 3/23/06 -- Replaced entire script with SCDespawnAllCompanions.
// BMA-OEI 5/23/06 -- replaced w/ SCRemoveRosterMembersFromParty(), updated comment
		
#include "_SCInclude_AI"
	
void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	SCRemoveRosterMembersFromParty(oPC, FALSE, FALSE); 
}