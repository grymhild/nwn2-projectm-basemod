//::///////////////////////////////////////////////
//:: Enrage Animal
//:: cmi_s0_enrageanim
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Enrage Animal
//:: Necromancy
//:: Level: Druid 1, Ranger 1
//:: Components: V, S
//:: Range: Long
//:: Target: One animal companion
//:: Duration: 1 round/level
//:: Enrage animal bestows the effects of the whirlwind frenzy rage: a +4 bonus
//:: to Strength and a +2 dodge bonus to Armor Class and on Reflex saves. While
//:: in a whirling frenzy, the animal companion may make one extra attack in a
//:: round at its highest base attack bonus, but this attack takes a -2 penalty,
//:: as does each other attack made that round.
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENRAGE_ANIMAL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	object oTarget = HkGetSpellTarget();

	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_AWAKEN );	// NWN2 VFX
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
	effect eAC = EffectACIncrease(2);
	effect eDex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2);
	effect eAB = EffectAttackDecrease(2);
	effect eAtk = EffectModifyAttacks(1);
	effect eLink = EffectLinkEffects(eVis, eStr);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eDex);
	eLink = EffectLinkEffects(eLink, eAB);
	eLink = EffectLinkEffects(eLink, eAtk);

	if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
	
	HkPostCast(oCaster);
}