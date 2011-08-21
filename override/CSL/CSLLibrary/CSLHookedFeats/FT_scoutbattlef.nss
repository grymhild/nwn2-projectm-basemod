//::///////////////////////////////////////////////
//:: Battle Fortitude
//:: cmi_s2_battlefort
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: November 23, 2009
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SCOUT_BATTLEFORT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
	

	//At 2nd level, a scout gains a +1 bonus on Fortitude saves. This bonus increases to +2 at 11th, +3 at 20th, and +4 at 29th.
	int nScout = GetLevelByClass(CLASS_SCOUT, OBJECT_SELF);
	int nBonus = 1;
	nBonus += ((nScout - 2) / 9);

	effect eFort = EffectSavingThrowIncrease(SAVING_THROW_FORT, nBonus);

	if (nScout > 17)
	{
		effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
		effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
		effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
		effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
		effect eHit = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);

		//Link effects
		effect eLink = EffectLinkEffects(eParal, eEntangle);
		eLink = EffectLinkEffects(eLink, eSlow);
		eLink = EffectLinkEffects(eLink, eMove);
		eLink = EffectLinkEffects(eLink, eHit);
		eFort = EffectLinkEffects(eLink, eFort);
	}

	eFort = SetEffectSpellId(eFort,iSpellId);
	eFort = SupernaturalEffect(eFort);
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFort, OBJECT_SELF, HoursToSeconds(72)));
}