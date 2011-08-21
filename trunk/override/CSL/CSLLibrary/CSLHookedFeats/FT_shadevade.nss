//::///////////////////////////////////////////////
//:: Shadow Evade
//:: X0_S2_ShadEvade   .nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the caster the following bonuses:
	Level 4:
		5% concealment
		5/+1 DR
		+1 AC
	Level 6
		10% concealment
		5/+2 DR
		+2 AC

	Level 8
		15% concealment
		10/+2 DR
		+3 AC

	Level 10
		20% concealment
		10/+3 DR
		+4 AC

	Lasts: 5 rounds

	Epic:
	+2 DR Amount +1 DR Power per 5 levels after 10

*/

#include "_HkSpell"


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;

	object oTarget = OBJECT_SELF;
	CSLUnstackSpellEffects(oTarget, GetSpellId());

	//Declare major variables
	int iLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
	int nConceal, nDRAmount, nAC, nMatType, nDRType;

	if (iLevel<10) {
		switch (iLevel) {
			case 4:
			case 5: nConceal = 5; nDRAmount = 5; nDRType = DR_TYPE_MAGICBONUS; nMatType = DAMAGE_POWER_PLUS_ONE; nAC = 1; break;
			case 6:
			case 7: nConceal = 10; nDRAmount = 5; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ALCHEMICAL_SILVER; nAC = 2; break;
			case 8:
			case 9:  nConceal = 15; nDRAmount = 10; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ALCHEMICAL_SILVER; nAC = 3; break;
			case 10: nConceal = 20; nDRAmount = 10; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ADAMANTINE; nAC = 4; break;
		}
	} else {
		nConceal = 20; nDRAmount = 10; nDRType = DR_TYPE_GMATERIAL; nMatType = GMATERIAL_METAL_ADAMANTINE; nAC = 4;
	}

	effect eLink = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
	eLink = EffectLinkEffects(eLink, EffectConcealment(nConceal));
	eLink = EffectLinkEffects(eLink, EffectACIncrease(nAC));
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(nDRAmount, nMatType, 0, nDRType));

	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_EVIL), OBJECT_SELF);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(iLevel*2));
}