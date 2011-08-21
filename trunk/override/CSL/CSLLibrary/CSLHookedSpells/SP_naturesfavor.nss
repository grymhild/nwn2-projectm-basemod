//::///////////////////////////////////////////////
//:: Nature's Favor
//:: cmi_s0_natfavor
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: October 15, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook" 
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_naturesfavor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Natures_Favor;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	int iSpellPower = HkGetSpellPower(OBJECT_SELF, 15);
	int iBonus = iSpellPower/3;
	
    object oTarget = HkGetSpellTarget();
    effect eAB = EffectAttackIncrease(iBonus);
    effect eDam = EffectDamageIncrease(iBonus);	
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_AWAKEN );	// NWN2 VFX
	
    float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	
    if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
    {
        if(!GetHasSpellEffect(GetSpellId()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			fDuration = HkApplyMetamagicDurationMods(fDuration);
            effect eLink = EffectLinkEffects(eAB, eDam);
			eLink = EffectLinkEffects(eLink, eVis);
            HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
        }
    }
    
    HkPostCast(oCaster);
}

