//::///////////////////////////////////////////////
//:: Dragon Breath Paralyze
//:: NW_S1_DragParal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Calculates the proper DC Save for the
	breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Monster"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iAge = GetHitDice(OBJECT_SELF);
	int iDC;
	int nCount;
	float fDelay;
	object oTarget;

		//Determine save DC and duration of effect
	if (iAge <= 6) //Wyrmling
	{
			iDC = 14;
			nCount = 1;
	}
	else if (iAge >= 7 && iAge <= 9) //Very Young
	{
			iDC = 17;
			nCount = 2;
	}
	else if (iAge >= 10 && iAge <= 12) //Young
	{
			iDC = 18;
			nCount = 3;
	}
	else if (iAge >= 13 && iAge <= 15) //Juvenile
	{
			iDC = 21;
			nCount = 4;
	}
	else if (iAge >= 16 && iAge <= 18) //Young Adult
	{
			iDC = 23;
			nCount = 5;
	}
	else if (iAge >= 19 && iAge <= 21) //Adult
	{
			iDC = 26;
			nCount = 6;
	}
	else if (iAge >= 22 && iAge <= 24) //Mature Adult
	{
			iDC = 27;
			nCount = 7;
	}
	else if (iAge >= 25 && iAge <= 27) //Old
	{
			iDC = 30;
			nCount = 8;
	}
	else if (iAge >= 28 && iAge <= 30) //Very Old
	{
			iDC = 31;
			nCount = 9;
	}
	else if (iAge >= 31 && iAge <= 33) //Ancient
	{
			iDC = 34;
			nCount = 10;
	}
	else if (iAge >= 34 && iAge <= 37) //Wyrm
	{
			iDC = 36;
			nCount = 11;
	}
	else if (iAge > 37) //Great Wyrm
	{
			iDC = 39;
			nCount = 12;
	}
	
	effect eBreath = EffectParalyze(iDC, SAVING_THROW_FORT);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
	effect eParal = EffectVisualEffect(VFX_DUR_PARALYZED);
	
	effect eLink = EffectLinkEffects(eBreath, eDur);
	eLink = EffectLinkEffects(eLink, eDur2);
	eLink = EffectLinkEffects(eLink, eParal);

	SCPlayDragonBattleCry();
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				nCount = HkGetScaledDuration(nCount, oTarget);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_PARALYZE, TRUE));
				//Determine the effect delay time
				fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/20;
				//Make a saving throw check
				if(!/*FortitudeSave*/HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount)));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	}
}