//::///////////////////////////////////////////////
//:: Weapon Supremacy
//:: cmi_s2_wpnsuprm
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Aug 15, 2009
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"


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
	
	int nSpellId = SPELLABILITY_WEAPON_SUPREMACY;
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_WEAPON_SUPREMACY );

	effect eAB = EffectAttackIncrease(1);
	effect eAC = EffectACIncrease(1);
	effect eLink = EffectLinkEffects(eAB, eAC);
	eLink = SetEffectSpellId(eLink,nSpellId);
	eLink = SupernaturalEffect(eLink);
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HoursToSeconds(72)));
	
	HkPostCast(oCaster);
	
}