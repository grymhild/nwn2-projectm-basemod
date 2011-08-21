//::///////////////////////////////////////////////
//:: Name 	Heartache
//:: FileName sp_heartache.nss
//:://////////////////////////////////////////////
/**@file Heartache
Enchantment [Evil, Mind-Affecting]
Level: Clr 1, Mortal Hunter 1
Components: V, S, DF
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: 1 round
Saving Throw: Will negates
Spell Resistance: Yes

The caster fills the subject with heart wrenching
sorrow that renders it incapacitated for 1 round.
The subject cannot move or take actions and is
helpless for that round.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//Spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HEARTACHE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//vars
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	//float fDur = 6.0f;
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nMetaMagic = HkGetMetaMagicFeat();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_HEARTACHE, oCaster);

	//Spell Resistance
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//Save
		if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{

			effect ePar = EffectCutsceneParalyze();
			effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE), ePar);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

