void main(string sTag, int iMarkUp=100, int iMarkDown=50){
	object oPC    = GetPCSpeaker();	
	object oStore = GetNearestObjectByTag(sTag);
	if( !GetIsObjectValid(oStore) ){
		location lLoc = GetLocation(OBJECT_SELF);
		oStore = CreateObject(OBJECT_TYPE_STORE, sTag, lLoc, FALSE, sTag);
	}
	OpenStore(oStore, oPC, iMarkUp, iMarkDown);
}