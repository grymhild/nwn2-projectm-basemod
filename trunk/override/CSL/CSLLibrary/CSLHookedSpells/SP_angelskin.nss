//::///////////////////////////////////////////////
//:: Angelskin
//:: cmi_s0_angelskin
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: June 27, 2007
//:://////////////////////////////////////////////
//:: Angelskin
//:: Caster Level(s): Paladin 2
//:: Innate Level: 2
//:: School: Abjuration
//:: Descriptor(s): Good
//:: Component(s): Verbal, Somatic
//:: Range: Touch
//:: Area of Effect / Target: Single
//:: Duration: 1 round / level
//:: Save: None
//:: Spell Resistance: No
//:: The subject gains Damage Reduction 5/Adamantine and Damage Resistance
//:: 5/Negative Energy for 1 round/level.
//:: 
//:: You touch your ally with the holy symbol and invoke the blessed words.
//:: An opalescent glow spreads across her skin, imbuing it with a pearl-like
//:: sheen.
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
///#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Angelskin;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
  	object oTarget = HkGetSpellTarget();
	  	
	effect eDamRes = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 5, 0);	
	effect eDR = EffectDamageReduction(5, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
    //effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() ) );
	
	
	//effect eLink = EffectLinkEffects(eOnDispell, eDR);
	effect eLink = EffectLinkEffects(eDR, eVis);
	eLink = EffectLinkEffects(eLink, eDamRes);	
		
	
	// int iCasterLevel = GetCasterLevelForPaladins();
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
		
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );
    
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
	
	HkPostCast(oCaster);
}      

