void main (int FeatID)
{
	object oPC=GetPCSpeaker();
	effect eFeat=EffectVisualEffect(VFX_IMP_GOOD_HELP,FALSE);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eFeat, oPC, 0.5);
	FeatAdd(oPC, FeatID, FALSE);
}