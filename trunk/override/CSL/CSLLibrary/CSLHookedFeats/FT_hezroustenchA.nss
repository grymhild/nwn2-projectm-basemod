//::///////////////////////////////////////////////
//:: Hezrou Stench On Enter
//:: NW_S1_HezStenchA.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	A hezrou’s skin produces a foul-smelling,
	toxic liquid whenever it fights. Any living creature
	(except other demons) within 10 feet must succeed on a DC 24 Fortitude
	save or be nauseated for as long as it remains within the affected area
	and for 1d4 rounds afterward. Creatures that successfully save are
	sickened for as long as they remain in the area. A creature that
	successfully saves cannot be affected again by the same hezrou’s
	stench for 24 hours. A delay poison or neutralize poison spell removes
	either condition from one creature. Creatures that have immunity to poison
	are unaffected, and creatures resistant to poison receive their
	normal bonus on their saving throws. The save DC is Constitution-based.

*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 24, 2006
//:://////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_FT_hezroustench();
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();

	effect eSick = EffectVisualEffect(VFX_DUR_SICKENED);
	eSick = EffectLinkEffects(eSick, EffectAbilityDecrease(ABILITY_STRENGTH, 4));
	eSick = EffectLinkEffects(eSick, EffectAbilityDecrease(ABILITY_CONSTITUTION, 4));
	eSick = EffectLinkEffects(eSick, EffectAbilityDecrease(ABILITY_DEXTERITY, 4));

	effect eSlow = EffectVisualEffect(VFX_DUR_NAUSEA);
	eSlow = EffectLinkEffects(eSlow, EffectSlow());

	if (!GetHasSpellEffect(SPELLABILITY_HEZROU_STENCH, oTarget)) {
		if (GetIsEnemy(oTarget, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_HEZROU_STENCH));
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, 24, SAVING_THROW_TYPE_POISON, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON)) return;
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oTarget, RoundsToSeconds(d4(3)));
			}
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(30));
		}
	}
}