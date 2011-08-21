/*
This is a SP Official campaign script for features in the single player game
*/
//ga_set_useable
//Sets the useable flag of the caller. Should be called from a placeable. 1 is useable, 2 is not.
//Alternately, you can pass in a tag and it will set the flag of the nearest object with that tag.
//NLC 9/10/08
void main(int nUseable, string sTag = "")
{
	object oTarget;
	
	if(sTag == "")
		oTarget = OBJECT_SELF;
		
	else
		oTarget = GetNearestObjectByTag(sTag, OBJECT_SELF);
	
	SetUseableFlag(oTarget, nUseable);
}