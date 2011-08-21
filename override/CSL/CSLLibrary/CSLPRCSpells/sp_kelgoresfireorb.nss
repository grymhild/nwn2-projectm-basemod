//::///////////////////////////////////////////////
//:: Name 	Kelgore's Fire Bolt
//:: FileName sp_kelgore_fb.nss
//:://////////////////////////////////////////////
/**@file Kelgore's Fire Bolt
Conjuration/Evocation [Fire]
Level: Duskblade 1, sorcerer/wizard 1
Components: V,S,M
Casting Time: 1 standard action
Range: Medium
Target: One creature
Duration: Instantaneous
Saving Thorw: Reflex half
Spell Resistance: See text

This spell conjures a small orb of rock and sheathes
it in arcane energy. This spell deals 1d6 point of
fire damage per caster level (maximum 5d6). If you
fail to overcome the target's spell resistance, the
spell still deals 1d6 points of fire damage from the
heat and force of the conjured orb's impact.

Material component: A handful of ashes
**/

////////////////////////////////////////////////////
// Author: Tenjac
// Date: 	21.9.06
////////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_KELGORES_FIRE_ORB; // put spell constant here
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
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDC = HkGetSpellSaveDC(oTarget,OBJECT_SELF);
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

	int iSpellPower = HkGetSpellPower( oCaster, 5 );

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_KELGORES_FIRE_ORB, oCaster);
	
	int nDam = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);

	if(HkResistSpell(oCaster, oTarget ))
	{
		nDam = d6(1);
		eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	}

	nDam = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nDam, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_FIRE), oTarget);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}