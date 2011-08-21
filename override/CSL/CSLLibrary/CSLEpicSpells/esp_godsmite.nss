//::///////////////////////////////////////////////
//:: Epic Spell: Godsmite
//:: Author: Boneshank (Don Armstrong)
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"
//#include "x0_i0_position"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_GODSMIT;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_GODSMIT))
	{
		
		int iAdjustedDamage;
		
		object oTarget = HkGetSpellTarget();
		int nSpellPower = HkGetCasterLevel(OBJECT_SELF);

		int nDam, nDamGoodEvil, nDamLawChaos, nCount;
		location lTarget;

		// if this option has been enabled, the caster will take backlash damage
		if ( CSLGetPreferenceSwitch("EpicBacklashDamage") )
		{
			effect eCast = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
			int nDamage = d4(nSpellPower);
			effect eDam = HkEffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
			DelayCommand(3.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF));
			DelayCommand(3.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF));
		}

		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
		//Roll damage
		if (GetAlignmentGoodEvil(OBJECT_SELF) != GetAlignmentGoodEvil(oTarget))
		{ nDamGoodEvil = d8(nSpellPower); }
		else if (GetAlignmentGoodEvil(OBJECT_SELF) != GetAlignmentGoodEvil(oTarget) &&
			(GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL ||
			GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL))
		{ nDamGoodEvil = d6(nSpellPower); }
		else
		{ nDamGoodEvil = d4(nSpellPower); }
		if (GetAlignmentLawChaos(OBJECT_SELF) != GetAlignmentLawChaos(oTarget))
		{ nDamLawChaos = d8(nSpellPower); }
		else if (GetAlignmentLawChaos(OBJECT_SELF) != GetAlignmentLawChaos(oTarget) &&
			(GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_NEUTRAL ||
			GetAlignmentLawChaos(oTarget) == ALIGNMENT_NEUTRAL))
		{ nDamLawChaos = d6(nSpellPower); }
		else
		{ nDamLawChaos = d6(nSpellPower); }
		nDam = nDamGoodEvil + nDamLawChaos;

		//Set damage effect
		nDam = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, nDam, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget),SAVING_THROW_TYPE_SPELL, oCaster, SAVING_THROW_RESULT_ROLL );

		effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_PLUS_TWENTY);
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 4.0);
		DelayCommand(0.4, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 3.5);
		DelayCommand(0.8, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 3.0);
		DelayCommand(1.2, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 2.5);
		DelayCommand(1.6, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 2.0);
		DelayCommand(2.0, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 1.5);
		DelayCommand(2.4, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 1.0);
		DelayCommand(2.7, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		lTarget = CSLGetRandomLocation(GetArea(oTarget), oTarget, 0.5);
		DelayCommand(3.0, HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
		HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND), oTarget, 0.75);
		DelayCommand(0.75, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND), oTarget, 1.0));
		DelayCommand(1.75, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST), oTarget, 0.75));
		DelayCommand(2.5, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND), oTarget, 1.0));
		DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_DIVINE), oTarget));
		DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM), oTarget));
		DelayCommand(3.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	}
	HkPostCast(oCaster);
}
