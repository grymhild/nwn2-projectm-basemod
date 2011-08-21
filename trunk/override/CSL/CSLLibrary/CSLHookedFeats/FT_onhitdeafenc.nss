//::///////////////////////////////////////////////
//:: OnHitCastSpell Deafening Clang
//:: x2_s3_deafclng
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	* OnHit 100% chance to deafen enemy for
		1 round per casterlevel

	* Fort Save DC 10+CasterLevel negates

	* Standard level used by the deafening clang
		spellscript is 5.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-19
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oItem;        // The item casting triggering this spellscript
	object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
	object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

	// fill the variables
	oSpellOrigin = OBJECT_SELF;
	oSpellTarget = HkGetSpellTarget();
	oItem        =  GetSpellCastItem();

	if (GetIsObjectValid(oItem))
	{
		// you can not be deafened if you already can not hear.
		if (!GetHasSpellEffect(GetSpellId(),oSpellTarget) &&!GetHasSpellEffect(SPELL_MASS_BLINDNESS_AND_DEAFNESS,oSpellTarget)  && !GetHasSpellEffect(SPELL_BLINDNESS_AND_DEAFNESS,oSpellTarget) )
		{
			if (!HkResistSpell(oSpellOrigin,oSpellTarget) == 0)
			{
				int iDC= HkGetSpellPower(oSpellOrigin)+10;
				if ( !HkSavingThrow(SAVING_THROW_FORT,oSpellTarget, iDC,SAVING_THROW_TYPE_SONIC,oSpellOrigin) )
				{
					int nRounds = HkGetSpellPower(oSpellOrigin);
					effect eDeaf = EffectDeaf();
					effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDeaf,oSpellTarget,RoundsToSeconds(nRounds));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSpellTarget);
					FloatingTextStrRefOnCreature(85388,oSpellTarget,FALSE);
				}
			}
		}

	}
}