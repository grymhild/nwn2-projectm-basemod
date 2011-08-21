//::///////////////////////////////////////////////
//:: Curse Song
//:: X2_S2_CurseSong
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spells applies penalties to all of the
	bard's enemies within 30ft for a set duration of
	10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: May 16, 2003
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 20, 2003

#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_FT_cursesong();
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
	{
			FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
			return;
	}

	if (CSLGetHasEffectType( OBJECT_SELF, EFFECT_TYPE_SILENCE ))
	{
			FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
			return;
	}


	//Declare major variables
    int iLevel = GetBardicClassLevelForUses(OBJECT_SELF);

	int nRanks = GetSkillRank(SKILL_PERFORM);
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
	if(GetHasFeat(870))
	{
			iDuration *= 10;
	}

	if(GetHasFeat(424)) // lingering song
	{
			iDuration += 5;
	}

	if(nPerform >= 100 && iLevel >= 30)
	{
			nAttack = 2;
			iDamage = 3;
			nWill = 3;
			nFort = 2;
			nReflex = 2;
			nHP = 48;
			nAC = 7;
			nSkill = 18;
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
			nSkill = 17;
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
			nSkill = 16;
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
			nSkill = 15;
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
			nSkill = 14;
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
			nSkill = 13;
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
			nSkill = 12;
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
			nSkill = 11;
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
			nSkill = 10;
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
	else if(nPerform >= 18 && iLevel >= 12)
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
	//effect eVis = EffectVisualEffect(VFX_IMP_DOOM);

	eAttack = EffectAttackDecrease(nAttack);
	eDamage = EffectDamageDecrease(iDamage, DAMAGE_TYPE_SLASHING);
	effect eLink = EffectLinkEffects(eAttack, eDamage);

	if(nWill > 0)
	{
			eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, nWill);
			eLink = EffectLinkEffects(eLink, eWill);
	}
	if(nFort > 0)
	{
			eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, nFort);
			eLink = EffectLinkEffects(eLink, eFort);
	}
	if(nReflex > 0)
	{
			eReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, nReflex);
			eLink = EffectLinkEffects(eLink, eReflex);
	}
	if(nHP > 0)
	{
			//SpeakString("HP Bonus " + IntToString(nHP));
			eHP = EffectDamage(nHP, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL);
//        eLink = EffectLinkEffects(eLink, eHP);
	}
	if(nAC > 0)
	{
			eAC = EffectACDecrease(nAC, AC_DODGE_BONUS);
			eLink = EffectLinkEffects(eLink, eAC);
	}
	if(nSkill > 0)
	{
			eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, nSkill);
			eLink = EffectLinkEffects(eLink, eSkill);
	}
	effect eDur  = EffectVisualEffect(VFX_DUR_CURSESONG);
	//effect eDur2 = EffectVisualEffect( VFX_DUR_BARD_SONG_EVIL );
	eLink = EffectLinkEffects(eLink, eDur);

	//effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
	effect eFNF = EffectVisualEffect(VFX_HIT_AOE_SONIC);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

	eHP = ExtraordinaryEffect(eHP);
	eLink = ExtraordinaryEffect(eLink);

	//if(!GetHasFeatEffect(871, oTarget)&& !GetHasSpellEffect(GetSpellId(),oTarget))
	//{
	//    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur2, OBJECT_SELF, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	//}
	float fDelay;
	while(GetIsObjectValid(oTarget))
	{
			if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
			{
				// * GZ Oct 2003: If we are deaf, we do not have negative effects from curse song
				if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
				{
					if(!GetHasFeatEffect(871, oTarget)&& !GetHasSpellEffect(GetSpellId(),oTarget))
					{
							SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_EPIC_CURSE_SONG));
							if (nHP > 0)
							{
								HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_SONIC), oTarget);
								DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHP, oTarget));
							}

							if (!GetIsDead(oTarget))
							{
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
								//DelayCommand(CSLRandomBetweenFloat(0.1,0.5),HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
						}
					}
				}
				else
				{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT), oTarget);
				}
			}

			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}

