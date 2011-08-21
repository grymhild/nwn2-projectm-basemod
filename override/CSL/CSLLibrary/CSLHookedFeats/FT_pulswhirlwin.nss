//::///////////////////////////////////////////////
//:: Pulse Whirlwind
//:: NW_S1_PulsWind
//:: Copyright (c) 2001 Bioware Corp.
//::///////////////////////////////////////////////
/*
	All those that fail a save of DC 14 are knocked
	down by the elemental whirlwind.

		* made this make the knockdown last 2 rounds instead of 1
		* it will now also do d3(hitdice/2) damage
*/
//::///////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//::///////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eDown = EffectKnockdown();
	effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	int iDamage = GetHitDice(OBJECT_SELF) /2;
	effect eDam = EffectDamage(d3(iDamage), DAMAGE_TYPE_SLASHING);
	//Get first target in spell area
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Make a saving throw check
				if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, 14))
				{
					//Apply the VFX impact and effects

					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDown, oTarget, RoundsToSeconds(2));
					DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
					
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  RoundsToSeconds(2), 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
				}
				//Get next target in spell area
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}