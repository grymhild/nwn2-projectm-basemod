//::///////////////////////////////////////////////
//:: AlarmA
//:: SG_S0_AlarmA.nss
//:: 2003 Karl Nickels
//:://////////////////////////////////////////////
/*
	Sounds a mental alarm upon any creature entering
	the warded area.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 28, 2003
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();

	if(GetIsObjectValid(oCaster) && !CSLGetIsIncorporeal( oTarget ) )
	{
		SendMessageToPC(oCaster, "A creature has entered your alarm area." );
	}
}
