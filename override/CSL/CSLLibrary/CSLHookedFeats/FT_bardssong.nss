//::///////////////////////////////////////////////
//:: Bard Song
//:: NW_S2_BardSong
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spells applies bonuses to all of the
	bard's allies within 30ft for a set duration of
	10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller Oct 1, 2003
/*
bugfix by Kovi 2002.07.30
- loosing temporary hp resulted in loosing the other bonuses
*/


// (Updated JLR - OEI 08/01/05 NWN2 3.5 -- NO LONGER USED)
// PKM-OEI 07.13.06 VFX Pass: Removed NWN1 VFX causing problems



#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	if (CSLGetHasEffectType( OBJECT_SELF, EFFECT_TYPE_SILENCE ))
	{
			FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
			return;
	}
	string sTag = GetTag(OBJECT_SELF);

	if (sTag == "x0_hen_dee" || sTag == "x2_hen_deekin")
	{
			// * Deekin has a chance of singing a doom song
			// * same effect, better tune
			if (Random(100) + 1 > 80)
			{
				// the Xp2 Deekin knows more than one doom song
				if (d3() ==1 && sTag == "x2_hen_deekin")
				{
					DelayCommand(0.0, PlaySound("vs_nx2deekM_050"));
				}
				else
				{
					DelayCommand(0.0, PlaySound("vs_nx0deekM_074"));
					DelayCommand(5.0, PlaySound("vs_nx0deekM_074"));
				}
			}
	}


	//Declare major variables
	int iLevel = GetLevelByClass(CLASS_TYPE_BARD);
	int nRanks = GetSkillRank(SKILL_PERFORM);
	int nChr = GetAbilityModifier(ABILITY_CHARISMA);
	int nPerform = nRanks;
	int iDuration = 10; //+ nChr;

	effect eAttack;
	effect eDamage;
	effect eWill;
	effect eFort;
	effect eReflex;
	effect eHP;
	effect eAC;
	effect eSkill;

	int nAttack;
	int iDamage;
	int nWill;
	int nFort;
	int nReflex;
	int nHP;
	int nAC;
	int nSkill;
	//Check to see if the caster has Lasting Impression and increase duration.
	if(GetHasFeat(FEAT_EPIC_LASTING_INSPIRATION))
	{
			iDuration *= 10;
	}

	// lingering song
	if(GetHasFeat(FEAT_LINGERING_SONG)) // lingering song
	{
			iDuration += 5;
	}

	//SpeakString("Level: " + IntToString(iLevel) + " Ranks: " + IntToString(nRanks));

	if(nPerform >= 100 && iLevel >= 30)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 48;
			nAC = 7;
			nSkill = 19;
	}
	else if(nPerform >= 95 && iLevel >= 29)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 46;
			nAC = 6;
			nSkill = 18;
	}
	else if(nPerform >= 90 && iLevel >= 28)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 44;
			nAC = 6;
			nSkill = 17;
	}
	else if(nPerform >= 85 && iLevel >= 27)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 42;
			nAC = 6;
			nSkill = 16;
	}
	else if(nPerform >= 80 && iLevel >= 26)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 40;
			nAC = 6;
			nSkill = 15;
	}
	else if(nPerform >= 75 && iLevel >= 25)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 38;
			nAC = 6;
			nSkill = 14;
	}
	else if(nPerform >= 70 && iLevel >= 24)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 36;
			nAC = 5;
			nSkill = 13;
	}
	else if(nPerform >= 65 && iLevel >= 23)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 34;
			nAC = 5;
			nSkill = 12;
	}
	else if(nPerform >= 60 && iLevel >= 22)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 32;
			nAC = 5;
			nSkill = 11;
	}
	else if(nPerform >= 55 && iLevel >= 21)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 30;
			nAC = 5;
			nSkill = 9;
	}
	else if(nPerform >= 50 && iLevel >= 20)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 28;
			nAC = 5;
			nSkill = 8;
	}
	else if(nPerform >= 45 && iLevel >= 19)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 26;
			nAC = 5;
			nSkill = 7;
	}
	else if(nPerform >= 40 && iLevel >= 18)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 24;
			nAC = 5;
			nSkill = 6;
	}
	else if(nPerform >= 35 && iLevel >= 17)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 22;
			nAC = 5;
			nSkill = 5;
	}
	else if(nPerform >= 30 && iLevel >= 16)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 20;
			nAC = 5;
			nSkill = 4;
	}
	else if(nPerform >= 24 && iLevel >= 15)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 2;
			nFort = 2;
			nReflex = 2;
			nHP = 16;
			nAC = 4;
			nSkill = 3;
	}
	else if(nPerform >= 21 && iLevel >= 14)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 1;
			nFort = 1;
			nReflex = 1;
			nHP = 16;
			nAC = 3;
			nSkill = 2;
	}
	else if(nPerform >= 18 && iLevel >= 11)
	{
			nAttack = 2;
			iDamage = 2;
			nWill = 1;
			nFort = 1;
			nReflex = 1;
			nHP = 8;
			nAC = 2;
			nSkill = 2;
	}
	else if(nPerform >= 15 && iLevel >= 8)
	{
			nAttack = 2;
			iDamage = 2;
			nWill = 1;
			nFort = 1;
			nReflex = 1;
			nHP = 8;
			nAC = 0;
			nSkill = 1;
	}
	else if(nPerform >= 12 && iLevel >= 6)
	{
			nAttack = 1;
			iDamage = 2;
			nWill = 1;
			nFort = 1;
			nReflex = 1;
			nHP = 0;
			nAC = 0;
			nSkill = 1;
	}
	else if(nPerform >= 9 && iLevel >= 3)
	{
			nAttack = 1;
			iDamage = 2;
			nWill = 1;
			nFort = 1;
			nReflex = 0;
			nHP = 0;
			nAC = 0;
			nSkill = 0;
	}
	else if(nPerform >= 6 && iLevel >= 2)
	{
			nAttack = 1;
			iDamage = 1;
			nWill = 1;
			nFort = 0;
			nReflex = 0;
			nHP = 0;
			nAC = 0;
			nSkill = 0;
	}
	else if(nPerform >= 3 && iLevel >= 1)
	{
			nAttack = 1;
			iDamage = 1;
			nWill = 0;
			nFort = 0;
			nReflex = 0;
			nHP = 0;
			nAC = 0;
			nSkill = 0;
	}
	effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);

	eAttack = EffectAttackIncrease(nAttack);
	eDamage = EffectDamageIncrease(iDamage, DAMAGE_TYPE_BLUDGEONING );
	effect eLink = EffectLinkEffects(eAttack, eDamage);

	if(nWill > 0)
	{
			eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, nWill);
			eLink = EffectLinkEffects(eLink, eWill);
	}
	if(nFort > 0)
	{
			eFort = EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort);
			eLink = EffectLinkEffects(eLink, eFort);
	}
	if(nReflex > 0)
	{
			eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nReflex);
			eLink = EffectLinkEffects(eLink, eReflex);
	}
	if(nHP > 0)
	{
			//SpeakString("HP Bonus " + IntToString(nHP));
			eHP = EffectTemporaryHitpoints(nHP);
//        eLink = EffectLinkEffects(eLink, eHP);
	}
	if(nAC > 0)
	{
			eAC = EffectACIncrease(nAC, AC_DODGE_BONUS);
			eLink = EffectLinkEffects(eLink, eAC);
	}
	if(nSkill > 0)
	{
			eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nSkill);
			eLink = EffectLinkEffects(eLink, eSkill);
	}
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	eLink = EffectLinkEffects(eLink, eDur);

	//effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC); //NWN1 VFX
	//effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30); //NWN1 VFX
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF)); //NWN1 VFX

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

	eHP = ExtraordinaryEffect(eHP);
	eLink = ExtraordinaryEffect(eLink);

	while(GetIsObjectValid(oTarget))
	{
			if(!GetHasFeatEffect(FEAT_BARD_SONGS, oTarget) && !GetHasSpellEffect(GetSpellId(),oTarget))
			{
				// * GZ Oct 2003: If we are silenced, we can not benefit from bard song
				if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_SILENCE ) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
				{
					if(oTarget == OBJECT_SELF)
					{
							effect eLinkBard = EffectLinkEffects(eLink, eVis);
							eLinkBard = ExtraordinaryEffect(eLinkBard);
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
							if (nHP > 0)
							{
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
							}
					}
					else if(GetIsFriend(oTarget))
					{
							//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget); //NWN1 VFX
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
							if (nHP > 0)
							{
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
							}
					}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
}