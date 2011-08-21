//::///////////////////////////////////////////////
//:: Elemental Sanctuary
//:: cmi_s2_elemsanct
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: August 13, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell" 

void main()
{
	//scSpellMetaData = SCMeta_Generic();

    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_SANCTUARY);
	int iDC = 10 + 10 + GetAbilityModifier(ABILITY_STRENGTH);
    effect eSanc = EffectSanctuary(iDC); 
    effect eLink = EffectLinkEffects(eDur, eSanc);

    float fDuration = RoundsToSeconds(10);

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration));
}