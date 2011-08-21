//::///////////////////////////////////////////////
//:: Eldritch Disciple, Fiendish Resistance
//:: cmi_s2_giftfr
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
	int iSpellId = SPELLABILITY_ELDDISC_FR;
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
	int nSpellId = SPELLABILITY_ELDDISC_FR;

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, nSpellId );
	
	int nAcid = GetLevelByClass(CLASS_ELDRITCH_DISCIPLE, oPC) + 10;
	int nFire = nAcid;

	int nLevel = GetLevelByClass(CLASS_TYPE_WARLOCK, oPC);
	if (nLevel > 9)
	{
		if (GetHasFeat(1785)) //Acid
		{
			if (GetHasFeat(1790)) //Acid
				nAcid += 10;
			else
			if (GetHasFeat(1943)) //Acid
				nAcid += 15;
			else
				nAcid += 5;
		}
		if (GetHasFeat(1788)) //Fire
		{
			if (GetHasFeat(1793)) //Fire
				nFire += 10;
			else
			if (GetHasFeat(1946)) //Fire
				nFire += 15;
			else
				nFire += 5;
		}
	}

	effect eDRFire = EffectDamageResistance(DAMAGE_TYPE_FIRE , nFire);
	effect eDRAcid = EffectDamageResistance(DAMAGE_TYPE_ACID , nAcid);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eLink = EffectLinkEffects(eDRFire, eDRAcid);
	eLink = EffectLinkEffects(eLink, eVis);

	eLink = SetEffectSpellId(eLink,nSpellId);
	eLink = SupernaturalEffect(eLink);

	int nDuration = 3 + GetAbilityModifier(ABILITY_CHARISMA);
	if (nDuration <=0)
		nDuration = 1;
	float fDuration = RoundsToSeconds( nDuration );

	SignalEvent(oPC, EventSpellCastAt(oPC, nSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	DecrementRemainingFeatUses(oPC, 294);
}