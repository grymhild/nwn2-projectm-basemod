// gc_speaker_tag
// Checks to see if the current speaker's tag is equal to sSpeakerTag.
// NLC 6/10/08


int StartingConditional(string sSpeakerTag)
{
	object oSpeaker = GetPCSpeaker();
	if(GetTag(oSpeaker) == sSpeakerTag)
		return TRUE;

	else return FALSE;
}