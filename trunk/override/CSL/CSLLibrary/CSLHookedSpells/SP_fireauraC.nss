//::///////////////////////////////////////////////
//:: Fire Aura (C) - OnHeartbeat
//:: sg_s0_FireAuraC.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Abjuration
Level: Sor/Wiz 4
Components: V,S
Casting Time: 1 action
Range: Personal
Duration: 1 round/level
Saving Throw: Special (see text)
Spell Resistance: No

By means of this spell, you surround your body with an
aura of magical green fire. The fire aura extends 1 foot
from your body and provides illumination in a 10-foot
radius. The fire aura provides a resistance of 20 to both
natural and magical fire; the flames can be extinguished
only by dispel magic or a similar spell. Those touching
the fire aura suffer 2d4 hit points of fire damage; additionally,
if the touched victim failes to make his Reflex saving throw,
his body is set afire with green flames.
The flames persist for a maximum of 10 rounds. Each round the
victim is engulfed in these flames, he suffers an additional
1-6 hit points of fire damage; the victim's attack rolls are made
with a -2 penalty during this time.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 10, 2004
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	/*
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget 		= oCaster;
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC; 			//= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	float 	fDuration; 		//= HkGetSpellDuration(iCasterLevel);
	*/
	int 	iRemainingRounds = GetLocalInt(OBJECT_SELF, "REMAINING_ROUNDS");

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	//effect eImpVis = EffectVisualEffect( VFXSC_DUR_COMBUSTION_GREEN );

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	iRemainingRounds--;
	if(iRemainingRounds<0) iRemainingRounds=0;

	if(iRemainingRounds)
	{
		SetLocalInt(OBJECT_SELF,"REMAINING_ROUNDS", iRemainingRounds);
		//SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FIRE_AURA, FALSE));
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
	}
}
