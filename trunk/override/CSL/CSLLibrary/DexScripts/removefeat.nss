void main (int FeatID)
{
	object oPC=GetPCSpeaker();
	effect eFeat=EffectVisualEffect(VFX_IMP_EVIL_HELP,FALSE);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eFeat, oPC, 0.5);
	FeatRemove(oPC, FeatID);
}