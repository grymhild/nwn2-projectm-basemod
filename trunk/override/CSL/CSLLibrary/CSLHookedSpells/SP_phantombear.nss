//::///////////////////////////////////////////////
//:: Phantom Bear
//:: cmi_s0_phantbear
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 14, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_SP_phantombear();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PHANTOMBEAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	int iDuration = HkGetSpellPower(OBJECT_SELF);
	
	effect eSummon = EffectSummonCreature("csl_sum_spirit_phantbear");
	effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
	
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, HkGetSpellTargetLocation());
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), fDuration );
	/*
	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
	effect eLink = IncorporealEffect(oSummon);
	effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_2d10, DAMAGE_TYPE_COLD);
	eLink = EffectLinkEffects(eDamage, eLink);
	
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon));
	*/
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	DelayCommand(2.0f, ApplyPhantomStats(OBJECT_SELF));		
	
	HkPostCast(oCaster);	
}

