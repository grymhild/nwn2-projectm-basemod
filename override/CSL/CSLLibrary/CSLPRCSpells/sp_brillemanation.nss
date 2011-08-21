//::///////////////////////////////////////////////
//:: Name 	Brilliant Emanation
//:: FileName sp_brill_eman.nss
//:://////////////////////////////////////////////
/**@file Brilliant Emanation
Evocation [Good]
Level: Sanctified 3
Components: Sacrifice
Casting Time: 1 standard action
Range: 100 ft. + 10 ft./level
Area: 100-ft.-radius emanation + 10-ft. radius per level
Duration: 1d4 rounds
Saving Throw: Fortitude partial
Spell Resistance: Yes

This spell causes a divine glow to radiate from
any reflective objects worn or carried by the
caster, including metal armor. Evil creatures
within the spell's area are blinded unless they
succeed on a Fortitude saving throw. Non-evil
characters perceive the brilliant light emanating
from the caster, but are not blinded by it and do
not suffer any negative effects from it. Evil
characters that make their saving throw are not
blinded, but are distracted, taking a -1 penalty
on any attacks made within the spell's area for
the duration of the spell. Creatures must be able
to see visible light to be affected by this spell.

Sacrifice: 1d3 points of Strength damage.

Author: 	Tenjac
Created: 	6/8/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BRILLIANT_EMANATION; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//


	
	location lLoc = GetLocation(oCaster);
	//float fDur = RoundsToSeconds(d4());
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(d4(), SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//int nMetaMagic = HkGetMetaMagicFeat();

	
	//VFX on caster
	effect eAOE = EffectAreaOfEffect(VFX_MOB_BRILLIANT_EMANATION);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration);

	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d3(), 0);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}