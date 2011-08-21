//::///////////////////////////////////////////////
//:: Manifest Life
//:: cmi_s0_mnfstlife
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 24, 2010
//:://////////////////////////////////////////////
//#include "x0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_inc_sneakattack"
//#include "cmi_ginc_spells"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MANIFEST_DEATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	object oTarget = HkGetSpellTarget();

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && CSLGetIsUndead(oTarget) )
	{

		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			if( !HkResistSpell(oCaster, oTarget) )
			{
				int iSpellPower = HkGetSpellPower( oCaster, 30 )/2;
				int iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), iSpellPower*6);
				iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDamage, SC_TOUCHSPELL_MELEE );
				
				
				effect eDamage = EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE);
				effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);

				SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

				
				IncrementRemainingFeatUses(oCaster, FEAT_TURN_UNDEAD);
			}
		}

	}
	HkPostCast(oCaster);
}