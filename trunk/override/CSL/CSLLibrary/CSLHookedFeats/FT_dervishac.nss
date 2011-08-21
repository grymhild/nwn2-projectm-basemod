//::///////////////////////////////////////////////
//:: Dervish, AC Bonus
//:: cmi_s2_dervacbonus
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 3, 2009
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_chars"
//#include "cmi_ginc_spells"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	

	object oPC = OBJECT_SELF;
	int nSpellId = SPELLABILITY_DERVISH_AC_BONUS;

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, nSpellId );
	
	//1,5,9
	int nLevel = GetLevelByClass(CLASS_DERVISH, oPC) + 3;
	nLevel = nLevel/4;

	effect eLink = EffectACIncrease(nLevel);
	eLink = SetEffectSpellId(eLink,nSpellId);
	eLink = SupernaturalEffect(eLink);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48)));


}