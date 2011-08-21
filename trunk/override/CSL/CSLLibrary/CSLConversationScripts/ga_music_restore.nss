// ga_music_restore
/*
   restore background music in current area
*/
// EPF 8/23/06

#include "_CSLCore_Visuals"

void main()
{
	object oPC = GetPCSpeaker();
	
	if(!GetIsObjectValid(oPC))
	{
		oPC = OBJECT_SELF;
	}
	object oArea = GetArea(oPC);
	
	RestoreMusicTrack(oArea);
}