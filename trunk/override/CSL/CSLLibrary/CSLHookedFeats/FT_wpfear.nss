//::///////////////////////////////////////////////
//:: Warpriest Fear Aura
//:: NW_S2_WPFearAura
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
// The Warpriest "bursts" a fear aura, causing all
// enemies within 20' to suffer the effects of a fear
// spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	//effect eVis    = EffectVisualEffect(VFX_IMP_FEAR_S);
	effect eFear   = EffectFrightened();
	effect eDur    = EffectVisualEffect( VFX_DUR_SPELL_CAUSE_FEAR );
	effect eVis = EffectVisualEffect( VFX_HIT_CURE_AOE );
	//effect eDur2   = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
	//effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_MIND);

	effect eLink = EffectLinkEffects(eFear, eDur);
	//eLink = EffectLinkEffects(eLink, eDur2);
	
	float fDelay;
	int iLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST);
	int iDC = 10 + iLevel + GetAbilityModifier(ABILITY_CHARISMA);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);

	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	while(GetIsObjectValid(oTarget))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
		{
				fDelay = GetDistanceToObject(oTarget)/10;
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WARPRIEST_FEAR_AURA));

				if(!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
					//Make a saving throw check
					if(!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR))
					{
						//Apply the VFX impact and effects
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iLevel)));
						//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
			}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
	}
}