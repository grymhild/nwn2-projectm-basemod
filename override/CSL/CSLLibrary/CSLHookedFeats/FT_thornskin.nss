//::///////////////////////////////////////////////
//:: Plant Body
//:: cmi_s0_plantbody
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 8, 2008
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
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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

	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6 , DAMAGE_TYPE_PIERCING);
	effect eDS = EffectDamageShield(5, 0, DAMAGE_TYPE_PIERCING);
		
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	
	effect eLink = EffectLinkEffects(eVis, eDmg);
	eLink = EffectLinkEffects(eLink, eDS);				
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
	
	HkPostCast(oCaster);
}