//::///////////////////////////////////////////////
//:: Slaad Chaos Spittle
//:: x2_s1_chaosspit
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature must make a ranged touch attack to hit
	the intended target.

	Damage is 20d4 for black slaad, 10d4 for white
	slaad and hd/2 d4 for any other creature this
	spell  is assigned to

	A shifter will do his shifter level /3 d6
	points of damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Sept 08  , 2003
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_INTERNAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int iHD = GetHitDice(OBJECT_SELF);
	effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
	effect eVis2 = EffectVisualEffect(VFX_IMP_ACID_S);
	effect eBolt;
	int nCount;
	if (GetIsPC(OBJECT_SELF))
	{
			nCount = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)/3) + 2 ;
	}
	else if (GetAppearanceType(OBJECT_SELF) == 426) // black slaad = 20d6
	{
			nCount = 20  ;
	}
	else if (GetAppearanceType(OBJECT_SELF) == 427) // white slaad = 10d6
	{
			nCount = 10         ;
	}
	else
	{
			nCount = iHD /2;
	}

	if (nCount == 0)
	{
			nCount = 1;
	}
	int bVody = CSLStringStartsWith(GetTag(OBJECT_SELF),"vodyanoi");
	if (bVody) nCount = GetHitDice(OBJECT_SELF);

	int iDamage = d4(nCount);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.

	//Make a ranged touch attack
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
		
		if (bVody) {
			int iHD = GetHitDice(OBJECT_SELF);
			iDamage = d4(iHD/2) * iTouch;
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iHD+8, SAVING_THROW_TYPE_ACID);
			if (iDamage) {
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_ACID), oTarget);
				if (WillSave(oTarget, iHD + 10, SAVING_THROW_TYPE_MIND_SPELLS)==SAVING_THROW_CHECK_FAILED) {
						effect eLink = EffectVisualEffect(VFX_DUR_SPELL_CONFUSION);
						eLink = EffectLinkEffects(eLink, EffectConfused());
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iHD/3));
				}
				iDamage = d4(iHD/3) * iTouch;
			}
		}
			eBolt = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
			if (iDamage > 0) {
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
			}
	}
}