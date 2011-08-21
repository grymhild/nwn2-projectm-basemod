//::///////////////////////////////////////////////
//:: Name 	Waves of Fatigue
//:: FileName sp_waves_fatg.nss
//:://////////////////////////////////////////////
/**@file Waves of Fatigue
Necromancy
Level: 	Sor/Wiz 5
Components: 	V, S
Casting Time: 	1 standard action
Range: 	30 ft.
Area: 	Cone-shaped burst
Duration: 	Instantaneous
Saving Throw: 	No
Spell Resistance: 	Yes

Waves of negative energy render all living creatures
in the spell's area fatigued. This spell has no effect
on a creature that is already fatigued.

**/
//::////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date : 29.9.06
//::////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WAVESOFFATIGUE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 9.14f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 

	while(GetIsObjectValid(oTarget))
	{
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			effect eSpeed = EffectMovementSpeedDecrease(25);
			effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, 2), EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
					eLink = EffectLinkEffects(eLink, eSpeed);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(8));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 9.14f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}





