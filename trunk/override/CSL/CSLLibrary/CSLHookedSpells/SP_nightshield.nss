//::///////////////////////////////////////////////
//:: Nightshield
//:: nx2_s0_nightshield.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Nightshield
	Abjuration
	Level: Cleric 1, sorceror/wizard 1
	Components: V, S
	Range: Personal
	Target: You
	Duration: 1 minute/level
	
	This spell provides a +1 resistance bonus on saving throws; this resistance increases to +2 at caster level 6th, and +3 at caster level 9th.
	In addition, the spell negate magic missile attacks directed at you.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NIGHTSHIELD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	// Caster level
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	// Spell Duration
	float fDuration = TurnsToSeconds( HkGetSpellDuration( oCaster ) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	// Amount of increase
	int nIncrease = 1;
	
	if(iSpellPower >= 9)
	{
		nIncrease = 3;
	}
	else if( iSpellPower >= 6)
	{
		nIncrease = 2;
	}
	// Effects
	effect eSTIncrease = EffectSavingThrowIncrease(SAVING_THROW_ALL, nIncrease);
	effect eImmuneMM = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
	effect eVisual = EffectVisualEffect(VFX_DUR_SPELL_NIGHTSHIELD);
	effect eLink = EffectLinkEffects(eSTIncrease, eImmuneMM);
	eLink = EffectLinkEffects(eLink, eVisual);

		// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, iSpellId);
		if ( GetHasSpellEffect(SPELL_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_GREATER_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_SUPERIOR_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_CONVICTION, oTarget) )
		{
			FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
			return;
		}
		
		
		// check to see if ally
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			// apply linked effect to target
			HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
		
	}
	
	HkPostCast(oCaster);
}
