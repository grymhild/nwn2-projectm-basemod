//::///////////////////////////////////////////////
//:: Tanglefoot bag
//:: x0_s3_tangle
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grenade.
	Fires at a target. If hit, the target takes
	direct damage. If missed, all enemies within
	an area of effect take splash damage.

	HOWTO:
			Will entangle target.
			+ If a saving throw REFLEX vs. DC 15 is failed the creature
			is immobile (HELD)
			
			DURATION: 1 turn
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	effect eHold = EffectEntangle();
	effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
	object oTarget = HkGetSpellTarget();
	effect eLink = EffectLinkEffects(eHold, eEntangle);
	int nDur;

	int iSaveDC = 0;

	object oItem = GetSpellCastItem();
	string sTag = GetStringLowerCase(GetTag(oItem));

	if (sTag == "x1_wmgrenade006")
	{
		iSaveDC = 15;
		nDur = 2;
	}
	else if (sTag == "n2_it_tang_2")
	{
		iSaveDC = 17;
		nDur = 3;
	}
	else if (sTag == "n2_it_tang_3")
	{
		iSaveDC = 19;
		nDur = 4;
	}
	else if (sTag == "n2_it_tang_4")
	{
		iSaveDC = 21;
		nDur = 6;
	}
	
	if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
	{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
			//Make reflex save
			if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iSaveDC))
			{
				//Apply linked effects
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));
			}
	}
}