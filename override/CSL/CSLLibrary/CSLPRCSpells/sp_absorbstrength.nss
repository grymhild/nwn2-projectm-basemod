//::///////////////////////////////////////////////
//:: Name 	Absorb Strength
//:: FileName sp_absorb_str.nss
//:://////////////////////////////////////////////
/** @file Absorb Strength
Necromancy [Evil]
Level: Corrupt 4
Components: V, S, F, Corrupt
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/level

The caster eats at least a portion of the flesh of
another creature's corpse, thereby gaining one-quarter
of the creature's Strength score as an enhancement
bonus to the caster's Strength score, and one-quarter
of the creature's Constitution score as an enhancement
bonus to the caster's Constitution.

Focus: A fresh or preserved (still bloody) 1-ounce
portion of another creature's flesh.

Corruption Cost: 2d6 points of Wisdom damage.

Author: 	Tenjac
Created: 	1/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "inc_abil_damage"

#include "_HkSpell"
#include "_SCInclude_Necromancy"

void DiseaseCheck(object oTarget, object oCaster)
{
	effect eDisease;
	
	if ( CSLGetIsFiend( oTarget  ) )
	{
		eDisease = SupernaturalEffect(EffectDisease(DISEASE_SOUL_ROT));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oCaster);
	}
	else if ( CSLGetIsUndead(oTarget) )
	{
		eDisease = SupernaturalEffect(EffectDisease(DISEASE_BLUE_GUTS));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oCaster);
	}
	else if ( CSLGetIsVermin(oTarget) )
	{
		eDisease = SupernaturalEffect(EffectDisease(DISEASE_BLUE_GUTS));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oCaster);
	}
	else if ( CSLGetIsAberration(oTarget) )
	{
		eDisease = SupernaturalEffect(EffectDisease(DISEASE_BLUE_GUTS));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oCaster);
	}
	else if ( CSLGetIsOoze(oTarget) )
	{
		eDisease = SupernaturalEffect(EffectDisease(DISEASE_BLUE_GUTS));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oCaster);
	}

	
}


void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ABSORB_STRENGTH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	object oSkin = CSLGetPCSkin(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_CUBE, RADIUS_SIZE_SMALL, lLoc, FALSE, OBJECT_TYPE_CREATURE);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_ABSORB_STRENGTH, oCaster);

		while(!GetIsDead(oTarget) && GetIsObjectValid(oTarget))
		{
		oTarget = GetNextObjectInShape(SHAPE_CUBE, RADIUS_SIZE_SMALL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}

	//must be dead creature so check again for HkGetSpellTarget
	if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || !GetIsDead(oTarget))
	{
		return;
	}

	//Get ability scores
	int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
	int nCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);

	//Bonus of 1/4
	nStr = nStr/4;
	nCon = nCon/4;

	//Construct effects
	effect eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
	effect eConBonus = EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon);
	effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	//Link
	effect eBonus = EffectLinkEffects(eStrBonus, eConBonus);
			eBonus = EffectLinkEffects(eBonus, eVis);

	//Duration 10 min/level
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	//Apply
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oCaster, fDuration);

	//If appropriate, expose player to disease
	DiseaseCheck(oTarget, oCaster);

	//Corruption Cost
	{
		int nCost = d6(2);
		DelayCommand(fDuration, SCApplyCorruptionCost(oCaster, ABILITY_WISDOM, nCost, 0));
	}


	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


