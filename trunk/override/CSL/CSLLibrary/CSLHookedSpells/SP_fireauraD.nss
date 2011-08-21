//::///////////////////////////////////////////////
//:: Fire Aura (D) - Victim OnHeartbeat
//:: sg_s0_FireAuraD.nss
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
radius. The fire aura provides protection 20 from both
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
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------


	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget = HkGetAOEOwner( OBJECT_SELF );
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	float 	fDuration; 		//= HkGetSpellDuration(iCasterLevel);		

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 6;
	int 	iNumDice 		= 1;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImpVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
	effect eDamage = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
	effect eLink = EffectLinkEffects(eImpVis, eDamage);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_FIRE_AURA, TRUE ));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}
