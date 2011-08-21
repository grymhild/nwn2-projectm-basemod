//::///////////////////////////////////////////////
//:: Sanctify Strikes
//:: cmi_s2_sancstrikes
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Aug 17, 2009
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
	
	int nSpellId = SPELLABILITY_SANCTIFY_STRIKES;

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_SANCTIFY_STRIKES );
	

	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
	eDmg = SetEffectSpellId(eDmg,nSpellId);
	eDmg = SupernaturalEffect(eDmg);
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmg, OBJECT_SELF, HoursToSeconds(72)));

	HkPostCast(oCaster);
}