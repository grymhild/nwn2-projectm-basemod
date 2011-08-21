//::///////////////////////////////////////////////
//:: Prismatic Dragon Prismatic Breath
//:: X2_S1_PrisSpray
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:: Save is HD
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Aug 09, 2003
//:://////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget);

#include "_HkSpell"

int PDGetBreathDC()
{
	return GetHitDice(OBJECT_SELF);
}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oTarget;
	int iCasterLevel = GetHitDice(OBJECT_SELF);
	int nRandom;
	int iHD;
	int nVisual;
	effect eVisual;
	int bTwoEffects;

	//Set the delay to apply to effects based on the distance to the target
	float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
	//Get first target in the spell area

	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, HkGetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				//Make an SR check
									//Blind the target if they are less than 9 HD
					iHD = GetHitDice(oTarget);
					if (iHD <= 8)
					{
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(iCasterLevel));
					}
					//Determine if 1 or 2 effects are going to be applied
					nRandom = d8();
					if(nRandom == 8)
					{
							//Get the visual effect
							nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget);
							nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget);
					}
					else
					{
							//Get the visual effect
							nVisual = ApplyPrismaticEffect(nRandom, oTarget);
					}
					//Set the visual effect
					if(nVisual != 0)
					{
							eVisual = EffectVisualEffect(nVisual);
							//Apply the visual effect
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
					}
			}
			//Get next target in the spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0, HkGetSpellTargetLocation());
	}
}

///////////////////////////////////////////////////////////////////////////////
//  ApplyPrismaticEffect
///////////////////////////////////////////////////////////////////////////////
/*  Given a reference integer and a target, this function will apply the effect
	of corresponding prismatic cone to the target.  To have any effect the
	reference integer (nEffect) must be from 1 to 7.*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan On: April 11, 2001
///////////////////////////////////////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget)
{
	int iDamage;
	effect ePrism;
	effect eVis;
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink;
	int nVis;
	float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
	//Based on the random number passed in, apply the appropriate effect and set the visual to
	//the correct constant
	switch(nEffect)
	{
			case 1://fire
				iDamage = 20;
				nVis = VFX_IMP_FLAME_S;
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, PDGetBreathDC(),SAVING_THROW_TYPE_FIRE);
				ePrism = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			break;
			case 2: //Acid
				iDamage = 40;
				nVis = VFX_IMP_ACID_L;
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, PDGetBreathDC(),SAVING_THROW_TYPE_ACID);
				ePrism = EffectDamage(iDamage, DAMAGE_TYPE_ACID);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			break;
			case 3: //Electricity
				iDamage = 80;
				nVis = VFX_IMP_LIGHTNING_S;
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, PDGetBreathDC(),SAVING_THROW_TYPE_ELECTRICITY);
				ePrism = EffectDamage(iDamage, DAMAGE_TYPE_ELECTRICAL);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			break;
			case 4: //Poison
				{
					effect ePoison = EffectPoison(POISON_BEBILITH_VENOM);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget));
				}
			break;
			case 5: //Paralyze
				{
					effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
					if (HkSavingThrow(SAVING_THROW_FORT, oTarget, PDGetBreathDC()) == 0)
					{
							ePrism = EffectParalyze(PDGetBreathDC(), SAVING_THROW_FORT);
							eLink = EffectLinkEffects(eDur, ePrism);
							eLink = EffectLinkEffects(eLink, eDur2);
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
					}
				}
			break;
			case 6: //Confusion
				{
					effect eMind = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
					ePrism = EffectConfused();
					eLink = EffectLinkEffects(eMind, ePrism);
					eLink = EffectLinkEffects(eLink, eDur);

					if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, PDGetBreathDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
					{
							nVis = VFX_IMP_CONFUSION_S;
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
					}
				}
			break;
			case 7: //Death
				{
					if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, PDGetBreathDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
					{
							//nVis = VFX_IMP_DEATH;
							ePrism = EffectDeath();
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
					}
				}
			break;
	}
	return nVis;
}