//::///////////////////////////////////////////////
//:: Divine Vengeance
//:: x0_s2_divveng.nss
//:: Copyright (c) 2002 Bioware Corp.
//::				2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Up to (turn undead amount) per day the character may add 2d6 bonus to all
	weapon damage until the end of your next action

	based on work x2_s2_divmight.nss By "Brent"

	Adapted to last for rounds equal to your charisma bonus, instead of one
	turn (same as Divine Might)
*/
//:://////////////////////////////////////////////
//:: Created By: JWR-OEI
//:: Created On: May 23 2008
//:://////////////////////////////////////////////
//#include "x0_i0_spells"
//#include "_CSLCore_Items"
//#include "nwn2_inc_spells"



#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP ;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
	{
		SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
	}
	else
	{
		
		object oTarget = HkGetSpellTarget();
		int nLevel = HkGetCasterLevel(OBJECT_SELF);

		effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

		int nDamageBonus = d6(2);
		int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
		if ( nCharismaBonus < 1 )
		{
			nCharismaBonus = 1;
		}

		//int nDamage1 = CSLGetDamageBonusConstantFromNumber(nDamageBonus);
		int nDamage1 = IP_CONST_DAMAGEBONUS_2d6;
		
		effect eDamage1 = EffectDamageIncrease(nDamage1,DAMAGE_TYPE_DIVINE, RACIAL_TYPE_UNDEAD);
		effect eLink = EffectLinkEffects(eDamage1, eDur);
		eLink = SupernaturalEffect(eLink);

		// * Do not allow this to stack
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
		//RemoveEffectsFromSpell(oTarget, HkGetSpellId());

		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_VENGEANCE, FALSE));

		//Apply Link and VFX effects to the target
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus+1));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
	}
	HkPostCast(oCaster);
}