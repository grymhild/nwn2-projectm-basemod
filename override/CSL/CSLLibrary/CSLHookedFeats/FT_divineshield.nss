//::///////////////////////////////////////////////
//:: Divine Shield
//:: x0_s2_divshield.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Up to [turn undead] times per day the character may add his Charisma bonus to his armor
	class for a number of rounds equal to the Charisma bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13, 2002
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_divineshield();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);

	if (!GetHasFeat(FEAT_TURN_UNDEAD, oCaster))
	{
		SpeakStringByStrRef(40550);
		return;
	}
	
	object oTarget = HkGetSpellTarget();
	CSLUnstackSpellEffects(oTarget, SPELL_DIVINE_SHIELD);
	
	if (!GetHasFeatEffect(FEAT_DIVINE_SHIELD))
	{

		int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
		effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		eLink = EffectLinkEffects(eLink, EffectACIncrease(nCharismaBonus));
		eLink = SupernaturalEffect(eLink);

		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DIVINE_SHIELD, FALSE));

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_EVOCATION), oTarget);

		DecrementRemainingFeatUses(oCaster, FEAT_TURN_UNDEAD);
	}
	
	HkPostCast(oCaster);
}