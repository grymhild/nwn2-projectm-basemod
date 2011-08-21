void main (int Alignment, int Amount)
{
	object oSpeaker;
	effect eAlignment;
	
	oSpeaker = GetPCSpeaker();
	
	switch (Alignment)
	{
		case ALIGNMENT_GOOD:
		    eAlignment=EffectVisualEffect(VFX_IMP_HEALING_G,FALSE);
		    break;
		case ALIGNMENT_LAWFUL:
		    eAlignment=EffectVisualEffect(VFX_IMP_SUNSTRIKE,FALSE);
		    break;
		case ALIGNMENT_EVIL:
		    eAlignment=EffectVisualEffect(VFX_IMP_DEATH,FALSE);
		    break;
		case ALIGNMENT_CHAOTIC:
		    eAlignment=EffectVisualEffect(VFX_IMP_HARM,FALSE);
		    break;
		case ALIGNMENT_NEUTRAL:
		    eAlignment=EffectVisualEffect(VFX_IMP_MAGBLUE,FALSE);
		    break;
	}
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eAlignment, oSpeaker, 0.5);
	AdjustAlignment(oSpeaker, Alignment, Amount);
}