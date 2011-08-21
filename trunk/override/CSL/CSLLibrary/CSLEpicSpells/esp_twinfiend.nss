//::///////////////////////////////////////////////
//:: Epic Spell: Twinfiend
//:: Author: Boneshank (Don Armstrong)

//#include "x2_inc_toollib"
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "x2_inc_spellhook"


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_SCInclude_Summon"
#include "_CSLCore_Combat"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_TWINF;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_TWINF))
	{
		
		float fDuration = RoundsToSeconds(20);
		object oFiend, oFiend2;
		// effect eSummon;
		effect eVis = EffectVisualEffect(460);
		effect eVis2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
		if(CSLGetPreferenceInteger("MaxNormalSummons"))
		{
			CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
			effect eSummon = EffectSummonCreature("csl_sum_tanar_balor", 460);
			CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
			
			HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,
				HkGetSpellTargetLocation(), fDuration);
			HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,
				HkGetSpellTargetLocation(), fDuration);
		}
		else
		{
			DelayCommand(1.0, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, HkGetSpellTargetLocation()));
			oFiend = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", HkGetSpellTargetLocation());
			oFiend2 = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", HkGetSpellTargetLocation());
			SetMaxHenchmen(GetMaxHenchmen() + 2);
			AddHenchman(OBJECT_SELF, oFiend);
			AddHenchman(OBJECT_SELF, oFiend2);
			SetMaxHenchmen(GetMaxHenchmen() - 2);
			CSLDetermineCombatRound( oFiend );
			//AssignCommand(oFiend, DetermineCombatRound());
			CSLDetermineCombatRound( oFiend2 );
			//AssignCommand(oFiend2, DetermineCombatRound());
			DelayCommand(fDuration, DestroyObject(oFiend));
			DelayCommand(fDuration, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend)));
			DelayCommand(fDuration, DestroyObject(oFiend2));
			DelayCommand(fDuration, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend2)));
		}
	}
	HkPostCast(oCaster);
}


