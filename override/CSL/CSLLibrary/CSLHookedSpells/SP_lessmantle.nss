//::///////////////////////////////////////////////
//:: Lesser Spell Mantle
//:: NW_S0_LsSpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Absorbs 1d6 + 6 spell levels before collapsing
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_lessmantle();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LESSER_SPELL_MANTLE;
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
	


	//Declare major variables
	// int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( HkGetSpellDuration( oCaster ) ));
	object oTarget = HkGetSpellTarget();
	int iAbsorb = HkApplyMetamagicVariableMods(d6()+6, 12);
	int iNumberLevels = 9;
	
	//effect eLink = EffectSpellLevelAbsorption(9, iAbsorb);
	//eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_LESSER_SPELL_MANTLE));
	//eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	CSLUnstackSpellEffects(oTarget, SPELL_LEAST_SPELL_MANTLE, "Least Spell Mantle");
	CSLUnstackSpellEffects(oTarget, SPELL_LESSER_SPELL_MANTLE);
	CSLUnstackSpellEffects(oTarget, SPELL_SPELL_MANTLE, "Spell Mantle");
	CSLUnstackSpellEffects(oTarget, SPELL_GREATER_SPELL_MANTLE, "Greater Spell Mantle");
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	
	HkApplySpellMantleEffect( oTarget, GetSpellId(), fDuration, iAbsorb, iNumberLevels );
	
	HkPostCast(oCaster);
}