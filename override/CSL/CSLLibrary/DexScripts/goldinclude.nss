void GiveGold(object oPC, int GoldAmount)
{
	effect eGold;

	if (GoldAmount>0)
	{
	    eGold=EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT,FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eGold, oPC, 0.5);
		GiveGoldToCreature(oPC, GoldAmount);
	}
	else
	{
	    eGold=EffectVisualEffect(VFX_IMP_SILENCE,FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eGold, oPC, 0.5);
		TakeGoldFromCreature(GoldAmount*-1, oPC, TRUE);
	}
}