// ld_s0_mechmind.nss
//
// Mechanus Mind
//
//
//

//#include "ld_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x2_i0_spells"




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
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
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
	
	object oTarget = HkGetSpellTarget();

	effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
	effect eINT = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2);
	effect eCHA = EffectAbilityDecrease(ABILITY_CHARISMA, 2);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId ) );


	effect eLink = EffectLinkEffects(eOnDispell, eINT);
	eLink = EffectLinkEffects(eLink, eCHA);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = EffectLinkEffects(eLink, eWill);


	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	float fDuration = RoundsToSeconds( nCasterLvl );
	fDuration = HkApplyMetamagicDurationMods(fDuration);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}