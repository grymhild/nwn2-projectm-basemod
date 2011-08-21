//::///////////////////////////////////////////////
//:: Name 	Unheavened
//:: FileName sp_unheavened.nss
//:://////////////////////////////////////////////
/**@fileUnheavened
Abjuration [Evil]
Level: Sor/Wiz 2
Components: V, S, Drug
Casting Time: 1 action
Range: Touch
Target: One creature
Duration: 10 minutes/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

The caster grants one creature a +4 profane bonus on
saving throws made against any spell or spell-like
effect from a good outsider. This protection
manifests as a black and red nimbus of energy
visible around the subject. All celestial beings can
identify an unheavened nimbus on sight.

Drug Component: Vodare.

Author: 	Tenjac
Created: 	5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_UNHEAVENED; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	//float fDur = (600.0f * nCasterLevel);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);



	//check for Vodare
	if(GetHasSpellEffect(SPELL_VODARE, oCaster))
	{
		//Make sure the spell effect hangs around for the duration
		//to be checked by prc_add_spell_dc.nss

		//effect eVis = EffectVisualEffect(VFX_DUR_UNHEAVENED);
		effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
	}

	CSLSpellEvilShift(oCaster);
}
