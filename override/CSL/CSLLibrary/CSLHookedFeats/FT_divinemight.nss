//::///////////////////////////////////////////////
//:: Divine Might
//:: x0_s2_divmight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Up to (turn undead amount) per day the character may add his Charisma bonus to all
	weapon damage for a number of rounds equal to the Charisma bonus.

	MODIFIED JULY 3 2003
	+ Won't stack
	+ Set it up properly to give correct + to hit (to a max of +20)

	MODIFIED SEPT 30 2003
	+ Made use of new Damage Constants
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13 2002
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Items"
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;

	if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
	{
		SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
	}
	else
	{
		//Declare major variables
		object oTarget = HkGetSpellTarget();
		int iLevel = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);

		effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

		int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
		if (nCharismaBonus>0)
		{
			// AFW-OEI 02/08/2007: If you have Epic Divine Might, your CHA bonus is doubled.
			if (GetHasFeat(FEAT_EPIC_DIVINE_MIGHT, OBJECT_SELF, TRUE))
			{
				nCharismaBonus = 2 * nCharismaBonus;
			}
		
			int nDamage1 = CSLGetDamageBonusConstantFromNumber(nCharismaBonus);

			effect eDamage1 = EffectDamageIncrease(nDamage1,DAMAGE_TYPE_DIVINE );
			effect eLink = EffectLinkEffects(eDamage1, eDur);
			eLink = SupernaturalEffect(eLink);

			// * Do not allow this to stack
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());

			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_MIGHT, FALSE));

			//Apply Link and VFX effects to the target
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus+1));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
	}
}