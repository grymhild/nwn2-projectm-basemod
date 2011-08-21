//::///////////////////////////////////////////////
//:: Nixie's Grace
//:: cmi_s0_nixiegrce
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: October 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Nixies_Grace;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND|SCMETA_DESCRIPTOR_WATER, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	
	float fDuration = 10 * TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eChaBonus = EffectAbilityIncrease(ABILITY_CHARISMA, 8);
	effect eDexBonus = EffectAbilityIncrease(ABILITY_DEXTERITY, 6);
	effect eWisBonus = EffectAbilityIncrease(ABILITY_WISDOM, 2);
	effect eDR = EffectDamageReduction(5, GMATERIAL_METAL_COLD_IRON, 0, DR_TYPE_GMATERIAL);
	//effect eVision = EffectLowLightVision();
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
		
	effect eLink = EffectLinkEffects(eWisBonus, eDexBonus);
	eLink = EffectLinkEffects(eLink, eChaBonus);
	//eLink = EffectLinkEffects(eLink, eVision);
	eLink = EffectLinkEffects(eLink, eVis);	
	eLink = EffectLinkEffects(eLink, eDR);	
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, HkGetSpellId());
	
	HkPostCast(oCaster);	
}  

