//::///////////////////////////////////////////////
//:: Inspire Hatred
//:: cmi_s2_insphatred
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 28, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x0_I0_SPELLS"
//#include "x2_inc_spellhook"

void main()
{	
	//scSpellMetaData = SCMeta_FT_inspirehate();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes =123264;
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
	


    object oTarget = HkGetSpellTarget();
	
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	
	
	effect eABLoss = EffectAttackDecrease(2);
	effect eACLoss = EffectACDecrease(2);
	effect eSaveLoss = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
	
	effect eLink = EffectLinkEffects(eABLoss,eACLoss);
	eLink = EffectLinkEffects (eSaveLoss,eACLoss);
	eLink = SupernaturalEffect(eLink);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    {
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(1));
    }
    
    HkPostCast(oCaster);
}