//::///////////////////////////////////////////////
//:: Demilich paralzying touch
//:: x2_s3_demitouch
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	On touch a demilich can paralyze an opponent.
	Fort vs DC 38

	Duration varies by game difficulty between
	1 and 5 rounds
	(Sorry, no permanent paralyze, its just not fun)
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-27
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oItem;        // The item casting triggering this spellscript
	object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
	object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

	// fill the variables
	oSpellOrigin = OBJECT_SELF;
	oSpellTarget = HkGetSpellTarget();
	oItem        =  GetSpellCastItem();

	int iDuration = 2;
	int nDiff = GetGameDifficulty();
	int iSaveDC = 36;

	if (nDiff == GAME_DIFFICULTY_CORE_RULES)
	{
			iDuration = 3;
	}
	else if (nDiff == GAME_DIFFICULTY_DIFFICULT)
	{
			iDuration = 5;
	}
	else if (nDiff == GAME_DIFFICULTY_VERY_EASY)
	{
			iDuration =1;
	}

	if (GetIsObjectValid(oItem))
	{
		SignalEvent(oSpellTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		if(!GetHasSpellEffect(GetSpellId(),oSpellTarget))
		{
			if(!HkSavingThrow(SAVING_THROW_FORT, oSpellTarget, iSaveDC, SAVING_THROW_TYPE_ALL))
			{
				effect eVis = EffectVisualEffect(VFX_IMP_STUN);
				effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
				effect ePara = EffectParalyze(iSaveDC, SAVING_THROW_FORT);
				ePara = EffectLinkEffects(eDur,ePara);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePara,oSpellTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
			}
		}
	}

}