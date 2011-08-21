//::///////////////////////////////////////////////
//:: Beholder Anti Magic cone
//:: x2_s1_beantimag
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Beholder anti magic cone
	30m cone,
	100% spell failure to all targets,
	100% spellresistance to all targets
	9 seconds duration
	No save

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-19
//:://////////////////////////////////////////////

#include "_HkSpell"

void DoRemoveEffects(object oTarget)
{
	effect eEff = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEff))
	{
			if (GetEffectSubType(eEff) == SUBTYPE_MAGICAL)
			{
				if (GetEffectType(eEff) != EFFECT_TYPE_DISAPPEARAPPEAR
					&& GetEffectType(eEff) != EFFECT_TYPE_SPELL_FAILURE
					)
				{

					RemoveEffect (oTarget, eEff);
				}
			}
			eEff = GetNextEffect(oTarget);
	}
}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	location lTargetLocation = HkGetSpellTargetLocation();
	effect eDur = EffectVisualEffect(VFX_DUR_RUBUKE_UNDEAD);
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	effect eAntiMag = EffectSpellFailure(100);
	effect eImmune = EffectSpellResistanceIncrease(100, -1);
	eAntiMag = ExtraordinaryEffect(eAntiMag);
	eAntiMag = EffectLinkEffects(eDur, eAntiMag);
	eAntiMag = EffectLinkEffects(eImmune, eAntiMag);


	object oTarget;
	float fDuration = 9.0f;
	float fDelay;

	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 25.0f, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
	while(GetIsObjectValid(oTarget))
	{
			if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
				{
					// only dispel AoEs done by creatures
					if (GetObjectType(GetAreaOfEffectCreator(oTarget)) == OBJECT_TYPE_CREATURE)
					{
						DestroyObject(oTarget,0.1f);
					}
				}
				else
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
					//Determine effect delay
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					//Set damage effect
					//Apply the VFX impact and effects
					if (!GetIsDM(oTarget) && !GetPlotFlag(oTarget) )
					{
							if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_PETRIFY ) && GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") != 10)
							{
								DoRemoveEffects(oTarget);
							}
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAntiMag, oTarget, fDuration));

					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 25.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
	}
	
	effect eCone = EffectNWN2SpecialEffectFile("fx_mindflayer_cone");
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, 1.0);
}