//::///////////////////////////////////////////////
//:: Name 	Sure Strike
//:: FileName sp_sure_strike.nss
//:://////////////////////////////////////////////
/**@file Sure Strike
Divination
Level: Duskblade 2, sorcerer/wizard 2
Components: V
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round or until discharged

You cast this spell immediately before you make an
attack roll. You can see into the future for that
attack, granting you a +1 insight bonus per three
caster levels on your next attack roll.
**/
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SURE_STRIKE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
	int nCasterLvl = HkGetCasterLevel(oCaster);

	// determine the attack bonus to apply
	effect eAttack = EffectAttackIncrease(nCasterLvl/3);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eAttack, eDur);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oCaster, FALSE, SPELL_SURE_STRIKE, oCaster);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(1));

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
