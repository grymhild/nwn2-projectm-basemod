//::///////////////////////////////////////////////
//:: Dragonslayer Bonus Damage
//:: cmi_s2_drgbondmg
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Feb 1, 2009
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"
//#include "cmi_ginc_spells"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_DRSLR_DMG_BONUS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
	
	int nBonus = GetLevelByClass(CLASS_DRAGONSLAYER);
	int nDR = 0;
	int nRes = 0;

	effect eDmg = EffectDamageIncrease(CSLGetDamageBonusConstantFromNumber(nBonus, TRUE));
	eDmg = VersusRacialTypeEffect(eDmg, RACIAL_TYPE_DRAGON);
	effect eLink = eDmg;

	if (nBonus > 9)
	{
		nRes = 10;
		nDR = 3;
	}
	else
	if (nBonus > 8)
	{
		nRes = 5;
		nDR = 3;
	}
	else
	if (nBonus > 5)
	{
		nRes = 5;
		nDR = 2;
	}
	else
	if (nBonus > 4)
	{
		nRes = 5;
		nDR = 1;
	}
	else
	if (nBonus > 2)
	{
		nDR = 1;
	}

	if (nDR > 0)
	{
		if (GetHasFeat(494))
		{
			nDR += 9;
		}
		else
		if (GetHasFeat(493))
		{
			nDR += 6;
		}
		else
		if (GetHasFeat(492))
		{
			nDR += 3;
		}

		if (GetHasFeat(1253))
			nDR++;

		effect eDR = EffectDamageReduction(nDR, DR_TYPE_NONE, 0, DR_TYPE_NONE);
		eLink = EffectLinkEffects(eLink, eDR);
	}

	if (nRes > 0)
	{
		effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID , nRes);
		effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD , nRes);
		effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL , nRes);
		effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE , nRes);
		effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC , nRes);
		eLink = EffectLinkEffects(eAcid, eLink);
		eLink = EffectLinkEffects(eCold, eLink);
		eLink = EffectLinkEffects(eElec, eLink);
		eLink = EffectLinkEffects(eFire, eLink);
		eLink = EffectLinkEffects(eSonic, eLink);
	}

	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF));

}