//::///////////////////////////////////////////////
//:: Divine Power
//:: NW_S0_DivPower.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Improves the Clerics attack to be the
	equivalent of a Fighter's BAB of the same level,
	+1 HP per level and raises their strength to
	18 if is not already there.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 21, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_AbilityBuff"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_divinepower();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIVINE_POWER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	

	if (GetHasSpellEffect( SPELL_DIVINE_POWER, oCaster))
	{
		SendMessageToPC(oCaster, "You already have Divine Power in effect.");
		HkPostCast(oCaster);
		return;
	}
	//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELL_DIVINE_POWER );
	
	// SCRemoveTempHitPoints();
	CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, EFFECT_TYPE_TEMPORARY_HITPOINTS );

	int iSpellPower = HkGetSpellPower(oCaster, 26); // capping at level 26
	//int iLevel = GetHitDice(oCaster);
	
	effect eHP = EffectTemporaryHitpoints( iSpellPower );
	
	effect eDivinePower = EffectVisualEffect( VFX_DUR_SPELL_DIVINE_POWER );
	//if ( ( GetAbilityScore(oCaster, ABILITY_STRENGTH, TRUE) + 6 ) > GetAbilityScore(oCaster, ABILITY_STRENGTH ) )
    //{
		// only do increase if it affects the target to prevent some exploits
		eDivinePower = EffectLinkEffects(eDivinePower, EffectAbilityIncrease(ABILITY_STRENGTH, 6) );
	//}
	eDivinePower = EffectLinkEffects(eDivinePower, EffectBABMinimum( iSpellPower ) );

	//Meta-Magic
	float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds( HkGetSpellDuration( oCaster ) ) );

	effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELL_DIVINE_POWER) );
	
	eDivinePower = SetEffectSpellId(eDivinePower, SPELL_DIVINE_POWER);
	eHP = SetEffectSpellId(eHP, SPELL_DIVINE_POWER);
	
	eDivinePower = EffectLinkEffects(eDivinePower, eOnDispell);
	eHP = EffectLinkEffects(eHP, eOnDispell);

	//Fire cast spell at event for the specified target
	SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_DIVINE_POWER, FALSE ) );

	//Apply Link and VFX effects to the target
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDivinePower, oCaster, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oCaster, fDuration);
	
	HkPostCast(oCaster);
}

