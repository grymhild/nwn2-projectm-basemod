//::///////////////////////////////////////////////
//:: Dragon Breath Weaken
//:: NW_S1_DragWeak
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Calculates the proper damage and DC Save for the
	breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:: Updated On: Oct 21, 2003
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Monster"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iAge = GetHitDice(OBJECT_SELF);
	int iDamage;
	int iDC;
	float fDelay;
	object oTarget;
	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	//Determine save DC and ability damage
	if (iAge <= 6) //Wyrmling
	{
			iDamage = 1;
			iDC = 15;
	}
	else if (iAge >= 7 && iAge <= 9) //Very Young
	{
			iDamage = 2;
			iDC = 18;
	}
	else if (iAge >= 10 && iAge <= 12) //Young
	{
			iDamage = 3;
			iDC = 19;
	}
	else if (iAge >= 13 && iAge <= 15) //Juvenile
	{
			iDamage = 4;
			iDC = 22;
	}
	else if (iAge >= 16 && iAge <= 18) //Young Adult
	{
			iDamage = 5;
			iDC = 24;
	}
	else if (iAge >= 19 && iAge <= 21) //Adult
	{
			iDamage = 6;
			iDC = 25;
	}
	else if (iAge >= 22 && iAge <= 24) //Mature Adult
	{
			iDamage = 7;
			iDC = 28;
	}
	else if (iAge >= 25 && iAge <= 27) //Old
	{
			iDamage = 8;
			iDC = 30;
	}
	else if (iAge >= 28 && iAge <= 30) //Very Old
	{
			iDamage = 9;
			iDC = 33;
	}
	else if (iAge >= 31 && iAge <= 33) //Ancient
	{
			iDamage = 10;
			iDC = 35;
	}
	else if (iAge >= 34 && iAge <= 37) //Wyrm
	{
			iDamage = 11;
			iDC = 38;
	}
	else if (iAge > 37) //Great Wyrm
	{
			iDamage = 12;
			iDC = 40;
	}
	SCPlayDragonBattleCry();
	effect eBreath = EffectAbilityDecrease(ABILITY_STRENGTH, iDamage);
	eBreath = ExtraordinaryEffect(eBreath);
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	while(GetIsObjectValid(oTarget))
	{
			if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_WEAKEN, TRUE ));
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				//Make a saving throw check
				if(!/*ReflexSave*/HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

					//--------------------------------------------------------------
					//GZ: Bug fix
					//--------------------------------------------------------------
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBreath, oTarget));
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	}
}