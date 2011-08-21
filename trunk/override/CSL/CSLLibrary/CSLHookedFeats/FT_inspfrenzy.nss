//::///////////////////////////////////////////////////////////////////////////
//::
//::  nw_s1_inspfrenzy.nss
//::
//::  This is the script for Frenzied Berserker feat Inspire Frenzy.
//::  Based largely off the script for the similar feat Frenzy.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created by: Brian Fox
//::  Created on: 7/11/06
//::
//::///////////////////////////////////////////////////////////////////////////
//:: AFW-OEI 08/07/2006: Inspire frenzy now lasts a fixed 2 rounds,
//::  and inflicts 12 points of damage per round.
//:: AFW-OEI 10/30/2006: Changed to 6 pts./rnd.

#include "_HkSpell"
#include "_HkSpell"


void DoFrenzy(object oTarget, int nIncrease, float fDuration)
{
	// This is an immense hack to make the effect be created by the person going into the Frenzy;
	// the DoT effect causes you to become hostile to the effect creator, so to keep you from going
	// hostile to your own party, you must be the creator of the effect that damages you.
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_RAGE);
	eLink = EffectLinkEffects(eLink, EffectACDecrease(4, AC_DODGE_BONUS));
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease));
	eLink = EffectLinkEffects(eLink, EffectDamageOverTime(6, 5.5, DAMAGE_TYPE_ALL));
	eLink = EffectLinkEffects(eLink, EffectModifyAttacks(1));
	eLink = ExtraordinaryEffect(eLink);
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
	DelayCommand(fDuration - 0.5f, CSLApplyFatigue(oTarget, RoundsToSeconds(2), 0.6f));   // Fatigue duration is fixed to 2 rounds.
}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_TURNABLE;

	int nIncrease = 6;
	object oCaster = OBJECT_SELF;
	int iLevel = GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER, oCaster);
	float fDuration = RoundsToSeconds(2);
	object oFactionMember = GetFirstFactionMember(oCaster, FALSE);
	while (GetIsObjectValid(oFactionMember))
	{
		if (CSLPCIsClose(oCaster, oFactionMember, 10) && !GetHasFeatEffect(FEAT_FRENZY_1, oFactionMember) && oFactionMember!=OBJECT_SELF)
		{
			PlayVoiceChat(VOICE_CHAT_BATTLECRY1, oFactionMember);
			SignalEvent(oFactionMember, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			AssignCommand( oFactionMember, DoFrenzy(oFactionMember, nIncrease, fDuration));
		}
		oFactionMember = GetNextFactionMember(oCaster, FALSE);
	}
}