//::///////////////////////////////////////////////
//:: Fight to the Death
//:: cmi_s2_fight2death
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: May 29, 2010
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_DRPIRATE_FIGHT2DEATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
	
	int nCasterLvl = GetLevelByClass(CLASS_DREAD_PIRATE, oCaster);

	float fDuration = RoundsToSeconds( nCasterLvl );

	int nCha = GetAbilityModifier(ABILITY_CHARISMA);
	if (nCha < 1)
	{
		nCha = 1;
	}
	effect eAC = EffectACIncrease(nCha);
	effect eBonusHP = EffectBonusHitpoints(GetHitDice(oCaster));
	effect eFightToDeath = EffectLinkEffects(eAC, eBonusHP);
	effect eTempHP = EffectTemporaryHitpoints(10 + nCha);
	eFightToDeath = SetEffectSpellId(eFightToDeath, iSpellId);
	eFightToDeath = SupernaturalEffect(eFightToDeath);
	eTempHP = SetEffectSpellId(eTempHP, iSpellId);
	eTempHP = SupernaturalEffect(eTempHP);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCaster));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{

			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iSpellId );
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFightToDeath, oTarget, RoundsToSeconds(nCasterLvl));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oTarget, RoundsToSeconds(nCasterLvl));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCaster));
	}
}