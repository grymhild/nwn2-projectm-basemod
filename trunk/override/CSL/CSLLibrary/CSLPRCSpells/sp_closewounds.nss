//::///////////////////////////////////////////////
//:: Name 	Close Wounds
//:: FileName sp_close_wounds.nss
//:://////////////////////////////////////////////
/** @file Close Wounds
Conjuration (Healing)
Level: Clr 3, Hlr 3
Components: V
Casting Time: 1 swift action
Range: Close
Target: One creature
Duration: Instantaneous
Saving Throw: Will half (harmless)
Spell Resistance: Yes (harmless)

This spell cures 2d4 points of damage. You can cast
this spell with an instant utterance.

Used against an undead creature, close wounds deals
damage instea of curing the creature (which takes half
damage if it makes a Will saving throw).
**/
//////////////////////////////////////////////////
// Author: Tenjac
// Date: 	5.10.06
///////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CLOSE_WOUNDS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	
	int nHeal = HkApplyMetamagicVariableMods(d4(2), 8);

	//Damage if undead
	if(CSLGetIsUndead( oTarget ))
	{
		//SR
		if(!HkResistSpell(oCaster, oTarget ))
		{
			//save for 1/2 dam
			if(HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(oCaster,oTarget), SAVING_THROW_TYPE_POSITIVE))
			{
				nHeal = nHeal/2;
			}

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(DAMAGE_TYPE_POSITIVE, nHeal), oTarget);
		}
	}

	else
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
