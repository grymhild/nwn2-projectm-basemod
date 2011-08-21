//::///////////////////////////////////////////////
//:: Spell Turning
//:: NW_S0_SpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Absorbes 1d8 + 8 spell levels before disapearing.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_splmantle();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPELL_MANTLE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(HkGetSpellDuration( oCaster )));
	object oTarget = HkGetSpellTarget();
	int iAbsorb = HkApplyMetamagicVariableMods(d8()+8, 16);
	int iNumberLevels = 9;
	
	//effect eLink = EffectSpellLevelAbsorption(9, iAbsorb);
	//eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_SPELL_MANTLE));
	//eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	CSLUnstackSpellEffects(oTarget, SPELL_LEAST_SPELL_MANTLE, "Least Spell Mantle");
	CSLUnstackSpellEffects(oTarget, SPELL_LESSER_SPELL_MANTLE, "Lesser Spell Mantle");
	CSLUnstackSpellEffects(oTarget, SPELL_SPELL_MANTLE);
	CSLUnstackSpellEffects(oTarget, SPELL_GREATER_SPELL_MANTLE, "Greater Spell Mantle");
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	
	
	
	
	
	
	HkApplySpellMantleEffect( oTarget, GetSpellId(), fDuration, iAbsorb, iNumberLevels );
	
	HkPostCast(oCaster);
}