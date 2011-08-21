///////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 4/28/2009											//
//	Name: TB_battleclarit										//
//	Description: Grants a bonus to reflex saves based on Int.//
//	Battle Clarity is capped at the Warblade's maximum level.//
///////////////////////////////////////////////////////////////
//#include "tob_i0_spells"
//#include "bot9s_inc_constants"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	int nIntelligence = GetAbilityModifier(ABILITY_INTELLIGENCE);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE);
	int nEffectID = SPELL_FEAT_BCLARITY;
	int nBonus;
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELL_FEAT_BCLARITY );

	if (nIntelligence >= nWarblade)
	{
		nBonus = nWarblade;
	}
	else if (nIntelligence < 1)
	{
		nBonus = 0;
	}
	else nBonus = nIntelligence;

	effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBonus);
	eReflex = SupernaturalEffect(eReflex);
	eReflex = SetEffectSpellId(eReflex, nEffectID);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflex, oPC));
}