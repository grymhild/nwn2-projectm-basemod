//::///////////////////////////////////////////////
//:: Name 	Dread Word
//:: FileName sp_dread_word.nss
//:://////////////////////////////////////////////
/**@file Dread Word
Evocation [Evil]
Level: Demonologist 3, Sor/Wiz 3
Components: V
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature of good alignment
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster speaks a single unique word of pure malevolence;
a powerful utterance from the Dark Speech. The word is so
foul that it harms the very soul of one that hears it. The
utterance of a dread word causes one subject within range
to take 1d3 points of Charisma drain. The power of this
spell protects the caster from the damaging effects of
both hearing and knowing the word.

To attempt to speak this unique word without using this spell
means instant death (and no effect, because the caster dies
before she gets the entire word out).

Author: 	Tenjac
Created: 	3/26/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DREAD_WORD; // put spell constant here
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

	
	object oTarget = HkGetSpellTarget();
	int nDC = HkGetSpellSaveDC(oTarget, oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	
	int nDam = HkApplyMetamagicVariableMods(d3(), 3);
	

	if(!HkResistSpell(oCaster, oTarget ))
	{
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, 1.0))
		{
			effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

			//Apply 1d3 Cha DRAIN
			SCApplyAbilityDrainEffect( ABILITY_CHARISMA, nDam, oTarget, DURATION_TYPE_PERMANENT );
		}
	}
	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
