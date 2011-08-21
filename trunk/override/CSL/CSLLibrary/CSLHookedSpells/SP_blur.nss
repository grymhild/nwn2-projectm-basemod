//::///////////////////////////////////////////////
//:: Blur
//:: cmi_s0_blur
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: May 29, 2010
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
		
	object oTarget = HkGetSpellTarget();

	effect eConc = EffectConcealment(20);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	effect eLink = EffectLinkEffects(eConc, eDur);

	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	float fDuration = TurnsToSeconds( nCasterLvl );
	fDuration = HkApplyMetamagicDurationMods(fDuration);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oTarget, HkGetSpellId(), FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}