//::///////////////////////////////////////////////
//:: Divine Protection
//:: cmi_s0_divprot
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 24, 2010
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIVINE_PROTECTION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iDuration = HkGetSpellDuration( oCaster, 30 )+ GetAbilityModifier(ABILITY_CHARISMA);;
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) ); // SC_DURCATEGORY_MINUTES SC_DURCATEGORY_HOURS SC_DURCATEGORY_DAYS 
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	effect eBonus = EffectACIncrease(1);
	effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HEROISM);
	effect eLink = EffectLinkEffects(eBonus, eSaves);
	eLink = EffectLinkEffects(eLink, eVis);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) && (oTarget != oCaster))
		{

			float fDelay = CSLRandomBetweenFloat(0.4, 1.1);

			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
			SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId(), FALSE));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));

		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	}
	HkPostCast(oCaster);
}