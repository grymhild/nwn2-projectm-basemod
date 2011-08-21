//::///////////////////////////////////////////////
//:: Radiant Aura
//:: cmi_s2_radntaura
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 12, 2007
//:://////////////////////////////////////////////
//:: Based on Aura of Despair


/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_radiantaura();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
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
	
	float fDuration = TurnsToSeconds(1);
	
    object oTarget = HkGetSpellTarget();
	
	int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_MASTER_RADIANCE );
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	if (!GetHasSpellEffect(SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA, OBJECT_SELF))
	{
		effect eVis = EffectVisualEffect( VFX_SPELL_DUR_BODY_SUN ); //Body of the Sun		
		effect eAOE = EffectAreaOfEffect(VFX_PER_RADIANT_AURA, "", "", "", sAOETag);
		effect eLink = EffectLinkEffects(eAOE, eVis);	
		eLink = SetEffectSpellId(eLink, SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA);
		eLink = SupernaturalEffect(eLink); 	
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA, FALSE));
	    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
	}
	HkPostCast(oCaster);		
}

