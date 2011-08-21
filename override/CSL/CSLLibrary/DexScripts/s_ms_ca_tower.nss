// Send PC down the tower

void main(){
	object oPC = GetPCSpeaker();
	object oWP = GetNearestObjectByTag("wp_tower_entry",oPC);
	object oFM = GetFirstFactionMember(oPC,FALSE);
	while( GetIsObjectValid(oFM) ){
		if( GetIsPC(oFM)
		 || GetIsOwnedByPlayer(oFM)
		 || GetIsRosterMember(oFM) ){
			AssignCommand(oFM, ActionJumpToObject(oWP));
		}
		oFM = GetNextFactionMember(oPC,FALSE);
	}
}