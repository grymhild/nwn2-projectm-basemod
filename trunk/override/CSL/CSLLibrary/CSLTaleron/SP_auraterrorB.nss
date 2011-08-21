//#include "NW_I0_SPELLS"


#include "_HkSpell"

void main()
{	

	
object 	oTarget 	= GetExitingObject();
effect 	eFear 		= EffectFrightened();
RemoveEffect(oTarget, eFear);
}