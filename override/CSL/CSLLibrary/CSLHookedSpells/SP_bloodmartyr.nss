//::///////////////////////////////////////////////
//:: Blood of the Martyr
//:: cmi_s0_bloodmartyr
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 5, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_bloodmartyr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Blood_of_the_Martyr;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
		

	
	int nMaxHealth = GetMaxHitPoints(oTarget);
	int nCurrentHealth = GetCurrentHitPoints(oTarget);
	int nHeal = nMaxHealth - nCurrentHealth;	
	int iDamage=20;
	
	if (nHeal > iDamage)
	{
		iDamage = nHeal;
	}
		
	effect eDamage = HkEffectDamage(iDamage,DAMAGE_TYPE_DIVINE);
	effect eHeal = EffectHeal(nHeal);
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_X);
	effect eVisSelf = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
		
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));	
	CSLRemoveEffectByType(oTarget, EFFECT_TYPE_WOUNDING);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisSelf, OBJECT_SELF);
	
	HkPostCast(oCaster);
}

