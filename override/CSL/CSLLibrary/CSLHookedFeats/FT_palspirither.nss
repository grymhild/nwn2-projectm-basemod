//::///////////////////////////////////////////////
//:: Paladin - Spirit of Heroism
//:: cmi_s2_spirheroism
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 1, 2009
//:://////////////////////////////////////////////
//#include "nwn2_inc_spells"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_includes"


#include "_HkSpell"
#include "_SCInclude_Class"

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
	
	int nSpellId = SPELLABILITY_PALADIN_SPIRIT_HEROISM;

	int nPaladin = GetLevelByClass(CLASS_TYPE_PALADIN);
	float fDuration = RoundsToSeconds(nPaladin);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS);

	effect eDR = EffectDamageReduction(10, DR_TYPE_NONE, 0, DR_TYPE_NONE);
	effect eHP = EffectBonusHitpoints(GetHitDice(OBJECT_SELF));

	effect eLink = EffectLinkEffects(eDR, eHP);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = SetEffectSpellId(eLink,nSpellId);
	eLink = SupernaturalEffect(eLink);

	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));
	DelayCommand(0.2f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration));

}