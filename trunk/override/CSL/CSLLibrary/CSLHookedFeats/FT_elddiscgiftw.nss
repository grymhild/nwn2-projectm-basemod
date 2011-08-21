//::///////////////////////////////////////////////
//:: Eldritch Disciple, Wild Frenzy
//:: cmi_s2_giftwf
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 2, 2009
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
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
	
	object oPC = OBJECT_SELF;
	int nSpellId = SPELLABILITY_ELDDISC_WF;

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, nSpellId );

	int nHP = GetLevelByClass(CLASS_ELDRITCH_DISCIPLE, oPC) * 2;
	effect eTempHP = EffectTemporaryHitpoints(nHP);

	effect eAB = EffectAttackIncrease(2);
	effect eDmg = EffectDamageIncrease(2);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eLink = EffectLinkEffects(eAB, eDmg);
	eLink = EffectLinkEffects(eLink, eVis);

	eLink = SetEffectSpellId(eLink,nSpellId);
	eLink = SupernaturalEffect(eLink);

	int nDuration = 3 + GetAbilityModifier(ABILITY_CHARISMA);
	if (nDuration <=0)
		nDuration = 1;
	float fDuration = RoundsToSeconds( nDuration );

	SignalEvent(oPC, EventSpellCastAt(oPC, nSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oPC, fDuration);
	DecrementRemainingFeatUses(oPC, 294);
}