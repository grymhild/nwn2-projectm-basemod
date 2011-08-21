//////////////////////////////////////////////
//	Author: Drammel 							//
//	Date: 4/15/2009 						//
//	Title: TB_sensemagic						//
//	Description: Identifies an item based on//
//	the player's swordsage level.			//
//////////////////////////////////////////////
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
	
	int nLevel = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) / 2;
	effect eVis = EffectNWN2SpecialEffectFile("ror_blue_eyes1", oPC);
	effect eSenseMagic = EffectSkillIncrease(SKILL_LORE, nLevel);
	eVis = SupernaturalEffect(eVis);
	eSenseMagic = SupernaturalEffect(eSenseMagic);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 3.0f);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSenseMagic, oPC, 18.0f);
	DelayCommand(16.0f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 3.0f));
}
