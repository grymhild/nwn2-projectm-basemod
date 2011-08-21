//::///////////////////////////////////////////////
//:: Name 	Wave of Pain
//:: FileName sp_wave_pain.nss
//:://////////////////////////////////////////////
/**@file Wave of Pain
Necromancy [Evil]
Level: Brd 6, Pain 7
Components: S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Area: Cone
Duration: 1 round/2 levels
Saving Throw: Fortitude negates
Spell Resistance: Yes

All living creatures within the cone are overcome
with pain and suffering. They are stunned for the
duration of the spell. A creature with no
discernible anatomy is unaffected by this spell.

Material Component: A needle.

Author: 	Tenjac
Created: 	5/10/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WAVE_OF_PAIN; // put spell constant here
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
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	effect eStun = EffectStunned();
	effect eVis = EffectVisualEffect(VFX_IMP_STUN);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	//float fDur = (6.0f * (nCasterLvl/2));
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration/2, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
	while(GetIsObjectValid(oTarget))
	{
		//Check for "discernable anatomy"
		if( !CSLGetIsOoze(oTarget) )
		{
			if(!HkResistSpell(oCaster, oTarget))
			{
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDuration);
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}