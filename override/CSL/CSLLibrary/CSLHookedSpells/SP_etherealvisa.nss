//::///////////////////////////////////////////////
//:: Ethereal Visage
//:: NW_S0_EtherVis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Caster gains 20/+3 Damage reduction and is immune
	to 2 level spells and lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_etherealvisa();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ETHEREAL_VISAGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
		object oTarget = HkGetSpellTarget();
		//effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE); // NWN1 VFX
		effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ETHEREAL_VISAGE ); // NWN2 VFX
		//effect eDam = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE); // 3.0 DR rules
		effect eDam = EffectDamageReduction(20, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL); // 3.5 DR approximation
		effect eSpell = EffectSpellLevelAbsorption(2);
		effect eConceal = EffectConcealment(25);
		//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
		//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION); // NWN1 VFX
	
		effect eLink = EffectLinkEffects(eDam, eVis);
		eLink = EffectLinkEffects(eLink, eSpell);
		//eLink = EffectLinkEffects(eLink, eDur); // NWN1 VFX
		eLink = EffectLinkEffects(eLink, eConceal);
		
		int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
		//Enter Metamagic conditions
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREAL_VISAGE, FALSE));
		
		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
		HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget); // NWN1 VFX
	
	HkPostCast(oCaster);
}

