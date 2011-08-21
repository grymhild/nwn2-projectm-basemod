//::///////////////////////////////////////////////
//:: Ghast Stench On Enter
//:: NW_S1_ghaststencha.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	The stink of death and corruption surrounding
	these creatures is overwhelming. Living creatures
	within 10 feet must succeed on a DC 15 Fortitude
	save or be sickened for 1d6+4 minutes. A creature
	that successfully saves cannot be affected again
	by the same ghasts stench for 24 hours. A delay
	poison or neutralize poison spell removes the effect
	from a sickened creature. Creatures with immunity
	to poison are unaffected, and creatures resistant
	to poison receive their normal bonus on their
	saving throws. The save DC is Charisma-based.

*/

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_ghaststench(); //SPELLABILITY_GHAST_STENCH;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();

	effect eLink = EffectVisualEffect(VFX_DUR_SICKENED);
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_STRENGTH, 4));
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_CONSTITUTION, 4));
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 4));

	if (!GetHasSpellEffect(SPELLABILITY_GHAST_STENCH, oTarget)) {
		if (GetIsEnemy(oTarget, oCreator)) {
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_GHAST_STENCH ));
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_POISON, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON)) {
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d4()+1));
				}
			}
		}
	}
}