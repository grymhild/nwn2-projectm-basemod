//::///////////////////////////////////////////////
//:: OnHitCastSpell Misc Effects
//:: x2_s3_misceffect
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
		Gelatinous cube paralzye
		DC 10 + CasterLevel

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-18
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "x2_inc_switches"
#include "_HkSpell"
#include "_SCInclude_Monster"

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

	if (GetIsObjectValid(oItem) && GetIsObjectValid(oSpellTarget) )
	{

		// you can not be deafened if you already can not hear.
		if (!GetHasSpellEffect(GetSpellId(),oSpellTarget)  )
		{
			int iDC = HkGetSpellPower(oSpellOrigin)+10;  ;
			if (SCDoCubeParalyze(oSpellTarget, oSpellOrigin,iDC))
			{
				FloatingTextStrRefOnCreature(84609,oSpellTarget);
			}
			else
			{
				effect eSave = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT,eSave,oSpellTarget);
			}
		}
	}
}