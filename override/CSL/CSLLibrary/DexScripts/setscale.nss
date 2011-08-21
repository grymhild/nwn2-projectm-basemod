void main (float Scale)
{
	object oSpeaker = GetPCSpeaker();
	int Score;
	effect eScale, eSetScale;
	
	if (Scale<1.0)
	{
		eScale=EffectSetScale(Scale);
		eSetScale=EffectVisualEffect(VFX_IMP_FROST_L,FALSE);
	}
	else
	{
		eScale=EffectSetScale(Scale);
		eSetScale=EffectVisualEffect(VFX_IMP_FLAME_M,FALSE);
	}

	eScale=ExtraordinaryEffect(eScale);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eSetScale, oSpeaker, 0.5);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eScale, oSpeaker, 0.0);
}