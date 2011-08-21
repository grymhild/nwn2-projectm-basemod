// ga_sound_object_stop(string sTarget)
/*
	Stops a sound object from playing
	
	Parameters:
		string sTarget	= tag of the sound object

*/
//ChazM 8/17/06

#include "_CSLCore_Messages"


void main(string sTarget)
{
	object oTarget = CSLGetSoundObjectByTag(sTarget);
	if (GetIsObjectValid(oTarget))
	{
		SoundObjectStop(oTarget);
	}
}