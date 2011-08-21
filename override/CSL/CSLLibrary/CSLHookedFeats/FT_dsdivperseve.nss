//::///////////////////////////////////////////////
//:: Sacred Stealth
//:: cmi_s2_sacredstlth
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_FT_dsdivperseve();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

    
    // Does not stack with itself.
    if (!GetHasSpellEffect(GetSpellId(), OBJECT_SELF))
    {
	
		int nChaBonus = GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
		if (nChaBonus < 0)
			nChaBonus = 0;
		int nHeal = d6(3) + nChaBonus;
		 
        effect eHP = EffectHealOnZeroHP(OBJECT_SELF, nHeal);
        eHP = ExtraordinaryEffect(eHP); // Make it not dispellable.
    
        //Fire cast spell at event for the specified target
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    
        //Apply the VFX impact and effects
        HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, OBJECT_SELF);
    }
    
    HkPostCast(oCaster);
}