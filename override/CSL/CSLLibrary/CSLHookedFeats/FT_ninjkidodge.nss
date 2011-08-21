//::///////////////////////////////////////////////
//:: Ninja - Ki Dodge
//:: cmi_s2_ninjakidodge
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 16, 2009
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_chars"
//#include "cmi_ginc_spells"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	

	int nSpellId = SPELLABILITY_NINJA_KI_DODGE;
	int nConceal = 20;

	if (GetLevelByClass(CLASS_NINJA, OBJECT_SELF) > 17)
		nConceal = 50;

	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DISPLACEMENT );
	effect eInvis = EffectConcealment(nConceal);
	effect eLink = EffectLinkEffects( eInvis, eVis );

	eLink = SetEffectSpellId(eLink,nSpellId);
	eLink = SupernaturalEffect(eLink);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(3)));
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_NINJA_KI_POWER_1);

}