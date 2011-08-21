//::///////////////////////////////////////////////
//:: [Crushing Despair]
//:: [NW_S0_CrushDesp.nss]
//:://////////////////////////////////////////////
/*
	All affected creatures in range suffer -2
	penalties to attack rolls, saving throws,
	ability checks, skill checks, and weapon
	dmg rolls.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_crushingdesp();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CRUSHING_DESPAIR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lTarget = HkGetSpellTargetLocation();
	int iCasterLevel   = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nNumTargets  = (iCasterLevel / 3) + 1;

	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration( oCaster )));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget)) {
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) {
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				nNumTargets--;
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				if (!HkResistSpell(oCaster, oTarget)) {
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS)) {
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster)) {
							effect eLink = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
							eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
							eLink = EffectLinkEffects(eLink, EffectDamageDecrease(2));
							eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));
							HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_SPELL_CRUSHING_DESP), oTarget);
						}
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

