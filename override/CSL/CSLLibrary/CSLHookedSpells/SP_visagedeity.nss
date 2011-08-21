//::///////////////////////////////////////////////
//:: Visage of the Deity
//:: cmi_s0_visagedeity
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 25, 2007
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/



#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_visagedeity();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Visage_Deity;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
	switch (nAlign)
	{
		case ALIGNMENT_EVIL:
			iDescriptor = iDescriptor|SCMETA_DESCRIPTOR_EVIL;
			break;
		case ALIGNMENT_GOOD:
			iDescriptor = iDescriptor|SCMETA_DESCRIPTOR_GOOD;
			break;
		case ALIGNMENT_NEUTRAL:
			iDescriptor = iDescriptor|SCMETA_DESCRIPTOR_NONE;
			break;
	}
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eDR = EffectDamageReduction(10,DR_TYPE_GMATERIAL,0,GMATERIAL_METAL_ADAMANTINE);
	effect eSR = EffectSpellResistanceIncrease(20);
	effect eDarkVision = EffectDarkVision();
	effect eDamResistAcid = EffectDamageResistance(DAMAGE_TYPE_ACID,20);
	effect eDamResistCold = EffectDamageResistance(DAMAGE_TYPE_COLD,20);
	effect eDamResistElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL,20);
	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	
	effect eLink = EffectLinkEffects(eDamResistAcid, eDamResistCold);
	eLink = EffectLinkEffects(eLink, eDamResistElec);
	eLink = EffectLinkEffects(eLink, eDR);
	eLink = EffectLinkEffects(eLink, eSR);
	eLink = EffectLinkEffects(eLink, eDarkVision);		
	eLink = EffectLinkEffects(eLink, eVis);	
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);

	HkPostCast(oCaster);
}      

