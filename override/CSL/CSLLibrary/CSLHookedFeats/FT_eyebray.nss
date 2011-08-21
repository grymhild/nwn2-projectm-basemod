//::///////////////////////////////////////////////
//:: Eyeball attacks
//:: x1_s1_eyebray
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

	By default, the eyeball only has the cold
	attack. On critical its freezing

	2nd attack (familiar) is wounding
	On Critical hit its slowing for 1d3 rounds


*/
//:://////////////////////////////////////////////
//:
//:://////////////////////////////////////////////

int EBGetScaledBoltDamage(int iSpellId)
{
	int iLevel = GetHitDice(OBJECT_SELF);
	int nCount = iLevel /5;
	if (nCount == 0)
	{
			nCount =1;
	}

	int iDamage;

	switch (iSpellId)
	{
			case 710:  iDamage = d4(nCount) + (iLevel /2);
			case 711:  iDamage = d6(2) + (nCount*2);
			case 712:  iDamage = d6(nCount) + (nCount);
	}

	return iDamage;
}

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int iHD = GetHitDice(OBJECT_SELF);
	effect eVis;
	effect eBolt ;
	int iTouch;
	int iDamage;
	int iSpellId = GetSpellId();
	int iDC;

	if (iSpellId == 710) // cold bolt
	{
		iDamage = EBGetScaledBoltDamage(iSpellId);
		eVis = EffectVisualEffect(VFX_IMP_FROST_S);


		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		//Make a saving throw check
		iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage,DAMAGE_TYPE_COLD), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

			// if critical hit , freeze for 1 round
			if (iTouch == TOUCH_ATTACK_RESULT_CRITICAL )
			{
				iDC = 10 + (iHD/3);
				effect ePara = EffectParalyze(iDC, SAVING_THROW_FORT);
				effect eIce = EffectVisualEffect(VFX_DUR_ICESKIN);
				ePara = EffectLinkEffects(eIce,ePara);
				if (HkSavingThrow(SAVING_THROW_FORT,oTarget, iDC, SAVING_THROW_TYPE_COLD,OBJECT_SELF) == 0)
				{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara,oTarget, RoundsToSeconds(1));
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L),oTarget, RoundsToSeconds(d3(2)));
				}

			}
		}
	}
	else if (iSpellId == 711) // inflict wounds
	{

		iDamage = EBGetScaledBoltDamage(iSpellId);
		eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		//Make a saving throw check
		iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage,DAMAGE_TYPE_NEGATIVE), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

			// if critical hit , slow for 1 round
			if (iTouch == TOUCH_ATTACK_RESULT_CRITICAL )
			{
				effect eSlow = EffectSlow();
				iDC = 10 + (iHD/3);
				if (HkSavingThrow(SAVING_THROW_FORT,oTarget, iDC, SAVING_THROW_TYPE_NONE,OBJECT_SELF) == 0)
				{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow,oTarget, RoundsToSeconds(d3(2)));
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW),oTarget, RoundsToSeconds(d3(2)));
				}

			}
		}

	}
	else if (iSpellId == 712)//Fire
	{

		iDamage = EBGetScaledBoltDamage(iSpellId);
		eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
		
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		//Make a saving throw check
		iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
		if (iTouch  != TOUCH_ATTACK_RESULT_MISS )
		{
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
			//Apply the VFX impact and effects
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage,DAMAGE_TYPE_FIRE), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

			// if critical hit , knockdown for 1 round
			if (iTouch == TOUCH_ATTACK_RESULT_CRITICAL)
			{
				effect eKnock = EffectKnockdown();
				int iDC = 10 + (iHD/3);
				if (HkSavingThrow(SAVING_THROW_FORT,oTarget, iDC, SAVING_THROW_TYPE_NONE,OBJECT_SELF) == 0)
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock,oTarget, RoundsToSeconds(2));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M),oTarget, RoundsToSeconds(d3(2)));
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  RoundsToSeconds(2), 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
				}

			}
		}

	}
	
}