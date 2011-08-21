//::///////////////////////////////////////////////
//:: OnHitCastSpell Misc Effects
//:: x2_s3_misceffect
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Used for Aribeth in Hell...

	Based on Spell ID, has different effects

	791 - knockdown, DC = 10 + Caster Level
			will not work on PCs

	792 - freeze, DC = 10 + Caster Level,
						Slow Creature hit or hitting for d3() rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-19
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL;

	object oItem;        // The item casting triggering this spellscript
	object oTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
	object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

	// fill the variables
	oSpellOrigin = OBJECT_SELF;
	oTarget = HkGetSpellTarget();
	oItem        =  GetSpellCastItem();

	if (GetIsObjectValid(oItem))
	{

		// you can not be deafened if you already can not hear.
		if (!GetHasSpellEffect(GetSpellId(),oTarget)  )
		{

				if (GetSpellId() == 791) // OnHitKnockDown
				{
						if (!GetIsPC(oSpellOrigin))    // This does not work on PCs
						{
							int iDC = HkGetSpellPower(oSpellOrigin)+10;  ;
							if  (GetIsSkillSuccessful(oTarget,SKILL_DISCIPLINE,iDC) == 0)
							{
								effect eKnock = EffectKnockdown();
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKnock,oTarget, 6.0f );
								if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
								{
									CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  6.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
								}
							}
						}
						return;
				}
				else if (GetSpellId() == 792) // OnHitFreeze
				{
						int iDC = HkGetSpellPower(oSpellOrigin)+10;  ;
						if  (HkSavingThrow(SAVING_THROW_FORT,oTarget,iDC,SAVING_THROW_TYPE_COLD,oSpellOrigin) == 0)
						{
							effect eDur= EffectVisualEffect(VFX_DUR_ICESKIN);
							effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
							effect eSlow = EffectSlow();
							effect eLink = EffectLinkEffects(eDur,eSlow);
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(d3()));
							HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget,RoundsToSeconds(d3()));
						}
						return;
				}

		}

	}
}