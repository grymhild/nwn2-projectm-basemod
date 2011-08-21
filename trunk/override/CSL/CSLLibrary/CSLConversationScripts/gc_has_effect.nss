//gc_has_effect
//Checks to see if the PC has the specified iEffectType effect constant.

int StartingConditional(int iEffectType)
{
	object oPC = GetPCSpeaker();
	effect eEffect = GetFirstEffect(oPC);
	while(GetIsEffectValid(eEffect))
	{
		if(GetEffectType(eEffect) == iEffectType)
			return TRUE;
		
		eEffect = GetNextEffect(oPC);
	}
	
	return FALSE;
}