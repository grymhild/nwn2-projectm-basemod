//:://////////////////////////////////////////////
//:: FileName: "ss_ep_ruin"
/* 	Purpose: Ruin, as with "Greater Ruin" except only 20d6 instead of 35d6.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_RUINN;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iAdjustedDamage;
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_RUINN))
	{
		
		object oTarget = HkGetSpellTarget();
		float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
		float fDelay = fDist/(3.0 * log(fDist) + 2.0);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
		int nDam = d6(20);
		
		
		nDam = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORFULLDAMAGE, nDam, oTarget,HkGetSpellSaveDC(OBJECT_SELF, oTarget),SAVING_THROW_TYPE_SPELL, oCaster, SAVING_THROW_RESULT_ROLL );
		
		effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_TWENTY);
		HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(487), oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oTarget);
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	}
	HkPostCast(oCaster);
}
