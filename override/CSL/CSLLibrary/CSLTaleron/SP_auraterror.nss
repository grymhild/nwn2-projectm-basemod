/*
Aura of Terror
Sean Harrington
11/10/07
#1346
*/

#include "_HkSpell"

void main()
{	
	
int nDuration = HkGetCasterLevel(OBJECT_SELF);
effect eAOE = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR,"nw_sh_aura_of_terrora","","nw_sh_aura_of_terrorb");
	if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
		{
		nDuration = nDuration *2;
		}
HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, TurnsToSeconds(nDuration));
}