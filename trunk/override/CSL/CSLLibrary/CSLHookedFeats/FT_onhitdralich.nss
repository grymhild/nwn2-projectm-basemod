//::///////////////////////////////////////////////
//:: Dracolich paralyzing touch
//:: X2_S3_DracTouch
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	On touch a dracolich can paralyze an opponent.
	Fort vs DC 10+(HD/2)+ChaMod

	Duration varies by game difficulty between
	1 and 5 rounds (opposed to the 2d6 in the FRCS)

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-27
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oItem;        // The item casting triggering this spellscript
	object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
	object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

	// fill the variables
	oSpellOrigin = OBJECT_SELF;
	oSpellTarget = HkGetSpellTarget();
	oItem        =  GetSpellCastItem();

	int iDuration = 2;
	int nDiff = GetGameDifficulty();

	if (nDiff == GAME_DIFFICULTY_CORE_RULES )
	{
			iDuration = 4;
	}
	else if (nDiff == GAME_DIFFICULTY_DIFFICULT)
	{
			iDuration = 5;
	}
	else if (nDiff == GAME_DIFFICULTY_VERY_EASY)
	{
			iDuration =1;
	}

	int iDC =  10 + (HkGetSpellPower(OBJECT_SELF))   + GetAbilityModifier(ABILITY_CHARISMA, oSpellOrigin);
	if (GetIsObjectValid(oItem))
	{
			SignalEvent(oSpellTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			if(!GetHasSpellEffect(GetSpellId(),oSpellTarget))
			{
				if(!HkSavingThrow(SAVING_THROW_FORT, oSpellTarget, iDC, SAVING_THROW_TYPE_ALL))
				{
					effect eVis = EffectVisualEffect(VFX_IMP_STUN);
					effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
					effect ePara = EffectParalyze(iDC, SAVING_THROW_FORT);
					ePara = EffectLinkEffects(eDur,ePara);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePara,oSpellTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				}
			}
	}
}