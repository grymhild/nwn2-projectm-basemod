#include "setlevel"

void main(int Level)
{
    object oSpeaker=GetPCSpeaker();
	SetLevel(oSpeaker, Level);
}