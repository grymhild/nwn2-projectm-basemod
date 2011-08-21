//::///////////////////////////////////////////////
//:: Name 	Ectoplasmic Enhancement
//:: FileName sp_ecto_enhnc.nss
//:://////////////////////////////////////////////
/**@file Ectoplasmic Enhancement
Necromancy [Evil]
Level: Sor/Wiz 6
Components: V, S
Casting Time: 1 full round
Range: Close (25 ft. + 5 ft./2 levels)
Target: One incorporeal undead/level
Duration: 24 hours
Saving Throw: None
Spell Resistance: No

The undead affected by this spell gain a +1
deflection bonus to Armor Class, +1d8 temporary
hit points, a +1 enhancement bonus on attack rolls,
and a +2 bonus to turn resistance. Each of these
enhancements increases by +1 for every three caster
levels. So a 12th level caster grants a +5
deflection bonus to AC, an extra 1d8+4 temporary
hit points, a +5 enhancement bonus on attack rolls,
and a +6 bonus to turn resistance.

Author: 	Tenjac
Created: 	5/9/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "_CSLCore_Info"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ECTOPLASMIC_ENCHANCEMENT; // put spell constant here
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
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nBonus = CSLGetMax((nCasterLvl/3), 1);
	//


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);

	//loop
	while(GetIsObjectValid(oTarget))
	{
		//Check for incorporeal undead
		if(CSLGetIsIncorporeal(oTarget))
		{
			effect eLink = EffectACIncrease(nBonus, AC_DEFLECTION_BONUS);
			eLink = EffectLinkEffects(eLink, EffectTurnResistanceIncrease(nBonus + 1));
			eLink = EffectLinkEffects(eLink, EffectTemporaryHitpoints(d8(1) + nBonus - 1));
			eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonus));
			eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZED));

			//Apply for 1 day
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24));

		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}







