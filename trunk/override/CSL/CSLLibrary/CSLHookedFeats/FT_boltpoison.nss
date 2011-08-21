//::///////////////////////////////////////////////
//:: Bolt: Poison
//:: NW_S1_BltPoison.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Must make a ranged touch attack. If successful
	the target is struck down with poison that
	scales with level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////


#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect ePoison;
	int nPoison;
	int nRacial = GetRacialType(OBJECT_SELF);
	int iHD = GetHitDice(OBJECT_SELF);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_POISON));

	//Determine the poison type based on the Racial Type and HD
	// June 3/04: Bugfix for some screwy if statements.
	switch (nRacial)
	{
			case RACIAL_TYPE_OUTSIDER:
				if (iHD <= 9)
				{
					nPoison = POISON_QUASIT_VENOM;
				}
				else if (iHD < 13)
				{
					nPoison = POISON_BEBILITH_VENOM;
				}
				else //if (iHD >= 13) //if statement not actually needed...
				{
					nPoison = POISON_PIT_FIEND_ICHOR;
				}
			break;
			case RACIAL_TYPE_VERMIN:
				if (iHD < 3)
				{
					nPoison = POISON_TINY_SPIDER_VENOM;
				}
				else if (iHD < 6)
				{
					nPoison = POISON_SMALL_SPIDER_VENOM;
				}
				else if (iHD < 9)
				{
					nPoison = POISON_MEDIUM_SPIDER_VENOM;
				}
				else if (iHD < 12)
				{
					nPoison =  POISON_LARGE_SPIDER_VENOM;
				}
				else if (iHD < 15)
				{
					nPoison = POISON_HUGE_SPIDER_VENOM;
				}
				else if (iHD < 18)
				{
					nPoison = POISON_GARGANTUAN_SPIDER_VENOM;
				}
				else //if (iHD >= 18)
				{
					nPoison = POISON_COLOSSAL_SPIDER_VENOM;
				}
			break;
			default:
				if (iHD < 3)
				{
					nPoison = POISON_NIGHTSHADE;
				}
				else if (iHD < 6)
				{
					nPoison = POISON_BLADE_BANE;
				}
				else if (iHD < 9)
				{
					nPoison = POISON_BLOODROOT;
				}
				else if (iHD < 12)
				{
					nPoison =  POISON_LARGE_SPIDER_VENOM;
				}
				else if (iHD < 15)
				{
					nPoison = POISON_LICH_DUST;
				}
				else if (iHD < 18)
				{
					nPoison = POISON_DARK_REAVER_POWDER;
				}
				else //if (iHD >= 18 )
				{
					nPoison = POISON_BLACK_LOTUS_EXTRACT;
				}

			break;
	}
	//Make a ranged touch attack
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
			ePoison = EffectPoison(nPoison);
			//Apply effects
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
	}
}