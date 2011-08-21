//::///////////////////////////////////////////////
//:: Skin of the Cactus
//:: cmi_s0_skincact
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Skin of the Cactus
//:: Abjuration
//:: Caster Level(s): Druid 4, Ranger 3
//:: Innate Level: 4
//:: Component(s): Verbal, Somatic
//:: Range: Touch
//:: Area of Effect / Target: Living creature touched
//:: Duration: 10 minutes/level
//:: This spell grants a living creature the toughness, resilience, and needles
//:: of a cactus. The effect grants a +3 enhancement bonus to the creature's
//:: existing natural armor bonus. This enhancement bonus increases to +4 at
//:: caster level 10th and to a maximum of +5 at caster level 13th.
//:: 
//:: In addition to the enhancement bonus, skin of the cactus causes the subject
//:: to grow needles from its skin, clothing, or armor. Any creature striking it
//:: will take 1d6 points of piercing damage from the needles.
//:://////////////////////////////////////////////



#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SKIN_CACTUS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iSpellPower = HkGetSpellPower( oCaster, 60, iClass );
	int nBonus = HkCapAC( ( 3+(iSpellPower-7)/3) );
	
	object oTarget = HkGetSpellTarget();	

	effect eAC = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
	effect eDS = EffectDamageShield(0, DAMAGE_BONUS_1d6, DAMAGE_TYPE_PIERCING);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eLink = EffectLinkEffects(eAC, eDS);
	eLink = EffectLinkEffects(eLink, eVis);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}