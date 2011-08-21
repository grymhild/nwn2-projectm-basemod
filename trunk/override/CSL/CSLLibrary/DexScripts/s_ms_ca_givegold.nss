void main(int iGold){
	object oPC = GetPCSpeaker();
	if( iGold > 0 ){
		GiveGoldToCreature(oPC, iGold);
	}else{
		TakeGoldFromCreature(abs(iGold), oPC, TRUE); 
	}
}