//::///////////////////////////////////////////////
//:: Radiant Aura OnExit
//:: cmi_s2_radntauraB
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 12, 2007
//:://////////////////////////////////////////////
//:: Based on Aura of Despair


/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"

void main()
{	
	if ( GetExitingObject() != GetAreaOfEffectCreator() )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA );
	}    
}